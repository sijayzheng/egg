package com.grcreat.${moduleName}.vo;

<#list importList as import>
import ${import};
</#list>
import com.grcreat.${moduleName}.domain.${className};
import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import com.grcreat.common.excel.annotation.ExcelDictFormat;
import com.grcreat.common.excel.convert.ExcelDictConvert;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

/**
 * ${functionName}视图对象 ${tableName}
 *
 * @author ${author}
 * @since ${datetime}
 */
@Data
@ExcelIgnoreUnannotated
@AutoMapper(target = ${className}.class)
public class ${className}Vo implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

<#list columns as column>
<#if column.isList>
    /**
     * ${column.columnComment}
     */
    <#assign parentheseIndex=column.columnComment?index_of("（")>
    <#if parentheseIndex != -1>
        <#assign comment=column.columnComment?substring(0, parentheseIndex)>
    <#else>
        <#assign comment=column.columnComment>
    </#if>
    <#if !column.isPk>
    <#if column.dictCode?? && column.dictCode != ''>
    @ExcelProperty(value = "${comment}", converter = ExcelDictConvert.class)
    @ExcelDictFormat(dictCode = "${column.dictCode}")
    <#elseif parentheseIndex != -1>
    @ExcelProperty(value = "${comment}", converter = ExcelDictConvert.class)
    @ExcelDictFormat(readConverterExp = "${column.readConverterExp()}")
    <#else>
    @ExcelProperty(value = "${comment}")
    </#if>
    </#if>
    private ${column.javaType} ${column.javaField};

    <#if column.htmlType == "imageUpload">
    /**
     * ${column.columnComment}Url
     */
    @Translation(type = TransConstant.OSS_ID_TO_URL, mapper = "${column.javaField}")
    private String ${column.javaField}Url;
    </#if>
</#if>
</#list>
}
