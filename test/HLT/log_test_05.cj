//3rd_party_lib:log4cj2/build/log4cj
//data_file:src/resources/log4cj.xml

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
from std import os.posix.*

/**
 * logger类的验证
 *
 *
 */
@Test
public class LogTestE {
    var flag = false

    // 验证: class ConsoleLoggerAppender
    @TestCase
    public func log_test_050():Unit{
        var console_02: ConsoleLoggerAppender = ConsoleLoggerAppender()
        console_02.initAppender("[%T %D] [%L] (%S) [%M]", ArrayList<AppenderProperty>())
        console_02.start()
        var logRecord_02 = LogRecord("logRecord_02", LogLevel.ALL, Time.now(), "source", "message")
        @Expect(logRecord_02.getTagName(),"logRecord_02")
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
        @Expect(content_02.contains(formatContent_02.substring(0,39)),true)
    }

    // 验证: LoggerAppenderFactory
    @TestCase
    public func log_test_051():Unit{
        var factory_01: LoggerAppenderFactory = LoggerAppenderFactory()
        var instance_01: LoggerAppenderFactory = factory_01.new()
        var fileAppender_01 = instance_01.registryType("file", FileLoggerAppender())
        @Expect(fileAppender_01.getAppenderByType("file") is FileLoggerAppender,true)    
    }

    // 验证: LoggerAppenderFactory
    @TestCase
    public func log_test_052():Unit{
        // testAppenderFactorWithInitParams
        var appenderNames_03 = ArrayList<String>()
        appenderNames_03.append("file")
        var appenderValues_03 = ArrayList<LoggerAppender>()
        appenderValues_03.append(FileLoggerAppender())

        var typeNames_03 = ArrayList<String>()
        typeNames_03.append("file")
        var typeValues_03 = ArrayList<LoggerAppender>()
        typeValues_03.append(FileLoggerAppender())

        var factory_03: LoggerAppenderFactory = LoggerAppenderFactory(appenderNames_03, appenderValues_03, typeNames_03, typeValues_03, ReentrantMutex())
        var instance_03: LoggerAppenderFactory = factory_03.new()
        var fileAppender_03 = instance_03.registryType("file", FileLoggerAppender())

        //@Expect(fileAppender_03.getAppenderByName("file") is ConsoleLoggerAppender,true)
        @Expect(fileAppender_03.getAppenderByType("file") is FileLoggerAppender,true)
        var file_03 = instance_03.registerLoggerAppender(
            "file",
            "file",
            "[%D %T %m] [%L] [%l] (%S) %M",
            ArrayList<AppenderProperty>()
        )
        @Expect(file_03.getAppenderByName("file") is FileLoggerAppender,true)

    }

    // 验证: LoggerAppenderFactory
    @TestCase
    public func log_test_053():Unit{
        
        var appenderNames_04 = ArrayList<String>()
        appenderNames_04.append("file")
        var appenderValues_04 = ArrayList<LoggerAppender>()
        appenderValues_04.append(FileLoggerAppender())

        var factory_04: LoggerAppenderFactory = LoggerAppenderFactory(
            appenderNames_04, appenderValues_04, ArrayList<String>(), ArrayList<LoggerAppender>(), ReentrantMutex()
        )
        var fileAppender_04 = factory_04.registryType("file", FileLoggerAppender())
        @Expect(fileAppender_04.getAppenderByName("file") is FileLoggerAppender,true)
    }

    @TestCase
    public func log_test_054():Unit{
        let loggerManager = LoggerManager()
        @Expect(loggerManager.getLoggerAppenderFactory().getAppenderByName("file") is FileLoggerAppender,true)
        var size: Int64 = loggerManager.getRootLogger().getAppenderList().size
        @Expect(size, 0)

        var defaultCdonfig: LoggerConfiguration = Logger_Manager.loadDefaultConfiguration()
        var level = defaultCdonfig.getRoot().getLevel()
        @Expect(level, "info")
    }
   
    @TestCase
    public func log_test_055():Unit{
        var path = getcwd()
        let loggerManager = LoggerManager("${path}/src/resources/log4cj.xml")
        var size: Int64 = loggerManager.getRootLogger().getAppenderList().size
        @Expect(size, 2)

        var log = loggerManager.getLogger("test")
        @Expect(log.getName(), "test")

        var logNameArr:ArrayList<String> = Logger_Manager.getLoggerNameArr()
        @Expect(logNameArr.size, 3)
        var getLoggerAttrArr:ArrayList<LoggerAppenderReference> = Logger_Manager.getLoggerAttrArr()
        @Expect(getLoggerAttrArr.size, 3)
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