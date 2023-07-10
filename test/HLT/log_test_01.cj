//3rd_party_lib:log4cj2/build/log4cj
//3rd_party_lib:log4cj2/build/zip4cj
//3rd_party_lib:log4cj2/build/charset
package test

from std import unittest.*
from std import unittest.testmacro.*
from log4cj import appender.*
from log4cj import config.*
from log4cj import logger.*
from log4cj import utils.*
from std import time.*

/**
 * utils类的验证
 */
@Test
public class LogTestA {
    var flag = false

    // 验证: enum LogLevel
    @TestCase
    public func log_test_001(): Unit {
        var logLevel_01 = LogLevel.ALL
        var logLevel_02 = LogLevel.TRACE
        var logLevel_03 = LogLevel.DEBUG
        var logLevel_04 = LogLevel.INFO
        var logLevel_05 = LogLevel.WARN
        var logLevel_06 = LogLevel.ERROR
        var logLevel_07 = LogLevel.FATAL
        var logLevel_08 = LogLevel.OFF

        @Expect(logLevel_01.level(),1)
        @Expect(logLevel_02.level(),2)
        @Expect(logLevel_03.level(),3)
        @Expect(logLevel_04.level(),4)
        @Expect(logLevel_05.level(),5)
        @Expect(logLevel_06.level(),6)
        @Expect(logLevel_07.level(),7)
        @Expect(logLevel_08.level(),8)

        @Expect(logLevel_01.levelName(),"ALL")
        @Expect(logLevel_02.levelName(),"TRACE")
        @Expect(logLevel_03.levelName(),"DEBUG")
        @Expect(logLevel_04.levelName(),"INFO")
        @Expect(logLevel_05.levelName(),"WARN")
        @Expect(logLevel_06.levelName(),"ERROR")
        @Expect(logLevel_07.levelName(),"FATAL")
        @Expect(logLevel_08.levelName(),"OFF")

        @Expect(logLevel_01 >= logLevel_02,false)
        @Expect(logLevel_03 >= logLevel_03,true)
        @Expect(logLevel_05 >= logLevel_04,true)
        @Expect(logLevel_06 >= logLevel_07,false)
        @Expect(logLevel_07 >= logLevel_08,false)
    }

    // 验证: enum LogLevel levelName
    @TestCase
    public func log_test_002(): Unit {
        @Expect(LogLevel.getLevelByString("all").levelName(),"ALL")
        @Expect(LogLevel.getLevelByString("trace").levelName(),"TRACE")
        @Expect(LogLevel.getLevelByString("debug").levelName(),"DEBUG")
        @Expect(LogLevel.getLevelByString("info").levelName(),"INFO")
        @Expect(LogLevel.getLevelByString("warn").levelName(),"WARN")
        @Expect(LogLevel.getLevelByString("error").levelName(),"ERROR")
        @Expect(LogLevel.getLevelByString("fatal").levelName(),"FATAL")
        @Expect(LogLevel.getLevelByString("off").levelName(),"OFF")
        @Expect(LogLevel.getLevelByString("test").levelName(),"INFO")
    }

    // 验证: class LogRecord
    // 验证: public func formatLogRecord(pattern: String, logRecord: LogRecord): String
    @TestCase
    public func log_test_003(): Unit {
        let defaultPatternConverter = DefaultPatternConverter()
        var timeNow: DateTime = DateTime.now()

        var logRecord_01 = LogRecord(timeNow)
        @Expect(logRecord_01.getTagName(), "")
        @Expect(logRecord_01.getLevel().level(), 4)
        @Expect(logRecord_01.getSource(), "")
        @Expect(logRecord_01.getMessage(), "")
        @Expect(logRecord_01.getCreatedTime().year != 0, true)
        var format_01 = defaultPatternConverter.formatLogRecord("", logRecord_01)
        println(format_01)

        var logRecord_02 = LogRecord("logRecord_02", LogLevel.ALL, DateTime.now(), "source", "message")
        @Expect(logRecord_02.getTagName(),"logRecord_02")
        @Expect(logRecord_02.getLevel().level(), 1)
        @Expect(logRecord_02.getSource(), "source")
        @Expect(logRecord_02.getMessage(), "message")
        @Expect(logRecord_02.getCreatedTime().year != 0, true)
        var format_02 = defaultPatternConverter.formatLogRecord("[%D %T %m] [%L] [%l] (%S) %M", logRecord_02)
        println(format_02)
        var format_02_1 = defaultPatternConverter.formatLogRecord("", logRecord_02)
        println(format_02_1)
        var format_02_2 = defaultPatternConverter.formatLogRecord("%D %T %m %L %l %S %M", logRecord_02)
        println(format_02_2)
        var format_02_3 = defaultPatternConverter.formatLogRecord("+++++%D %T55 %m+-- ##%L#$ %%%l (%S) %M", logRecord_02
        )
        println(format_02_3)

        var logRecord_03 = LogRecord("", LogLevel.TRACE, DateTime.now(), "", "")
        @Expect(logRecord_03.getTagName(),"")
        @Expect(logRecord_03.getLevel().level(), 2)
        @Expect(logRecord_03.getSource(), "")
        @Expect(logRecord_03.getMessage(), "")
        @Expect(logRecord_03.getCreatedTime().year != 0, true)
        var format_03 = defaultPatternConverter.formatLogRecord("[%D %T %m] [%L] [%l] (%S) %M", logRecord_03)
        println(format_03)

        var logRecord_04 = LogRecord("@#$^,;[^&^%**(", LogLevel.DEBUG, DateTime.now(), "_+(^^&/\\@$@&", "%^&*' '&(*@#")
        @Expect(logRecord_04.getTagName(),"@#$^,;[^&^%**(")
        @Expect(logRecord_04.getLevel().level(), 3)
        @Expect(logRecord_04.getSource(), "_+(^^&/\\@$@&")
        @Expect(logRecord_04.getMessage(), "%^&*' '&(*@#")
        @Expect(logRecord_04.getCreatedTime().year != 0, true)
        var format_04 = defaultPatternConverter.formatLogRecord("[%D %T %m] [%L] [%l] (%S) %M", logRecord_04)
        println(format_04)
    }

    // 验证: func setCachedTimeSlice(timeSlice: TimeSlice)
    // 验证: class TimeSlice
    @TestCase
    public func log_test_004(): Unit {
        var timeNow: DateTime = DateTime.now()
        var timeSilce = TimeSlice()

        //setCachedTimeSlice(timeSilce)
        @Expect(timeSilce.getShortTime(), "")
        @Expect(timeSilce.getLongTime(), "")
        @Expect(timeSilce.getShortDate(), "")
        @Expect(timeSilce.getLongDate(), "")

        timeSilce.getTimeSlice(timeNow)
        @Expect(timeSilce.getShortTime().size>0, true)
        @Expect(timeSilce.getLongTime().size>0, true)
        @Expect(timeSilce.getShortDate().size>0, true)
        @Expect(timeSilce.getLongDate().size>0, true)

        //setCachedTimeSlice(timeSilce)
        @Expect(timeSilce.getShortTime().size>0, true)
        @Expect(timeSilce.getLongTime().size>0, true)
        @Expect(timeSilce.getShortDate().size>0, true)
        @Expect(timeSilce.getLongDate().size>0, true)
    }

    // 验证: public func flushLeft(str: String, limit: Int64, placeholder: String): String 将字符串向右对齐，并在剩余的位中补充指定的字符
    @TestCase
    public func log_test_005(): Unit {
        @Expect(flushLeft("abcdefg", 8, "0"),"0abcdefg")
        @Expect(flushLeft("中文", 8, "0"),"000000中文")
        @Expect(flushLeft("中文中文", 8, "0"),"0000中文中文")
        @Expect(flushLeft("@#%&……*：“{}", 8, "0"),"@#%&……*：“{}")
        @Expect(flushLeft("", 8, "0"),"")

        @Expect(flushLeft("", 8, "0"),"")
        @Expect(flushLeft("abcdefg",-1,"0"),"abcdefg")
        @Expect(flushLeft("abcdefg",0,"0"),"abcdefg")
        @Expect(flushLeft("abcdefgh", 8, "0"),"abcdefgh")
        @Expect(flushLeft("abcdefghijklmn", 8, "0"),"abcdefghijklmn")

        @Expect(flushLeft("abcdefg", 8, ""),"abcdefg")
        @Expect(flushLeft("文", 8, "中"),"中中中中中中中文")
        @Expect(flushLeft("中文中文", 8, "中文"),"中文中文中文中文中文中文")
        @Expect(flushLeft("abcdefg", 8, ":%^"),":%^abcdefg")
    }

    // 验证: public func getNumByString(str: String, defaultValue: Int64) 将数字字符串转换为int64
    @TestCase
    public func log_test_006(): Unit {
        @Expect(getNumByString("123456", -9223372036854775808), 123456)
        @Expect(getNumByString("0", 9223372036854775807), 0)
        @Expect(getNumByString("1234", 123), 1234)
        @Expect(getNumByString("-1234", 123), -1234)
        try {
            getNumByString("中文中文", 0)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message,"The part of value convert failed.")
        }
        try {
            getNumByString("", 1)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message,"The string is empty.")
        }
        try {
            getNumByString("@#%&……*：“{}", 1234)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message,"The part of value convert failed.")
        }
        try {
            getNumByString("abcdefg", -9223372036854775808)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message,"The part of value convert failed.")
        }
        try {
            getNumByString("abcdefg", 9223372036854775807)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message,"The part of value convert failed.")
        }
        try {
            getNumByString("abcdefg", 0)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message,"The part of value convert failed.")
        }
        try {
            getNumByString("abcdefg", 1)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message,"The part of value convert failed.")
        }
    }

    // 验证: public func strToNumBySuffix(str: String, mult: Int64, defaultValue: Int64): Int64
    @TestCase
    public func log_test_007(): Unit {
        var res: Int64 = strToNumBySuffix("230", 1024, 2097152)
        var res1: Int64 = strToNumBySuffix("2M", 1024, 2097152)
        var res2: Int64 = strToNumBySuffix("2m", 1024, 2097152)
        var res3: Int64 = strToNumBySuffix("2g", 1024, 2097152)
        var res4: Int64 = strToNumBySuffix("2G", 1024, 2097152)
        var res5: Int64 = strToNumBySuffix("2k", 1024, 2097152)
        var res6: Int64 = strToNumBySuffix("2K", 1024, 2097152)
        @Expect(res,230)
        @Expect(res1,2*1024*1024)
        @Expect(res2,2*1024*1024)
        @Expect(res3,2*1024*1024*1024)
        @Expect(res4,2*1024*1024*1024)
        @Expect(res5,2*1024)
        @Expect(res6,2*1024)
        try {
            strToNumBySuffix("2l", 1024, 2097152)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message,"The part of value convert failed.")
        }
    }
}
