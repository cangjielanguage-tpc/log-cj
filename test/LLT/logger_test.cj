// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
package test

from logcj import appender.*
from logcj import config.*
from logcj import logger.*
from logcj import utils.*
from std import time.*
from std import fs.*
from std import os.posix.*
from std import collection.*

main(): Int64 {
    println("测试开始")

    var result1: Bool = testLoadDefaultConfig()
    println("testLoadDefaultConfig = ${result1}")

    var result2: Bool = testGetLogger()
    println("testGetLogger = ${result2}")

    var result3: Bool = testInitLogggerManager()
    println("testInitLogggerManager = ${result3}")

    var result4: Bool = testPrintInfoLog()
    println("testPrintInfoLog = ${result4}")

    var result5: Bool = testPrintErrorLog()
    println("testPrintErrorLog = ${result5}")

    var result6: Bool = testPrintWarnLog()
    println("testPrintWarnLog = ${result6}")

    var result7: Bool = testPrintOffLog()
    println("testPrintOffLog = ${result7}")

    var result8: Bool = testPrintTraceLog()
    println("testPrintTraceLog = ${result8}")

    var result9: Bool = testPrintDebugLog()
    println("testPrintDebugLog = ${result9}")

    var result10: Bool = testPrintAllLog()
    println("testPrintAllLog = ${result10}")

    var result11: Bool = testGetAppenderFactory()
    println("testGetAppenderFactory = ${result11}")

    var result12: Bool = testInitLogggerManagerWithEmptyPath()
    println("testInitLogggerManagerWithEmptyPath = ${result12}")

    var result13: Bool = testPrintFatalLog()
    println("testPrintFatalLog = ${result13}")

    println("测试结束")

    if (result1 && result2 && result3 && result4) {
        return 0
    }

    if (result5 && result6 && result7 && result8) {
        return 0
    }

    if (result9 && result10 && result11 && result12 && result13) {
        return 0
    }

    return -1
}

func testLoadDefaultConfig(): Bool {
    var config: LoggerConfiguration = Logger_Manager.loadDefaultConfiguration()
    var rootLevel: String = config.getRoot().getLevel()
    if (!rootLevel.equals("info")) {
        return false
    }
    return true
}

func testGetLogger(): Bool {
    var log = Logger_Manager.getLogger("test")
    if (!log.getName().equals("test")) {
        return false
    }
    return true
}

func testInitLogggerManager(): Bool {
    var size: Int64 = Logger_Manager.getRootLogger().getAppenderList().size
    if (size != 2) {
        return false
    }
    return true
}

func testPrintInfoLog(): Bool {
    let log = Logger_Manager.getLogger("test")
    log.info("info")
    var res1 = getQueryResult("test", "info")
    var res2 = getQueryResult("test", "info2")

    if (res1 && !res2) {
        return true
    }
    return false
}
func testPrintErrorLog(): Bool {
    let log = Logger_Manager.getLogger("test")
    log.error("error")
    var res1 = getQueryResult("test", "error")
    var res2 = getQueryResult("test", "error2")

    if (res1 && !res2) {
        return true
    }
    return false
}
func testPrintWarnLog(): Bool {
    let log = Logger_Manager.getLogger("test")
    log.warn("warn")
    var res1 = getQueryResult("test", "warn")
    var res2 = getQueryResult("test", "warn2")

    if (res1 && !res2) {
        return true
    }
    return false
}

func testPrintFatalLog(): Bool {
    let log = Logger_Manager.getLogger("test")
    log.fatal("fatal")
    var res1 = getQueryResult("test", "fatal")
    var res2 = getQueryResult("test", "off2")

    if (res1 && !res2) {
        return true
    }
    return false
}

func testPrintOffLog(): Bool {
    let log = Logger_Manager.getLogger("test")
    log.off("off")
    var res1 = getQueryResult("test", "off")
    var res2 = getQueryResult("test", "off2")

    if (res1 && !res2) {
        return true
    }
    return false
}

func testPrintDebugLog(): Bool {
    let log = Logger_Manager.getLogger("test")
    log.debug("debug")
    var res1 = getQueryResult("test", "debug")
    if (!res1) {
        return true
    }
    return false
}

func testPrintTraceLog(): Bool {
    let log = Logger_Manager.getLogger("test")
    log.trace("trace")
    var res1 = getQueryResult("test", "trace")
    if (!res1) {
        return true
    }
    return false
}
func testPrintAllLog(): Bool {
    let log = Logger_Manager.getLogger("test")
    log.all("all msg")
    var res1 = getQueryResult("test", "all msg")
    if (!res1) {
        return true
    }
    return false
}

func testGetAppenderFactory(): Bool {
    let loggerManager = LoggerManager()
    var res: Bool = loggerManager.getLoggerAppenderFactory().getAppenderByType("aa") is FileLoggerAppender
    if (!res) {
        return false
    }
    return true
}

func testInitLogggerManagerWithEmptyPath(): Bool {
    let Logger_Manager = LoggerManager("")
    var size: Int64 = Logger_Manager.getRootLogger().getAppenderList().size
    if (size != 2) {
        return false
    }
    return true
}
func getQueryResult(name: String, msg: String): Bool {
    var curDir: Directory = Directory(".")
    var fileList: ArrayList<FileInfo> = curDir.fileList()
    for (f in fileList) {
        if (f.isFile() && f.path.toString().contains("root.log")) {
            var allBytes: Array<Byte> = File.readFrom(f.path.toString())
            var content: String = String.fromUtf8(allBytes)
            var time: String = DateTime.now().toString().substring(11, 8)
            if (content.contains(time) && content.contains(name) && content.contains(msg)) {
                return true
            }
        }
    }
    return false
}
