// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
// DEPENDENCE: ./src/resources/issue.json
import logcj.appender.*
import logcj.config.*
import logcj.logger.*
import logcj.utils.*

main() {
    let logger = LoggerManager.createManager("./issue.json").getLogger("aaa")
    

    // Print logs.
    logger.all("This is test 1")
    logger.trace("This is test 2")
    logger.debug("This is test 3")
    logger.info("This is test 4")
    logger.warn("This is test 5")
    logger.error("This is test 6")

    // Create another logger.
    let logger1 = LoggerManager.createManager("./issue.json").getLogger("Demo")

    logger1.all("This is another test 1")
    logger1.trace("This is another test 2")
    logger1.debug("This is another test 3")
    logger1.info("This is another test 4")
    logger1.warn("This is another test 5")
    logger1.error("This is another test 6")
    logger1.warn("这是个中文测试")
    
    

    sleep(5000 * Duration.millisecond)
}