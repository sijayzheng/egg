package cn.sijay.egg.${moduleName}.records;

<#list imports as import>
import ${import};
</#list>
import java.util.List;

/**
 * ${className}查询对象
 *
 * @author ${author}
 * @since ${date}
 */
public record ${className}Query(
<#list columns?filter(item -> item.isQuery) as column>
    <#if column.queryType=="IN">
        List<${column.javaType.code}> ${column.javaField}<#sep>,</#sep>
    <#elseif column.queryType=="BETWEEN">
        ${column.javaType.code} ${column.javaField}Start<#sep>,</#sep>
        ${column.javaType.code} ${column.javaField}End<#sep>,</#sep>
    <#else>
        ${column.javaType.code} ${column.javaField}<#sep>,</#sep>
    </#if>
</#list>
){
}
