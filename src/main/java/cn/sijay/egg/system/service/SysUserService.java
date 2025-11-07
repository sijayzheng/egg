package cn.sijay.egg.system.service;

import cn.sijay.egg.core.base.BaseService;
import cn.sijay.egg.core.records.PageQuery;
import cn.sijay.egg.system.entity.SysUser;
import cn.sijay.egg.system.mapper.SysUserMapper;
import cn.sijay.egg.system.records.SysUserQuery;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;

/**
 * SysUserService
 *
 * @author sijay
 * @since 2025/11/3
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class SysUserService extends BaseService<SysUserMapper, SysUser> {

    /**
     * 分页查询测试树列表
     *
     * @param query     查询条件
     * @param pageQuery 分页参数
     * @return 测试树分页列表
     */
    public Page<SysUser> page(SysUserQuery query, PageQuery pageQuery) {
        return page(pageQuery.page(), buildQueryWrapper(query));
    }

    /**
     * 查询符合条件的测试树列表
     *
     * @param query 查询条件
     * @return 测试树列表
     */
    public List<SysUser> list(SysUserQuery query) {
        return list(buildQueryWrapper(query));
    }

    /**
     * 构建查询条件
     *
     * @param query 查询条件
     * @return 查询条件
     */
    private QueryWrapper buildQueryWrapper(SysUserQuery query) {
        return query();
    }

    /**
     * 新增测试树
     *
     * @param entity 测试树
     * @return 是否新增成功
     */
    @Transactional(rollbackFor = Exception.class)
    public Boolean insert(SysUser entity) {
        validEntityBeforeSave(entity);
        return save(entity);
    }

    /**
     * 修改测试树
     *
     * @param entity 测试树
     * @return 是否修改成功
     */
    @Transactional(rollbackFor = Exception.class)
    public Boolean update(SysUser entity) {
        validEntityBeforeSave(entity);
        return updateById(entity);
    }

    /**
     * 保存前的数据校验
     */
    private void validEntityBeforeSave(SysUser entity) {
        //TODO 做一些数据校验,如唯一约束
    }

    /**
     * 校验并批量删除测试树信息
     *
     * @param ids 待删除的主键集合
     * @return 是否删除成功
     */
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteWithValidByIds(Collection<Long> ids) {
        //TODO 做一些业务上的校验，如是否有后代，是否被引用等
        return removeByIds(ids);
    }
}
