/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file defines FileLoggerAppender class.
 */

package appender

from std import fs.*
from std import format.*
from std import time.*
import utils.*

/**
   The specific implementation class of LoggerAppender, which enables the file can be logged.
 */
public class FileLoggerAppender <: LoggerAppender {
    // Defalut log file.
    private let DEFAULT_OUTPUT_FILE_NAME: String = "log4cj_default.log"

    //Log Print Format.
    private var pattern: String = ""

    // Log file name.
    private var fileName: String = ""

    // Log file pointer.
    private var file: fs.File

    // Maximum limit of a single log. The value 0 indicates no limit.
    private var maxSize: Int64 = 0

    // Current log size.
    private var curSize: Int64 = 0

    //Day-based log scrolling flag.
    private var daily: Bool = false

    // Time then a log file is created. This parameter is used together with Daily.
    private var opendate: Int64 = 0

    // Indicates whether to pack logs.
    private var rotate: Bool = false

    private var retentionDays: Int64 = 7

    private let lock = ReentrantMutex()

    /**
     * Constructor, initialize variable file.
     */
    public init() {
        this.file = File(DEFAULT_OUTPUT_FILE_NAME, OpenOption.CreateOrAppend)
    }

    /**
     * Destructor, close file.
     */
    ~init() {
        if (!file.isClosed()) {
            file.flush()
            file.close()
        }
    }

    /**
     * Initialize file logger appender.
     *
     * @param pattern log format.
     * @param property file appender properties.
     */
    public func initAppender(pattern: String, properties: ArrayList<AppenderProperty>): Unit {
        //delete default.log.
        File.delete(this.file.info.path)
        var file = ""
        let dFormat = "[%T %D %m] [%L][%l] (%S) %M"
        var maxSize = 0
        var daily = false
        var rotate = false
        var retentionDays = 7

        if (pattern.size == 0) {
            this.pattern = dFormat
        } else {
            this.pattern = pattern
        }

        //Parse properties.
        for (property in properties) {
            var value = property.getValue().trimLeft(" \r\n").trimRight(" \r\n")
            match (property.getName().toAsciiLower()) {
                case "filename" => file = value
                case "maxsize" => maxSize = strToNumBySuffix(value, 1024, 20 * 1024 * 1024) // 默认20M
                case "daily" => daily = value.toAsciiLower() != "false"
                case "rotate" => rotate = value.toAsciiLower() != "false"
                case "retentiondays" => retentionDays = getNumByString(value, 7)
                case _ => print("LoadConfiguration: Warning: Unknown property ${property.getName()}")
            }
        }

        if (file.size == 0) {
            file = "root.log"
        }
        this.fileName = file
        this.rotate = rotate
        this.maxSize = maxSize
        this.daily = daily
        this.retentionDays = retentionDays
    }

    /**
     * Process default file, and assigns values to file-related variables.
     */
    public func start(): Unit {
        this.file = File(this.fileName, OpenOption.CreateOrAppend)
        this.curSize = this.file.info.length
        this.opendate = this.file.info.creationTime.day()
    }

    /**
     * Write log to file.
     *
     * @param rec log recording.
     */
    public func logWrite(rec: LogRecord): Unit {
        let fut = spawn {
            if (this.file.isClosed()) {
                start()
            }
            let now = Time.now()
            if ((this.maxSize > 0 && this.curSize >= this.maxSize) || (this.daily && now.day() != this.opendate)) {
                rollingFile()
            }

            // Formatting logging.
            var mess = getDefaultPatternConvert().formatLogRecord(this.pattern, rec).toUtf8Array()
            try {
                this.file.write(mess)
            } catch (e: FSException) {
                println("write file occur exception: ${e.message}")
                return
            }
            let n = mess.size

            // Update the size.
            this.curSize += n
        }
        fut.getResult(100 * 1000 * 1000)
    }

    /**
     * Close file.
     */
    public func close(): Unit {
        if (!this.file.isClosed()) {
            this.file.flush()
            this.file.close()
        }
    }

    // If this is called in a threaded context, it must be synchronized.
    private func rollingFile() {
        if (!this.rotate) {
            return
        }

        lock.lock()

        // Close current file.
        if (!this.file.isClosed()) {
            this.file.flush()
            this.file.close()
        }

        var fname = ""

        // If daily in the configuration is true (archived by day), the opening date is not the same as the current day.
        if (this.daily && Time.now().day() != this.opendate) {
            // Get yesterday's time, format to day.
            let yesterday = Time.now().addDays(0, 0, -1).toString("YYYYMMddhhmmss-SS")
            fname = this.fileName + "_" + yesterday + ".log"
        } else {
            fname = this.fileName + "_" + Time.now().toString("YYYYMMddhhmmss-SS") + ".log"
        }
        try {
            //An error message is returned when the current file is named fname.
            File.move(this.fileName, fname, true)

            //Open a new file.
            this.file = File(this.fileName, OpenOption.CreateOrAppend)
        } catch (e: IllegalArgumentException | FSException) {
            lock.unlock()
            println("rolling file occur exception: ${e.message}")
            return
        }
        // Set the daily open date to the current date.
        this.opendate = Time.now().day()
        this.curSize = 0

        //Indicates whether to start the thread to run.
        deleterollingFile()
        lock.unlock()
    }

    /**
     * Delete log files whose storage duration exceeds the retention period.
     */
    private func deleterollingFile() {
        try {
            let fileDir = this.file.info.parentDirectory.getOrThrow()
            for (file in Directory(fileDir.path).fileList()) {
                if (file.path.toString().contains(".log") && file.lastModificationTime.addDays(0, 0, this.retentionDays)<
                    Time.now()) {
                    File.delete(file.path)
                }
            }
        } catch (e: NoneValueException) {
            println("logfile Directory is none")
            return
        } catch (e: FSException) {
            println("delete log file has occur an exception")
        }
    }
}
