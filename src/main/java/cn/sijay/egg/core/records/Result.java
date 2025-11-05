package cn.sijay.egg.core.records;

/**
 * Result
 *
 * @author sijay
 * @since 2025/11/3
 */
public record Result<T>(
        Boolean success,
        Integer code,
        String message,
        T data,
        Long total
) {

    public Result(Boolean success, Integer code, String message, T data) {
        this(success, code, message, data, 0L);
    }

    public Result(Boolean success, Integer code, String message) {
        this(success, code, message, null, 0L);
    }

}