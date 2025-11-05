package cn.sijay.egg.system.entity;

import cn.sijay.egg.core.base.BaseEntity;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@EqualsAndHashCode(callSuper = true)
@Table(value = "sys_user")
public class SysUser extends BaseEntity {
    @Id(keyType = KeyType.Auto)
    @Column(value = "user_id")
    private Long id;

    @Column(value = "dept_id")
    private Long deptId;

    @Column(value = "username")
    private String username;

    @Column(value = "avatar")
    private Long avatar;

    @JsonIgnore
    @Column(value = "password")
    private String password;

    @Column(value = "is_enabled")
    private Boolean isEnabled;

    @Column(value = "is_deleted", isLogicDelete = true)
    private Boolean isDeleted;

    @Column(value = "login_ip")
    private String loginIp;

    @Column(value = "login_date")
    private LocalDateTime loginDate;

}