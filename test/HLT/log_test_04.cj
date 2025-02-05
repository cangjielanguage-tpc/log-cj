//3rd_party_lib:log-cj/build/logcj
//3rd_party_lib:log-cj/build/zip4cj
//3rd_party_lib:log-cj/build/charset
//data_file:src/resources/logcj.json

package test

import std.unittest.*
import std.unittest.testmacro.*
import logcj.appender.*
import logcj.config.*
import logcj.logger.*
import logcj.utils.*
import std.time.*
import std.collection.*
import std.fs.*
import std.io.*
import std.sync.*
import std.posix.*

@Test
public class LogTestD {
    // 验证: class ConsoleLoggerAppender
    @TestCase
    public func log_test_042():Unit{
        var console_02: ConsoleLoggerAppender = ConsoleLoggerAppender()
        console_02.initAppender("[%T %D] [%L] [%I] (%S) [%M]", ArrayList<AppenderProperty>())
        console_02.start()
        var logRecord_02 = LogRecord("logRecord_02", LogLevel.ALL, DateTime.now(), "source", "message", Thread.currentThread.id)
        @Expect(logRecord_02.getTagName(),"logRecord_02")
        console_02.logWrite(logRecord_02)
        console_02.close()
        console_02.logWrite(logRecord_02)
        var content_02: String = getDefaultPatternConvert().formatLogRecord("[%D %T] [%L] [%I] (%S) %M", logRecord_02)
        let timeSlice_02 = TimeSlice()
        timeSlice_02.getTimeSlice(logRecord_02.getCreatedTime())
        var lt_02 = timeSlice_02.getLongTime()
        var ld_02 = timeSlice_02.getLongDate()
        var level_02 = logRecord_02.getLevel().levelName()
        var message_02 = logRecord_02.getMessage()
        var source_02 = logRecord_02.getSource()
        var id_02 = logRecord_02.getThreadId()
        var formatContent_02: String = "[${ld_02} ${lt_02}] [${level_02}] [${id_02}] (${source_02}) ${message_02}"
        @Expect(content_02.contains(formatContent_02[0..39]),true)
    }

    // 验证: LoggerAppenderFactory
    @TestCase
    public func log_test_043():Unit{
        var factory_01: LoggerAppenderFactory = LoggerAppenderFactory()
        var instance_01: LoggerAppenderFactory = factory_01.new()
        var fileAppender_01 = instance_01.registryType("file", FileLoggerAppender())
        @Expect(fileAppender_01.getAppenderByType("file") is FileLoggerAppender,true)    
    }

    // 验证: LoggerAppenderFactory
    @TestCase
    public func log_test_044():Unit{
        // testAppenderFactorWithInitParams
        var appenderNames_03 = ArrayList<String>()
        appenderNames_03.add("file")
        var appenderValues_03 = ArrayList<LoggerAppender>()
        appenderValues_03.add(FileLoggerAppender())

        var typeNames_03 = ArrayList<String>()
        typeNames_03.add("file")
        var typeValues_03 = ArrayList<LoggerAppender>()
        typeValues_03.add(FileLoggerAppender())

        var factory_03: LoggerAppenderFactory = LoggerAppenderFactory(appenderNames_03, appenderValues_03, typeNames_03, typeValues_03, ReentrantMutex())
        var instance_03: LoggerAppenderFactory = factory_03.new()
        var fileAppender_03 = instance_03.registryType("file", FileLoggerAppender())

        //@Expect(fileAppender_03.getAppenderByName("file") is ConsoleLoggerAppender,true)
        @Expect(fileAppender_03.getAppenderByType("file") is FileLoggerAppender,true)
        var file_03 = instance_03.registerLoggerAppender(
            "file",
            "file",
            "[%D %T %m] [%L] [%I] [%l] (%S) %M",
            ArrayList<AppenderProperty>()
        )
        @Expect(file_03.getAppenderByName("file") is FileLoggerAppender,true)

    }

    // 验证: LoggerAppenderFactory
    @TestCase
    public func log_test_045():Unit{
        
        var appenderNames_04 = ArrayList<String>()
        appenderNames_04.add("file")
        var appenderValues_04 = ArrayList<LoggerAppender>()
        appenderValues_04.add(FileLoggerAppender())

        var factory_04: LoggerAppenderFactory = LoggerAppenderFactory(
            appenderNames_04, appenderValues_04, ArrayList<String>(), ArrayList<LoggerAppender>(), ReentrantMutex()
        )
        var fileAppender_04 = factory_04.registryType("file", FileLoggerAppender())
        @Expect(fileAppender_04.getAppenderByName("file") is FileLoggerAppender,true)
    }

    @TestCase
    public func log_test_046():Unit{
        let loggerManager = LoggerManager.createManager("")
        @Expect(loggerManager.getLoggerAppenderFactory().getAppenderByName("file") is FileLoggerAppender)
        var size: Int64 = loggerManager.getRootLogger().getAppenderList().size
        @Expect(size, 2)

        var defaultCdonfig: LoggerConfiguration = Logger_Manager.loadDefaultConfiguration()
        var level = defaultCdonfig.getRoot().getLevel().replace("\"","")
        @Expect(level, "info")
    }
   
    @TestCase
    public func log_test_047():Unit{
        var path = getcwd()
        let loggerManager = LoggerManager.createManager("${path}/src/resources/log4cj.json")
        var size: Int64 = loggerManager.getRootLogger().getAppenderList().size
        @Expect(size, 2)

        var log = loggerManager.getLogger("test")
        @Expect(log.getName(), "test")

        var logNameArr:ArrayList<String> = Logger_Manager.getLoggerNameArr()
        @Expect(logNameArr.size, 1)

        var getLoggerAttrArr:ArrayList<LoggerAppenderReference> = Logger_Manager.getLoggerAttrArr()
        @Expect(getLoggerAttrArr.size, 1)
    }

    // 验证: class LoggerAppenderReference
    @TestCase
    public func log_test_048():Unit{
        var appenderRef_01 = LoggerAppenderReference()
        @Expect(appenderRef_01.getLevel().levelName(),"INFO")
        @Expect(appenderRef_01.getAppenderList().size,0)
    }

    // 验证: class LoggerAppenderReference
    @TestCase
    public func log_test_049():Unit{
        var appenderList_02 = ArrayList<LoggerAppender>()
        appenderList_02.add(FileLoggerAppender())
        //appenderList_02.append(ConsoleLoggerAppender())
        var appenderRef_02 = LoggerAppenderReference(LogLevel.ALL, appenderList_02)
        @Expect(appenderRef_02.getLevel().levelName(),"ALL")
        @Expect(appenderRef_02.getAppenderList().size,1)
    }

    // 验证: class LoggerAppenderReference
    @TestCase
    public func log_test_050():Unit{
        var appenderList_03 = ArrayList<LoggerAppender>()
        appenderList_03.add(FileLoggerAppender())
       // appenderList_03.append(ConsoleLoggerAppender())
        var appenderRef_03 = LoggerAppenderReference()
        appenderRef_03.setLevel(LogLevel.ERROR)
        appenderRef_03.setAppenderList(appenderList_03)
        @Expect(appenderRef_03.getLevel().levelName(),"ERROR")
        @Expect(appenderRef_03.getAppenderList().size,1)
    }
    
    // 验证: class LoggerAppenderReference
    @TestCase
    public func log_test_051():Unit{
        var appenderList_04 = ArrayList<LoggerAppender>()
        var appenderRef_04 = LoggerAppenderReference()
        appenderRef_04.setLevel(LogLevel.OFF)
        appenderRef_04.setAppenderList(appenderList_04) 
        @Expect(appenderRef_04.getLevel().levelName(),"OFF")
        @Expect(appenderRef_04.getAppenderList().size,0)
    }

    // 验证: class ConsoleLoggerAppender
    @TestCase
    public func log_test_052():Unit{
        var console_01: ConsoleLoggerAppender = ConsoleLoggerAppender()
        console_01.initAppender("", ArrayList<AppenderProperty>())
        console_01.start()
        var logRecord_01 = LogRecord("logRecord_01", LogLevel.ALL, DateTime.now(), "source", "message", Thread.currentThread.id)
        @Expect(logRecord_01.getTagName(),"logRecord_01")
        console_01.logWrite(logRecord_01)
        console_01.close()
        console_01.logWrite(logRecord_01)
        var content_01: String = getDefaultPatternConvert().formatLogRecord("[%T %D %m] [%L][%l] (%S) %M", logRecord_01)
        let timeSlice_01 = TimeSlice()
        timeSlice_01.getTimeSlice(logRecord_01.getCreatedTime())
        var lt_01 = timeSlice_01.getLongTime()
        var ld_01 = timeSlice_01.getLongDate()
        var m_01 = flushLeft((logRecord_01.getCreatedTime().nanosecond / Int64(1e6)).toString(), 3, "0")
        var level_01 = logRecord_01.getLevel().levelName()
        var tagName_01 = logRecord_01.getTagName()
        var message_01 = logRecord_01.getMessage()
        var source_01 = logRecord_01.getSource()
        var formatContent_01: String = "[${lt_01} ${ld_01} ${m_01}] [${level_01}][${tagName_01}] (${source_01}) ${message_01}"
        @Expect(content_01.contains(formatContent_01[0..55]),true)
    }

    // 验证: class ConsoleLoggerAppender
    @TestCase
    public func log_test_053():Unit{
        var console_02: ConsoleLoggerAppender = ConsoleLoggerAppender()
        console_02.initAppender("[%T %D] [%L] (%S) [%M]", ArrayList<AppenderProperty>())
        console_02.start()
        var logRecord_02 = LogRecord("logRecord_02", LogLevel.ALL, DateTime.now(), "source", "message", Thread.currentThread.id)
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
        @Expect(content_02.contains(formatContent_02[0..39]),true)
    }
    
}