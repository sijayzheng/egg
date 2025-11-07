package cn.sijay.egg.${moduleName}.service;

import cn.sijay.egg.core.base.BaseService;
<#if isTree>
import cn.sijay.egg.core.records.PageQuery;
import com.mybatisflex.core.paginate.Page;
</#if>
import cn.sijay.egg.${moduleName}.entity.${className};
import cn.sijay.egg.${moduleName}.mapper.${className}Mapper;
import cn.sijay.egg.${moduleName}.records.${className}Query;
import com.mybatisflex.core.query.QueryChain;
import com.mybatisflex.core.query.QueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;

import static cn.sijay.egg.${moduleName}.entity.table.${className}TableDef.${tableDef};

/**
 * ${className}业务逻辑
 *
 * @author ${author}
 * @since ${date}
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class ${className}Service extends BaseService<${className}Mapper, ${className}> {

<#if isTree>
    /**
     * 分页查询${classComment}列表
     *
     * @param query        查询条件
     * @param pageQuery 分页参数
     * @return ${classComment}分页列表
     */
    public Page<${className}> page(${className}Query query, PageQuery pageQuery) {
        return page(pageQuery.page(), buildQueryWrapper(query));
    }
</#if>

    /**
     * 查询符合条件的${classComment}列表
     *
     * @param query 查询条件
     * @return ${classComment}列表
     */
    public List<${className}> list(${className}Query query) {
        return list(buildQueryWrapper(query));
    }

    /**
     * 构建查询条件
     * @param query 查询条件
     * @return 查询条件
     */
    private QueryWrapper buildQueryWrapper(${className}Query query) {
        QueryWrapper wrapper = query().select(${tableDef}.ALL_COLUMNS).from(${tableDef});
<#list columns?filter(item -> item.isQuery) as column>
    <#if column.isQuery>
        <#if column.queryType == "BETWEEN">
        wrapper.and(${tableDef}.${column.columnName?upper_case}.between(query.${column.javaField}Start(), query.${column.javaField}End()));
        <#elseif column.queryType=="IN">
        wrapper.and(${tableDef}.${column.columnName?upper_case}.in(query.${column.javaField}()));
        <#elseif column.queryType=="LIKE">
        wrapper.and(${tableDef}.${column.columnName?upper_case}.like(query.${column.javaField}()));
        <#else>
        wrapper.and(${tableDef}.${column.columnName?upper_case}.eq(query.${column.javaField}()));
        </#if>
    </#if>
</#list>
        return wrapper;
    }

    /**
     * 新增${classComment}
     *
     * @param entity ${classComment}
     * @return 是否新增成功
     */
    @Transactional(rollbackFor = Exception.class)
    public Boolean insert(${className} entity) {
        validEntityBeforeSave(entity);
        return save(entity);
    }

    /**
     * 修改${classComment}
     *
     * @param entity ${classComment}
     * @return 是否修改成功
     */
    @Transactional(rollbackFor = Exception.class)
    public Boolean update(${className} entity) {
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
     * 校验并批量删除${classComment}信息
     *
     * @param ids 待删除的主键集合
     * @return 是否删除成功
     */
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteWithValidByIds(Collection<${pkColumn.javaType.code}> ids) {
        //TODO 做一些业务上的校验，如是否有后代，是否被引用等
        return removeByIds(ids);
    }
}
