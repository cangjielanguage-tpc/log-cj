// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
package test

from log4cj import utils.*
from std import time.*

main(): Int64 {
    println("测试开始")

    var resultGetNumByString: Bool = testGetNumByString()
    println("testGetNumByString = ${resultGetNumByString}")

    var resultStrToNumBySuffix: Bool = testStrToNumBySuffix()
    println("testStrToNumBySuffix = ${resultStrToNumBySuffix}")

    var resultFlushLeft: Bool = testFlushLeft()
    println("testFlushLeft = ${resultFlushLeft}")

    var resultFormatLogRecord: Bool = testFormatLogRecord()
    println("testFormatLogRecord = ${resultFormatLogRecord}")

    var resultLogRecord: Bool = testLogRecord()
    println("testLogRecord = ${resultLogRecord}")

    var resultLogLevel: Bool = testLogLevel()
    println("testLogLevel = ${resultLogLevel}")

    var resultGetLevelByString: Bool = testGetLevelByString()
    println("testGetLevelByString = ${resultGetLevelByString}")

    var resultTimeSlice: Bool = testTimeSlice()
    println("testTimeSlice = ${resultTimeSlice}")

    var resultOperator: Bool = testLogLevelOperator()
    println("testLogLevelOperator = ${resultOperator}")

    println("测试结束")
    if (resultGetNumByString && resultStrToNumBySuffix && resultFlushLeft && resultFormatLogRecord && resultLogRecord &&
        resultLogLevel && resultGetLevelByString && resultTimeSlice && !resultOperator) {
        return 0
    }
    return -1
}

func testGetNumByString(): Bool {
    var number1: Int64 = getNumByString("123", 456)
    var number2: Int64 = getNumByString("345", 456)
    if (number1 != 123 && number2 != 456) {
        return false
    }
    return true
}

func testStrToNumBySuffix(): Bool {
    var res: Int64 = strToNumBySuffix("230", 1024, 2097152)
    var res1: Int64 = strToNumBySuffix("2M", 1024, 2097152)
    var res2: Int64 = strToNumBySuffix("2m", 1024, 2097152)
    var res3: Int64 = strToNumBySuffix("2g", 1024, 2097152)
    var res4: Int64 = strToNumBySuffix("2G", 1024, 2097152)
    var res5: Int64 = strToNumBySuffix("2k", 1024, 2097152)
    var res6: Int64 = strToNumBySuffix("2K", 1024, 2097152)

    if (res != 230 || res1 != 2 * 1024 * 1024 || res2 != 2 * 1024 * 1024) {
        return false
    }
    if (res3 != 2 * 1024 * 1024 * 1024 || res4 != 2 * 1024 * 1024 * 1024) {
        return false
    }
    if (res5 != 2 * 1024 || res6 != 2 * 1024) {
        return false
    }
    return true
}

func testFlushLeft(): Bool {
    var flushString1 = flushLeft("abcdefg", 8, "0")
    var flushString2 = flushLeft("", 8, "0")
    var flushString3 = flushLeft("abcdefg", -1, "0")
    var flushString4 = flushLeft("abcdefg", 2, "0")
    var flushString5 = flushLeft("abcdefgk", 8, "0")
    if (flushString1 != "0abcdefg" || flushString2 != "" || flushString3 != "abcdefg") {
        return false
    }
    if (flushString4 != "abcdefg" || flushString5 != "abcdefgk") {
        return false
    }
    return true
}

func testFormatLogRecord(): Bool {
    let defaultPatternConverter = DefaultPatternConverter()
    var logRecord1 = LogRecord(Time.now())
    var logRecord2 = LogRecord("com.test", LogLevel.ALL, Time.now(), "source/hello", "message")
    var size1 = defaultPatternConverter.formatLogRecord("", logRecord1).size
    var size2 = getDefaultPatternConvert().formatLogRecord("", logRecord1).size
    var size3 = defaultPatternConverter.formatLogRecord("[%D %T %m] [%L] [%l] (%S) %M", logRecord1).size
    var size4 = defaultPatternConverter.formatLogRecord("[%D %T %m] [%L] [%l] (%s) %M", logRecord2).size
    var size5 = defaultPatternConverter.formatLogRecord("[%A]", logRecord1).size

    if (size1 != 0 || size2 != 0 || size3 == 0 || size4 == 0 || size5 == 0) {
        return false
    }
    return true
}

func testLogRecord(): Bool {
    var logRecord2 = LogRecord(Time.now())
    var year = logRecord2.getCreatedTime().year()
    var logRecord3 = LogRecord("com.test", LogLevel.ALL, Time.now(), "source", "message")
    var tagname = logRecord3.getTagName()
    if (year == 0 || tagname != "com.test") {
        return false
    }
    return true
}

func testLogLevel(): Bool {
    var logLevel1 = LogLevel.ALL
    if (logLevel1.level() != 1 || logLevel1.levelName() != "ALL") {
        return false
    }
    var logLevel2 = LogLevel.TRACE
    if (logLevel2.level() != 2 || logLevel2.levelName() != "TRACE") {
        return false
    }
    var logLevel3 = LogLevel.DEBUG
    if (logLevel3.level() != 3 || logLevel3.levelName() != "DEBUG") {
        return false
    }
    var logLevel4 = LogLevel.INFO
    if (logLevel4.level() != 4 || logLevel4.levelName() != "INFO") {
        return false
    }
    var logLevel5 = LogLevel.WARN
    if (logLevel5.level() != 5 || logLevel5.levelName() != "WARN") {
        return false
    }
    var logLevel6 = LogLevel.ERROR
    if (logLevel6.level() != 6 || logLevel6.levelName() != "ERROR") {
        return false
    }
    var logLevel7 = LogLevel.OFF
    if (logLevel7.level() != 7 || logLevel7.levelName() != "OFF") {
        return false
    }
    return true
}

func testGetLevelByString(): Bool {
    var levestring1 = LogLevel.getLevelByString("all").levelName()
    var levestring2 = LogLevel.getLevelByString("trace").levelName()
    var levestring3 = LogLevel.getLevelByString("debug").levelName()
    var levestring4 = LogLevel.getLevelByString("info").levelName()
    var levestring5 = LogLevel.getLevelByString("warn").levelName()
    var levestring6 = LogLevel.getLevelByString("error").levelName()
    var levestring7 = LogLevel.getLevelByString("off").levelName()
    var levestring8 = LogLevel.getLevelByString("test").levelName()
    if (levestring1 != "ALL" || levestring2 != "TRACE" || levestring3 != "DEBUG") {
        return false
    }
    if (levestring4 != "INFO" || levestring5 != "WARN" || levestring6 != "ERROR") {
        return false
    }
    if (levestring7 != "OFF" || levestring8 != "INFO") {
        return false
    }
    return true
}

func testTimeSlice(): Bool {
    let timeSilce = TimeSlice()
    timeSilce.getTimeSlice(Time.now())
    setCachedTimeSlice(timeSilce)
    if (timeSliceCache.shortTime.size <= 0 || timeSilce.getShortDate().size <= 0 || timeSilce.getShortTime().size <= 0) {
        return false
    }
    return true
}

func testLogLevelOperator(): Bool {
    var logLevel = LogLevel.ALL
    var result: Bool = logLevel >= LogLevel.INFO
    return result
}
