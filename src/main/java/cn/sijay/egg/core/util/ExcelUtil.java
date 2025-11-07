package cn.sijay.egg.core.util;

import cn.idev.excel.EasyExcel;
import cn.idev.excel.context.AnalysisContext;
import cn.idev.excel.read.listener.ReadListener;
import com.mybatisflex.core.BaseMapper;
import com.mybatisflex.core.query.QueryWrapper;
import jakarta.servlet.http.HttpServletResponse;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.transaction.annotation.Transactional;

import java.io.InputStream;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

interface ExcelImportService<T> {

    /**
     * 导入Excel数据
     *
     * @param inputStream Excel文件流
     * @param update      是否更新数据
     * @param uniqueKeys  唯一标识字段
     * @return 导入结果
     */
    ImportResult<T> importExcel(InputStream inputStream, boolean update, String... uniqueKeys);

    /**
     * 获取数据Mapper
     */
    BaseMapper<T> getMapper();

    /**
     * 获取实体类类型
     */
    Class<T> getEntityClass();

    /**
     * 数据校验
     */
    default String validateData(T data) {
        return null;
    }

    /**
     * 数据转换（如果需要）
     */
    default void convertData(T data) {
        // 默认不进行转换
    }

    /**
     * 批量处理前的回调
     */
    default void beforeBatchProcess(List<T> dataList) {
        // 默认空实现
    }

    /**
     * 批量处理后的回调
     */
    default void afterBatchProcess(List<T> dataList) {
        // 默认空实现
    }
}

public class ExcelUtil {
    public static <T> void exportExcel(List<T> list, String sheetName, Class<T> clazz, HttpServletResponse response) {

    }

    public static <T> List<T> importExcel(java.io.InputStream inputStream, Class<T> clazz) {
        return null;
    }
}

@Data
class ImportResult<T> {
    /**
     * 导入成功的数据
     */
    private List<T> successList;

    /**
     * 导入失败的数据
     */
    private List<ImportError<T>> errorList;

    /**
     * 总记录数
     */
    private int totalCount;

    /**
     * 成功数量
     */
    private int successCount;

    /**
     * 失败数量
     */
    private int errorCount;

    public ImportResult() {
        this.successList = new ArrayList<>();
        this.errorList = new ArrayList<>();
    }

    public void addSuccess(T data) {
        this.successList.add(data);
        this.successCount++;
        this.totalCount++;
    }

    public void addError(T data, String errorMsg) {
        this.errorList.add(new ImportError<>(data, errorMsg));
        this.errorCount++;
        this.totalCount++;
    }

    public boolean hasError() {
        return CollectionUtils.isNotEmpty(errorList);
    }

    @Data
    public static class ImportError<T> {
        private T data;
        private String errorMsg;

        public ImportError(T data, String errorMsg) {
            this.data = data;
            this.errorMsg = errorMsg;
        }
    }
}

@Slf4j
abstract class AbstractExcelImportService<T> implements ExcelImportService<T> {

    // 批量处理大小
    private static final int BATCH_SIZE = 1000;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ImportResult<T> importExcel(InputStream inputStream, boolean update, String... uniqueKeys) {
        ImportResult<T> result = new ImportResult<>();
        List<T> batchList = new ArrayList<>(BATCH_SIZE);

        try {
            EasyExcel.read(inputStream, getEntityClass(), new ReadListener<T>() {
                @Override
                public void invoke(T data, AnalysisContext context) {
                    // 数据转换
                    convertData(data);

                    // 数据校验
                    String errorMsg = validateData(data);
                    if (StringUtils.isNotBlank(errorMsg)) {
                        result.addError(data, errorMsg);
                        return;
                    }

                    batchList.add(data);
                    if (batchList.size() >= BATCH_SIZE) {
                        processBatch(batchList, result, update, uniqueKeys);
                        batchList.clear();
                    }
                }

                @Override
                public void doAfterAllAnalysed(AnalysisContext context) {
                    if (CollectionUtils.isNotEmpty(batchList)) {
                        processBatch(batchList, result, update, uniqueKeys);
                        batchList.clear();
                    }
                }
            }).sheet().doRead();
        } catch (Exception e) {
            log.error("导入Excel失败", e);
            throw new RuntimeException("导入Excel失败: " + e.getMessage(), e);
        }

        return result;
    }

    private void processBatch(List<T> batchList, ImportResult<T> result, boolean update, String... uniqueKeys) {
        if (CollectionUtils.isEmpty(batchList)) {
            return;
        }

        // 批量处理前的回调
        beforeBatchProcess(batchList);

        if (update && ArrayUtils.isNotEmpty(uniqueKeys)) {
            // 更新模式，根据唯一键更新
            processWithUpdate(batchList, result, uniqueKeys);
        } else {
            // 插入模式
            processWithInsert(batchList, result);
        }

        // 批量处理后的回调
        afterBatchProcess(batchList);
    }

    private void processWithInsert(List<T> batchList, ImportResult<T> result) {
        try {
            // 批量插入
            for (T data : batchList) {
                int rows = getMapper().insert(data, true);
                if (rows > 0) {
                    result.addSuccess(data);
                } else {
                    result.addError(data, "插入数据失败");
                }
            }
        } catch (Exception e) {
            log.error("批量插入数据失败", e);
            // 单条插入，记录失败数据
            for (T data : batchList) {
                try {
                    int rows = getMapper().insert(data, true);
                    if (rows > 0) {
                        result.addSuccess(data);
                    } else {
                        result.addError(data, "插入数据失败");
                    }
                } catch (Exception ex) {
                    result.addError(data, "插入数据异常: " + ex.getMessage());
                }
            }
        }
    }

    private void processWithUpdate(List<T> batchList, ImportResult<T> result, String[] uniqueKeys) {
        // 构建唯一键条件，查询已存在的数据
        Map<String, T> existingDataMap = findExistingData(batchList, uniqueKeys);

        List<T> toInsert = new ArrayList<>();
        List<T> toUpdate = new ArrayList<>();

        for (T data : batchList) {
            String uniqueKey = buildUniqueKey(data, uniqueKeys);
            if (existingDataMap.containsKey(uniqueKey)) {
                // 更新数据
                T existingData = existingDataMap.get(uniqueKey);
                updateEntity(existingData, data);
                toUpdate.add(existingData);
            } else {
                // 插入数据
                toInsert.add(data);
            }
        }

        // 执行批量操作
        batchInsert(toInsert, result);
        batchUpdate(toUpdate, result);
    }

    private Map<String, T> findExistingData(List<T> dataList, String[] uniqueKeys) {
        if (CollectionUtils.isEmpty(dataList)) {
            return new ConcurrentHashMap<>();
        }

        Map<String, T> result = new ConcurrentHashMap<>();

        // 分批查询，避免SQL过长
        int batchSize = 500;
        for (int i = 0; i < dataList.size(); i += batchSize) {
            int end = Math.min(i + batchSize, dataList.size());
            List<T> subList = dataList.subList(i, end);

            QueryWrapper queryWrapper = QueryWrapper.create();

            for (T data : subList) {
                for (String uniqueKey : uniqueKeys) {
                    Object value = getFieldValue(data, uniqueKey);
                    if (value != null) {
                        queryWrapper.and(uniqueKey + " = {0}", value);
                    }
                }
            }

            List<T> existingList = getMapper().selectListByQuery(queryWrapper);
            for (T existing : existingList) {
                String uniqueKey = buildUniqueKey(existing, uniqueKeys);
                result.put(uniqueKey, existing);
            }
        }

        return result;
    }

    private void batchInsert(List<T> toInsert, ImportResult<T> result) {
        if (CollectionUtils.isEmpty(toInsert)) {
            return;
        }

        for (T data : toInsert) {
            try {
                int rows = getMapper().insert(data, true);
                if (rows > 0) {
                    result.addSuccess(data);
                } else {
                    result.addError(data, "插入数据失败");
                }
            } catch (Exception e) {
                log.error("插入数据失败", e);
                result.addError(data, "插入数据异常: " + e.getMessage());
            }
        }
    }

    private void batchUpdate(List<T> toUpdate, ImportResult<T> result) {
        if (CollectionUtils.isEmpty(toUpdate)) {
            return;
        }

        for (T data : toUpdate) {
            try {
                int rows = getMapper().update(data);
                if (rows > 0) {
                    result.addSuccess(data);
                } else {
                    result.addError(data, "更新数据失败");
                }
            } catch (Exception e) {
                log.error("更新数据失败", e);
                result.addError(data, "更新数据异常: " + e.getMessage());
            }
        }
    }

    private String buildUniqueKey(T data, String[] uniqueKeys) {
        StringBuilder keyBuilder = new StringBuilder();
        for (String uniqueKey : uniqueKeys) {
            Object value = getFieldValue(data, uniqueKey);
            keyBuilder.append(value != null ? value.toString() : "null").append("_");
        }
        return keyBuilder.toString();
    }

    private Object getFieldValue(T data, String fieldName) {
        try {
            Field field = data.getClass().getDeclaredField(fieldName);
            field.setAccessible(true);
            return field.get(data);
        } catch (Exception e) {
            // 尝试从父类获取
            try {
                Field field = data.getClass().getSuperclass().getDeclaredField(fieldName);
                field.setAccessible(true);
                return field.get(data);
            } catch (Exception ex) {
                log.error("获取字段值失败: {}", fieldName, e);
                return null;
            }
        }
    }

    private void updateEntity(T target, T source) {
        // 这里可以实现自定义的更新逻辑
        // 默认使用反射复制非空字段
        Field[] fields = source.getClass().getDeclaredFields();
        for (Field field : fields) {
            try {
                field.setAccessible(true);
                Object value = field.get(source);
                if (value != null) {
                    field.set(target, value);
                }
            } catch (Exception e) {
                log.warn("更新字段失败: {}", field.getName(), e);
            }
        }
    }
}