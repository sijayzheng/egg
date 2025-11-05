package com.grcreat.${moduleName}.domain;

<#if hasSuper>import com.grcreat.common.mybatis.core.domain.BaseEntity;</#if>
import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
<#if hasSuper>import lombok.EqualsAndHashCode;</#if>
<#list importList as import>
import ${import};
</#list>

<#if !hasSuper>
import java.io.Serial;
import java.io.Serializable;
</#if>

/**
 * ${functionName}对象 ${tableName}
 *
 * @author ${author}
 * @since ${datetime}
 */
@Data
<#if hasSuper>@EqualsAndHashCode(callSuper = true)</#if>
@TableName("${tableName}")
public class ${className} <#if hasSuper>extends BaseEntity<#else>implements Serializable</#if> {

    <#if !hasSuper>
    @Serial
    private static final long serialVersionUID = 1L;

    </#if>
<#list columns as column>
    <#if !table.isSuperColumn(column.javaField)>
    /**
     * ${column.columnComment}
     */
    <#if column.javaField == 'isDeleted'>
    @TableLogic
    </#if>
    <#if column.javaField == 'version'>
    @Version
    </#if>
    <#if column.isPk>
    @TableId(value = "${column.columnName}")
    </#if>
    private ${column.javaType} ${column.javaField};

    </#if>
</#list>
}
