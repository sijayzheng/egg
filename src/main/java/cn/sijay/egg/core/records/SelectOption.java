package cn.sijay.egg.core.records;

/**
 * SelectOption
 *
 * @author sijay
 * @since 2025-11-05
 */
public record SelectOption<T>(
        T value,
        String label
) {
}
