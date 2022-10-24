package utils

from std import convert.*

/**
 *  实现字符串右对齐，余位补充指定的字符
 * */
public func LeftPad(str: String, limit: Int64, placeholder: String): String {
    var len = limit - str.size
    if (len >= limit) {
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
public func strToNumSuffix(str: String, mult: Int64): Int64 {
    var num = 1
    let len = str.size
    var strNum = str
    if (len > 1) {
        let suffix = str[len - 1..]
        if (suffix.equals("g") || suffix.equals("G")) {
            num = num * mult * mult * mult
        } else if (suffix.equals("m") || suffix.equals("M")) {
            num = num * mult * mult
        } else if (suffix.equals("k") || suffix.equals("K")) {
            num = num * mult
        }
        strNum = str[0..len - 1]
    }
    let parsed = Int64.parse(strNum)
    return parsed * num
}
