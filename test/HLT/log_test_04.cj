//3rd_party_lib:log4cj2/build/log4cj

package test

from std import unittest.*
from std import unittest.testmacro.*
from log4cj import appender.*
from log4cj import config.*
from log4cj import logger.*
from log4cj import utils.*
from std import time.*
from std import collection.*
from std import fs.*
from std import io.*
from std import sync.*

/**
 * logger类的验证
 *
 *
 */
@Test
public class LogTestD {
    var flag = false

    // 验证: class LoggerAppenderReference
    @TestCase
    public func log_test_042():Unit{
        var appenderRef_01 = LoggerAppenderReference()
        @Assert(appenderRef_01.getLevel().levelName(),"INFO")
        @Assert(appenderRef_01.getAppenderList().size,0)
    }

    // 验证: class LoggerAppenderReference
    @TestCase
    public func log_test_043():Unit{
        var appenderList_02 = ArrayList<LoggerAppender>()
        appenderList_02.append(FileLoggerAppender())
        appenderList_02.append(ConsoleLoggerAppender())
        var appenderRef_02 = LoggerAppenderReference(LogLevel.ALL, appenderList_02)
        @Assert(appenderRef_02.getLevel().levelName(),"ALL")
        @Assert(appenderRef_02.getAppenderList().size,2)
    }

    // 验证: class LoggerAppenderReference
    @TestCase
    public func log_test_044():Unit{
        var appenderList_03 = ArrayList<LoggerAppender>()
        appenderList_03.append(FileLoggerAppender())
        appenderList_03.append(ConsoleLoggerAppender())
        var appenderRef_03 = LoggerAppenderReference()
        appenderRef_03.setLevel(LogLevel.ERROR)
        appenderRef_03.setAppenderList(appenderList_03)
        @Assert(appenderRef_03.getLevel().levelName(),"ERROR")
        @Assert(appenderRef_03.getAppenderList().size,2)
    }

    // 验证: class LoggerAppenderReference
    @TestCase
    public func log_test_045():Unit{
        var appenderList_04 = ArrayList<LoggerAppender>()
        var appenderRef_04 = LoggerAppenderReference()
        appenderRef_04.setLevel(LogLevel.OFF)
        appenderRef_04.setAppenderList(appenderList_04) 
        @Assert(appenderRef_04.getLevel().levelName(),"OFF")
        @Assert(appenderRef_04.getAppenderList().size,0)
    }

    // 验证: class FileLoggerAppender
    @TestCase
    public func log_test_046():Unit{
        var file_01: FileLoggerAppender = FileLoggerAppender()
        file_01.initAppender("", ArrayList<AppenderProperty>())
        file_01.start()
        var logRecord_01 = LogRecord("file_01", LogLevel.INFO, Time.now(), "source", "message")
        file_01.logWrite(logRecord_01)
        file_01.close()
        @Assert(getQueryResult("",logRecord_01,"root.log"),true)
    }

    // 验证: class FileLoggerAppender
    @TestCase
    public func log_test_047():Unit{
        var file_02: FileLoggerAppender = FileLoggerAppender()
        var proList_02 = ArrayList<AppenderProperty>()
        var fileName_02 = AppenderProperty("filename", "logRecord_02.log")
        // 这个设置是限制什么的?不是条数吗?
        var maxSize_02 = AppenderProperty("maxsize", "3") 
        var daily_02 = AppenderProperty("daily", "false")
        var rotate_02 = AppenderProperty("rotate", "true")
        var retentionDays_02 = AppenderProperty("retentiondays", "3")
        proList_02.append(fileName_02)
        proList_02.append(maxSize_02)
        proList_02.append(daily_02)
        proList_02.append(rotate_02)
        proList_02.append(retentionDays_02)
        file_02.initAppender("[%D %T] [%L] (%S) %M", proList_02)
        file_02.start()
        var logRecord_02_1= LogRecord("logRecord_02_1", LogLevel.WARN, Time.now(), "source", "message")
        file_02.logWrite(logRecord_02_1)
        var logRecord_02_2= LogRecord("logRecord_02_2", LogLevel.WARN, Time.now(), "source", "message")
        file_02.logWrite(logRecord_02_2)
        var logRecord_02_3= LogRecord("logRecord_02_3", LogLevel.WARN, Time.now(), "source", "message")
        file_02.logWrite(logRecord_02_3)
        var logRecord_02_4= LogRecord("logRecord_02_4", LogLevel.WARN, Time.now(), "source", "message")
        file_02.logWrite(logRecord_02_4)
        file_02.close()
        @Assert(getQueryResult("[%D %T] [%L] (%S) %M",logRecord_02_1,"logRecord_02.log"),true)
        @Assert(getQueryResult("[%D %T] [%L] (%S) %M",logRecord_02_2,"logRecord_02.log"),true)
        @Assert(getQueryResult("[%D %T] [%L] (%S) %M",logRecord_02_3,"logRecord_02.log"),true)
        @Assert(getQueryResult("[%D %T] [%L] (%S) %M",logRecord_02_4,"logRecord_02.log"),true)
    }

    // 验证: class FileLoggerAppender
    @TestCase
    public func log_test_048():Unit{
        var file_03: FileLoggerAppender = FileLoggerAppender()
        var proList_03 = ArrayList<AppenderProperty>()
        var fileName_03 = AppenderProperty("filename", "logRecord_03.log")
        var maxSize_03 = AppenderProperty("maxsize", "3")
        var daily_03 = AppenderProperty("daily", "false")
        var rotate_03 = AppenderProperty("rotate", "true")
        var retentionDays_03 = AppenderProperty("retentiondays", "3")
        proList_03.append(fileName_03)
        proList_03.append(maxSize_03)
        proList_03.append(daily_03)
        proList_03.append(rotate_03)
        proList_03.append(retentionDays_03)
        file_03.initAppender("[%D %T] [%L] (%S) %M", proList_03)
        file_03.start()
        file_03.close()
        var logRecord_03= LogRecord("logRecord_03", LogLevel.WARN, Time.now(), "source", "message")
        file_03.logWrite(logRecord_03)
        // close 之后还是可以输入进去??
        @Assert(getQueryResult("[%D %T] [%L] (%S) %M",logRecord_03,"logRecord_03.log"),true) 
    }

    // 验证: class ConsoleLoggerAppender
    @TestCase
    public func log_test_049():Unit{
        var console_01: ConsoleLoggerAppender = ConsoleLoggerAppender()
        console_01.initAppender("", ArrayList<AppenderProperty>())
        console_01.start()
        var logRecord_01 = LogRecord("logRecord_01", LogLevel.ALL, Time.now(), "source", "message")
        @Assert(logRecord_01.getTagName(),"logRecord_01")
        console_01.logWrite(logRecord_01)
        console_01.close()
        console_01.logWrite(logRecord_01)
        var content_01: String = getDefaultPatternConvert().formatLogRecord("[%T %D %m] [%L][%l] (%S) %M", logRecord_01)
        let timeSlice_01 = TimeSlice()
        timeSlice_01.getTimeSlice(logRecord_01.getCreatedTime())
        var lt_01 = timeSlice_01.getLongTime()
        var ld_01 = timeSlice_01.getLongDate()
        var m_01 = flushLeft((logRecord_01.getCreatedTime().nanosecond() / Int64(1e6)).toString(), 3, "0")
        var level_01 = logRecord_01.getLevel().levelName()
        var tagName_01 = logRecord_01.getTagName()
        var message_01 = logRecord_01.getMessage()
        var source_01 = logRecord_01.getSource()
        var formatContent_01: String = "[${lt_01} ${ld_01} ${m_01}] [${level_01}][${tagName_01}] (${source_01}) ${message_01}"
        @Assert(content_01.contains(formatContent_01.substring(0,55)),true)
    }

    // 验证: class ConsoleLoggerAppender
    @TestCase
    public func log_test_050():Unit{
        var console_02: ConsoleLoggerAppender = ConsoleLoggerAppender()
        console_02.initAppender("[%T %D] [%L] (%S) [%M]", ArrayList<AppenderProperty>())
        console_02.start()
        var logRecord_02 = LogRecord("logRecord_02", LogLevel.ALL, Time.now(), "source", "message")
        @Assert(logRecord_02.getTagName(),"logRecord_02")
        console_02.logWrite(logRecord_02)
        console_02.close()
        console_02.logWrite(logRecord_02)
        var content_02: String = getDefaultPatternConvert().formatLogRecord("[%D %T] [%L] (%S) %M", logRecord_02)
        let timeSlice_02 = TimeSlice()
        timeSlice_02.getTimeSlice(logRecord_02.getCreatedTime())
        var lt_02 = timeSlice_02.getLongTime()
        var ld_02 = timeSlice_02.getLongDate()
        var level_02 = logRecord_02.getLevel().levelName()
        var message_02 = logRecord_02.getMessage()
        var source_02 = logRecord_02.getSource()
        var formatContent_02: String = "[${ld_02} ${lt_02}] [${level_02}] (${source_02}) ${message_02}"
        @Assert(content_02.contains(formatContent_02.substring(0,39)),true)
    }

    // 验证: LoggerAppenderFactory
    @TestCase
    public func log_test_051():Unit{
        // testAppenderFactoryNoType
        var factory_01: LoggerAppenderFactory = LoggerAppenderFactory()
        var instance_01: LoggerAppenderFactory = factory_01.new()
        var console_01 = instance_01.registerLoggerAppender(
            "console",
            "console",
            "[%D %T %m] [%L] [%l] (%S) %M",
            ArrayList<AppenderProperty>()
        )
        //@Assert(console_01.getAppenderByName("console") is ConsoleLoggerAppender,true)

        // testAppenderFactorWithConsoleType
        var factory_02: LoggerAppenderFactory = LoggerAppenderFactory()
        var instance_02: LoggerAppenderFactory = factory_02.new()
        var fileAppender_02 = instance_02.registryType("file", FileLoggerAppender())
        @Assert(fileAppender_02.getAppenderByName("file") is ConsoleLoggerAppender,true)
        @Assert(fileAppender_02.getAppenderByType("file") is FileLoggerAppender,true)
        var console_02 = instance_02.registerLoggerAppender(
            "console",
            "console",
            "[%D %T %m] [%L] [%l] (%S) %M",
            ArrayList<AppenderProperty>()
        )
        @Assert(console_02.getAppenderByName("console") is ConsoleLoggerAppender,true)
    }

    // 验证: LoggerAppenderFactory
    @TestCase
    public func log_test_052():Unit{
        // testAppenderFactorWithInitParams
        var appenderMap_03 = HashMap<String, LoggerAppender>()
        appenderMap_03.put("file", FileLoggerAppender())
        var appenderTypeMap_03 = HashMap<String, LoggerAppender>()
        appenderTypeMap_03.put("console", ConsoleLoggerAppender())
        appenderTypeMap_03.put("file", FileLoggerAppender())
        var factory_03: LoggerAppenderFactory = LoggerAppenderFactory(appenderMap_03, appenderTypeMap_03, ReentrantMutex())
        var instance_03: LoggerAppenderFactory = factory_03.new()
        var fileAppender_03 = instance_03.registryType("file", FileLoggerAppender())

        @Assert(fileAppender_03.getAppenderByName("file") is ConsoleLoggerAppender,true)
        @Assert(fileAppender_03.getAppenderByType("file") is FileLoggerAppender,true)
        var file_03 = instance_03.registerLoggerAppender(
            "file",
            "file",
            "[%D %T %m] [%L] [%l] (%S) %M",
            ArrayList<AppenderProperty>()
        )
        @Assert(file_03.getAppenderByName("file") is FileLoggerAppender,true)

        // testAppenderFactorNoNew
        var appenderMap_04 = HashMap<String, LoggerAppender>()
        appenderMap_04.put("file", FileLoggerAppender())
        var factory_04: LoggerAppenderFactory = LoggerAppenderFactory(
            appenderMap_04,
            HashMap<String, LoggerAppender>(),
            ReentrantMutex()
        )
        var fileAppender_04 = factory_04.registryType("file", FileLoggerAppender())
        @Assert(fileAppender_04.getAppenderByName("file") is FileLoggerAppender,true)
    }

    func getQueryResult(pattern: String, rec: LogRecord, fileName: String): Bool {
        var curDir: Directory = Directory(".")
        var fileList: ArrayList<FileInfo> = curDir.fileList()
        for (f in fileList) {
            if (f.isFile() && f.path.toString().contains(fileName)) {
                var allBytes: Array<Byte> = File.readFrom(f.path.toString())
                var content: String = String.fromUtf8(allBytes)
                var time: String = rec.getCreatedTime().toString().substring(11, 8)
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
}