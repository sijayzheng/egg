package cn.sijay.egg.core.base;

import cn.sijay.egg.core.enums.ResultCode;
import cn.sijay.egg.core.records.Result;
import com.mybatisflex.core.paginate.Page;
import org.apache.commons.collections4.CollectionUtils;

import java.util.List;

/**
 * BaseController
 *
 * @author sijay
 * @since 2025/11/3
 */
public class BaseController {

    protected Result<Void> message(Boolean flag, String message) {
        return flag ? success(message + "成功") : error(message + "失败");
    }

    protected Result<Void> success() {
        return new Result<>(true, ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage());
    }

    protected Result<Void> success(String message) {
        return new Result<>(true, ResultCode.SUCCESS.getCode(), message, null);
    }

    protected <T> Result<T> success(T data) {
        return new Result<>(true, ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), data);
    }

    protected <T> Result<List<T>> success(List<T> list) {
        if (CollectionUtils.isNotEmpty(list)) {
            return new Result<>(true, ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), list, (long) list.size());
        }
        return new Result<>(true, ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), list, 0L);
    }

    protected <T> Result<List<T>> success(Page<T> page) {
        return new Result<>(true, ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), page.getRecords(), page.getTotalRow());
    }

    protected <T> Result<T> success(Boolean success, Integer code, String message, T data) {
        return new Result<>(success, code, message, data);
    }

    protected Result<Void> error() {
        return new Result<>(false, ResultCode.INTERNAL_SERVER_ERROR.getCode(), ResultCode.INTERNAL_SERVER_ERROR.getMessage());
    }

    protected Result<Void> error(String message) {
        return new Result<>(true, ResultCode.CUSTOM_ERROR.getCode(), message);
    }

    protected Result<Void> error(ResultCode resultCode) {
        return new Result<>(false, resultCode.getCode(), resultCode.getMessage());
    }

}
