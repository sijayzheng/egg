package cn.sijay.egg.core.exception;

import lombok.Getter;
import lombok.Setter;

/**
 * BaseException
 *
 * @author sijay
 * @since 2025-11-04
 */
@Getter
@Setter
public class BaseException extends RuntimeException {
    private String code;
    private String message;
    private Throwable cause;

    // 无参构造方法
    public BaseException() {
        super();
    }

    // 带有错误信息的构造方法
    public BaseException(String message) {
        super(message);
        this.message = message;
    }

    // 带有错误信息和错误码的构造方法
    public BaseException(String code, String message) {
        super(code + ": " + message);
        this.code = code;
        this.message = message;
    }

    // 带有错误信息和根本原因的构造方法
    public BaseException(String message, Throwable cause) {
        super(message, cause);
        this.message = message;
        this.cause = cause;
    }

    // 带有错误码、错误信息和根本原因的构造方法
    public BaseException(String code, String message, Throwable cause) {
        super(code + ": " + message, cause);
        this.code = code;
        this.message = message;
        this.cause = cause;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getName());
        if (code != null) {
            sb.append(" [Code: ").append(code).append("]");
        }
        if (message != null) {
            sb.append(": ").append(message);
        }
        if (cause != null) {
            sb.append("; Root Cause: ").append(cause);
        }
        return sb.toString();
    }
}
