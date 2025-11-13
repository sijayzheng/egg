package cn.sijay.egg.${moduleName}.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import cn.sijay.egg.core.annotations.Log;
import cn.sijay.egg.core.annotations.RepeatSubmit;
import cn.sijay.egg.core.base.BaseController;
import cn.sijay.egg.core.enums.BusinessType;
import cn.sijay.egg.core.records.PageQuery;
import cn.sijay.egg.core.records.Result;
<#if isTree>
import cn.sijay.egg.core.records.TreeNode;
import cn.sijay.egg.core.util.TreeUtil;
</#if>
import cn.sijay.egg.core.util.ExcelUtil;
import cn.sijay.egg.${moduleName}.entity.${className};
import cn.sijay.egg.${moduleName}.records.${className}Query;
import cn.sijay.egg.${moduleName}.service.${className}Service;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

/**
 * ${className}接口控制器
 *
 * @author ${author}
 * @since ${date}
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/${moduleName}/${businessName}")
public class ${className}Controller extends BaseController {

    private final ${className}Service ${businessName}Service;

    <#if isTree>
    /**
     * 查询${classComment}列表
     */
    @SaCheckPermission("${moduleName}:${businessName}:list")
    @GetMapping("/list")
    public Result<List<${className}>> list(${className}Query query) {
        return success(${businessName}Service.list(query));
    }


    /**
     * 获取${classComment}树
     */
    @SaCheckPermission("${moduleName}:${businessName}:list")
    @GetMapping("/tree")
    public Result<List<TreeNode<${className}, ${pkColumn.javaType.code}>>> tree() {
        List<${className}> list = ${businessName}Service.list();
        return success(TreeUtil.buildTree(list, ${className}::get${treeKey}, ${className}::get${treeLabel}, ${className}::get${treeParentKey}, ${parentId}));
    }
    <#else>
    /**
     * 查询${classComment}列表
     */
    @SaCheckPermission("${moduleName}:${businessName}:list")
    @GetMapping("/list")
    public Result<List<${className}>> list(${className}Query query, PageQuery pageQuery) {
        return success(${businessName}Service.page(query, pageQuery));
    }
    </#if>

    /**
     * 获取${classComment}详细信息
     *
     * @param ${pkColumn.javaField} 主键
     */
    @SaCheckPermission("${moduleName}:${businessName}:query")
    @GetMapping("/{${pkColumn.javaField}}")
    public Result<${className}> getById(@NotNull(message = "主键不能为空") @PathVariable("${pkColumn.javaField}") ${pkColumn.javaType.code} ${pkColumn.javaField}) {
        return success(${businessName}Service.getById(${pkColumn.javaField}));
    }

    /**
     * 新增${classComment}
     */
    @SaCheckPermission("${moduleName}:${businessName}:add")
    @Log(title = "${classComment}", businessType = BusinessType.INSERT)
    @RepeatSubmit()
    @PostMapping("/add")
    public Result<Void> add(@RequestBody @Valid ${className} entity) {
        return message(${businessName}Service.insert(entity), "新增");
    }

    /**
     * 修改${classComment}
     */
    @SaCheckPermission("${moduleName}:${businessName}:edit")
    @Log(title = "${classComment}", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PostMapping("/edit")
    public Result<Void> edit(@RequestBody @Valid ${className} entity) {
        return message(${businessName}Service.update(entity), "修改");
    }

    /**
     * 删除${classComment}
     *
     * @param ${pkColumn.javaField}s 主键串
     */
    @SaCheckPermission("${moduleName}:${businessName}:remove")
    @Log(title = "${classComment}", businessType = BusinessType.DELETE)
    @DeleteMapping
    public Result<Void> remove(@NotEmpty(message = "主键不能为空") List<${pkColumn.javaType.code}> ${pkColumn.javaField}s) {
        return message(${businessName}Service.deleteWithValidByIds(${pkColumn.javaField}s), "删除");
    }

    /**
     * 导出${classComment}列表
     */
    @SaCheckPermission("${moduleName}:${businessName}:export")
    @Log(title = "${classComment}", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(${className}Query query, HttpServletResponse response) {
        List<${className}> list = ${businessName}Service.list(query);
        ExcelUtil.exportExcel(list, "${classComment}", ${className}.class, response);
    }

    /**
     * 获取导入模板
     */
    @PostMapping("/downloadTemplate")
    public void downloadTemplate(HttpServletResponse response) {
        ExcelUtil.exportExcel(new ArrayList<>(), "${classComment}模板", ${className}.class, response);
    }

    /**
     * 导入数据
     *
     * @param file          导入文件
     * @param updateSupport 是否更新已存在数据
     */
    @Log(title = "${classComment}", businessType = BusinessType.IMPORT)
    @SaCheckPermission("${moduleName}:${businessName}:import")
    @PostMapping(value = "/importData", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<Void> importData(@RequestPart("file") MultipartFile file, boolean updateSupport) throws Exception {
        List<${className}> result = ExcelUtil.importExcel(file.getInputStream(), ${className}.class);
        if (CollectionUtils.isEmpty(result)) {
            return error("导入数据不能为空");
        }
        boolean flag = ${businessName}Service.saveBatch(result);
        return message(flag, "数据导入");
    }

}
