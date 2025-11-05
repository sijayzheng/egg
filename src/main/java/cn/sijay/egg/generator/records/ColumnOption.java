package cn.sijay.egg.generator.records;

import cn.sijay.egg.core.records.SelectOption;

import java.util.List;

/**
 * ColumnOption
 *
 * @author sijay
 * @since 2025-11-04
 */
public record ColumnOption(
        String dictCode,
        List<SelectOption<String>> dictData,
        Boolean isSingleChose
) {
    public ColumnOption(String dictCode, Boolean isSingleChose) {
        this(dictCode, null, isSingleChose);
    }

    public ColumnOption(List<SelectOption<String>> dictData, Boolean isSingleChose) {
        this(null, dictData, isSingleChose);
    }
}
