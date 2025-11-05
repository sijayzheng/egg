package cn.sijay.egg.generator.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * HtmlTypeEnum
 *
 * @author sijay
 * @since 2025-11-04
 */
@Getter
@AllArgsConstructor
public enum HtmlTypeEnum {
    DATE_PICKER("日期选择器"),
    DATETIME_PICKER("日期时间选择器"),
    INPUT("输入框"),
    TEXTAREA("输入框"),
    INPUT_NUMBER("数字输入框"),
    RADIO("单选框"),
    SELECT("下拉选择框"),
    TIME_PICKER("时间选择器"),
    TREE_SELECT("树形选择器"),
    IMAGE_UPLOAD("图片上传"),
    FILE_UPLOAD("文件上传"),
    ;
    private final String label;

}
