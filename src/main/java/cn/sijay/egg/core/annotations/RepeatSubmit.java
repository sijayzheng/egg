package cn.sijay.egg.core.annotations;

import java.lang.annotation.*;
import java.util.concurrent.TimeUnit;

/**
 * RepeatSubmit
 *
 * @author sijay
 * @since 2025-11-07
 */
@Inherited
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface RepeatSubmit {

    /**
     * 间隔时间(ms)，小于此时间视为重复提交
     */
    int interval() default 5000;

    TimeUnit timeUnit() default TimeUnit.MILLISECONDS;

    /**
     * 提示消息 支持国际化 格式为 {code}
     */
    String message() default "不允许重复提交，请稍候再试";

}
