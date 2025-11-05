package cn.sijay.egg.core.records;

import java.util.List;

/**
 * TreeNode
 *
 * @author sijay
 * @since 2025-11-05
 */
public record TreeNode<T>(
        String label,
        T value,
        List<TreeNode<T>> children,
        Integer level,
        Boolean isLeaf
) {
}
