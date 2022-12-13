/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

package utils

from std import unittest.*
from std import unittest.testmacro.*
from std import time.*

@Test
public class UtilTests {
    @TestCase
    func testGetNumByString(): Unit {
        @Assert(getNumByString("123",456),123)
        @Assert(getNumByString("abc",456),456)
    }

    @TestCase
    func testStrToNumBySuffix(): Unit {
        var res: Int64 = strToNumBySuffix("230", 1024, 2097152)
        var res1: Int64 = strToNumBySuffix("2M", 1024, 2097152)
        var res2: Int64 = strToNumBySuffix("2m", 1024, 2097152)
        var res3: Int64 = strToNumBySuffix("2g", 1024, 2097152)
        var res4: Int64 = strToNumBySuffix("2G", 1024, 2097152)
        var res5: Int64 = strToNumBySuffix("2k", 1024, 2097152)
        var res6: Int64 = strToNumBySuffix("2K", 1024, 2097152)
        var res7: Int64 = strToNumBySuffix("2l", 1024, 2097152)
        @Assert(res,230)
        @Assert(res1,2*1024*1024)
        @Assert(res2,2*1024*1024)
        @Assert(res3,2*1024*1024*1024)
        @Assert(res4,2*1024*1024*1024)
        @Assert(res5,2*1024)
        @Assert(res6,2*1024)
        @Assert(res7,2097152)
    }

    @TestCase
    func testFlushLeft(): Unit {
        @Assert(flushLeft("abcdefg", 8, "0"),"0abcdefg")
        @Assert(flushLeft("", 8, "0"),"")
        @Assert(flushLeft("abcdefg",-1,"0"),"abcdefg")
        @Assert(flushLeft("abcdefg",2,"0"),"abcdefg")
        @Assert(flushLeft("abcdefgk",8,"0"),"abcdefgk")
    }

    @TestCase
    func testTimeSlice(): Unit {
        let timeSilce = TimeSlice()
        timeSilce.getTimeSlice(Time.now())
        @Assert(timeSliceCache.shortTime.size>0,true)
    }

    @TestCase
    func testFormatLogRecord(): Unit {
        let defaultPatternConverter = DefaultPatternConverter()
        var logRecord = LogRecord(Time.now())
        @Assert(defaultPatternConverter.formatLogRecord("",logRecord).size==0,true)
        @Assert(defaultPatternConverter.formatLogRecord("[%D %T %m] [%L] [%l] (%S) %M",logRecord).size!=0,true)
    }

    @TestCase
    func testLogRecord(): Unit {
        var logRecord = LogRecord(Time.now())
        @Assert(logRecord.getCreatedTime().year()!=0,true)
        var logRecord2 = LogRecord("com.test", LogLevel.ALL, Time.now(), "source", "message")
        @Assert(logRecord2.getTagName(),"com.test")
    }

    @TestCase
    func testLogLevel(): Unit {
        var logLevel = LogLevel.ALL
        var logLevel2 = LogLevel.TRACE
        var logLevel3 = LogLevel.DEBUG
        var logLevel4 = LogLevel.INFO
        var logLevel5 = LogLevel.WARN
        var logLevel6 = LogLevel.ERROR
        var logLevel7 = LogLevel.OFF
        @Assert(logLevel.level(),1)
        @Assert(logLevel2.level(),2)
        @Assert(logLevel3.level(),3)
        @Assert(logLevel4.level(),4)
        @Assert(logLevel5.level(),5)
        @Assert(logLevel6.level(),6)
        @Assert(logLevel7.level(),7)
        @Assert(logLevel.levelName(),"ALL")
        @Assert(logLevel2.levelName(),"TRACE")
        @Assert(logLevel3.levelName(),"DEBUG")
        @Assert(logLevel4.levelName(),"INFO")
        @Assert(logLevel5.levelName(),"WARN")
        @Assert(logLevel6.levelName(),"ERROR")
        @Assert(logLevel7.levelName(),"OFF")
        @Assert(logLevel>=LogLevel.INFO,false)
        @Assert(LogLevel.getLevelByString("all").levelName(),"ALL")
        @Assert(LogLevel.getLevelByString("trace").levelName(),"TRACE")
        @Assert(LogLevel.getLevelByString("debug").levelName(),"DEBUG")
        @Assert(LogLevel.getLevelByString("info").levelName(),"INFO")
        @Assert(LogLevel.getLevelByString("warn").levelName(),"WARN")
        @Assert(LogLevel.getLevelByString("error").levelName(),"ERROR")
        @Assert(LogLevel.getLevelByString("off").levelName(),"OFF")
        @Assert(LogLevel.getLevelByString("test").levelName(),"INFO")
    }
}