/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file defines LoggerManager class.
 */

package logger

from encoding import json.*
from std import collection.*
from std import fs.*
from std import os.posix.*
from std import sync.*
import appender.*
import config.*
import utils.*

public let Logger_Appender_Factory = LoggerAppenderFactory()
public let Logger_Manager = LoggerManager("${getcwd()}/src/resources/log4cj.json")

/**
 * Log management class, load and parse log file to get a specific configuration item.
 */
public class LoggerManager {
    // Logger appender factory, mainly register logger appender.
    private var loggerAppenderFactory: LoggerAppenderFactory = LoggerAppenderFactory()

    // Root configuation variable.
    private var rootLogger: LoggerAppenderReference = LoggerAppenderReference()

    // Logger configuration map, mainly stores configurtion items related to logger configuration.
    private var loggerNameArr: ArrayList<String> = ArrayList<String>()
    private var loggerAttrArr: ArrayList<LoggerAppenderReference> = ArrayList<LoggerAppenderReference>()

    /**
     * No-parameter constructor.
     */
    public init() {}

    /**
     * Constructor, load and parse xml file.
     *
     * @param jsonPath log file path.
     */
    public init(jsonPath: String) {
        initLoggerManager(jsonPath)
    }

    public func getLoggerAppenderFactory(): LoggerAppenderFactory {
        return this.loggerAppenderFactory
    }

    public func getRootLogger(): LoggerAppenderReference {
        return this.rootLogger
    }

    public func getLoggerNameArr(): ArrayList<String> {
        return this.loggerNameArr
    }

    public func getLoggerAttrArr(): ArrayList<LoggerAppenderReference> {
        return this.loggerAttrArr
    }

    /**
     * Get the specific logger based on the logger name.
     *
     * @param name logger name.
     * @return logger object.
     */
    public func getLogger(name: String): Logger {
        var logger = Logger(name)
        return logger
    }

    /**
     * Initialize default configurations of log file.
     *
     * @param jsonPath log file path.
     */
    private func initWithDefaultConfig(jsonPath: String): Unit {
        var loggerConfiguration: LoggerConfiguration = parseJson(jsonPath)
        if (loggerConfiguration.getAppenders().size == 0) {
            println("can not find any appender!")
            return
        }
        initWithConfig(loggerConfiguration)
    }

    /**
     * Initialize the log configurtion obtained by loading the xml file.
     *
     * @param configuration log configuration obtained by loading the xml file.
     */
    private func initWithConfig(configuration: LoggerConfiguration): Unit {
        this.loggerAppenderFactory = Logger_Appender_Factory.new()

        this.loggerNameArr = ArrayList<String>()
        this.loggerAttrArr = ArrayList<LoggerAppenderReference>()
        this.rootLogger = LoggerAppenderReference(DEFAULT_LOG_LEVEL, ArrayList<LoggerAppender>())

        var nameArr: ArrayList<String> = ArrayList<String>()
        var enabledArr: ArrayList<String> = ArrayList<String>()

        // Register appenders.
        if (configuration.getAppenders().size > 0) {
            var i: Int64 = 0
            var appenders: ArrayList<AppenderConfig> = configuration.getAppenders()
            while (i < appenders.size) {
                nameArr.append(appenders.get(i).getOrThrow().getName().toAsciiLower())
                enabledArr.append(appenders.get(i).getOrThrow().getEnabled().toAsciiLower().trimAscii())
                if (nameArr.get(i).getOrThrow().size > 0 && enabledArr.get(i).getOrThrow().contains("true")) {
                    this.loggerAppenderFactory.registerLoggerAppender(
                        appenders.get(i).getOrThrow().getName(),
                        appenders.get(i).getOrThrow().getAppenderType(),
                        appenders.get(i).getOrThrow().getPattern(),
                        appenders.get(i).getOrThrow().getProperties()
                    )
                }
                i++
            }
        }

        // Initialize root configuration.
        let rootConfig = configuration.getRoot()

        this.rootLogger.setLevel(LogLevel.getLevelByString(rootConfig.getLevel()))

        if (rootConfig.getAppenderRefList().size > 0) {
            var j: Int64 = 0
            var appenderRefList: ArrayList<AppenderRef> = rootConfig.getAppenderRefList()
            while (j < appenderRefList.size) {
                var appenderRef = appenderRefList.get(j).getOrThrow()
                var index: Int64 = 0
                while (index < nameArr.size) {
                    if (nameArr.get(index).getOrThrow().contains(appenderRef.getRef().toAsciiLower()) &&
                        enabledArr.get(index).getOrThrow().contains("true")) {
                        let ap = this.loggerAppenderFactory.getAppenderByName(appenderRef.getRef().toAsciiLower())
                        this.rootLogger.getAppenderList().append(ap)
                    }
                    index++
                }
                j++
            }
        }
 
        // Initialize logger configuration.
        if (configuration.getLogger().size > 0) {
            var k: Int64 = 0
            var loggers: ArrayList<LoggerConfig> = configuration.getLogger()
            while (k < loggers.size) {
                var logger: LoggerConfig = loggers.get(k).getOrThrow()
                let oneLogger = LoggerAppenderReference(
                    LogLevel.getLevelByString(logger.getLevel()),
                    ArrayList<LoggerAppender>()
                )
                var m: Int64 = 0
                while (m < logger.getAppenderRefList().size) {
                    var appenderRef: AppenderRef = logger.getAppenderRefList().get(m).getOrThrow()
                    var index: Int64 = 0
                    while (index < nameArr.size) {
                        if (nameArr.get(index).getOrThrow().contains(appenderRef.getRef().toAsciiLower()) &&
                            enabledArr.get(index).getOrThrow().contains("true")) {
                            let oneAppender = this.loggerAppenderFactory.getAppenderByName(
                                appenderRef.getRef().toAsciiLower()
                            )
                            oneLogger.getAppenderList().append(oneAppender)
                        }
                        index++
                    }
                    m++
                }
                if (oneLogger.getAppenderList().size > 0) {
                    this.loggerNameArr.append(logger.getName())
                    this.loggerAttrArr.append(oneLogger)
                }
                k++
            }
        }
    }

    private func initLoggerManager(jsonPath: String): Unit {
        // Register the LoggerAppender provided by the system.
        Logger_Appender_Factory.registryType("console", ConsoleLoggerAppender())
        Logger_Appender_Factory.registryType("file", FileLoggerAppender())

        // Initialize the log configuration file.
        initWithDefaultConfig(jsonPath)
    }

    /**
     * This function is used to parse the XML file into the LoggerConfiguration object.
     *
     * @param jsonPath log file path.
     * @return logger configuration object.
     */
    private func parseJson(jsonPath: String): LoggerConfiguration {
        var filePath: Path = Path(jsonPath)
        var isFileExist: Bool = File.exists(filePath)
        if (jsonPath.size == 0 || !isFileExist) {
            return loadDefaultConfiguration()
        }

        // read file.
        let allBytes: Array<Byte> = File.readFrom(jsonPath)
        if (allBytes.size == 0) {
            println("can not find any element in json file!")
            return LoggerConfiguration()
        }

        var jsonValue: JsonValue = JsonValue.fromStr(String.fromUtf8(allBytes))

        // Get appender configuration.
        var appenderList: ArrayList<AppenderConfig> = getAppenderConfiguration(jsonValue)

        if (appenderList.size == 0) {
            println("can not find any appender in xml file!")
            return LoggerConfiguration()
        }

        // Get logger configuration.
        var loggerList: ArrayList<LoggerConfig> = getLoggerConfiguration(jsonValue)
        if (loggerList.size == 0) {
            println("can not find any logger in xml file!")
        }

        // Get root configuration.
        var root: RootLoggerConfig = getRootConfiguration(jsonValue)
        if (root.getLevel().size == 0 || root.getAppenderRefList().size == 0) {
            println("root configuration has mistakes!")
            return LoggerConfiguration()
        }

        return LoggerConfiguration(appenderList, root, loggerList)
    }

    /**
     * Parse the built-in log configuration.
     *
     * @return logger configuration object.
     */
    public func loadDefaultConfiguration(): LoggerConfiguration {
        println("enter default...")
        var str =
            ##"{"appenders":[{"enabled":"false","name":"console","type":"console","pattern":"[%D %T %m] [%L] [%l] (%S) %M"},{"enabled":"true","name":"file","type":"file","pattern":"[%D %T %m] [%L] [%l] (%S) %M","properties":[{"name":"filename","value":"root.log"},{"name":"rotate","value":"true"},{"name":"maxsize","value":"20M"},{"name":"daily","value":"false"}]}],"loggers":[{"name":"Demo","level":"info","appender-refs":[{"ref":"console"},{"ref":"file"}]}],"root":{"level":"info","appender-refs":[{"ref":"console"},{"ref":"file"}]}}"##
        var jsonValue: JsonValue = JsonValue.fromStr(str)
        var appenderList: ArrayList<AppenderConfig> = getAppenderConfiguration(jsonValue)
        var loggerList: ArrayList<LoggerConfig> = getLoggerConfiguration(jsonValue)
        var root: RootLoggerConfig = getRootConfiguration(jsonValue)
        return LoggerConfiguration(appenderList, root, loggerList)
    }

    /**
     * Get appender configuarations.
     *
     * @param jsonValue basic configuration elements by parsing json file.
     * @return appender configuration list.
     */
    private func getAppenderConfiguration(jsonValue: JsonValue): ArrayList<AppenderConfig> {
        var configList: ArrayList<AppenderConfig> = ArrayList<AppenderConfig>()
        let appenders = jsonValue.asObject().get("appenders").getOrThrow()
        var jsArr: JsonArray = JsonValue.fromStr(appenders.toJsonString()).asArray()
        var propertyList: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()

        for (o in 0..jsArr.size()) {
            var appender: AppenderConfig = AppenderConfig()
            if (jsArr.get(o).getOrThrow().asObject().containsKey("enabled")) {
                appender.setEnabled(jsArr.get(o).getOrThrow().asObject().get("enabled").getOrThrow().toString())
            }
            if (jsArr.get(o).getOrThrow().asObject().containsKey("enabled")) {
                appender.setName(jsArr.get(o).getOrThrow().asObject().get("name").getOrThrow().toString())
            }
            if (jsArr.get(o).getOrThrow().asObject().containsKey("type")) {
                appender.setAppenderType(jsArr.get(o).getOrThrow().asObject().get("type").getOrThrow().toString())
            }
            if (jsArr.get(o).getOrThrow().asObject().containsKey("pattern")) {
                appender.setPattern(jsArr.get(o).getOrThrow().asObject().get("pattern").getOrThrow().toString())
            }
            if (jsArr.get(o).getOrThrow().asObject().containsKey("properties")) {
                var proArr: JsonArray = jsArr.get(o).getOrThrow().asObject().get("properties").getOrThrow().asArray()
                for (i in 0..proArr.size()) {
                    var property: AppenderProperty = AppenderProperty()
                    property.setName(proArr.get(i).getOrThrow().asObject().get("name").getOrThrow().toString())
                    property.setValue(proArr.get(i).getOrThrow().asObject().get("value").getOrThrow().toString())
                    propertyList.append(property)
                }
                appender.setProperties(propertyList)
            }
            configList.append(appender)
        }
        return configList
    }

    /**
     * Get logger configuarations.
     *
     * @param jsonValue basic configuration elements by parsing json file.
     * @return logger configuration list.
     */
    private func getLoggerConfiguration(jsonValue: JsonValue): ArrayList<LoggerConfig> {
        var loggerList: ArrayList<LoggerConfig> = ArrayList<LoggerConfig>()
        let loggers = jsonValue.asObject().get("loggers").getOrThrow()
        var jsArr: JsonArray = JsonValue.fromStr(loggers.toJsonString()).asArray()
        var refList: ArrayList<AppenderRef> = ArrayList<AppenderRef>()

        for (o in 0..jsArr.size()) {
            var logger: LoggerConfig = LoggerConfig()
            if (jsArr.get(o).getOrThrow().asObject().containsKey("name")) {
                logger.setName(jsArr.get(o).getOrThrow().asObject().get("name").getOrThrow().toString())
            }
            if (jsArr.get(o).getOrThrow().asObject().containsKey("enabled")) {
                logger.setLevel(jsArr.get(o).getOrThrow().asObject().get("level").getOrThrow().toString())
            }
            if (jsArr.get(o).getOrThrow().asObject().containsKey("appender-refs")) {
                var refArr: JsonArray = jsArr.get(o).getOrThrow().asObject().get("appender-refs").getOrThrow().asArray()
                for (i in 0..refArr.size()) {
                    var ref: AppenderRef = AppenderRef(
                        refArr.get(i).getOrThrow().asObject().get("ref").getOrThrow().toString()
                    )
                    refList.append(ref)
                }
                logger.setAppenderRefList(refList)
            }
            loggerList.append(logger)
        }
        return loggerList
    }

    /**
     * Get root configuarations.
     *
     * @param jsonValue basic configuration elements by parsing json file.
     * @return root configuration list.
     */
    private func getRootConfiguration(jsonValue: JsonValue): RootLoggerConfig {
        var configList: ArrayList<AppenderConfig> = ArrayList<AppenderConfig>()
        let appenders = jsonValue.asObject().get("root").getOrThrow()
        var jsObj: JsonObject = JsonValue.fromStr(appenders.toJsonString()).asObject()
        var root: RootLoggerConfig = RootLoggerConfig()
        var refList: ArrayList<AppenderRef> = ArrayList<AppenderRef>()
        if (jsObj.containsKey("level")) {
            root.setLevel(jsObj.get("level").getOrThrow().toString())
        }
        if (jsObj.containsKey("appender-refs")) {
            var jsArr: JsonArray = jsObj.get("appender-refs").getOrThrow().asArray()
            for (j in 0..jsArr.size()) {
                var ref: AppenderRef = AppenderRef(
                    jsArr.get(j).getOrThrow().asObject().get("ref").getOrThrow().toString()
                )
                refList.append(ref)
            }
            root.setAppenderRefList(refList)
        }
        return root
    }
}
