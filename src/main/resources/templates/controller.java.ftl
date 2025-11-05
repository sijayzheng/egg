package com.grcreat.${moduleName}.controller;

import java.util.List;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.grcreat.common.core.domain.Result;
import com.grcreat.common.core.utils.MapstructUtils;
import com.grcreat.common.core.validate.AddGroup;
import com.grcreat.common.core.validate.EditGroup;
import com.grcreat.common.excel.utils.ExcelUtil;
import com.grcreat.common.idempotent.annotation.RepeatSubmit;
import com.grcreat.common.log.annotation.Log;
import com.grcreat.common.log.enums.BusinessType;
import com.grcreat.common.mybatis.core.page.PageQuery;
import com.grcreat.common.web.core.BaseController;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.grcreat.${moduleName}.bo.${className}Bo;
import com.grcreat.${moduleName}.domain.${className};
import com.grcreat.${moduleName}.service.I${className}Service;
import com.grcreat.${moduleName}.vo.${className}Vo;

import java.util.ArrayList;
import java.util.List;
/**
 * ${functionName}
 *
 * @author ${author}
 * @since ${datetime}
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/${moduleName}/${businessName}")
public class ${className}Controller extends BaseController {

    private final I${className}Service ${businessName}Service;

    /**
     * 查询${functionName}列表
     */
    @SaCheckPermission("${permissionPrefix}:list")
    @GetMapping("/list")
    <#if table.crud>
    public Result<${className}Vo> list(${className}Bo bo, PageQuery pageQuery) {
        return build(${businessName}Service.queryPageList(bo, pageQuery));
    }
    <#elseif table.tree>
    public Result<List<${className}Vo>> list(${className}Bo bo) {
        List<${className}Vo> list = ${businessName}Service.queryList(bo);
        return success(list);
    }
    </#if>

    /**
     * 导出${functionName}列表
     */
    @SaCheckPermission("${permissionPrefix}:export")
    @Log(title = "${functionName}", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(${className}Bo bo, HttpServletResponse response) {
    List<${className}Vo> list = ${businessName}Service.queryList(bo);
        ExcelUtil.exportExcel(list, "${functionName}", ${className}Vo.class, response);
    }

    /**
     * 导入数据
     *
     * @param file          导入文件
     * @param updateSupport 是否更新已存在数据
     */
    @Log(title = "${functionName}", businessType = BusinessType.IMPORT)
    @SaCheckPermission("${permissionPrefix}:import")
    @PostMapping(value = "/importData", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<Void> importData(@RequestPart("file") MultipartFile file, boolean updateSupport) throws Exception {
        List<${className}Vo> result = ExcelUtil.importExcel(file.getInputStream(), ${className}Vo.class);
        if (CollectionUtils.isEmpty(result)) {
            return error("导入数据不能为空");
        }
        boolean flag = ${businessName}Service.saveBatch(MapstructUtils.convert(result, ${className}.class));
        if (!flag) {
            return error("数据导入失败");
        }
        return success("数据导入成功");
    }

    /**
     * 获取导入模板
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil.exportExcel(new ArrayList<>(), "${functionName}数据", ${className}Vo.class, response);
    }

    /**
     * 获取${functionName}详细信息
     *
     * @param ${pkColumn.javaField} 主键
     */
    @SaCheckPermission("${permissionPrefix}:query")
    @GetMapping("/{${pkColumn.javaField}}")
    public Result<${className}Vo> getInfo(@NotNull(message = "主键不能为空") @PathVariable ${pkColumn.javaType} ${pkColumn.javaField}) {
        return success(${businessName}Service.queryById(${pkColumn.javaField}));
    }

    /**
     * 新增${functionName}
     */
    @SaCheckPermission("${permissionPrefix}:add")
    @Log(title = "${functionName}", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping()
    public Result<Void> add(@Validated(AddGroup.class) @RequestBody ${className}Bo bo) {
        return toAjax(${businessName}Service.insertByBo(bo));
    }

    /**
     * 修改${functionName}
     */
    @SaCheckPermission("${permissionPrefix}:edit")
    @Log(title = "${functionName}", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public Result<Void> edit(@Validated(EditGroup.class) @RequestBody ${className}Bo bo) {
        return toAjax(${businessName}Service.updateByBo(bo));
    }

    /**
     * 删除${functionName}
     *
     * @param ${pkColumn.javaField}s 主键串
     */
    @SaCheckPermission("${permissionPrefix}:remove")
    @Log(title = "${functionName}", businessType = BusinessType.DELETE)
    @DeleteMapping("/{${pkColumn.javaField}s}")
    public Result<Void> remove(@NotEmpty(message = "主键不能为空") @PathVariable ${pkColumn.javaType}[] ${pkColumn.javaField}s) {
        return toAjax(${businessName}Service.deleteWithValidByIds(List.of(${pkColumn.javaField}s), true));
    }
}
