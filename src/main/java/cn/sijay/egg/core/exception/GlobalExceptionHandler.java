package cn.sijay.egg.core.exception;

import cn.sijay.egg.core.enums.ResultCode;
import cn.sijay.egg.core.records.Result;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import reactor.core.publisher.Mono;

import java.util.Objects;

/**
 * GlobalExceptionHandler
 *
 * @author sijay
 * @since 2025/11/3
 */
@RestControllerAdvice // 全局异常处理器
public class GlobalExceptionHandler {
    protected <T> Mono<Result<T>> error(ResultCode resultCode) {
        return Mono.just(new Result<>(false, resultCode.getCode(), resultCode.getMessage()));
    }

    protected <T> Mono<Result<T>> error(String message) {
        return Mono.just(new Result<>(false, ResultCode.INTERNAL_SERVER_ERROR.getCode(), message));
    }

    // 处理校验失败的异常
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Mono<Result<Void>> handleValidationException(MethodArgumentNotValidException e) {
        // 获取校验失败的提示信息（取第一个错误）
        String errorMsg = Objects.requireNonNull(e.getBindingResult().getFieldError()).getDefaultMessage();
        return Mono.just(new Result<>(false, ResultCode.BAD_REQUEST.getCode(), "参数校验失败：" + errorMsg));
    }

    @ExceptionHandler(GeneratorException.class)
    public Mono<Result<Void>> handleGeneratorException(GeneratorException e) {
        return error(e.getMessage());
    }

    @ExceptionHandler(ServiceException.class)
    public Mono<Result<Void>> handleServiceException(ServiceException e) {
        return error(e.getMessage());
    }

    @ExceptionHandler(BaseException.class)
    public Mono<Result<Void>> handleBaseException(BaseException e) {
        return error(e.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public Mono<Result<Void>> handleException(Exception e) {
        return error(e.getMessage());
    }

}
