package cn.sijay.egg;

import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;

/**
 * Main
 *
 * @author sijay
 * @since 2025/10/27
 */
public class Main {
    public static void main(String[] args) {
        Arrays.stream(StringUtils.substringBetween("enum('v1','v2','v3','v4','v5','v6','v7','v8','v9','v10')", "(", ")")
                                 .replaceAll("'", "")
                                 .split(","))
              .forEach(System.out::println);
    }

}