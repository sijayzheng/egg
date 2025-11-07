package cn.sijay.egg.core.records;

import com.mybatisflex.core.paginate.Page;
import jakarta.validation.constraints.NotNull;

import java.util.List;

/**
 * PageQuery
 *
 * @author sijay
 * @since 2025/11/3
 */
public record PageQuery(
        @NotNull(message = "当前页数不能为空")
        Long current,
        @NotNull(message = "分页大小不能为空")
        Long size,
        List<PageOrder> orders
) {
    public <T> Page<T> page() {
        return Page.of(current, size);
    }
}
