package cn.sijay.egg.generator.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * GenerateTypeEnum
 *
 * @author sijay
 * @since 2025-11-04
 */
@Getter
@AllArgsConstructor
public enum GenerateTypeEnum {
    LIST("列表"),
    TREE("树表"),
    ;
    private final String label;

}
