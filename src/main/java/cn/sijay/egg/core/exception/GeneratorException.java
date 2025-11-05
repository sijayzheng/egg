package cn.sijay.egg.core.exception;

/**
 * GeneratorException
 *
 * @author sijay
 * @since 2025-11-05
 */
public class GeneratorException extends BaseException {
    public GeneratorException(String message) {
        super(message);
    }

    public GeneratorException(String message, Throwable cause) {
        super(message, cause);
    }

    public GeneratorException(String errorCode, String errorMessage) {
        super(errorCode, errorMessage);
    }

    public GeneratorException(String errorCode, String errorMessage, Throwable cause) {
        super(errorCode, errorMessage, cause);
    }

}
