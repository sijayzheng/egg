
/**
* ${className}接口
*
* @author ${author}
* @since ${date}
*/
export const ${className}Api={
<#if isTree>
  // 查询${classComment}列表
  list: (query?: ${className}Query): AxiosPromise<${className}[]> => {
    return request({
      url: '/${moduleName}/${businessName}/list',
      method: 'get',
      params: query
    })
  },
  // 获取${classComment}树
  tree: (): AxiosPromise<${className}[]> => {
    return request({
      url: '/${moduleName}/${businessName}/tree',
      method: 'get',
      params: query
    })
  },
<#else>
  // 查询${classComment}列表
  list(query?: ${className}Query) {
    return request({
      url: '/${moduleName}/${businessName}/list',
      method: 'get',
      params: query
    })
  },
</#if>
  // 获取${classComment}详细信息
  getById(${pkColumn.javaField}: ${pkColumn.javaType.tsType}) {
    return request({
      url: '/${moduleName}/${businessName}/'+${pkColumn.javaField},
      method: 'get',
      params: query
    })
  },
  // 新增${classComment}
  add(entity: ${className}) {
    return request({
      url: '/${moduleName}/${businessName}/add',
      method: 'post',
      data: query
    })
  },
  // 修改${classComment}
  edit(entity: ${className}) {
    return request({
      url: '/${moduleName}/${businessName}/edit',
      method: 'post',
      data: query
    })
  },
  // 删除${classComment}
  remove(${pkColumn.javaField}s: Array<${pkColumn.javaType.tsType}>) {
    return request({
      url: '/${moduleName}/${businessName}/',
      method: 'delete',
      data: ${pkColumn.javaField}s
    })
  },
  // 导出${classComment}列表
  export(query?: ${className}Query) {
    return request({
      url: '/${moduleName}/${businessName}/export',
      method: 'post',
      data: query
    responseType: 'blob',
  })
  },
  // 获取{classComment}导入模板
  downloadTemplate() {
    return request({
        url: '/${moduleName}/${businessName}/downloadTemplate',
        method: 'post',
        responseType: 'blob'
    })
  },
  // 导入{classComment}数据
  importDataUrl:'/${moduleName}/${businessName}/importData',
}