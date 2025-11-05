export interface ${className}VO {
<#list columns as column>
<#if column.isList>
  /**
   * ${column.columnComment}
   */
  ${column.javaField}: <#if column.javaField?contains("id") || column.javaField?contains("Id")>string | number<#elseif column.javaType == 'Long' || column.javaType == 'Integer' || column.javaType == 'Double' || column.javaType == 'Float' || column.javaType == 'BigDecimal'>number<#elseif column.javaType == 'Boolean'>boolean<#else>string</#if>;
  <#if column.htmlType == "imageUpload">
  /**
   * ${column.columnComment}Url
   */
  ${column.javaField}Url: string;
  </#if>
</#if>
</#list>
<#if table.tree>
  /**
   * 子对象
   */
  children: ${className}VO[];
</#if>
}

export interface ${className}Form <#if hasSuper>extends BaseEntity</#if> {
<#list columns as column>
  <#if column.isInsert || column.isEdit>
  /**
   * ${column.columnComment}
   */
  ${column.javaField}?: <#if column.javaField?contains("id") || column.javaField?contains("Id")>string | number<#elseif column.javaType == 'Long' || column.javaType == 'Integer' || column.javaType == 'Double' || column.javaType == 'Float' || column.javaType == 'BigDecimal'>number<#elseif column.javaType == 'Boolean'>boolean<#else>string</#if>;
  </#if>
</#list>
}

export interface ${className}Query <#if !treeCode?has_content>extends PageQuery</#if> {
<#list columns as column>
  <#if column.isQuery>
  /**
   * ${column.columnComment}
   */
  ${column.javaField}?: <#if column.javaField?contains("id") || column.javaField?contains("Id")>string | number<#elseif column.javaType == 'Long' || column.javaType == 'Integer' || column.javaType == 'Double' || column.javaType == 'Float' || column.javaType == 'BigDecimal'>number<#elseif column.javaType == 'Boolean'>boolean<#else>string</#if>;
  </#if>
</#list>
  /**
   * 日期范围参数
   */
  params?: any;
}
