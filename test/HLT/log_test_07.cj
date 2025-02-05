//3rd_party_lib:log-cj/build/logcj
//3rd_party_lib:log-cj/build/zip4cj
//3rd_party_lib:log-cj/build/charset
//dependence:./query.cj
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
        proList_03.add(fileName_03)
        proList_03.add(maxSize_03)
        proList_03.add(daily_03)
        proList_03.add(rotate_03)
        proList_03.add(retentionDays_03)
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