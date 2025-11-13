package cn.sijay.egg.generator.service;

import cn.sijay.egg.core.exception.GeneratorException;
import cn.sijay.egg.core.records.SelectOption;
import cn.sijay.egg.core.util.FileUtil;
import cn.sijay.egg.core.util.StringUtil;
import cn.sijay.egg.generator.constants.GenContstant;
import cn.sijay.egg.generator.entity.GenColumn;
import cn.sijay.egg.generator.entity.GenTable;
import cn.sijay.egg.generator.enums.GenerateTypeEnum;
import cn.sijay.egg.generator.enums.HtmlTypeEnum;
import cn.sijay.egg.generator.enums.JavaTypeEnum;
import cn.sijay.egg.generator.enums.QueryTypeEnum;
import cn.sijay.egg.generator.properties.GenProperties;
import cn.sijay.egg.generator.records.ColumnOption;
import cn.sijay.egg.generator.records.GenTableQuery;
import freemarker.template.Configuration;
import freemarker.template.TemplateException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.RegExUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.Strings;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;

import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

/**
 * GenService
 *
 * @author sijay
 * @since 2025-11-04
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class GenService {
    private final static List<String> TEMPLATES = List.of(
            "entity.java",
            "mapper.java",
            "query.java",
            "service.java",
            "controller.java",
            "api.ts",
            "types.ts",
//                "dialog.vue",
            "sql"
    );
    private final GenTableService tableService;
    private final GenColumnService columnService;
    private final Configuration configuration;
    private final GenProperties genProperties;

    /**
     * 导入表结构
     */
    @Transactional
    public void importTable(List<String> tableNames) {
        List<GenTable> tableList = tableService.listByTableNames(tableNames);
        for (GenTable table : tableList) {
            String tableName = table.getTableName();
            table.setPackageName(genProperties.getPackageName());
            table.setModuleName(tableName.split("_")[0]);
            table.setClassName(StringUtil.toUpperCamelCase(tableName));
            String tableComment = table.getTableComment();
            table.setClassComment(RegExUtils.replaceAll(tableComment, "表$", ""));
            table.setBusinessName(StringUtils.uncapitalize(table.getClassName()));
            table.setAuthor(genProperties.getAuthor());
            table.setGenerateType(GenerateTypeEnum.LIST);
            table.setParentMenuId(1L);
            boolean flag = tableService.save(table);
            if (!flag) {
                throw new GeneratorException("保存表{}信息失败", tableName);
            }
            // 保存列信息
            List<GenColumn> genColumns = columnService.listColumnByTableName(tableName);
            if (CollectionUtils.isNotEmpty(genColumns)) {
                List<GenColumn> columns = genColumns
                        .stream()
                        .peek(column -> column.setTableId(table.getId()))
                        .peek(this::initColumn)
                        .toList();
                flag = columnService.saveBatch(columns);
                if (!flag) {
                    throw new GeneratorException("保存表{}的列信息失败", tableName);
                }
            }
        }
    }

    private void initColumn(GenColumn column) {
        String columnType = column.getColumnType();
        String dataType = (columnType.contains("(") ? StringUtils.substringBefore(columnType, "(") : columnType).toLowerCase();
        dataType = dataType.replace("unsigned", "").trim();
        // 统一转小写 避免有些数据库默认大写问题
        String columnName = column.getColumnName().toLowerCase();
        // 设置java字段名
        column.setJavaField(StringUtil.toLowerCamelCase(columnName));
        column.setJavaType(switch (dataType) {
            case "date" -> JavaTypeEnum.LOCAL_DATE;
            case "time" -> JavaTypeEnum.LOCAL_TIME;
            case "datetime", "timestamp" -> JavaTypeEnum.LOCAL_DATE_TIME;
            case "tinyint" -> columnType.contains("(") && getLength(columnType) > 1 ? JavaTypeEnum.INTEGER : JavaTypeEnum.BOOLEAN;
            case "bit" -> JavaTypeEnum.BOOLEAN;
            case "smallint", "mediumint", "int", "integer", "year" -> JavaTypeEnum.INTEGER;
            case "bigint" -> JavaTypeEnum.LONG;
            case "float", "double", "decimal", "numeric" -> JavaTypeEnum.BIG_DECIMAL;
            case "binary", "varbinary", "tinyblob", "blob", "mediumblob" -> JavaTypeEnum.BYTE_ARRAY;
            default -> JavaTypeEnum.STRING;
        });
        String comment = column.getColumnComment().replace("（", "(").replace("）", ")");
        if (comment.contains("(")) {
            column.setJavaComment(StringUtils.substringBefore(comment, "("));
            column.setJavaDesc(StringUtils.substringBetween(comment, "(", ")"));
            column.setColumnOption(new ColumnOption(columnDescToSelectOptions(column),
                    true));
        } else {
            column.setJavaComment(comment);
        }
        boolean isSelect = Strings.CS.containsAny(dataType, "enum", "set");
        column.setHtmlType(switch (column.getJavaType()) {
            case JavaTypeEnum.STRING ->
                    isSelect ? HtmlTypeEnum.SELECT : columnType.contains("(") && getLength(columnType) >= 500 ? HtmlTypeEnum.TEXTAREA : HtmlTypeEnum.INPUT;
            case JavaTypeEnum.LOCAL_DATE -> HtmlTypeEnum.DATE_PICKER;
            case JavaTypeEnum.LOCAL_TIME -> HtmlTypeEnum.TIME_PICKER;
            case JavaTypeEnum.LOCAL_DATE_TIME -> HtmlTypeEnum.DATETIME_PICKER;
            case JavaTypeEnum.BOOLEAN -> HtmlTypeEnum.RADIO;
            case JavaTypeEnum.INTEGER, JavaTypeEnum.BIG_DECIMAL -> HtmlTypeEnum.INPUT_NUMBER;
            case JavaTypeEnum.LONG -> columnName.contains("id") ? HtmlTypeEnum.SELECT : HtmlTypeEnum.INPUT_NUMBER;
            default -> HtmlTypeEnum.INPUT;
        });
        column.setQueryType(switch (column.getJavaType()) {
            case JavaTypeEnum.STRING -> isSelect ? QueryTypeEnum.EQUALS : QueryTypeEnum.LIKE;
            case JavaTypeEnum.LOCAL_DATE, JavaTypeEnum.LOCAL_TIME,
                 JavaTypeEnum.LOCAL_DATE_TIME -> QueryTypeEnum.BETWEEN;
            case JavaTypeEnum.LONG -> columnName.contains("id") ? QueryTypeEnum.IN : QueryTypeEnum.EQUALS;
            default -> QueryTypeEnum.EQUALS;
        });
        if (isSelect) {
            column.setColumnOption(new ColumnOption(columnTypeToSelectOptions(columnType), dataType.equals("enum")));
        }
        boolean need = !GenContstant.NEEDLESS.contains(columnName);
        column.setIsVisible(need);
        column.setIsQuery(need && !column.isPk() && !"remark".equals(columnName));
    }

    private int getLength(String columnType) {
        return Integer.parseInt(StringUtils.substringBetween(columnType, "(", ")"));
    }

    private List<SelectOption<String>> columnTypeToSelectOptions(String columnType) {
        return Arrays.stream(StringUtils.substringBetween(columnType, "(", ")")
                                        .replaceAll("'", "")
                                        .split(","))
                     .map(item -> new SelectOption<>(item, item))
                     .toList();
    }

    private List<SelectOption<String>> columnDescToSelectOptions(GenColumn column) {
        return Arrays.stream(column.getJavaDesc().split(","))
                     .map(item -> item.split("-"))
                     .map(item -> new SelectOption<>(item[0], item[1]))
                     .toList();
    }

    /**
     * 生成代码
     *
     * @param tableId 表ID
     */
    public void generateCode(Long tableId) {
        // 生成代码
        // 获取表信息
        GenTable table = tableService.getById(tableId);
        if (table == null) {
            throw new GeneratorException("表信息不存在");
        }
        // 获取列信息
        List<GenColumn> columns = columnService.listByTableId(tableId);
        if (CollectionUtils.isEmpty(columns)) {
            throw new GeneratorException("列信息不存在");
        }
        Map<String, Object> data = processData(table, columns);
        Map<String, String> codeMap = genCode(data, table.getGenerateType() == GenerateTypeEnum.TREE);

        String moduleName = table.getModuleName();
        String className = table.getClassName();
        String businessName = table.getBusinessName();

        String rootPath = StringUtils.defaultIfBlank(genProperties.getGenPath(), System.getProperty("user.dir"));

        String javaPath = FileUtil.joinPath(rootPath, "src", "main", "java", "cn", "sijay", "egg", moduleName);
        String vuePath = FileUtil.joinPath(rootPath, "ui", "src");
        try {
            FileUtil.writeToFile(FileUtil.joinPath(javaPath, "entity", className + ".java"), codeMap.get("entity.java"));
            FileUtil.writeToFile(FileUtil.joinPath(javaPath, "records", className + "Query.java"), codeMap.get("query.java"));
            FileUtil.writeToFile(FileUtil.joinPath(javaPath, "mapper", className + "Mapper.java"), codeMap.get("mapper.java"));
            FileUtil.writeToFile(FileUtil.joinPath(javaPath, "service", className + "Service.java"), codeMap.get("service.java"));
            FileUtil.writeToFile(FileUtil.joinPath(javaPath, "controller", className + "Controller.java"), codeMap.get("controller.java"));
            FileUtil.writeToFile(FileUtil.joinPath(vuePath, "api", moduleName, businessName + ".ts"), codeMap.get("api.ts"));
            FileUtil.writeToFile(FileUtil.joinPath(vuePath, "types", moduleName, businessName + ".ts"), codeMap.get("types.ts"));
//            FileUtil.writeToFile(FileUtil.joinPath(vuePath, "views", moduleName, businessName,"index.vue"), codeMap.get("index.vue"));
//            FileUtil.writeToFile(FileUtil.joinPath(vuePath, "views", moduleName, businessName,"dialog.vue"), codeMap.get("dialog.vue"));
//            FileUtil.writeToFile(FileUtil.joinPath(rootPath, "menuSql", className + ".sql"), codeMap.get("sql"));
        } catch (Exception e) {
            e.printStackTrace();
            throw new GeneratorException("渲染模板失败，表名：" + table.getTableName());
        }
    }

    /**
     * 生成代码
     */
    private Map<String, String> genCode(Map<String, Object> data, boolean isTree) {
        // 生成文件列表
        Map<String, String> codes = new LinkedHashMap<>();
        for (String template : TEMPLATES) {
            codes.put(template, processTemplate(template + ".ftl", data));
        }
//            codes.put("index.vue", processTemplate("index"+isTree?"":"-tree")+".ftl", data));
        return codes;
    }

    /**
     * 处理模板并返回结果
     *
     * @param templateName 模板名称
     * @param data         数据模型
     * @return 渲染后的内容
     */
    private String processTemplate(String templateName, Map<String, Object> data) {
        try {
            return FreeMarkerTemplateUtils.processTemplateIntoString(configuration.getTemplate(templateName), data);
        } catch (IOException | TemplateException e) {
            log.error("渲染模板失败: ", e);
            throw new GeneratorException("渲染模板失败，表名：" + templateName);
        }
    }

    private Map<String, Object> processData(GenTable table, List<GenColumn> columns) {
        Map<String, Object> data = new HashMap<>();
        // 字段信息
        data.put("columns", columns);
        GenColumn pk = columns.parallelStream()
                              .filter(GenColumn::isPk)
                              .findFirst()
                              .orElse(new GenColumn());
        data.put("pkColumn", pk);
        // 需要导入的包
        Set<String> imports = columns.parallelStream()
                                     .map(GenColumn::getJavaType)
                                     .map(JavaTypeEnum::getPackageName)
                                     .filter(StringUtils::isNotBlank)
                                     .collect(Collectors.toSet());
//
        data.put("hasSuper", columns.parallelStream()
                                    .map(GenColumn::getColumnName)
                                    .collect(Collectors.toSet())
                                    .containsAll(GenContstant.SUPER_FIELDS));
        // 物理表名
        data.put("tableName", table.getTableName());
        data.put("tableDef", table.getTableName().toUpperCase(Locale.ROOT));
        // Java包路径
        data.put("packageName", table.getPackageName());
        // 模块名
        data.put("moduleName", table.getModuleName());
        // 实体类名
        data.put("className", table.getClassName());
        // 实体类注释
        data.put("classComment", table.getClassComment());
        // 业务名
        data.put("businessName", table.getBusinessName());
        // 作者
        data.put("author", table.getAuthor());
        data.put("date", LocalDate.now());
        // 生成类型
        data.put("generateType", table.getGenerateType().name());
        data.put("isTree", false);
        if (table.getGenerateType() == GenerateTypeEnum.TREE) {
            // 唯一标识字段
            data.put("treeKey", StringUtil.toUpperCamelCase(table.getTreeKey()));
            // 父标识字段
            data.put("treeParentKey", StringUtil.toUpperCamelCase(table.getTreeParentKey()));
            // 展示字段
            data.put("treeLabel", StringUtil.toUpperCamelCase(table.getTreeLabel()));
            data.put("parentId", pk.getJavaType() == JavaTypeEnum.LONG ? "0L" : "\"0\"");
            data.put("isTree", true);
            imports.add("java.util.List");
        }
        // 所属菜单
        data.put("parentMenuId", table.getParentMenuId());
        data.put("imports", imports);
        return data;
    }

    public List<GenTable> listDbTable(GenTableQuery query) {
        return tableService.listDbTable(query);
    }
}
