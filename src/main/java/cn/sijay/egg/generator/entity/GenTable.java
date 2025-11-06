package cn.sijay.egg.generator.entity;

import cn.sijay.egg.generator.enums.GenerateTypeEnum;
import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * 代码生成表信息 实体类。
 *
 * @author sijay
 * @since 2025-11-04
 */
@Data
@Table("gen_table")
public class GenTable implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键id
     */
    @Id(keyType = KeyType.Auto)
    @Column(value = "id")
    private Long id;

    /**
     * 物理表名
     */
    @Column(value = "table_name")
    private String tableName;

    /**
     * 表注释
     */
    @Column(value = "table_comment")
    private String tableComment;

    /**
     * Java包路径
     */
    @Column(value = "package_name")
    private String packageName;

    /**
     * 模块名
     */
    @Column(value = "module_name")
    private String moduleName;

    /**
     * 实体类名
     */
    @Column(value = "class_name")
    private String className;

    /**
     * 实体类注释
     */
    @Column(value = "class_comment")
    private String classComment;

    /**
     * 业务名
     */
    @Column(value = "business_name")
    private String businessName;

    /**
     * 作者
     */
    @Column(value = "author")
    private String author;

    /**
     * 生成类型
     */
    @Column(value = "generate_type")
    private GenerateTypeEnum generateType;

    /**
     * 唯一标识字段
     */
    @Column(value = "tree_key")
    private String treeKey;

    /**
     * 父标识字段
     */
    @Column(value = "tree_parent_key")
    private String treeParentKey;

    /**
     * 展示字段
     */
    @Column(value = "tree_label")
    private String treeLabel;

    /**
     * 所属菜单
     */
    @Column(value = "parent_menu_id")
    private Long parentMenuId;

}
