package cn.sijay.egg.system.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import cn.sijay.egg.core.annotations.Log;
import cn.sijay.egg.core.annotations.RepeatSubmit;
import cn.sijay.egg.core.base.BaseController;
import cn.sijay.egg.core.enums.BusinessType;
import cn.sijay.egg.core.records.PageQuery;
import cn.sijay.egg.core.records.Result;
import cn.sijay.egg.core.util.ExcelUtil;
import cn.sijay.egg.system.entity.SysUser;
import cn.sijay.egg.system.records.SysUserQuery;
import cn.sijay.egg.system.service.SysUserService;
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

@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/users")
public class UserController extends BaseController {

    private final SysUserService sysUserService;

    /**
     * 查询${functionName}列表
     */
    @SaCheckPermission("${permissionPrefix}:list")
    @GetMapping("/list")
    public Result<List<SysUser>> list(SysUserQuery query, PageQuery pageQuery) {
        return success(sysUserService.page(query, pageQuery));
    }

    public Result<List<SysUser>> list(SysUserQuery query) {
        return success(sysUserService.list(query));
    }

    /**
     * 导出${functionName}列表
     */
    @SaCheckPermission("${permissionPrefix}:export")
//    @Log(title = "${functionName}", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(SysUserQuery query, HttpServletResponse response) {
        List<SysUser> list = sysUserService.list(query);
        ExcelUtil.exportExcel(list, "${functionName}", SysUser.class, response);
    }

    /**
     * 导入数据
     *
     * @param file   导入文件
     * @param update 是否更新已存在数据
     */
//    @Log(title = "${functionName}", businessType = BusinessType.IMPORT)
    @SaCheckPermission("${permissionPrefix}:import")
    @PostMapping(value = "/importData", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<Void> importData(@RequestPart("file") MultipartFile file, boolean update) throws Exception {
        List<SysUser> result = ExcelUtil.importExcel(file.getInputStream(), SysUser.class);
        if (CollectionUtils.isEmpty(result)) {
            return error("导入数据不能为空");
        }
        boolean flag = sysUserService.saveBatch(result);
        return message(flag, "数据导入成功");
    }

    /**
     * 获取导入模板
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil.exportExcel(new ArrayList<>(), "${functionName}数据", SysUser.class, response);
    }

    /**
     * 获取${functionName}详细信息
     *
     * @param id 主键
     */
    @SaCheckPermission("${permissionPrefix}:query")
    @GetMapping("/{id}")
    public Result<SysUser> getById(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return success(sysUserService.getById(id));
    }

    /**
     * 新增${functionName}
     */
    @SaCheckPermission("${permissionPrefix}:add")
//    @Log(title = "${functionName}", businessType = BusinessType.INSERT)
//    @RepeatSubmit()
    @PostMapping()
    public Result<Void> add(@RequestBody @Valid SysUser entity) {
        return message(sysUserService.insert(entity), "Add");
    }

    /**
     * 修改${functionName}
     */
    @SaCheckPermission("${permissionPrefix}:edit")
    @Log(title = "${functionName}", businessType = BusinessType.UPDATE)
    @RepeatSubmit()
    @PutMapping()
    public Result<Void> edit(@RequestBody @Valid SysUser entity) {
        return message(sysUserService.update(entity), "Edit");
    }

    /**
     * 删除${functionName}
     */
    @SaCheckPermission("${permissionPrefix}:remove")
//    @Log(title = "${functionName}", businessType = BusinessType.DELETE)
    @DeleteMapping
    public Result<Void> remove(@NotEmpty(message = "主键不能为空") List<Long> ids) {
        return message(sysUserService.deleteWithValidByIds(ids), "删除$");
    }

}