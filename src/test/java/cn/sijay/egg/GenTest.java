package cn.sijay.egg;

import cn.sijay.egg.generator.entity.GenTable;
import cn.sijay.egg.generator.service.GenService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

/**
 * GenTest
 *
 * @author sijay
 * @since 2025-11-04
 */
@SpringBootTest
public class GenTest {
    @Autowired
    private GenService genService;

    @Test
    public void importTable() {
        genService.importTable(List.of("test_table", "test_tree"));
    }

    @Test
    void listDbTable() {
        genService.listDbTable(new GenTable())
                  .forEach(System.out::println);
    }

    @Test
    void generateCode() {
        genService.generateCode(1L);
        genService.generateCode(2L);
    }

}
