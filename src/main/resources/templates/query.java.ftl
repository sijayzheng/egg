package cn.sijay.egg.${moduleName}.records;

<#list imports as import>
import ${import};
</#list>

/**
 * ${className}业务对象 ${tableName}
 *
 * @author ${author}
 * @since ${date}
 */
public record ${className}Query(
<#list columns?filter(item -> item.isQuery) as column>
        ${column.javaType.code} ${column.javaField}<#sep>,</#sep>
</#list>
){
}
