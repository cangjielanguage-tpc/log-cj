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
import std.posix.*

@Test
public class LogTestE {

    // 验证: class FileLoggerAppender
    @TestCase
    public func log_test_054():Unit{
        var file_01: FileLoggerAppender = FileLoggerAppender()
        file_01.initAppender("", ArrayList<AppenderProperty>())
        file_01.start()
        var logRecord_01 = LogRecord("file_01", LogLevel.INFO, DateTime.now(), "source", "message", Thread.currentThread.id)
        file_01.logWrite(logRecord_01)
        sleep(1*Duration.second)
        file_01.close()
        @Expect(getQueryResult("",logRecord_01,"root.log",tag:"log_test_046"),true)
    }

}