//3rd_party_lib:log-cj/build/logcj
//3rd_party_lib:log-cj/build/zip4cj
//3rd_party_lib:log-cj/build/charset
//dependence:./query.cj
package test

from std import unittest.*
from std import unittest.testmacro.*
from logcj import appender.*
from logcj import config.*
from logcj import logger.*
from logcj import utils.*
from std import time.*
from std import collection.*
from std import fs.*
from std import io.*
from std import sync.*

@Test
public class LogTestG {
    // 验证: class FileLoggerAppender
    @TestCase
    public func log_test_056():Unit{
        var file_03: FileLoggerAppender = FileLoggerAppender()
        var proList_03 = ArrayList<AppenderProperty>()
        var fileName_03 = AppenderProperty("filename", "logrecord_03.log")
        var maxSize_03 = AppenderProperty("maxsize", "300")
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
        var logRecord_03= LogRecord("logRecord_03", LogLevel.WARN, DateTime.now(), "source", "message", Thread.currentThread.id)
        file_03.logWrite(logRecord_03)
        sleep(1*Duration.second)
        file_03.close()
        let result: Bool = getQueryResult("[%D %T] [%L] (%S) %M",logRecord_03,"logrecord_03.log")
        @Expect(result, true) 
        println(result)
    }
}