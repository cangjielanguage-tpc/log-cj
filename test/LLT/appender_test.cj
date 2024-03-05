// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
package test

from logcj import utils.*
from logcj import config.*
from logcj import appender.*
from std import collection.*
from std import io.*
from std import fs.*
from std import time.*
from std import sync.*

main(): Int64 {
    println("测试开始")

    var res1: Bool = testConsoleLoggerAppenderWithDefaultPattern()
    println("testConsoleLoggerAppenderWithDefaultPattern = ${res1}")

    var res2: Bool = testConsoleLoggerAppenderWithOtherPattern()
    println("testConsoleLoggerAppenderWithOtherPattern = ${res2}")

    var res3: Bool = testFileLoggerAppenderWithDefaultPattern()
    println("testFileLoggerAppenderWithDefaultPattern = ${res3}")

    var res4: Bool = testFileLoggerAppenderWithOtherPattern()
    println("testFileLoggerAppenderWithOtherPattern = ${res4}")

    var res5: Bool = testFileLoggerAppenderWithErrorRolling()
    println("testFileLoggerAppenderWithErrorRolling = ${res5}")

    var res6: Bool = testFileLoggerAppenderWithRightRolling()
    println("testFileLoggerAppenderWithRightRolling = ${res6}")
    var res7: Bool = testAppenderFactoryNoType()
    println("testAppenderFactoryNoType = ${res7}")

    var res8: Bool = testAppenderFactorWithConsoleType()
    println("testAppenderFactorWithConsoleType = ${res8}")

    var res9: Bool = testAppenderFactorWithInitParams()
    println("testAppenderFactorWithInitParams = ${res9}")

    var res10: Bool = testAppenderFactorNoNew()
    println("testAppenderFactorNoNew = ${res10}")

    var res11: Bool = testAppenderReference()
    println("testAppenderReference = ${res11}")

    var res12: Bool = testAppenderReferenceWithInitParams()
    println("testAppenderReferenceWithInitParams = ${res12}")

    var res13: Bool = testAppenderReferenceWithSetter()
    println("testAppenderReferenceWithSetter = ${res13}")

    var res14: Bool = testLevelEnabled()
    println("testLevelEnabled = ${res14}")
    var res15: Bool = testLevelEnabled01()
    println("testLevelEnabled01 = ${res15}")
    var res16: Bool = testInfoNotEnabled()
    println("testInfoNotEnabled = ${res16}")
    var res17: Bool = testErrorEnabled()
    println("testErrorEnabled = ${res17}")
    var res18: Bool = testWarnEnabled()
    println("testWarnEnabled = ${res18}")
    var res19: Bool = testTraceEnabled()
    println("testTraceEnabled = ${res19}")
    var res20: Bool = testFatalEnabled()
    println("testFatalEnabled = ${res20}")
    var res21: Bool = testDebugEnabled()
    println("testDebugEnabled = ${res21}")
    println("测试结束")
    if (res1 && res2 && res3 && res4 && res5 && res7 && res8 && res6) {
        return 0
    }

    if (res9 && res10 && res11 && res12 && res13) {
        return 0
    }

    if (res14 && res15 && res16 && res17 && res18 && res19 && res20 && res21) {
        return 0
    }
    return -1
}

func testConsoleLoggerAppenderWithDefaultPattern(): Bool {
    var console: ConsoleLoggerAppender = ConsoleLoggerAppender()
    console.initAppender("", ArrayList<AppenderProperty>())
    console.start()
    var logRecord = LogRecord("com.test", LogLevel.ALL, DateTime.now(), "source", "message", Thread.currentThread.id)
    if (logRecord.getTagName() != "com.test") {
        return false
    }
    console.logWrite(logRecord)
    console.close()
    var content: String = getDefaultPatternConvert().formatLogRecord("[%T %D %m] [%L][%l] (%S) %M", logRecord)
    let timeSlice = TimeSlice()
    timeSlice.getTimeSlice(logRecord.getCreatedTime())
    var lt = timeSlice.getLongTime()
    var ld = timeSlice.getLongDate()
    var m = flushLeft((logRecord.getCreatedTime().nanosecond / Int64(1e6)).toString(), 3, "0")
    var level = logRecord.getLevel().levelName()
    var tagName = logRecord.getTagName()
    var message = logRecord.getMessage()
    var source = logRecord.getSource()
    var formatContent: String = "[${lt} ${ld} ${m}] [${level}][${tagName}] (${source}) ${message}"
    var containResult: Bool = content.contains(formatContent[0..55])
    if (!containResult) {
        return false
    }
    return true
}

func testConsoleLoggerAppenderWithOtherPattern(): Bool {
    var console: ConsoleLoggerAppender = ConsoleLoggerAppender()
    console.initAppender("[%T %D] [%L] (%S) %M]", ArrayList<AppenderProperty>())
    console.start()
    var logRecord = LogRecord("com.test", LogLevel.ALL, DateTime.now(), "source", "message", Thread.currentThread.id)
    if (logRecord.getTagName() != "com.test") {
        return false
    }
    console.logWrite(logRecord)
    console.close()
    var content: String = getDefaultPatternConvert().formatLogRecord("[%D %T] [%L] (%S) %M", logRecord)
    let timeSlice = TimeSlice()
    timeSlice.getTimeSlice(logRecord.getCreatedTime())
    var lt = timeSlice.getLongTime()
    var ld = timeSlice.getLongDate()
    var level = logRecord.getLevel().levelName()
    var message = logRecord.getMessage()
    var source = logRecord.getSource()
    var formatContent: String = "[${ld} ${lt}] [${level}] (${source}) ${message}"
    var containResult: Bool = content.contains(formatContent[0..39])
    if (!containResult) {
        return false
    }
    return true
}

func testFileLoggerAppenderWithDefaultPattern(): Bool {
    var file: FileLoggerAppender = FileLoggerAppender()
    file.initAppender("", ArrayList<AppenderProperty>())
    file.start()
    var logRecord = LogRecord("com.test.file", LogLevel.INFO, DateTime.now(), "source", "message", Thread.currentThread.id)
    file.logWrite(logRecord)
    file.close()
    var res = getQueryResult("", logRecord, "root.log")
    if (!getQueryResult("", logRecord, "root.log")) {
        return false
    }
    return true
}

func testFileLoggerAppenderWithOtherPattern(): Bool {
    var file: FileLoggerAppender = FileLoggerAppender()
    var proList = ArrayList<AppenderProperty>()
    var fileName = AppenderProperty("filename", "test-file.log")
    var maxSize = AppenderProperty("maxsize", "500")
    var daily = AppenderProperty("daily", "false")
    var rotate = AppenderProperty("rotate", "true")
    var retentionDays = AppenderProperty("retentiondays", "3")
    proList.append(fileName)
    proList.append(maxSize)
    proList.append(daily)
    proList.append(rotate)
    proList.append(retentionDays)
    file.initAppender("[%D %T] [%L] (%S) %M", proList)
    file.start()
    var logRecord = LogRecord("com.test.file", LogLevel.INFO, DateTime.now(), "source", "message", Thread.currentThread.id)
    file.logWrite(logRecord)
    file.close()
    if (!getQueryResult("[%D %T] [%L] (%S) %M", logRecord, "test-file.log")) {
        return false
    }
    return true
}

func testFileLoggerAppenderWithErrorRolling(): Bool {
    for (i in 0..10) {
        var file: FileLoggerAppender = FileLoggerAppender()
        var proList = ArrayList<AppenderProperty>()
        var maxSize = AppenderProperty("maxsize", "1")
        var fileName = AppenderProperty("filename", "test-error.log")
        proList.append(maxSize)
        proList.append(fileName)
        file.initAppender("", proList)
        file.start()
        var logRecord = LogRecord("com.error.file", LogLevel.INFO, DateTime.now(), "source", "message", Thread.currentThread.id)
        file.logWrite(logRecord)
        file.close()
    }
    if (!getQueryFileRollingRes("test-error.log_")) {
        return true
    }
    return false
}

func testFileLoggerAppenderWithRightRolling(): Bool {
    for (i in 0..2) {
        var file: FileLoggerAppender = FileLoggerAppender()
        var proList = ArrayList<AppenderProperty>()
        var maxSize = AppenderProperty("maxsize", "1")
        var fileName = AppenderProperty("filename", "test-right.log")
        var rotate = AppenderProperty("rotate", "true")
        proList.append(maxSize)
        proList.append(fileName)
        proList.append(rotate)
        file.initAppender("", proList)
        file.start()
        var logRecord = LogRecord("com.right.file", LogLevel.INFO, DateTime.now(), "source", "message", Thread.currentThread.id)
        file.logWrite(logRecord)
        file.close()
    }
    if (!getQueryFileRollingRes("test-right.log_")) {
        return false
    }
    return true
}

func testAppenderFactoryNoType(): Bool {
    var factory: LoggerAppenderFactory = LoggerAppenderFactory()
    var instance: LoggerAppenderFactory = factory.new()
    var console = instance.registerLoggerAppender(
        "console",
        "console",
        "[%D %T %m] [%L] [%l] (%S) %M",
        ArrayList<AppenderProperty>()
    )
    var res: Bool = console.getAppenderByName("console") is ConsoleLoggerAppender
    if (!res) {
        return true
    }
    return false
}

func testAppenderFactorWithConsoleType(): Bool {
    var factory: LoggerAppenderFactory = LoggerAppenderFactory()
    var instance: LoggerAppenderFactory = factory.new()
    var fileAppender = instance.registryType("file", FileLoggerAppender())
    var res1: Bool = fileAppender.getAppenderByName("file") is ConsoleLoggerAppender
    var res2: Bool = fileAppender.getAppenderByType("file") is FileLoggerAppender

    if (res1 || !res2) {
        return false
    }
    var console = instance.registerLoggerAppender(
        "console",
        "console",
        "[%D %T %m] [%L] [%l] (%S) %M",
        ArrayList<AppenderProperty>()
    )
    var res: Bool = console.getAppenderByName("console") is ConsoleLoggerAppender
    if (res) {
        return false
    }
    return true
}

func testAppenderFactorWithInitParams(): Bool {
    var appenderList = ArrayList<String>()
    var appenderValueList = ArrayList<LoggerAppender>()
    appenderList.append("file")
    appenderValueList.append(FileLoggerAppender())
    var appenderTypeList = ArrayList<String>()
    var appenderTypeValueList = ArrayList<LoggerAppender>()
    appenderTypeList.append("console")
    appenderTypeValueList.append(ConsoleLoggerAppender())
    appenderTypeList.append("file")
    appenderTypeValueList.append(FileLoggerAppender())

    var factory: LoggerAppenderFactory = LoggerAppenderFactory(
        appenderList,
        appenderValueList,
        appenderTypeList,
        appenderTypeValueList,
        ReentrantMutex()
    )
    var instance: LoggerAppenderFactory = factory.new()
    var fileAppender = instance.registryType("file", FileLoggerAppender())

    //operator new clean appenderMap
    var res1: Bool = fileAppender.getAppenderByName("file") is ConsoleLoggerAppender
    var res2: Bool = fileAppender.getAppenderByType("file") is FileLoggerAppender
    if (!res1 || !res2) {
        return false
    }
    var file = instance.registerLoggerAppender(
        "file",
        "file",
        "[%D %T %m] [%L] [%l] (%S) %M",
        ArrayList<AppenderProperty>()
    )
    var res: Bool = file.getAppenderByName("file") is FileLoggerAppender
    if (!res) {
        return false
    }
    return true
}

func testAppenderFactorNoNew(): Bool {
    var appenderList = ArrayList<String>()
    var appenderValueList = ArrayList<LoggerAppender>()
    appenderList.append("file")
    appenderValueList.append(FileLoggerAppender())
    var factory: LoggerAppenderFactory = LoggerAppenderFactory(
        appenderList,
        appenderValueList,
        ArrayList<String>(),
        ArrayList<LoggerAppender>(),
        ReentrantMutex()
    )
    var fileAppender = factory.registryType("file", FileLoggerAppender())
    var res: Bool = fileAppender.getAppenderByName("file") is FileLoggerAppender
    if (!res) {
        return false
    }
    return true
}

func testAppenderReference(): Bool {
    var appenderRef = LoggerAppenderReference()
    var levelName: String = appenderRef.getLevel().levelName()
    var size: Int64 = appenderRef.getAppenderList().size
    if (levelName == "INFO" && size == 0) {
        return true
    }
    return false
}

func testAppenderReferenceWithInitParams(): Bool {
    var appenderList = ArrayList<LoggerAppender>()
    appenderList.append(FileLoggerAppender())
    appenderList.append(ConsoleLoggerAppender())
    var appenderRef = LoggerAppenderReference(LogLevel.INFO, appenderList)
    var levelName: String = appenderRef.getLevel().levelName()
    var size: Int64 = appenderRef.getAppenderList().size
    if (levelName == "INFO" && size == 2) {
        return true
    }
    return false
}

func testAppenderReferenceWithSetter(): Bool {
    var appenderList = ArrayList<LoggerAppender>()
    appenderList.append(FileLoggerAppender())
    appenderList.append(ConsoleLoggerAppender())
    var appenderRef = LoggerAppenderReference()
    appenderRef.setLevel(LogLevel.INFO)
    appenderRef.setAppenderList(appenderList)
    var levelName: String = appenderRef.getLevel().levelName()
    var size: Int64 = appenderRef.getAppenderList().size
    if (levelName == "INFO" && size == 2) {
        return true
    }
    return false
}

func testLevelEnabled(): Bool {
    var appenderRef = LoggerAppenderReference()
    appenderRef.setLevel(LogLevel.INFO)
    appenderRef.setAppenderList(ArrayList<LoggerAppender>())
    var debug = appenderRef.isDebugEnabled()
    var error = appenderRef.isErrorEnabled()
    var fatal = appenderRef.isFatalEnabled()
    var info = appenderRef.isInfoEnabled()
    var trace = appenderRef.isTraceEnabled()
    var warn = appenderRef.isWarnEnabled()
    var res = appenderRef.isEnabled(LogLevel.DEBUG)
    if (!debug && !error && !fatal && info && !trace && !warn && !res) {
        return true
    }
    return false
}
func testLevelEnabled01(): Bool {
    var appenderRef = LoggerAppenderReference()
    appenderRef.setLevel(LogLevel.DEBUG)
    appenderRef.setAppenderList(ArrayList<LoggerAppender>())
    var res = appenderRef.isEnabled(LogLevel.DEBUG)
    if (res) {
        return true
    }
    return false
}
func testInfoNotEnabled(): Bool {
    var appenderRef = LoggerAppenderReference()
    appenderRef.setLevel(LogLevel.DEBUG)
    appenderRef.setAppenderList(ArrayList<LoggerAppender>())
    var info = appenderRef.isInfoEnabled()
    if (!info) {
        return true
    }
    return false
}

func testDebugEnabled(): Bool {
    var appenderRef = LoggerAppenderReference()
    appenderRef.setLevel(LogLevel.DEBUG)
    appenderRef.setAppenderList(ArrayList<LoggerAppender>())
    var debug = appenderRef.isDebugEnabled()
    if (debug) {
        return true
    }
    return false
}

func testWarnEnabled(): Bool {
    var appenderRef = LoggerAppenderReference()
    appenderRef.setLevel(LogLevel.WARN)
    appenderRef.setAppenderList(ArrayList<LoggerAppender>())
    var warn = appenderRef.isWarnEnabled()
    if (warn) {
        return true
    }
    return false
}

func testTraceEnabled(): Bool {
    var appenderRef = LoggerAppenderReference()
    appenderRef.setLevel(LogLevel.TRACE)
    appenderRef.setAppenderList(ArrayList<LoggerAppender>())
    var trace = appenderRef.isTraceEnabled()
    if (trace) {
        return true
    }
    return false
}

func testFatalEnabled(): Bool {
    var appenderRef = LoggerAppenderReference()
    appenderRef.setLevel(LogLevel.FATAL)
    appenderRef.setAppenderList(ArrayList<LoggerAppender>())
    var fatal = appenderRef.isFatalEnabled()
    if (fatal) {
        return true
    }
    return false
}

func testErrorEnabled(): Bool {
    var appenderRef = LoggerAppenderReference()
    appenderRef.setLevel(LogLevel.ERROR)
    appenderRef.setAppenderList(ArrayList<LoggerAppender>())
    var error = appenderRef.isErrorEnabled()
    if (error) {
        return true
    }
    return false
}

func getQueryResult(pattern: String, rec: LogRecord, fileName: String): Bool {
    var curDir: Directory = Directory(".")
    var fileList: ArrayList<FileInfo> = curDir.fileList()
    for (f in fileList) {
        if (f.isFile() && f.path.fileName.getOrThrow() == fileName) {
            sleep(Duration.second * 3)
            var allBytes: Array<Byte> = File.readFrom(f.path.toString())
            var content: String = String.fromUtf8(allBytes)
            var time: String = rec.getCreatedTime().toString()[11..19]
            var tagName = rec.getTagName()
            var level = rec.getLevel().levelName()
            var source = rec.getSource()
            var message = rec.getMessage()

            if (pattern.size == 0 && content.contains(time) && content.contains(tagName) && content.contains(level) &&
                content.contains(source) && content.contains(message)) {
                return true
            }
            if (pattern.size != 0 && !pattern.contains("%l") && content.contains(time) && content.contains(level) &&
                content.contains(source) && content.contains(message)) {
                return true
            }
        }
    }
    return false
}

func getQueryFileRollingRes(fileName: String): Bool {
    var curDir: Directory = Directory(".")
    var fileList: ArrayList<FileInfo> = curDir.fileList()
    for (f in fileList) {
        // println(f.path.toString())
        if (f.isFile() && f.path.toString().contains(fileName)) {
            return true
        }
    }
    return false
}
