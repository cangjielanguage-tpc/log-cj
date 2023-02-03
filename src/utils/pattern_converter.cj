/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file defines PatternConverter interface and DefaultPatternConverter class.
 */

package utils

public interface PatternConverter {
    func formatLogRecord(pattern: String, logRecord: LogRecord): String
}

let defaultPatternConverter = DefaultPatternConverter()

public func getDefaultPatternConvert(): PatternConverter {
    return defaultPatternConverter
}

/**
 * Model class for formatting log recording.
 */
public class DefaultPatternConverter <: PatternConverter {
    // FormatLogRecord
    // Known format codes:
    // %T - Time (15:04:05 MST)
    // %t - Time (15:04)
    // %D - Date (2006/01/02)
    // %d - Date (01/02/06)
    // %o - UnixMilli (1649224315937)
    // %m - Millisecond (607)
    // %n - Nanosecond (794411287)
    // %L - Level (ALL, TRACE, DEBUG, INFO, WARN, ERROR, OFF)
    // %l - Label (TagName)
    // %S - Source
    // %M - Message
    // Ignores unknown formats
    // Recommended: "[%D %T] [%L] (%S) %M"
    
    /**
     * Formatting log recording.
     *
     * @param pattern output pattern.
     * @param logRecord log record.
     * @return format result.
     */
    public func formatLogRecord(pattern: String, logRecord: LogRecord): String {
        var result = ""
        if (pattern.size == 0) {
            return result
        }
        let timeSlice = TimeSlice()
        timeSlice.getTimeSlice(logRecord.getCreatedTime())

        // Split the string into pieces by % signs.
        let pieces = pattern.split("%")
        var i: Int64 = 0
        while (pieces.size != 0 && i < pieces.size) {
            var piece: String = pieces.get(i).getOrThrow()
            if (piece != pieces[0] && piece.size > 0) {
                match (piece[0]) {
                    case 'T' => result += timeSlice.getLongTime()
                    case 'o' =>
                        result += (logRecord.getCreatedTime().unixTimeStamp().nanoseconds() / Int64(1e12)).toString()
                    case 'n' => result += flushLeft(logRecord.getCreatedTime().nanosecond().toString(), 9, "0")
                    case 'm' =>
                        result += flushLeft(
                            (logRecord.getCreatedTime().nanosecond() / Int64(1e6)).toString(),
                            3,
                            "0"
                        )
                    case 't' => result += timeSlice.getShortTime()
                    case 'D' => result += timeSlice.getLongDate()
                    case 'd' => result += timeSlice.getShortDate()
                    case 'l' => result += logRecord.getTagName()
                    case 'L' => result += logRecord.getLevel().levelName()
                    case 'S' => result += logRecord.getSource()
                    case 's' =>
                        let slice = logRecord.getSource().split("/")
                        result += slice[slice.size - 1]
                    case 'M' => result += logRecord.getMessage()
                    case _ => result += ""
                }
                if (piece.size > 1) {
                    result += piece[1..]
                }
            } else if (piece.size > 0) {
                result += piece
            }
            i++
        }
        result += "\n"
        return result
    }
}
