package cn.sijay.egg.generator.enums;

import com.mybatisflex.annotation.EnumValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * JavaTypeEnum
 *
 * @author sijay
 * @since 2025-11-04
 */
@Getter
@AllArgsConstructor
public enum JavaTypeEnum {
    BYTE_ARRAY("byte[]", "字节数组", ""),
    INTEGER("Integer", "整数", ""),
    LONG("Long", "长整数", ""),
    BOOLEAN("Boolean", "布尔型", ""),
    STRING("String", "字符串", ""),
    BIG_DECIMAL("BigDecimal", "数字", "java.math.BigDecimal"),
    LOCAL_DATE("LocalDate", "日期", "java.time.LocalDate"),
    LOCAL_TIME("LocalTime", "时间", "java.time.LocalTime"),
    LOCAL_DATE_TIME("LocalDateTime", "日期时间", "java.time.LocalDateTime"),
    ;
    @EnumValue
    private final String code;
    private final String label;
    private final String packageName;
}
