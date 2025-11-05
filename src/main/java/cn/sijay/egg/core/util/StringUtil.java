package cn.sijay.egg.core.util;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import org.apache.commons.lang3.StringUtils;

/**
 * StringUtil
 *
 * @author sijay
 * @since 2025-11-04
 */
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class StringUtil {
    public static String toUpperCamelCase(String string) {
        return toUpperCamelCase(string, "_");
    }

    public static String toUpperCamelCase(String string, String delimiter) {
        if (StringUtils.isBlank(string)) {
            return string;
        }
        string = string.toLowerCase();
        StringBuilder builder = new StringBuilder();
        for (String s : string.split(delimiter)) {
            builder.append(StringUtils.capitalize(s));
        }
        return builder.toString();
    }

    public static String toLowerCamelCase(String string) {
        return StringUtils.uncapitalize(toUpperCamelCase(string, "_"));
    }

    public static String toLowerCamelCase(String string, String delimiter) {
        return StringUtils.uncapitalize(toUpperCamelCase(string, delimiter));
    }

    public static String toLowerSnakeCase(String string) {
        return toLowerSnakeCase(string, "");
    }

    public static String toLowerSnakeCase(String string, String delimiter) {
        if (StringUtils.isBlank(string)) {
            return string;
        }
        return string.replaceAll("([a-z])" + delimiter + "([A-Z])", "$1_$2").toLowerCase();
    }

    public static String toUpperSnakeCase(String string) {
        return toUpperSnakeCase(string, "");
    }

    public static String toUpperSnakeCase(String string, String delimiter) {
        if (StringUtils.isBlank(string)) {
            return string;
        }
        return string.replaceAll("([a-z])" + delimiter + "([A-Z])", "$1_$2").toUpperCase();
    }
}
