package cn.sijay.egg.system.controller;

import cn.sijay.egg.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * SysUserService
 *
 * @author sijay
 * @since 2025/11/3
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class SysUserService {
    private final SysUserMapper userMapper;
//
//    public List<SysUser> listAll() {
//        QueryWrapper query = QueryWrapper.create()
//                                         .select(SYS_USER.ALL_COLUMNS)
//                                         .from(SYS_USER)
//                                         .where(SYS_USER.IS_ENABLED.eq(true))
//                                         .and("length(username)<4");
//        return list(query);
//    }
//
//    public Page<SysUser> list(PageQuery pageQuery, SysUserQuery query) {
//        return page(pageQuery.page(), buildQueryWrapper(query));
//    }
//
//    public QueryWrapper buildQueryWrapper(SysUserQuery query) {
//        QueryWrapper wrapper = query().select(SYS_USER.ALL_COLUMNS).from(SYS_USER);
//        if (ObjectUtils.isNotEmpty(query.deptId())) {
//            wrapper.and(SYS_USER.DEPT_ID.eq(query.deptId()));
//        }
//        if (StringUtils.isNotBlank(query.username())) {
//            wrapper.and(SYS_USER.USERNAME.like(query.username()));
//        }
//        if (ObjectUtils.isNotEmpty(query.isEnabled())) {
//            wrapper.and(SYS_USER.IS_ENABLED.eq(query.isEnabled()));
//        }
//        if (ObjectUtils.isNotEmpty(query.loginDateStart()) && ObjectUtils.isNotEmpty(query.loginDateEnd())) {
//            wrapper.and(SYS_USER.LOGIN_DATE.between(query.loginDateStart(), query.loginDateEnd()));
//        }
//        return wrapper;
//    }
}
