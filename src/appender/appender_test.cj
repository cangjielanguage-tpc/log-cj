/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

package appender

from std import unittest.*
from std import unittest.testmacro.*
from std import io.*
from std import fs.*
from std import time.*
from std import sync.*

@Test
public class AppenderTests {
    @TestCase
    func testConsoleLoggerAppenderWithDefaultPattern(): Unit {
        var console: ConsoleLoggerAppender = ConsoleLoggerAppender()
        console.initAppender("", ArrayList<AppenderProperty>())
        console.start()
        var logRecord = LogRecord("com.test", LogLevel.ALL, Time.now(), "source", "message")
        @Assert(logRecord.getTagName(),"com.test")
        console.logWrite(logRecord)
        console.close()
        var content: String = getDefaultPatternConvert().formatLogRecord("[%T %D %m] [%L][%l] (%S) %M", logRecord)
        let timeSlice = TimeSlice()
        timeSlice.getTimeSlice(logRecord.getCreatedTime())
        var lt = timeSlice.getLongTime()
        var ld = timeSlice.getLongDate()
        var m = flushLeft((logRecord.getCreatedTime().nanosecond() / Int64(1e6)).toString(), 3, "0")
        var level = logRecord.getLevel().levelName()
        var tagName = logRecord.getTagName()
        var message = logRecord.getMessage()
        var source = logRecord.getSource()
        var formatContent: String = "[${lt} ${ld} ${m}] [${level}][${tagName}] (${source}) ${message}"
        @Assert(content.contains(formatContent.substring(0,55)),true)
    }

    @TestCase
    func testConsoleLoggerAppenderWithOtherPattern(): Unit {
        var console: ConsoleLoggerAppender = ConsoleLoggerAppender()
        console.initAppender("[%T %D] [%L] (%S) %M]", ArrayList<AppenderProperty>())
        console.start()
        var logRecord = LogRecord("com.test", LogLevel.ALL, Time.now(), "source", "message")
        @Assert(logRecord.getTagName(),"com.test")
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
        @Assert(content.contains(formatContent.substring(0,39)),true)
    }

    @TestCase
    func testFileLoggerAppenderWithDefaultPattern(): Unit {
        var file: FileLoggerAppender = FileLoggerAppender()
        file.initAppender("", ArrayList<AppenderProperty>())
        file.start()
        var logRecord = LogRecord("com.test.file", LogLevel.INFO, Time.now(), "source", "message")
        file.logWrite(logRecord)
        file.close()
        @Assert(getQueryResult("",logRecord,"root.log"),true)
    }

    @TestCase
    func testFileLoggerAppenderWithOtherPattern(): Unit {
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
        var logRecord = LogRecord("com.test.file", LogLevel.INFO, Time.now(), "source", "message")
        file.logWrite(logRecord)
        file.close()
        @Assert(getQueryResult("[%D %T] [%L] (%S) %M",logRecord,"test-file.log"),true)
    }

    @TestCase
    func testFileLoggerAppenderWithErrorRolling(): Unit {
        for (i in 0..10) {
            var file: FileLoggerAppender = FileLoggerAppender()
            var proList = ArrayList<AppenderProperty>()
            var maxSize = AppenderProperty("maxsize", "1")
            var fileName = AppenderProperty("filename", "test-error.log")
            proList.append(maxSize)
            proList.append(fileName)
            file.initAppender("", proList)
            file.start()
            var logRecord = LogRecord("com.error.file", LogLevel.INFO, Time.now(), "source", "message")
            file.logWrite(logRecord)
            file.close()
        }
        @Assert(getQueryFileRollingRes("test-error.log_"),false)
    }

    @TestCase
    func testFileLoggerAppenderWithRightRolling(): Unit {
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
            var logRecord = LogRecord("com.right.file", LogLevel.INFO, Time.now(), "source", "message")
            file.logWrite(logRecord)
            file.close()
        }
        @Assert(getQueryFileRollingRes("test-right.log_"),true)
    }

    @TestCase
    func testAppenderFactoryNoType(): Unit {
        var factory: LoggerAppenderFactory = LoggerAppenderFactory()
        var instance: LoggerAppenderFactory = factory.new()
        var console = instance.registerLoggerAppender(
            "console",
            "console",
            "[%D %T %m] [%L] [%l] (%S) %M",
            ArrayList<AppenderProperty>()
        )
        @Assert(console.getAppenderByName("console") is ConsoleLoggerAppender,true)
    }

    @TestCase
    func testAppenderFactorWithConsoleType(): Unit {
        var factory: LoggerAppenderFactory = LoggerAppenderFactory()
        var instance: LoggerAppenderFactory = factory.new()
        var fileAppender = instance.registryType("file", FileLoggerAppender())
        @Assert(fileAppender.getAppenderByName("file") is ConsoleLoggerAppender,true)
        @Assert(fileAppender.getAppenderByType("file") is FileLoggerAppender,true)
        var console = instance.registerLoggerAppender(
            "console",
            "console",
            "[%D %T %m] [%L] [%l] (%S) %M",
            ArrayList<AppenderProperty>()
        )
        @Assert(console.getAppenderByName("console") is ConsoleLoggerAppender,true)
    }

    @TestCase
    func testAppenderFactorWithInitParams(): Unit {
        var appenderMap = HashMap<String, LoggerAppender>()
        appenderMap.put("file", FileLoggerAppender())
        var appenderTypeMap = HashMap<String, LoggerAppender>()
        appenderTypeMap.put("console", ConsoleLoggerAppender())
        appenderTypeMap.put("file", FileLoggerAppender())
        var factory: LoggerAppenderFactory = LoggerAppenderFactory(appenderMap, appenderTypeMap, ReentrantMutex())
        var instance: LoggerAppenderFactory = factory.new()
        var fileAppender = instance.registryType("file", FileLoggerAppender())

        //operator new clean appenderMap
        @Assert(fileAppender.getAppenderByName("file") is ConsoleLoggerAppender,true)
        @Assert(fileAppender.getAppenderByType("file") is FileLoggerAppender,true)
        var file = instance.registerLoggerAppender(
            "file",
            "file",
            "[%D %T %m] [%L] [%l] (%S) %M",
            ArrayList<AppenderProperty>()
        )
        @Assert(file.getAppenderByName("file") is FileLoggerAppender,true)
    }

    @TestCase
    func testAppenderFactorNoNew(): Unit {
        var appenderMap = HashMap<String, LoggerAppender>()
        appenderMap.put("file", FileLoggerAppender())
        var factory: LoggerAppenderFactory = LoggerAppenderFactory(
            appenderMap,
            HashMap<String, LoggerAppender>(),
            ReentrantMutex()
        )
        var fileAppender = factory.registryType("file", FileLoggerAppender())
        @Assert(fileAppender.getAppenderByName("file") is FileLoggerAppender,true)
    }

    @TestCase
    func testAppenderReference(): Unit {
        var appenderRef = LoggerAppenderReference()
        @Assert(appenderRef.getLevel().levelName(),"INFO")
        @Assert(appenderRef.getAppenderList().size,0)
    }

    @TestCase
    func testAppenderReferenceWithInitParams(): Unit {
        var appenderList = ArrayList<LoggerAppender>()
        appenderList.append(FileLoggerAppender())
        appenderList.append(ConsoleLoggerAppender())
        var appenderRef = LoggerAppenderReference(LogLevel.INFO, appenderList)
        @Assert(appenderRef.getLevel().levelName(),"INFO")
        @Assert(appenderRef.getAppenderList().size,2)
    }

    @TestCase
    func testAppenderReferenceWithSetter(): Unit {
        var appenderList = ArrayList<LoggerAppender>()
        appenderList.append(FileLoggerAppender())
        appenderList.append(ConsoleLoggerAppender())
        var appenderRef = LoggerAppenderReference()
        appenderRef.setLevel(LogLevel.INFO)
        appenderRef.setAppenderList(appenderList)
        @Assert(appenderRef.getLevel().levelName(),"INFO")
        @Assert(appenderRef.getAppenderList().size,2)
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

    func getQueryFileRollingRes(fileName: String): Bool {
        var curDir: Directory = Directory(".")
        var fileList: ArrayList<FileInfo> = curDir.fileList()
        for (f in fileList) {
            if (f.isFile() && f.path.toString().contains(fileName)) {
                return true
            }
        }
        return false
    }
}
