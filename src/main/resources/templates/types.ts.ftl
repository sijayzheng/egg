export interface ${className} {
<#list columns?filter(item -> item.isVisible) as column>
  /**
   * ${column.columnComment}
   */
  ${column.javaField}?: ${column.javaType.tsType}
  <#if column.htmlType == "IMAGE_UPLOAD">
  /**
   * ${column.columnComment}Url
   */
  ${column.javaField}Url?: string
  </#if>
</#list>
<#if isTree>
  /**
   * 子对象
   */
  children?: ${className}[]
</#if>
}

export interface ${className}Form <#if hasSuper>extends BaseEntity</#if> {
<#list columns?filter(item -> item.isVisible) as column>
  /**
   * ${column.columnComment}
   */
  ${column.javaField}?: ${column.javaType.tsType}
</#list>
}

export interface ${className}Query <#if !isTree>extends PageQuery</#if> {
<#list columns?filter(item -> item.isQuery) as column>
  /**
   * ${column.columnComment}
   */
    <#if column.queryType=="IN">
  ${column.javaField}?: ${column.javaType.tsType}[]
    <#elseif column.queryType=="BETWEEN">
  ${column.javaField}Start?: ${column.javaType.tsType}
  ${column.javaField}End?: ${column.javaType.tsType}
    <#else>
  ${column.javaField}?: ${column.javaType.tsType}
    </#if>
</#list>
}
