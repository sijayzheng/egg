package cn.sijay.egg.core.enums;

import lombok.Getter;

/**
 * ResultCode
 *
 * @author sijay
 * @since 2025/11/3
 */
@Getter
public enum ResultCode {
    SUCCESS(200, "成功"),
    BAD_REQUEST(400, "参数错误"),
    UNAUTHORIZED(401, "未授权"),
    FORBIDDEN(403, "禁止访问"),
    NOT_FOUND(404, "资源不存在"),
    INTERNAL_SERVER_ERROR(500, "系统内部异常，请联系管理员"),
    CUSTOM_ERROR(999, ""),
    // 10 用户
    USER_LOGIN_ERROR(1001, "账号不存在或密码错误"),
    USER_ACCOUNT_LOCKED(1002, "账号已被锁定"),
    USER_ACCOUNT_DISABLE(1003, "账号已被禁用"),
    USER_ACCOUNT_ALREADY_EXIST(1004, "账号已存在"),

    ;
    private final int code;
    private final String message;

    ResultCode(int code, String message) {
        this.code = code;
        this.message = message;
    }
}
