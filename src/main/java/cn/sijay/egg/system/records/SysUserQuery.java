package cn.sijay.egg.system.records;

import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;

public record SysUserQuery(Long deptId,
                           String username,
                           Boolean isEnabled,
                           @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate loginDateStart,
                           @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate loginDateEnd) {
}