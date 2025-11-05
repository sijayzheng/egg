package com.grcreat.${moduleName}.service;

import com.baomidou.mybatisplus.extension.service.IService;
<#if table.crud>
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.grcreat.common.mybatis.core.page.PageQuery;
</#if>
import com.grcreat.${moduleName}.bo.${className}Bo;
import com.grcreat.${moduleName}.domain.${className};
import com.grcreat.${moduleName}.vo.${className}Vo;

import java.util.Collection;
import java.util.List;

/**
 * ${functionName}Service接口
 *
 * @author ${author}
 * @since ${datetime}
 */
public interface I${className}Service extends IService<${className}> {

    /**
     * 查询${functionName}
     *
     * @param ${pkColumn.javaField} 主键
     * @return ${functionName}
     */
    ${className}Vo queryById(${pkColumn.javaType} ${pkColumn.javaField});

    <#if table.crud>
    /**
     * 分页查询${functionName}列表
     *
     * @param bo        查询条件
     * @param pageQuery 分页参数
     * @return ${functionName}分页列表
     */
    Page<${className}Vo> queryPageList(${className}Bo bo, PageQuery pageQuery);
    </#if>

    /**
     * 查询符合条件的${functionName}列表
     *
     * @param bo 查询条件
     * @return ${functionName}列表
     */
    List<${className}Vo> queryList(${className}Bo bo);

    /**
     * 新增${functionName}
     *
     * @param bo ${functionName}
     * @return 是否新增成功
     */
    Boolean insertByBo(${className}Bo bo);

    /**
     * 修改${functionName}
     *
     * @param bo ${functionName}
     * @return 是否修改成功
     */
    Boolean updateByBo(${className}Bo bo);

    /**
     * 校验并批量删除${functionName}信息
     *
     * @param ids     待删除的主键集合
     * @param isValid 是否进行有效性校验
     * @return 是否删除成功
     */
    Boolean deleteWithValidByIds(Collection<${pkColumn.javaType}> ids, Boolean isValid);
}
