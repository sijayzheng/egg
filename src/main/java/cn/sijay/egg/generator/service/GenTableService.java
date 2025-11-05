package cn.sijay.egg.generator.service;

import cn.sijay.egg.core.base.BaseService;
import cn.sijay.egg.generator.entity.GenTable;
import cn.sijay.egg.generator.mapper.GenTableMapper;
import com.mybatisflex.core.query.QueryChain;
import com.mybatisflex.core.query.QueryColumn;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * GenTableService
 *
 * @author sijay
 * @since 2025-11-04
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class GenTableService extends BaseService<GenTableMapper, GenTable> {
    private final GenTableMapper baseMapper;

    public List<GenTable> listDbTable(GenTable genTable) {
        QueryChain<GenTable> queryChain = queryChain().select("table_name", "table_comment")
                                                      .from("information_schema.tables")
                                                      .where("table_schema=schema()")
                                                      .and("table_name not like 'gen_%'")
                                                      .and("table_name not in (select table_name from gen_table)");
        if (StringUtils.isNotBlank(genTable.getTableComment())) {
            queryChain.and("table_comment like '%" + genTable.getTableComment() + "%'");
        }
        if (StringUtils.isNotBlank(genTable.getTableName())) {
            queryChain.and("table_name like '%" + genTable.getTableName() + "%'");
        }
        return queryChain.list();
    }

    public List<GenTable> listByTableNames(List<String> tableNames) {
        QueryChain<GenTable> queryChain = queryChain().select("table_name", "table_comment")
                                                      .from("information_schema.tables")
                                                      .where("table_schema=schema() and table_name not like 'gen_%'");
        if (CollectionUtils.isNotEmpty(tableNames)) {
//            queryChain.and(" and table_name in ('" + String.join("','", tableNames) + "')");
            queryChain.and(new QueryColumn("table_name").in(tableNames));
        }
        queryChain.orderBy("table_name");
        System.out.println(queryChain.toSQL());
        return queryChain.list();
    }

}
