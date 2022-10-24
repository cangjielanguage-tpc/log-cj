package utils

from std import time.*
from std import sync.*
from std import format.*

var timeSliceCache = TimeSlice()

/**
* 设置 timeSliceCache 的值
**/
func setCachedTimeSlice(timeSlice: TimeSlice) {
    timeSliceCache.lock.lock()
    timeSliceCache.lastUpdateSeconds = timeSlice.lastUpdateSeconds
    timeSliceCache.shortTime = timeSlice.shortTime
    timeSliceCache.shortDate = timeSlice.shortDate
    timeSliceCache.longTime = timeSlice.longTime
    timeSliceCache.longDate = timeSlice.longDate
    timeSliceCache.lock.unlock()
}

/**
* 时间戳类，用于配合 pattern 打印不同规格的时间戳
**/
public class TimeSlice {
    public var lastUpdateSeconds: Int64 = 0
    public var shortTime: String = ""
    public var shortDate: String = ""
    public var longTime: String = ""
    public var longDate: String = ""
    public var lock: ReentrantMutex = ReentrantMutex()

    public func getTimeSlice(time: Time) {
        var secs = time.unixNano() / Int64(1e9)
        var cached = timeSliceCache
        if (cached.lastUpdateSeconds != secs) {
            let year = time.year()
            let month = time.month().value()
            let day = time.day()
            let hour = time.hour()
            let minute = time.minute()
            let second = time.second()
            let zone = time.zone()[0]

            this.lastUpdateSeconds = secs
            this.shortTime = hour.format("02") + ":" + minute.format("02")
            this.shortDate = day.format("02") + "/" + month.format("02") + "/" + (year % 100).format("02")
            this.longTime = hour.format("02") + ":" + minute.format("02") + ":" + second.format("02") + " " + zone
            this.longDate = year.format("04") + "/" + month.format("02") + "/" + day.format("02")
            setCachedTimeSlice(this)
        } else {
            this.lastUpdateSeconds = cached.lastUpdateSeconds
            this.shortTime = cached.shortTime
            this.shortDate = cached.shortDate
            this.longTime = cached.longTime
            this.longDate = cached.longDate
        }
    }
}