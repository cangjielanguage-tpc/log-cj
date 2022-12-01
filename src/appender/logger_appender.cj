package appender

from std import collection.ArrayList
import config.*

/**
 * LoggerAppender Interface
 */
public interface LoggerAppender {
    /**
     * Initialization Appender
     *
     * @param pattern Date Format
     * @param property Appender Attribute List
     */
    func initAppender(pattern: String, property: ArrayList<AppenderProperty>): Unit

    /**
     * Start print
     */
    func start(): Unit

    /**
     * Formatting Print Logs
     *
     * @param rec Log Recording
     */
    func logWrite(rec: LogRecord): Unit

    /**
     * End print
     */
    func close(): Unit
}
