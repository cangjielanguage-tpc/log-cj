package utils

public interface PatternConverter {
    func formatLogRecord(pattern: String, rec: LogRecord): String
}

let defaultPatternConverter = DefaultPatternConverter()

public func getDefaultPatternConvert(): PatternConverter {
    return defaultPatternConverter
}

public class DefaultPatternConverter <: PatternConverter {
    // FormatLogRecord
    // Known format codes:
    // %T - Time (15:04:05 MST)
    // %t - Time (15:04)
    // %D - Date (2006/01/02)
    // %d - Date (01/02/06)
    // %o - UnixMilli (1649224315937)
    // %m - Millisecond (607)  //
    // %n - Nanosecond (794411287)
    // %L - Level (FNST, FINE, DEBG, TRAC, WARN, EROR, CRIT)
    // %l - Label (TagName)
    // %S - Source
    // %M - Message
    // Ignores unknown formats
    // Recommended: "[%D %T] [%L] (%S) %M"
    public func formatLogRecord(pattern: String, rec: LogRecord): String {
        var result = ""
        if (pattern.size == 0) {
            return result
        }
        let timeSlice = TimeSlice()
        timeSlice.getTimeSlice(rec.created)

        // Split the string into pieces by % signs
        let pieces = pattern.split("%")
        for (piece in pieces) {
            if (piece != pieces[0] && piece.size > 0) {
                match (piece[0]) {
                    case 'T' => result += timeSlice.longTime
                    case 'o' => result += (rec.created.unixNano() / Int64(1e6)).toString()
                    case 'n' => result += LeftPad(rec.created.nanosecond().toString(), 9, "0")
                    case 'm' => result += LeftPad((rec.created.nanosecond() / Int64(1e6)).toString(), 3, "0")
                    case 't' => result += timeSlice.shortTime
                    case 'D' => result += timeSlice.longDate
                    case 'd' => result += timeSlice.shortDate
                    case 'l' => result += rec.tagName
                    case 'L' => result += rec.level.levelName()
                    case 'S' => result += rec.source
                    case 's' =>
                        let slice = rec.source.split("/")
                        result += slice[slice.size - 1]
                    case 'M' => result += rec.message
                    case _ => result += ""
                }
                if (piece.size > 1) {
                    result += piece[1..]
                }
            } else if (piece.size > 0) {
                result += piece
            }
        }
        result += "\n"
        return result
    }
}
