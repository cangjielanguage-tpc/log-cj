package appender

from std import collection.ArrayList
import config.*
import utils.*

/**
   LoggerAppender 接口
 * */
public interface LoggerAppender {
    // 初始化LoggerAppender
    func initAppender(pattern: String, property: ArrayList<AppenderProperty>): Unit

    // 启动函数
    func start(): Unit

    // 写日志函数
    func logWrite(rec: LogRecord): Unit

    // 资源释放函数
    func close(): Unit
}
