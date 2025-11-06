package cn.sijay.egg.generator.constants;

import java.util.List;

/**
 * GenContstant
 *
 * @author sijay
 * @since 2025-11-06
 */
public interface GenContstant {
    List<String> NEEDLESS = List.of("create_dept", "create_by", "create_time", "is_deleted", "update_by", "update_time", "version");
    List<String> SUPER_FIELDS = List.of("create_dept", "create_by", "create_time", "update_by", "update_time");

}
