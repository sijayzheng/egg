-- 菜单 SQL
insert into sys_menu (menu_id, menu_name, parent_id, sort, path, component, is_frame, is_cache, menu_type, visible, is_enable, perms, icon, remark)
values(${menuIds[0]}, '${functionName}', ${parentMenuId}, 1, '${businessName}', '${moduleName}/${businessName}', 1, 0, 'C', '0', 1, '${permissionPrefix}:list', 'category', '${functionName}菜单');
-- 按钮 SQL
insert into sys_menu (menu_id, menu_name, parent_id, sort, is_frame, is_cache, menu_type, visible, is_enable, perms, icon)
values(${menuIds[1]}, '${functionName}查询', ${menuIds[0]}, 1, 1, 0, 'F', '0', 1, '${permissionPrefix}:query', '#'),
      (${menuIds[2]}, '${functionName}新增', ${menuIds[0]}, 2, 1, 0, 'F', '0', 1, '${permissionPrefix}:add', '#'),
      (${menuIds[3]}, '${functionName}修改', ${menuIds[0]}, 3, 1, 0, 'F', '0', 1, '${permissionPrefix}:edit', '#'),
      (${menuIds[4]}, '${functionName}删除', ${menuIds[0]}, 4, 1, 0, 'F', '0', 1, '${permissionPrefix}:remove', '#'),
      (${menuIds[5]}, '${functionName}导出', ${menuIds[0]}, 5, 1, 0, 'F', '0', 1, '${permissionPrefix}:export', '#'),
      (${menuIds[6]}, '${functionName}导入', ${menuIds[0]}, 6, 1, 0, 'F', '0', 1, '${permissionPrefix}:import', '#');
