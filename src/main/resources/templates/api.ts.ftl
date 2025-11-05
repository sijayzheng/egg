import { AxiosPromise } from 'axios';

/**
 * 查询${functionName}列表
 * @param query
 * @returns {*}
 */
const list${className} = (query?: ${className}Query): AxiosPromise<${className}VO[]> => {
  return request({
    url: '/${moduleName}/${businessName}/list',
    method: 'get',
    params: query
  });
}

/**
 * 查询${functionName}详细
 * @param ${pkColumn.javaField}
 */
const get${className} = (${pkColumn.javaField}: string | number): AxiosPromise<${className}VO> => {
  return request({
    url: '/${moduleName}/${businessName}/' + ${pkColumn.javaField},
    method: 'get'
  });
}

/**
 * 新增${functionName}
 * @param data
 */
const add${className} = (data: ${className}Form) => {
  return request({
    url: '/${moduleName}/${businessName}',
    method: 'post',
    data: data
  });
}

/**
 * 修改${functionName}
 * @param data
 */
const update${className} = (data: ${className}Form) => {
  return request({
    url: '/${moduleName}/${businessName}',
    method: 'put',
    data: data
  });
}

/**
 * 删除${functionName}
 * @param ${pkColumn.javaField}
 */
const del${className} = (${pkColumn.javaField}: string | number | Array<string | number>) => {
  return request({
    url: '/${moduleName}/${businessName}/' + ${pkColumn.javaField},
    method: 'delete'
  });
}

export const ${businessName}Api = {
  list${className},
  get${className},
  add${className},
  update${className},
  del${className},
}
