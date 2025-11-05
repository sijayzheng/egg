package cn.sijay.egg.system.controller;

import cn.sijay.egg.core.base.BaseController;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/users")
public class UserController extends BaseController {
    private final SysUserService userService;

//    @GetMapping("/{id}")
//    public Mono<Result<SysUser>> getUser(@PathVariable("id") Long id) {
//        return success(userService.getById(id));
//    }
//
//    @GetMapping("/list")
//    public Mono<Result<List<SysUser>>> getUsers() {
//        return success(userService.listAll());
//    }
//
//    @GetMapping("/page")
//    public Mono<Result<List<SysUser>>> page(PageQuery pageQuery, SysUserQuery query) {
//        return success(userService.list(pageQuery, query));
//    }

}