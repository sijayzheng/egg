package cn.sijay.egg.generator.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * QueryTypeEnum
 *
 * @author sijay
 * @since 2025-11-04
 */
@Getter
@AllArgsConstructor
public enum QueryTypeEnum {

    EQUALS("相等"),
    IN("在列表"),
    BETWEEN("介于"),
    LIKE("包含"),
    ;
    private final String label;
}
