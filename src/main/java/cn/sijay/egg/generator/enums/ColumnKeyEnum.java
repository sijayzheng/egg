package cn.sijay.egg.generator.enums;

import com.mybatisflex.annotation.EnumValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * ColumnKeyEnum
 *
 * @author sijay
 * @since 2025-11-04
 */
@Getter
@AllArgsConstructor
public enum ColumnKeyEnum {
    /**
     * 无索引
     */
    NONE(""),
    /**
     * 主键
     */
    PRIMARY("PRI"),
    /**
     * 唯一索引
     */
    UNIQUE("UNI"),
    /**
     * 普通索引
     */
    MULTIPLE("MUL");

    @EnumValue
    private final String value;

    public static ColumnKeyEnum fromValue(String value) {
        for (ColumnKeyEnum type : ColumnKeyEnum.values()) {
            if (type.value.equals(value)) {
                return type;
            }
        }
        return NONE;
    }

}
