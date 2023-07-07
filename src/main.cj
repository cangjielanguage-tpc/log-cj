/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file defines the entry function.
 */

import logger.*

main(): Int64 {
    // Create a logger.
    let logger = Logger_Manager.getLogger("com.hello")

    // Print logs.
    logger.all("1")
    logger.trace("2")
    logger.debug("3")
    logger.info("4")
    logger.warn("5")

    // Create another logger.
    // let logger1 = LoggerManager("/home/helongfei/workspace/log4cj2/log4cj222.json").getLogger("com.test1")

    let logger1 = Logger_Manager.getLogger("com.test1")
    logger1.error("6")
    logger1.off("7")
    return 0
}
