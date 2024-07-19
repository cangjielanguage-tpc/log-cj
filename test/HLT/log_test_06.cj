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
public class LogTestF {
    // 验证: class FileLoggerAppender
    @TestCase
    public func log_test_055():Unit{
        var file_02: FileLoggerAppender = FileLoggerAppender()
        var proList_02 = ArrayList<AppenderProperty>()
        var fileName_02 = AppenderProperty("filename", "logrecord_02.log")
        var maxSize_02 = AppenderProperty("maxsize", "300") 
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
        var logRecord_02_1= LogRecord("logRecord_02_1", LogLevel.WARN, DateTime.now(), "source", "message", Thread.currentThread.id)
        file_02.logWrite(logRecord_02_1)
        var logRecord_02_2= LogRecord("logRecord_02_2", LogLevel.WARN, DateTime.now(), "source", "message", Thread.currentThread.id)
        file_02.logWrite(logRecord_02_2)
        var logRecord_02_3= LogRecord("logRecord_02_3", LogLevel.WARN, DateTime.now(), "source", "message", Thread.currentThread.id)
        file_02.logWrite(logRecord_02_3)
        var logRecord_02_4= LogRecord("logRecord_02_4", LogLevel.WARN, DateTime.now(), "source", "message", Thread.currentThread.id)
        file_02.logWrite(logRecord_02_4)
        sleep(1*Duration.second)
        file_02.close()
        
        let result_1: Bool = getQueryResult("[%D %T] [%L] (%S) %M",logRecord_02_1,"logrecord_02.log")
        @Expect(result_1, true)
        println(result_1)

        let result_2: Bool = getQueryResult("[%D %T] [%L] (%S) %M",logRecord_02_2,"logrecord_02.log")
        @Expect(result_2, true) 
        println(result_2)

        let result_3: Bool = getQueryResult("[%D %T] [%L] (%S) %M",logRecord_02_3,"logrecord_02.log")
        @Expect(result_3, true) 
        println(result_3)

        let result_4: Bool = getQueryResult("[%D %T] [%L] (%S) %M",logRecord_02_4,"logrecord_02.log")
        @Expect(result_4, true) 
        println(result_4)

    }
}