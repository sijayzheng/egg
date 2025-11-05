package cn.sijay.egg.core.base;

import com.mybatisflex.core.BaseMapper;
import com.mybatisflex.core.exception.FlexExceptions;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.*;
import com.mybatisflex.core.row.Db;
import com.mybatisflex.core.update.UpdateChain;
import com.mybatisflex.core.util.ClassUtil;
import com.mybatisflex.core.util.CollectionUtil;
import com.mybatisflex.core.util.SqlUtil;
import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * BaseService
 *
 * @author sijay
 * @since 2025/11/3
 */
public class BaseService<M extends BaseMapper<T>, T> {
    @Getter
    @Autowired
    protected M mapper;

    public boolean save(T entity) {
        return SqlUtil.toBool(mapper.insert(entity, true));
    }

    public boolean saveBatch(Collection<T> entities) {
        return this.saveBatch(entities, 1000);
    }

    public boolean saveBatch(Collection<T> entities, int batchSize) {
        if (entities == null || entities.isEmpty()) {
            return true;
        }
        @SuppressWarnings("unchecked")
        Class<BaseMapper<T>> usefulClass = (Class<BaseMapper<T>>) ClassUtil.getUsefulClass(this.getMapper().getClass());
        return SqlUtil.toBool(Db.executeBatch(entities, batchSize, usefulClass, BaseMapper::insertSelective));
    }

    public boolean saveOrUpdate(T entity) {
        return SqlUtil.toBool(mapper.insertOrUpdate(entity, true));
    }

    public boolean remove(QueryWrapper query) {
        return SqlUtil.toBool(mapper.deleteByQuery(query));
    }

    public boolean remove(QueryCondition condition) {
        return remove(query().where(condition));
    }

    public boolean removeById(T entity) {
        return SqlUtil.toBool(mapper.delete(entity));
    }

    public boolean removeById(Serializable id) {
        return SqlUtil.toBool(mapper.deleteById(id));
    }

    public boolean removeByIds(Collection<? extends Serializable> ids) {
        return !CollectionUtil.isEmpty(ids) && SqlUtil.toBool(mapper.deleteBatchByIds(ids));
    }

    public boolean removeByMap(Map<String, Object> query) {
        if (query != null && !query.isEmpty()) {
            return remove(query().where(query));
        } else {
            throw FlexExceptions.wrap("deleteByMap is not allow empty map.");
        }
    }

    public boolean updateById(T entity) {
        return SqlUtil.toBool(mapper.update(entity, true));
    }

    public boolean update(T entity, Map<String, Object> query) {
        return update(entity, query().where(query));
    }

    public boolean update(T entity, QueryWrapper query) {
        return SqlUtil.toBool(mapper.updateByQuery(entity, query));
    }

    public boolean update(T entity, QueryCondition condition) {
        return update(entity, query().where(condition));
    }

    public T getById(Serializable id) {
        return mapper.selectOneById(id);
    }

    public T getOneByEntityId(T entity) {
        return mapper.selectOneByEntityId(entity);
    }

    public T getOne(QueryWrapper query) {
        return mapper.selectOneByQuery(query);
    }

    public <R> R getOneAs(QueryWrapper query, Class<R> asType) {
        return mapper.selectOneByQueryAs(query, asType);
    }

    public T getOne(QueryCondition condition) {
        return getOne(query().where(condition).limit(1));
    }

    public Object getObj(QueryWrapper query) {
        return mapper.selectObjectByQuery(query);
    }

    public <R> R getObjAs(QueryWrapper query, Class<R> asType) {
        return mapper.selectObjectByQueryAs(query, asType);
    }

    public List<Object> objList(QueryWrapper query) {
        return mapper.selectObjectListByQuery(query);
    }

    public <R> List<R> objListAs(QueryWrapper query, Class<R> asType) {
        return mapper.selectObjectListByQueryAs(query, asType);
    }

    public List<T> list() {
        return list(query());
    }

    public List<T> list(QueryWrapper query) {
        return mapper.selectListByQuery(query);
    }

    public List<T> list(QueryCondition condition) {
        return list(query().where(condition));
    }

    public <R> List<R> listAs(QueryWrapper query, Class<R> asType) {
        return mapper.selectListByQueryAs(query, asType);
    }

    public List<T> listByIds(Collection<? extends Serializable> ids) {
        return mapper.selectListByIds(ids);
    }

    public List<T> listByMap(Map<String, Object> query) {
        return list(query().where(query));
    }

    public boolean exists(QueryWrapper query) {
        return exists(CPI.getWhereQueryCondition(query));
    }

    public boolean exists(QueryCondition condition) {
        QueryWrapper queryWrapper = QueryMethods.selectOne().where(condition).limit(1);
        List<Object> objects = mapper.selectObjectListByQuery(queryWrapper);
        return CollectionUtil.isNotEmpty(objects);
    }

    public long count() {
        return count(query());
    }

    public long count(QueryWrapper query) {
        return mapper.selectCountByQuery(query);
    }

    public long count(QueryCondition condition) {
        return count(query().where(condition));
    }

    public Page<T> page(Page<T> page) {
        return page(page, query());
    }

    public Page<T> page(Page<T> page, QueryWrapper query) {
        return mapper.paginateAs(page, query, null);
    }

    public QueryWrapper query() {
        return QueryWrapper.create();
    }

    public QueryChain<T> queryChain() {
        return QueryChain.of(mapper);
    }

    public UpdateChain<T> updateChain() {
        return UpdateChain.create(mapper);
    }
}
