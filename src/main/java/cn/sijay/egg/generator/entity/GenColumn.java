package cn.sijay.egg.generator.entity;

import cn.sijay.egg.generator.enums.ColumnKeyEnum;
import cn.sijay.egg.generator.enums.HtmlTypeEnum;
import cn.sijay.egg.generator.enums.JavaTypeEnum;
import cn.sijay.egg.generator.enums.QueryTypeEnum;
import cn.sijay.egg.generator.records.ColumnOption;
import com.mybatisflex.annotation.Column;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import com.mybatisflex.core.handler.JacksonTypeHandler;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

/**
 * 代码生成列信息 实体类。
 *
 * @author sijay
 * @since 2025-11-04
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table("gen_column")
public class GenColumn implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 主键id
     */
    @Id(keyType = KeyType.Auto)
    @Column(value = "id")
    private Long id;

    /**
     * 表信息id
     */
    @Column(value = "table_id")
    private Long tableId;

    /**
     * 物理名
     */
    @Column(value = "column_name")
    private String columnName;

    /**
     * 注释
     */
    @Column(value = "column_comment")
    private String columnComment;

    /**
     * 数据类型
     */
    @Column(value = "column_type")
    private String columnType;

    /**
     * Java类型
     */
    @Column(value = "java_type")
    private JavaTypeEnum javaType;

    /**
     * Java字段名
     */
    @Column(value = "java_field")
    private String javaField;

    /**
     * Java字段注释
     */
    @Column(value = "java_comment")
    private String javaComment;

    /**
     * Java字段描述
     */
    @Column(value = "java_desc")
    private String javaDesc;

    /**
     * 约束类型
     */
    @Column(value = "column_key")
    private ColumnKeyEnum columnKey;

    /**
     * 是否必填
     */
    @Column(value = "is_required")
    private Boolean isRequired;

    /**
     * 是否可见
     */
    @Column(value = "is_visible")
    private Boolean isVisible;

    /**
     * 作为查询条件
     */
    @Column(value = "is_query")
    private Boolean isQuery;

    /**
     * 查询方式
     */
    @Column(value = "query_type")
    private QueryTypeEnum queryType;

    /**
     * Vue组件类型
     */
    @Column(value = "html_type")
    private HtmlTypeEnum htmlType;

    /**
     * 列其他属性
     */
    @Column(value = "column_option", typeHandler = JacksonTypeHandler.class)
    private ColumnOption columnOption;

    /**
     * 排序
     */
    @Column(value = "sort")
    private Integer sort;

    /**
     * 是否主键
     */
    public boolean isPk() {
        return ColumnKeyEnum.PRIMARY == columnKey;
    }
}
