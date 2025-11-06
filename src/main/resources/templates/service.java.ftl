package cn.sijay.egg.${moduleName}.service;

<#if table.crud>
import cn.sijay.egg.common.mybatis.core.page.PageQuery;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
</#if>
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import cn.sijay.egg.common.core.utils.MapstructUtils;
import cn.sijay.egg.common.core.utils.StringUtils;
import cn.sijay.egg.${moduleName}.entity.${className}Bo;
import cn.sijay.egg.${moduleName}.domain.${className};
import cn.sijay.egg.${moduleName}.mapper.${className}Mapper;
import cn.sijay.egg.${moduleName}.service.I${className}Service;
import cn.sijay.egg.${moduleName}.vo.${className}Vo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * ${functionName}Service业务层处理
 *
 * @author ${author}
 * @since ${date}
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class ${className}ServiceImpl extends ServiceImpl<${className}Mapper, ${className}> {

    /**
     * 查询${functionName}
     *
     * @param ${pkColumn.javaField} 主键
     * @return ${functionName}
     */
    @Override
    public ${className}Vo queryById(${pkColumn.javaType} ${pkColumn.javaField}) {
        return baseMapper.selectVoById(${pkColumn.javaField});
    }

    <#if table.crud>
    /**
     * 分页查询${functionName}列表
     *
     * @param bo        查询条件
     * @param pageQuery 分页参数
     * @return ${functionName}分页列表
     */
    @Override
    public Page<${className}Vo> queryPageList(${className}Bo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<${className}> lqw = buildQueryWrapper(bo);
        return baseMapper.selectVoPage(pageQuery.build(), lqw);
    }
    </#if>

    /**
     * 查询符合条件的${functionName}列表
     *
     * @param bo 查询条件
     * @return ${functionName}列表
     */
    @Override
    public List<${className}Vo> queryList(${className}Bo bo) {
        LambdaQueryWrapper<${className}> lqw = buildQueryWrapper(bo);
        return baseMapper.selectVoList(lqw);
    }

    private LambdaQueryWrapper<${className}> buildQueryWrapper(${className}Bo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<${className}> lqw = Wrappers.lambdaQuery();
        <#list columns as column>
        <#if column.isQuery>
            <#assign queryType=column.queryType>
            <#assign javaField=column.javaField>
            <#assign javaType=column.javaType>
            <#assign columnName=column.columnName>
            <#assign AttrName=column.javaField?cap_first>
            <#assign mpMethod=column.queryType?lower_case>
            <#if queryType != 'BETWEEN'>
                    <#if javaType == 'String'>
        lqw.${mpMethod}(StringUtils.isNotBlank(bo.get${AttrName}()), ${className}::get${AttrName}, bo.get${AttrName}());
                    <#else>
        lqw.${mpMethod}(bo.get${AttrName}() != null, ${className}::get${AttrName}, bo.get${AttrName}());
                    </#if>
                <#else>
        lqw.between(params.get("begin${AttrName}") != null && params.get("end${AttrName}") != null, ${className}::get${AttrName}, params.get("begin${AttrName}"), params.get("end${AttrName}"));
                </#if>
            </#if>
            <#assign AttrName=column.javaField?cap_first>
            <#if column.isPk>
        lqw.orderByAsc(${className}::get${AttrName});
            </#if>
        </#list>
        return lqw;
    }

    /**
     * 新增${functionName}
     *
     * @param bo ${functionName}
     * @return 是否新增成功
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public Boolean insertByBo(${className}Bo bo) {
        ${className} entity = MapstructUtils.convert(bo, ${className}.class);
        validEntityBeforeSave(entity);
        return save(entity);
    }

    /**
     * 修改${functionName}
     *
     * @param bo ${functionName}
     * @return 是否修改成功
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public Boolean updateByBo(${className}Bo bo) {
        ${className} entity = MapstructUtils.convert(bo, ${className}.class);
        validEntityBeforeSave(entity);
        return updateById(entity);
    }

    /**
     * 保存前的数据校验
     */
    private void validEntityBeforeSave(${className} entity) {
        //TODO 做一些数据校验,如唯一约束
    }

    /**
     * 校验并批量删除${functionName}信息
     *
     * @param ids 待删除的主键集合
     * @param isValid 是否进行有效性校验
     * @return 是否删除成功
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public Boolean deleteWithValidByIds(Collection<${pkColumn.javaType}> ids, Boolean isValid) {
        if (isValid) {
        //TODO 做一些业务上的校验,判断是否需要校验
        }
        return removeBatchByIds(ids);
    }
}
