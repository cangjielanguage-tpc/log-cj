package logger

from std import unittest.*
from std import unittest.testmacro.*
from std import fs.*
from std import time.*

@Test
public class LoggerTests {
    @TestCase
    func testLoadDefaultConfig(): Unit {
        var config: LoggerConfiguration = Logger_Manager.loadDefaultConfiguration()
        @Assert(config.getRoot().getLevel(),"info")
    }

    @TestCase
    func testGetLogger(): Unit {
        var log = Logger_Manager.getLogger("test")
        @Assert(log.getName(),"test")
    }

    @TestCase
    func testInitLogggerManager(): Unit {
        let Logger_Manager = LoggerManager("./src/resources/log4cj.xml")
        @Assert(Logger_Manager.getRootLogger().getAppenderList().size,2)
    }

    @TestCase
    func testPrintInfoLog(): Unit {
        let log = Logger_Manager.getLogger("test")
        log.info("info")
        @Assert(getQueryResult("test","info"),true)
        @Assert(getQueryResult("test","info2"),false)
    }

    @TestCase
    func testPrintErrorLog(): Unit {
        let log = Logger_Manager.getLogger("test")
        log.error("error")
        @Assert(getQueryResult("test","error"),true)
        @Assert(getQueryResult("test","error2"),false)
    }

    @TestCase
    func testPrintWarnLog(): Unit {
        let log = Logger_Manager.getLogger("test")
        log.warn("warn")
        @Assert(getQueryResult("test","warn"),true)
        @Assert(getQueryResult("test","warn2"),false)
    }

    @TestCase
    func testPrintOffLog(): Unit {
        let log = Logger_Manager.getLogger("test")
        log.off("off")
        @Assert(getQueryResult("test","off"),true)
        @Assert(getQueryResult("test","off2"),false)
    }

    @TestCase
    func testPrintDebugLog(): Unit {
        let log = Logger_Manager.getLogger("test")
        log.debug("debug")
        @Assert(getQueryResult("test","debug"),true)
        @Assert(getQueryResult("test","debug2"),false)
    }

    @TestCase
    func testPrintTraceLog(): Unit {
        let log = Logger_Manager.getLogger("test")
        log.trace("trace")
        @Assert(getQueryResult("test","trace"),true)
        @Assert(getQueryResult("test","trace2"),false)
    }

    @TestCase
    func testPrintAllLog(): Unit {
        let log = Logger_Manager.getLogger("test")
        log.all("all msg")
        @Assert(getQueryResult("test","all msg"),true)
        @Assert(getQueryResult("test","all1msg2"),false)
    }

    func getQueryResult(name: String, msg: String): Bool {
        var curDir: Directory = Directory(".")
        var fileList: ArrayList<FileInfo> = curDir.fileList()
        for (f in fileList) {
            if (f.isFile() && f.path.toString().contains("root.log")) {
                var allBytes: Array<Byte> = File.readFrom(f.path.toString())
                var content: String = String.fromUtf8(allBytes)
                var time: String = Time.now().toString().substring(11, 8)
                if (content.contains(time) && content.contains(name) && content.contains(msg)) {
                    return true
                }
            }
        }
        return false
    }
}
