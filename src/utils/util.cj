package utils

from std import convert.*

/**
 * 实现字符串右对齐，余位补充指定的字符
 * */
public func flushLeft(str: String, limit: Int64, placeholder: String): String {
    var len = limit - str.size
    if (len == limit) {
        return str
    }

    var result: String = ""
    for (i in 0..len) {
        result = placeholder + result
    }
    result += str
    return result
}

// Parse a number with K/M/G suffixes based on thousands (1000) or 2^10 (1024) 待改进算法
public func strToNumBySuffix(str: String, mult: Int64, defaultValue: Int64): Int64 {
    var num = 1
    let len = str.size
    var numStr = str
    if (str.endsWith("g") || str.endsWith("G")) {
        num = num * mult * mult * mult
        numStr = str[0..len - 1]
    } else if (str.endsWith("m") || str.endsWith("M")) {
        num = num * mult * mult
        numStr = str[0..len - 1]
    } else if (str.endsWith("k") || str.endsWith("K")) {
        num = num * mult
        numStr = str[0..len - 1]
    }
    try {
        let parsed = Int64.parse(numStr)
        return parsed * num
    } catch (e: ConvertException) {
        return defaultValue
    }
}

/**
 * 数字字符串转Int64
 * 
 * @param str 待转换字符串
 * @param defaultValue 转换异常时返回默认值
 * @return 返回Int64类型的数据
 */
public func getNumByString(str: String, defaultValue: Int64) {
    try {
        return Int64.parse(str)
    } catch (e: ConvertException) {
        return defaultValue
    }
}
