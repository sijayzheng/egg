package cn.sijay.egg.core.base;

import com.mybatisflex.annotation.Column;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * BaseEntity
 *
 * @author sijay
 * @since 2025/11/3
 */
@Data
public class BaseEntity {
    @Column(value = "create_dept")
    private Long createDept;

    @Column(value = "create_by")
    private Long createBy;

    @Column(value = "create_time", onInsertValue = "CURRENT_TIMESTAMP")
    private LocalDateTime createTime;

    @Column(value = "update_by")
    private Long updateBy;

    @Column(value = "update_time", onUpdateValue = "CURRENT_TIMESTAMP")
    private LocalDateTime updateTime;
}
