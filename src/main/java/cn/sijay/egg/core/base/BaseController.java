package cn.sijay.egg.core.base;

import cn.sijay.egg.core.enums.ResultCode;
import cn.sijay.egg.core.records.Result;
import com.mybatisflex.core.paginate.Page;
import org.apache.commons.collections4.CollectionUtils;
import reactor.core.publisher.Mono;

import java.util.List;

/**
 * BaseController
 *
 * @author sijay
 * @since 2025/11/3
 */
public class BaseController {

    protected <T> Mono<Result<T>> success() {
        return Mono.just(new Result<>(true, ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage()));
    }

    protected <T> Mono<Result<T>> success(T data) {
        return Mono.just(new Result<>(true, ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), data));
    }

    protected <T> Mono<Result<List<T>>> success(List<T> list) {
        if (CollectionUtils.isNotEmpty(list)) {
            return Mono.just(new Result<>(true, ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), list, (long) list.size()));
        }
        return Mono.just(new Result<>(true, ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), list, 0L));
    }

    protected <T> Mono<Result<List<T>>> success(Page<T> page) {
        return Mono.just(new Result<>(true, ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), page.getRecords(), page.getTotalRow()));
    }

    protected <T> Mono<Result<T>> success(Boolean success, Integer code, String message, T data) {
        return Mono.just(new Result<>(success, code, message, data));
    }

    protected <T> Mono<Result<T>> error() {
        return Mono.just(new Result<>(false, ResultCode.INTERNAL_SERVER_ERROR.getCode(), ResultCode.INTERNAL_SERVER_ERROR.getMessage()));
    }

    protected <T> Mono<Result<T>> error(String message) {
        return Mono.just(new Result<>(true, ResultCode.CUSTOM_ERROR.getCode(), message));
    }

    protected <T> Mono<Result<T>> error(ResultCode resultCode) {
        return Mono.just(new Result<>(false, resultCode.getCode(), resultCode.getMessage()));
    }

}
