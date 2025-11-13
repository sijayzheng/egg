package cn.sijay.egg.core.records;

import java.util.List;

/**
 * TreeNode
 *
 * @author sijay
 * @since 2025-11-05
 */
public record TreeNode<T, K>(
        String label,
        K value,
        List<TreeNode<T, K>> children,
        Integer level,
        Boolean isLeaf
) {
    public TreeNode(String label, K value, List<TreeNode<T, K>> children) {
        this(label, value, children, null, null);
    }
}
