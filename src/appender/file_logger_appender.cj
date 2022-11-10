package appender

from std import fs.*
from std import format.*
from std import time.*
import utils.*

/**
   LoggerAppender 的具体实现类，文件日志打印方式
 * */
public class FileLoggerAppender <: LoggerAppender {
    // 默认日志文件
    let DEFAULT_OUTPUT_FILE_NAME: String = "root.log"

    // 日志打印格式
    var pattern: String = ""

    // 日志文件名称
    var fileName: String = ""

    // 日志文件指针
    var file: fs.File

    // 文件头部信息
    var header: String = ""

    // 文件尾部信息
    var trailer: String = ""

    // 最大行
    var maxLines: Int64 = 0

    // 当前行
    var maxLines_curLines: Int64 = 0

    // 大小
    var maxSize: Int64 = 0

    var maxSize_curSize: Int64 = 0

    var daily: Bool = false
    var daily_opendate: Int64 = 0

    // Keep old logfiles (.001, .002, etc)
    var rotate: Bool = false
    var maxBackup: Int64 = 0

    /**
     * 构造函数，打开或创建文件
     * */
    public init() {
        this.file = File(DEFAULT_OUTPUT_FILE_NAME, OpenOption.CreateOrAppend)
    }

    /**
     * 初始化 fileAppender
     * */
    public func initAppender(pattern: String, property: ArrayList<AppenderProperty>): Unit {
        var file = ""
        let dFormat = "[%T %D %m] [%L][%l] (%S) %M"
        var maxLines = 0
        var maxSize = 0
        var daily = false
        var rotate = false

        if (pattern.size == 0) {
            this.pattern = dFormat
        } else {
            this.pattern = pattern
        }

        // Parse properties
        for (pro in property) {
            var value = pro.value.trimLeft(" \r\n").trimRight(" \r\n")
            match (pro.name.toAsciiLower()) {
                case "filename" => file = value
                case "maxLines" => maxLines = strToNumSuffix(value, 1000)
                case "maxSize" => maxSize = strToNumSuffix(value, 1024)
                case "daily" => daily = value != "false"
                case "rotate" => rotate = value != "false"
                case _ => print("LoadConfiguration: Warning: Unknown property ${pro.name}")
            }
        }

        if (file.size == 0) {
            print("initAppender: fileName is empty, please check it")
            return
        }
        this.fileName = file
        this.rotate = rotate

        this.maxBackup = 999
        this.maxLines = maxLines
        this.maxSize = maxSize
        this.daily = daily

        // 日志文件循环打印设置
        intRotate()
    }

    public func start(): Unit {}

    /**
     * 写日志实现
     * */
    public func logWrite(rec: LogRecord): Unit {
        let fut = spawn {
            let now = Time.now()
            if ((this.maxLines > 0 && this.maxLines_curLines >= this.maxLines) || (this.maxSize > 0 &&
                this.maxSize_curSize >= this.maxSize) || (this.daily && now.day() != this.daily_opendate)) {
                // if with Rotate to put bool to rot chan, it will be raised a bug when concurrent environment
                intRotate()
            }

            // Perform the write
            var mess = getDefaultPatternConvert().formatLogRecord(this.pattern, rec).toUtf8Array()
            this.file.write(mess)
            let n = mess.size

            // Update the counts
            this.maxLines_curLines++
            this.maxSize_curSize += n
            mess = getDefaultPatternConvert().formatLogRecord(this.trailer, LogRecord(Time.now())).toUtf8Array()
            this.file.write(mess)
            this.file.flush()
        }
        fut.getResult(1000 * 1000 * 1000)
    }

    /**
     * 关闭文件操作
     * */
    public func close(): Unit {
        if (!this.file.isClosed()) {
            this.file.flush()
            this.file.close()
        }
    }

    // If this is called in a threaded context, it MUST be synchronized
    public func intRotate() {
        // TODO 待处理默认文件和多文件循环打印功能
        if (this.fileName.size != 0) {
            this.file.flush()
            this.file.close()
            this.file = File(this.fileName, OpenOption.CreateOrAppend)
        }
    }
}
