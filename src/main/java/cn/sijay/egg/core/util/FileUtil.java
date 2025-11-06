package cn.sijay.egg.core.util;

import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

/**
 * FileUtil
 *
 * @author sijay
 * @since 2025-11-04
 */
public class FileUtil {
    /**
     * 下载文件名重新编码
     *
     * @param response     响应对象
     * @param realFileName 真实文件名
     */
//    public static void setAttachmentResponseHeader(HttpServletResponse response, String realFileName) {
//        String percentEncodedFileName = percentEncode(realFileName);
//        String contentDispositionValue = "attachment; filename=%s;filename*=utf-8''%s".formatted(percentEncodedFileName, percentEncodedFileName);
//        response.addHeader("Access-Control-Expose-Headers", "Content-Disposition,download-filename");
//        response.setHeader("Content-disposition", contentDispositionValue);
//        response.setHeader("download-filename", percentEncodedFileName);
//    }

    /**
     * 百分号编码工具方法
     *
     * @param s 需要百分号编码的字符串
     * @return 百分号编码后的字符串
     */
    public static String percentEncode(String s) {
        String encode = URLEncoder.encode(s, StandardCharsets.UTF_8);
        return encode.replaceAll("\\+", "%20");
    }

    public static List<File> listFiles(String path) {
        return listFiles(new File(path));
    }

    public static List<File> listFiles(File file) {
        if (file.isDirectory()) {
            File[] files = file.listFiles();
            if (files == null) {
                return List.of();
            } else {
                List<File> list = new ArrayList<>();
                for (File f : files) {
                    if (f.isDirectory()) {
                        list.addAll(listFiles(f));
                    } else {
                        list.add(f);
                    }
                }
                return list;
            }
        } else {
            return List.of(file);
        }
    }

    public static String joinPath(String... path) {
        return StringUtils.join(path, File.separator);
    }

    public static void writeToFile(String path, String content) {
        System.out.println(path);
        writeToFile(new File(path), content);
    }

    public static void writeToFile(String path, String content, Charset charset) {
        writeToFile(new File(path), content, charset);
    }

    public static void writeToFile(File file, String content) {
        writeToFile(file, content, StandardCharsets.UTF_8);
    }

    public static void writeToFile(File file, String content, Charset charset) {
        try {
            // 获取父目录
            Path path = file.toPath();
            Path parentDir = path.getParent();
            // 如果父目录不为空且不存在，则创建父目录
            if (parentDir != null && !Files.exists(parentDir)) {
                Files.createDirectories(parentDir);
            }
            Files.writeString(path, content, charset, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING, StandardOpenOption.WRITE);
        } catch (IOException e) {
            throw new RuntimeException("写入文件失败", e);
        }
    }
}
