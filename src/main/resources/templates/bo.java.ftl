package com.grcreat.${moduleName}.bo;

<#if !hasSuper>
import com.baomidou.mybatisplus.annotation.TableField;
import com.fasterxml.jackson.annotation.JsonInclude;
</#if>
import com.grcreat.${moduleName}.domain.${className};
<#if hasSuper>import com.grcreat.common.mybatis.core.domain.BaseEntity;</#if>
import com.grcreat.common.core.validate.AddGroup;
import com.grcreat.common.core.validate.EditGroup;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;
<#if hasSuper>import lombok.EqualsAndHashCode;</#if>
import jakarta.validation.constraints.*;
<#list importList as import>
import ${import};
</#list>

<#if !hasSuper>
import java.io.Serial;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
</#if>
/**
 * ${functionName}业务对象 ${tableName}
 *
 * @author ${author}
 * @since ${datetime}
 */
@Data
<#if hasSuper>@EqualsAndHashCode(callSuper = true)</#if>
@AutoMapper(target = ${className}.class, reverseConvertGenerate = false)
public class ${className}Bo <#if hasSuper>extends BaseEntity<#else>implements Serializable</#if> {

<#if !hasSuper>
    @Serial
    private static final long serialVersionUID = 1L;

</#if>
<#list columns as column>
    <#if !table.isSuperColumn(column.javaField) && (column.isQuery || column.isInsert || column.isEdit)>
    /**
     * ${column.columnComment}
     */
    <#if column.isInsert && column.isEdit>
        <#assign Group="AddGroup.class, EditGroup.class">
    <#elseif column.isInsert>
        <#assign Group="AddGroup.class">
    <#elseif column.isEdit>
        <#assign Group="EditGroup.class">
    </#if>
    <#if column.isRequired>
        <#if column.javaType == 'String'>
    @NotBlank(message = "${column.columnComment}不能为空", groups = { ${Group} })
        <#else>
    @NotNull(message = "${column.columnComment}不能为空", groups = { ${Group} })
        </#if>
    </#if>
    private ${column.javaType} ${column.javaField};

    </#if>
</#list>


<#if !hasSuper>
    /**
     * 请求参数
     */
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    @TableField(exist = false)
    private Map<String, Object> params = new HashMap<>();
</#if>
}
