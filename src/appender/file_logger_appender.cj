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
    let DEFAULT_OUTPUT_FILE_NAME: String = "log4cj_default.log"

    // 日志打印格式
    var pattern: String = ""

    // 日志文件名称
    var fileName: String = ""

    // 日志文件指针
    var file: fs.File

    // 单个日志最大限制，为 0 则不限制
    var maxSize: Int64 = 0

    // 日志当前大小
    var curSize: Int64 = 0

    // 按天滚动日志标记
    var daily: Bool = false

    // 日志文件创建时间，配合daily使用
    var opendate: Int64 = 0

    // 是否打包日志标记
    var rotate: Bool = false

    // 日志序号最大值
    var maxBackup: Int64 = 0

    var retentionDays: Int64 = 7

    let lock = ReentrantMutex()

    /**
     * 构造函数，打开或创建文件
     * */
    public init() {
        //由于仓颉没有零值，后续会在初始化appender的时候，删掉默认日志文件
        this.file = File(DEFAULT_OUTPUT_FILE_NAME, OpenOption.CreateOrAppend)
    }

    ~init() {
        if (!file.isClosed()) {
            file.flush()
            file.close()
        }
    }

    /**
     * 初始化 fileAppender
     * */
    public func initAppender(pattern: String, property: ArrayList<AppenderProperty>): Unit {
        //删除default.log
        File.delete(this.file.info.path)
        var file = ""
        let dFormat = "[%T %D %m] [%L][%l] (%S) %M"
        var maxSize = 0
        var daily = false
        var rotate = false
        var retentionDays = 7

        if (pattern.size == 0) {
            this.pattern = dFormat
        } else {
            this.pattern = pattern
        }

        // Parse properties
        for (pro in property) {
            var value = pro.value.trimLeft(" \r\n").trimRight(" \r\n").toAsciiLower()
            match (pro.name.toAsciiLower()) {
                case "filename" => file = value
                case "maxsize" => maxSize = strToNumBySuffix(value, 1024, 20 * 1024 * 1024) // 默认20M
                case "daily" => daily = value != "false"
                case "rotate" => rotate = value != "false"
                case "retentiondays" => retentionDays = getNumByString(value, 7)
                case _ => print("LoadConfiguration: Warning: Unknown property ${pro.name}")
            }
        }

        if (file.size == 0) {
            file = "root.log"
        }
        this.fileName = file
        this.rotate = rotate

        this.maxBackup = 999
        this.maxSize = maxSize
        this.daily = daily
        this.retentionDays = retentionDays
    }

    public func start(): Unit {
        // 获取文件信息，不存在则直接创建，存在进行处理,获取已写入的大小
        this.file = File(this.fileName, OpenOption.CreateOrAppend)
        this.curSize = this.file.info.length
        this.opendate = this.file.info.creationTime.day()
    }

    /**
     * 写日志实现
     * */
    public func logWrite(rec: LogRecord): Unit {
        let now = Time.now()
        if ((this.maxSize > 0 && this.curSize >= this.maxSize) || (this.daily && now.day() != this.opendate)) {
            rollingFile()
        }

        // Perform the write
        var mess = getDefaultPatternConvert().formatLogRecord(this.pattern, rec).toUtf8Array()
        try {
            this.file.write(mess)
        } catch (e: FSException) {
            println("write file occur exception: ${e.message}")
            return
        }
        let n = mess.size

        // Update the size
        this.curSize += n
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
    public func rollingFile() {
        if (!this.rotate) {
            return
        }

        lock.lock()

        // 关闭当前文件
        if (!this.file.isClosed()) {
            this.file.flush()
            this.file.close()
        }

        var num = 1
        var fname = ""

        // 如果配置中的 daily 为 true（按天归档），打开日期不等于当天
        if (this.daily && Time.now().day() != this.opendate) {
            // 获取昨天时间，格式化到日
            let yesterday = Time.now().addDays(0, 0, -1).toString("YYYYMMdd")

            // 累加 num，不超过 maxbackup 变量
            while (num <= this.maxBackup) {
                fname = this.fileName + "_" + yesterday + "." + num.format("03") + ".log"
                if (!File.exists(fname)) {
                    break
                }
                num++
            }

            // TODO 循环完毕没找到合适的号码，返回错误
            if (num > this.maxBackup) {
                println("Rotate: Cannot find free log number to rename ${this.fileName}")
                return
            }
            // 日志替换为当前日期
        } else {
            fname = this.fileName + "_" + Time.now().toString("YYYYMMddhhmmssS") + ".log"
        }
        try {
            // Rename the file to its newfound home
            // 将当前文件命名为fname，出错返回错误信息
            File.move(this.fileName, fname, true)

            // 打开新文件
            this.file = File(this.fileName, OpenOption.CreateOrAppend)
        } catch (e: IllegalArgumentException | FSException) {
            println("rolling file occur exception: ${e.message}")
            return
        }
        // Set the daily open date to the current date
        this.opendate = Time.now().day()
        this.curSize = 0

        // Todo 是否启动线程运行
        deleterollingFile()
        lock.unlock()
    }

    public func deleterollingFile() {
        try {
            let fileDir = this.file.info.parentDirectory.getOrThrow()
            for (file in Directory(fileDir.path).fileList()) {
                if (file.path.toString().contains(".log") &&
                    file.lastModificationTime.addDays(0, 0, this.retentionDays) < Time.now()) {
                    File.delete(file.path)
                }
            }
        } catch (e: NoneValueException) {
            println("logfile Directory is none")
            return
        }catch (e:FSException) {
            println("delete log file has occur an exception")
        }
    }
}
