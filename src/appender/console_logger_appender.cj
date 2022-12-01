package appender

import utils.*

/**
 * The specific implementation class of LoggerAppender, which enables the console to print logs.
 * */
public class ConsoleLoggerAppender <: LoggerAppender {
    private var pattern: String = ""

    /**
     * Initialization ConsoleLoggerAppender
     *
     * @param pattern Date Format
     * @param property Appender Attribute List
     */
    public func initAppender(pattern: String, property: ArrayList<AppenderProperty>): Unit {
        if (pattern.size == 0) {
            this.pattern = "[%T %D %m] [%L][%l] (%S) %M"
        } else {
            this.pattern = pattern
        }
    }

    /**
     * Start print
     */
    public func start(): Unit {}

    /**
     * Formatting Print Logs
     *
     * @param rec Log Recording
     */
    public func logWrite(rec: LogRecord): Unit {
        print(getDefaultPatternConvert().formatLogRecord(pattern, rec))
    }

    /**
     * End print
     */
    public func close(): Unit {}
}
