// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
// DEPENDENCE: ./src/resources/logcj.json
from logcj import appender.*
from logcj import config.*
from logcj import logger.*
from logcj import utils.*

main(): Int64 {
    // Create a logger.
    let logger = LoggerManager.createManager("./logcj.json").getLogger("aaa")

    // Print logs.
    logger.all("1")
    logger.trace("2")
    logger.debug("3")
    logger.info("4")
    logger.warn("5")
    logger.error("6")
    logger.off("7")

    // Create another logger.
    let logger1 = LoggerManager.createManager("./logcj.json").getLogger("Demo")
    logger1.all("1")
    logger1.trace("2")
    logger1.debug("3")
    logger1.info("4")
    logger1.warn("5")
    logger1.error("6")
    logger1.off("789")

    return 0
}