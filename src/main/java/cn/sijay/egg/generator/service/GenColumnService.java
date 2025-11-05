package cn.sijay.egg.generator.service;

import cn.sijay.egg.core.base.BaseService;
import cn.sijay.egg.generator.entity.GenColumn;
import cn.sijay.egg.generator.mapper.GenColumnMapper;
import com.mybatisflex.core.query.QueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

import static cn.sijay.egg.generator.entity.table.GenColumnTableDef.GEN_COLUMN;

/**
 * GenColumnService
 *
 * @author sijay
 * @since 2025-11-04
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class GenColumnService extends BaseService<GenColumnMapper, GenColumn> {
    public List<GenColumn> listByTableId(Long tableId) {
        return list(QueryWrapper.create().from(GEN_COLUMN).where(GEN_COLUMN.TABLE_ID.eq(tableId)));
    }

    public List<GenColumn> listColumnByTableName(String tableName) {
        return queryChain().select("column_name", "column_key", "column_comment", "ordinal_position as sort", "is_nullable='NO' as is_required", "column_type")
                           .from("information_schema.COLUMNS")
                           .where("TABLE_SCHEMA=schema() and table_name='" + tableName + "'")
                           .orderBy("ordinal_position")
                           .list();

    }
}
