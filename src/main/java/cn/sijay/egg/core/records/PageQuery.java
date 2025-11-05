package cn.sijay.egg.core.records;

import com.mybatisflex.core.paginate.Page;

import java.util.List;

/**
 * PageQuery
 *
 * @author sijay
 * @since 2025/11/3
 */
public record PageQuery(
        Long current,
        Long size,
        List<PageOrder> orders
) {
    public <T> Page<T> page() {
        return Page.of(current, size);
    }
}
