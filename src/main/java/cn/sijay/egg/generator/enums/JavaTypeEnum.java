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
    BYTE_ARRAY("byte[]", "字节数组", "", "Uint8Array"),
    INTEGER("Integer", "整数", "", "number"),
    LONG("Long", "长整数", "", "number | string"),
    BOOLEAN("Boolean", "布尔型", "", "boolean"),
    STRING("String", "字符串", "", "string"),
    BIG_DECIMAL("BigDecimal", "数字", "java.math.BigDecimal", "number | string"),
    LOCAL_DATE("LocalDate", "日期", "java.time.LocalDate", "string"),
    LOCAL_TIME("LocalTime", "时间", "java.time.LocalTime", "string"),
    LOCAL_DATE_TIME("LocalDateTime", "日期时间", "java.time.LocalDateTime", "string"),
    ;
    @EnumValue
    private final String code;
    private final String label;
    private final String packageName;
    private final String tsType;
}
