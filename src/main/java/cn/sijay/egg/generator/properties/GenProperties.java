package cn.sijay.egg.generator.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * GenProperties
 *
 * @author sijay
 * @since 2025-11-04
 */
@Data
@Component
@ConfigurationProperties(prefix = "gen")
public class GenProperties {
    private String author;
    private String packageName;
    private String genPath;
}
