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