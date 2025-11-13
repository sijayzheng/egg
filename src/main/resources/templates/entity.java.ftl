package cn.sijay.egg.${moduleName}.entity;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
<#if hasSuper>import cn.sijay.egg.core.base.BaseEntity;</#if>
import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
<#list imports as import>
import ${import};
</#list>

<#if !hasSuper>
import java.io.Serial;
import java.io.Serializable;
</#if>

/**
 * ${className}对象-${tableName}
 *
 * @author ${author}
 * @since ${date}
 */
@ExcelIgnoreUnannotated
@Data
@Table("${tableName}")
public class ${className} <#if hasSuper>extends BaseEntity<#else>implements Serializable</#if> {

<#if !hasSuper>
    @Serial
    private static final long serialVersionUID = 1L;

</#if>
<#list columns?filter(item -> !item.isSuper()) as column>
    /**
     * ${column.javaComment}
     */
    <#if column.isPk()>
    @Id(keyType = KeyType.Auto)
    </#if>
    @Column(value = "${column.columnName}"<#if column.javaField == 'isDeleted'>, isLogicDelete = true</#if><#if column.javaField == 'version'>, version = true</#if>)
    <#if !column.isPk()>
        <#if column.isRequired>
            <#if column.javaType == 'STRING'>
    @NotBlank(message = "${column.javaComment}不能为空")
            <#else>
    @NotNull(message = "${column.javaComment}不能为空")
            </#if>
        </#if>
        <#if (column.columnOption.dictCode())?has_content>
    @ExcelProperty(value = "${column.javaComment}", converter = ExcelDictConvert.class)
    @ExcelDictFormat(dictCode = "${column.columnOption.dictCode}")
        <#elseif column.javaDesc?has_content>
    @ExcelProperty(value = "${column.javaComment}", converter = ExcelDictConvert.class)
    @ExcelDictFormat(readConverterExp = "${column.javaDesc}")
        <#else>
    @ExcelProperty(value = "${column.javaComment}")
        </#if>
    </#if>
    private ${column.javaType.code} ${column.javaField};

</#list>
<#if isTree>
    /**
     * 子列表
     */
    @Column(ignore = true)
    private List<${className}> children;

</#if>
}
