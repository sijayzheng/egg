package cn.sijay.egg.core.util;


import cn.sijay.egg.core.records.TreeNode;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * TreeUtil
 *
 * @author sijay
 * @since 2025-11-13
 */
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class TreeUtil {
    /**
     * 通用的集合转树形结构方法
     *
     * @param collection     数据集合
     * @param idGetter       提取节点ID的函数
     * @param labelGetter    提取节点标签的函数
     * @param parentIdGetter 提取父节点ID的函数
     * @param rootParentId   根节点的父ID值（通常为null、0或空字符串）
     * @param <T>            数据类型
     * @param <K>            ID类型
     * @return 树形结构列表
     */
    public static <T, K> List<TreeNode<T, K>> buildTree(Collection<T> collection, Function<T, K> idGetter, Function<T, String> labelGetter, Function<T, K> parentIdGetter, K rootParentId) {
        if (collection == null || collection.isEmpty()) {
            return new ArrayList<>();
        }
        // 将集合按ID映射
        Map<K, String> dataMap = collection.stream().collect(Collectors.toMap(idGetter, labelGetter));
        // 构建父子关系映射
        Map<K, List<T>> parentChildMap = new HashMap<>();
        for (T item : collection) {
            K parentId = parentIdGetter.apply(item);
            parentChildMap.computeIfAbsent(parentId, k -> new ArrayList<>()).add(item);
        }
        // 从根节点开始递归构建树
        return buildTreeNodes(rootParentId, parentChildMap, dataMap, labelGetter, idGetter);
    }

    /**
     * 递归构建树节点
     */
    private static <T, K> List<TreeNode<T, K>> buildTreeNodes(K parentId, Map<K, List<T>> parentChildMap, Map<K, String> dataMap, Function<T, String> labelGetter, Function<T, K> idGetter) {
        List<T> childrenData = parentChildMap.get(parentId);
        if (childrenData == null || childrenData.isEmpty()) {
            return new ArrayList<>();
        }
        List<TreeNode<T, K>> nodes = new ArrayList<>();
        for (T data : childrenData) {
            K currentId = idGetter.apply(data);
            String label = labelGetter.apply(data);
            // 递归构建子节点
            List<TreeNode<T, K>> childNodes = buildTreeNodes(currentId, parentChildMap, dataMap, labelGetter, idGetter);
            TreeNode<T, K> node = new TreeNode<>(label, currentId, childNodes);
            nodes.add(node);
        }
        return nodes;
    }
}
