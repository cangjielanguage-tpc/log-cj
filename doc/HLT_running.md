
# HLT（测试级别用例）运行说明

## HLT文件所在位置

test/HLT下log_test_xx.cj的仓颉文件
```shell
├── doc
├── src
├── test
│   ├── LLT
│   │    ├── log_test_xx.cj
│   │    ├── ...
├── resources
│   ├── log4cj.json
```

## HLT运行先决条件

### 新建文件夹cjtest（和项目位于一个机器）

### 下载[测试库](https://gitee.com/HW-PLLab/cj_test)，将测试库中src目录下cjtest和conf.cfg 文件复制到cjtest中

### 打开conf.cfg，配置3rd_party_root，具体值为项目路径的上一层，例如项目路径为xxx/workspace/log4cj，则配置为xxx/workspace

### 配置环境变量，export PATH=$PATH:xxx/cjtest/:cjtest


## 运行HLT

### 进入项目HLT文件所在目录

```cangjie
cd log4cj2/test/
```

### 运行HLT全部用例

```cangjie
cjtest HLT/
```
**出现`Ratio  : 100.0%`字眼，则表示运行成功**


### 运行单个用例文件

```cangjie
cjtest HLT/log_test_xx.cj
```
**出现`Ratio  : 100.0%`字眼，则表示运行成功**

### 运行HLT全部用例结果样例

```cangjie
helongfei@test-zhangxiaoyang://home/helongfei/workspace/log4cj2/test$ cjtest HLT/
line://3rd_party_lib:log4cj2/build/log4cj
[2023-07-11 14:13:34,381] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/log4cj']
line://3rd_party_lib:log4cj2/build/zip4cj
[2023-07-11 14:13:34,381] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/zip4cj']
line://3rd_party_lib:log4cj2/build/charset
[2023-07-11 14:13:34,382] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/charset']
[2023-07-11 14:13:34,382] [INFO] ************************Start to run case file: HLT/log_test_01.cj************************
[2023-07-11 14:13:34,382] [INFO] [Run CMD]cjc -O2   --import-path /home/helongfei/workspace/log4cj2/build/log4cj/.. -L /home/helongfei/workspace/log4cj2/build/log4cj -l log4cj_config -l log4cj_appender -l log4cj_logger -l log4cj_utils  --import-path /home/helongfei/workspace/log4cj2/build/zip4cj/.. -L /home/helongfei/workspace/log4cj2/build/zip4cj -l zip4cj_zip4cj.zip -l zip4cj_zip4cj.utils  --import-path /home/helongfei/workspace/log4cj2/build/charset/.. -L /home/helongfei/workspace/log4cj2/build/charset -l charset_charset.simplechinese -l charset_charset.korean -l charset_charset.japanese -l charset_charset.unicode -l charset_charset -l charset_charset.encoding -l charset_charset.singlebyte -l charset_charset.traditionchinese   HLT/log_test_01.cj  -o tmp/HLT/log_test_01.cj.out --test
[2023-07-11 14:13:36,534] [INFO] [Run CMD]cd tmp/HLT;./log_test_01.cj.out  
[2023-07-11 14:13:36,550] [INFO] enter default...
[2023-07-11 14:13:36,550] [INFO] 
[2023-07-11 14:13:36,550] [INFO] [2023/07/11 14:13:36 CST 543] [ALL] [logRecord_02] (source) message
[2023-07-11 14:13:36,551] [INFO] 
[2023-07-11 14:13:36,551] [INFO] 
[2023-07-11 14:13:36,551] [INFO] 2023/07/11 14:13:36 CST 543 ALL logRecord_02 source message
[2023-07-11 14:13:36,551] [INFO] 
[2023-07-11 14:13:36,551] [INFO] +++++2023/07/11 14:13:36 CST55 543+-- ##ALL#$ logRecord_02 (source) message
[2023-07-11 14:13:36,551] [INFO] 
[2023-07-11 14:13:36,551] [INFO] [2023/07/11 14:13:36 CST 543] [TRACE] [] ()
[2023-07-11 14:13:36,551] [INFO] 
[2023-07-11 14:13:36,551] [INFO] [2023/07/11 14:13:36 CST 543] [DEBUG] [@#$^,;[^&^%**(] (_+(^^&/\@$@&) %^&*' '&(*@#
[2023-07-11 14:13:36,551] [INFO] 
[2023-07-11 14:13:36,551] [INFO] --------------------------------------------------------------------------------------------------
[2023-07-11 14:13:36,551] [INFO] TP: test, time elapsed: 331780 ns, Result:
[2023-07-11 14:13:36,551] [INFO] TCS: LogTestA, time elapsed: 330149 ns, RESULT:
[2023-07-11 14:13:36,551] [INFO] [ PASSED ] CASE: log_test_001 (37008 ns)
[2023-07-11 14:13:36,551] [INFO] [ PASSED ] CASE: log_test_002 (22178 ns)
[2023-07-11 14:13:36,551] [INFO] [ PASSED ] CASE: log_test_003 (188589 ns)
[2023-07-11 14:13:36,551] [INFO] [ PASSED ] CASE: log_test_004 (10197 ns)
[2023-07-11 14:13:36,551] [INFO] [ PASSED ] CASE: log_test_005 (13563 ns)
[2023-07-11 14:13:36,552] [INFO] [ PASSED ] CASE: log_test_006 (29510 ns)
[2023-07-11 14:13:36,552] [INFO] [ PASSED ] CASE: log_test_007 (15960 ns)
[2023-07-11 14:13:36,552] [INFO] Summary: TOTAL: 7
[2023-07-11 14:13:36,552] [INFO] PASSED: 7, SKIPPED: 0, ERROR: 0
[2023-07-11 14:13:36,552] [INFO] FAILED: 0
[2023-07-11 14:13:36,552] [INFO] --------------------------------------------------------------------------------------------------
line://3rd_party_lib:log4cj2/build/log4cj
[2023-07-11 14:13:36,552] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/log4cj']
line://3rd_party_lib:log4cj2/build/zip4cj
[2023-07-11 14:13:36,553] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/zip4cj']
line://3rd_party_lib:log4cj2/build/charset
[2023-07-11 14:13:36,553] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/charset']
[2023-07-11 14:13:36,553] [INFO] ************************Start to run case file: HLT/log_test_05.cj************************
[2023-07-11 14:13:36,553] [INFO] Start to copy data files
[2023-07-11 14:13:36,554] [INFO] copy HLT/src/resources/log4cj.json to tmp/HLT/src/resources/log4cj.json
[2023-07-11 14:13:36,554] [INFO] [Run CMD]cjc -O2   --import-path /home/helongfei/workspace/log4cj2/build/log4cj/.. -L /home/helongfei/workspace/log4cj2/build/log4cj -l log4cj_config -l log4cj_appender -l log4cj_logger -l log4cj_utils  --import-path /home/helongfei/workspace/log4cj2/build/zip4cj/.. -L /home/helongfei/workspace/log4cj2/build/zip4cj -l zip4cj_zip4cj.zip -l zip4cj_zip4cj.utils  --import-path /home/helongfei/workspace/log4cj2/build/charset/.. -L /home/helongfei/workspace/log4cj2/build/charset -l charset_charset.simplechinese -l charset_charset.korean -l charset_charset.japanese -l charset_charset.unicode -l charset_charset -l charset_charset.encoding -l charset_charset.singlebyte -l charset_charset.traditionchinese   HLT/log_test_05.cj  -o tmp/HLT/log_test_05.cj.out --test
[2023-07-11 14:13:47,711] [INFO] [Run CMD]cd tmp/HLT;./log_test_05.cj.out  
[2023-07-11 14:13:47,727] [INFO] [14:13:47 CST 2023/07/11] [ALL] (source) [message]
[2023-07-11 14:13:47,728] [INFO] [14:13:47 CST 2023/07/11] [ALL] (source) [message]
[2023-07-11 14:13:47,728] [INFO] enter default...
[2023-07-11 14:13:47,728] [INFO] --------------------------------------------------------------------------------------------------
[2023-07-11 14:13:47,728] [INFO] TP: test, time elapsed: 1148586 ns, Result:
[2023-07-11 14:13:47,728] [INFO] TCS: LogTestE, time elapsed: 1146589 ns, RESULT:
[2023-07-11 14:13:47,728] [INFO] [ PASSED ] CASE: log_test_050 (153910 ns)
[2023-07-11 14:13:47,728] [INFO] [ PASSED ] CASE: log_test_051 (69521 ns)
[2023-07-11 14:13:47,728] [INFO] [ PASSED ] CASE: log_test_052 (195121 ns)
[2023-07-11 14:13:47,728] [INFO] [ PASSED ] CASE: log_test_053 (125707 ns)
[2023-07-11 14:13:47,728] [INFO] [ PASSED ] CASE: log_test_054 (211736 ns)
[2023-07-11 14:13:47,728] [INFO] [ PASSED ] CASE: log_test_055 (379422 ns)
[2023-07-11 14:13:47,728] [INFO] Summary: TOTAL: 6
[2023-07-11 14:13:47,728] [INFO] PASSED: 6, SKIPPED: 0, ERROR: 0
[2023-07-11 14:13:47,728] [INFO] FAILED: 0
[2023-07-11 14:13:47,728] [INFO] --------------------------------------------------------------------------------------------------
line://3rd_party_lib:log4cj2/build/log4cj
[2023-07-11 14:13:47,729] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/log4cj']
line://3rd_party_lib:log4cj2/build/zip4cj
[2023-07-11 14:13:47,729] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/zip4cj']
line://3rd_party_lib:log4cj2/build/charset
[2023-07-11 14:13:47,729] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/charset']
[2023-07-11 14:13:47,730] [INFO] ************************Start to run case file: HLT/log_test_03.cj************************
[2023-07-11 14:13:47,730] [INFO] [Run CMD]cjc -O2   --import-path /home/helongfei/workspace/log4cj2/build/log4cj/.. -L /home/helongfei/workspace/log4cj2/build/log4cj -l log4cj_config -l log4cj_appender -l log4cj_logger -l log4cj_utils  --import-path /home/helongfei/workspace/log4cj2/build/zip4cj/.. -L /home/helongfei/workspace/log4cj2/build/zip4cj -l zip4cj_zip4cj.zip -l zip4cj_zip4cj.utils  --import-path /home/helongfei/workspace/log4cj2/build/charset/.. -L /home/helongfei/workspace/log4cj2/build/charset -l charset_charset.simplechinese -l charset_charset.korean -l charset_charset.japanese -l charset_charset.unicode -l charset_charset -l charset_charset.encoding -l charset_charset.singlebyte -l charset_charset.traditionchinese   HLT/log_test_03.cj  -o tmp/HLT/log_test_03.cj.out --test
[2023-07-11 14:13:58,435] [INFO] [Run CMD]cd tmp/HLT;./log_test_03.cj.out  
[2023-07-11 14:13:58,453] [INFO] --------------------------------------------------------------------------------------------------
[2023-07-11 14:13:58,453] [INFO] TP: test, time elapsed: 84771 ns, Result:
[2023-07-11 14:13:58,454] [INFO] TCS: LogTestC, time elapsed: 83421 ns, RESULT:
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_025 (10049 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_026 (2811 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_027 (2023 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_028 (10361 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_029 (2136 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_030 (2013 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_031 (2069 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_032 (3197 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_033 (4833 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_034 (3107 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_035 (1431 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_036 (4260 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_037 (2417 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_038 (2350 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_039 (2521 ns)
[2023-07-11 14:13:58,454] [INFO] [ PASSED ] CASE: log_test_040 (8583 ns)
[2023-07-11 14:13:58,455] [INFO] [ PASSED ] CASE: log_test_041 (2100 ns)
[2023-07-11 14:13:58,455] [INFO] Summary: TOTAL: 17
[2023-07-11 14:13:58,455] [INFO] PASSED: 17, SKIPPED: 0, ERROR: 0
[2023-07-11 14:13:58,455] [INFO] FAILED: 0
[2023-07-11 14:13:58,455] [INFO] --------------------------------------------------------------------------------------------------
line://3rd_party_lib:log4cj2/build/log4cj
[2023-07-11 14:13:58,455] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/log4cj']
line://3rd_party_lib:log4cj2/build/zip4cj
[2023-07-11 14:13:58,456] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/zip4cj']
line://3rd_party_lib:log4cj2/build/charset
[2023-07-11 14:13:58,456] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/charset']
[2023-07-11 14:13:58,456] [INFO] ************************Start to run case file: HLT/log_test_04.cj************************
[2023-07-11 14:13:58,456] [INFO] [Run CMD]cjc -O2   --import-path /home/helongfei/workspace/log4cj2/build/log4cj/.. -L /home/helongfei/workspace/log4cj2/build/log4cj -l log4cj_config -l log4cj_appender -l log4cj_logger -l log4cj_utils  --import-path /home/helongfei/workspace/log4cj2/build/zip4cj/.. -L /home/helongfei/workspace/log4cj2/build/zip4cj -l zip4cj_zip4cj.zip -l zip4cj_zip4cj.utils  --import-path /home/helongfei/workspace/log4cj2/build/charset/.. -L /home/helongfei/workspace/log4cj2/build/charset -l charset_charset.simplechinese -l charset_charset.korean -l charset_charset.japanese -l charset_charset.unicode -l charset_charset -l charset_charset.encoding -l charset_charset.singlebyte -l charset_charset.traditionchinese   HLT/log_test_04.cj  -o tmp/HLT/log_test_04.cj.out --test
[2023-07-11 14:14:06,257] [INFO] [Run CMD]cd tmp/HLT;./log_test_04.cj.out  
[2023-07-11 14:14:09,385] [INFO] [14:14:09 CST 2023/07/11 374] [ALL][logRecord_01] (source) message
[2023-07-11 14:14:09,385] [INFO] [14:14:09 CST 2023/07/11 374] [ALL][logRecord_01] (source) message
[2023-07-11 14:14:09,385] [INFO] [14:14:09 CST 2023/07/11] [ALL] (source) [message]
[2023-07-11 14:14:09,386] [INFO] [14:14:09 CST 2023/07/11] [ALL] (source) [message]
[2023-07-11 14:14:09,386] [INFO] --------------------------------------------------------------------------------------------------
[2023-07-11 14:14:09,386] [INFO] TP: test, time elapsed: 3108409798 ns, Result:
[2023-07-11 14:14:09,386] [INFO] TCS: LogTestD, time elapsed: 3108407645 ns, RESULT:
[2023-07-11 14:14:09,386] [INFO] [ PASSED ] CASE: log_test_042 (16816 ns)
[2023-07-11 14:14:09,386] [INFO] [ PASSED ] CASE: log_test_043 (92867 ns)
[2023-07-11 14:14:09,386] [INFO] [ PASSED ] CASE: log_test_044 (47435 ns)
[2023-07-11 14:14:09,386] [INFO] [ PASSED ] CASE: log_test_045 (9048 ns)
[2023-07-11 14:14:09,386] [INFO] [ PASSED ] CASE: log_test_046 (3108042385 ns)
[2023-07-11 14:14:09,386] [INFO] [SKIPPED ] CASE: log_test_047
[2023-07-11 14:14:09,386] [INFO] [SKIPPED ] CASE: log_test_048
[2023-07-11 14:14:09,386] [INFO] [ PASSED ] CASE: log_test_049 (151257 ns)
[2023-07-11 14:14:09,386] [INFO] [ PASSED ] CASE: log_test_050 (34507 ns)
[2023-07-11 14:14:09,386] [INFO] Summary: TOTAL: 9
[2023-07-11 14:14:09,386] [INFO] PASSED: 7, SKIPPED: 2, ERROR: 0
[2023-07-11 14:14:09,386] [INFO] FAILED: 0
[2023-07-11 14:14:09,386] [INFO] --------------------------------------------------------------------------------------------------
line://3rd_party_lib:log4cj2/build/log4cj
[2023-07-11 14:14:09,387] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/log4cj']
line://3rd_party_lib:log4cj2/build/zip4cj
[2023-07-11 14:14:09,387] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/zip4cj']
line://3rd_party_lib:log4cj2/build/charset
[2023-07-11 14:14:09,387] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/charset']
[2023-07-11 14:14:09,388] [INFO] ************************Start to run case file: HLT/log_test_02.cj************************
[2023-07-11 14:14:09,388] [INFO] [Run CMD]cjc -O2   --import-path /home/helongfei/workspace/log4cj2/build/log4cj/.. -L /home/helongfei/workspace/log4cj2/build/log4cj -l log4cj_config -l log4cj_appender -l log4cj_logger -l log4cj_utils  --import-path /home/helongfei/workspace/log4cj2/build/zip4cj/.. -L /home/helongfei/workspace/log4cj2/build/zip4cj -l zip4cj_zip4cj.zip -l zip4cj_zip4cj.utils  --import-path /home/helongfei/workspace/log4cj2/build/charset/.. -L /home/helongfei/workspace/log4cj2/build/charset -l charset_charset.simplechinese -l charset_charset.korean -l charset_charset.japanese -l charset_charset.unicode -l charset_charset -l charset_charset.encoding -l charset_charset.singlebyte -l charset_charset.traditionchinese   HLT/log_test_02.cj  -o tmp/HLT/log_test_02.cj.out --test
[2023-07-11 14:14:13,594] [INFO] [Run CMD]cd tmp/HLT;./log_test_02.cj.out  
[2023-07-11 14:14:13,611] [INFO] --------------------------------------------------------------------------------------------------
[2023-07-11 14:14:13,611] [INFO] TP: test, time elapsed: 77598 ns, Result:
[2023-07-11 14:14:13,611] [INFO] TCS: LogTestB, time elapsed: 75764 ns, RESULT:
[2023-07-11 14:14:13,611] [INFO] [ PASSED ] CASE: log_test_008 (14780 ns)
[2023-07-11 14:14:13,611] [INFO] [ PASSED ] CASE: log_test_009 (3512 ns)
[2023-07-11 14:14:13,611] [INFO] [ PASSED ] CASE: log_test_010 (15074 ns)
[2023-07-11 14:14:13,611] [INFO] [ PASSED ] CASE: log_test_011 (2862 ns)
[2023-07-11 14:14:13,611] [INFO] [ PASSED ] CASE: log_test_012 (8232 ns)
[2023-07-11 14:14:13,611] [INFO] [ PASSED ] CASE: log_test_013 (2758 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_014 (1141 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_015 (1308 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_016 (1128 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_017 (1444 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_018 (1291 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_019 (2042 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_020 (794 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_021 (777 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_022 (706 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_023 (1227 ns)
[2023-07-11 14:14:13,612] [INFO] [ PASSED ] CASE: log_test_024 (1049 ns)
[2023-07-11 14:14:13,612] [INFO] Summary: TOTAL: 17
[2023-07-11 14:14:13,612] [INFO] PASSED: 17, SKIPPED: 0, ERROR: 0
[2023-07-11 14:14:13,613] [INFO] FAILED: 0
[2023-07-11 14:14:13,613] [INFO] --------------------------------------------------------------------------------------------------
[2023-07-11 14:14:13,626] [INFO] **************************************************
[2023-07-11 14:14:13,626] [INFO] Test Summary
[2023-07-11 14:14:13,626] [INFO] Total  : 56
[2023-07-11 14:14:13,626] [INFO] Passed : 54
[2023-07-11 14:14:13,626] [INFO] Failed : 0
[2023-07-11 14:14:13,626] [INFO] Error  : 0
[2023-07-11 14:14:13,626] [INFO] Skipped: 2
[2023-07-11 14:14:13,626] [INFO] Ratio  : 100.0%
[2023-07-11 14:14:13,626] [INFO] **************************************************
[2023-07-11 14:14:13,627] [INFO] Skipped listed below:
[2023-07-11 14:14:13,627] [INFO] HLT.log_test_04.LogTestD.log_test_047
[2023-07-11 14:14:13,627] [INFO] HLT.log_test_04.LogTestD.log_test_048
[2023-07-11 14:14:13,627] [INFO] **************************************************
[2023-07-11 14:14:13,627] [INFO] View the full log in log/all.log, or view the log of each case under log/split_log
```

### 运行单个用例结果样例

```cangjie
helongfei@test-zhangxiaoyang://home/helongfei/workspace/log4cj2/test$ cjtest HLT/log_test_01.cj 
line://3rd_party_lib:log4cj2/build/log4cj
[2023-07-11 14:24:38,933] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/log4cj']
line://3rd_party_lib:log4cj2/build/zip4cj
[2023-07-11 14:24:38,933] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/zip4cj']
line://3rd_party_lib:log4cj2/build/charset
[2023-07-11 14:24:38,934] [INFO] find 3rd party libs in ['/home/helongfei/workspace/log4cj2/build/charset']
[2023-07-11 14:24:38,934] [INFO] ************************Start to run case file: HLT/log_test_01.cj************************
[2023-07-11 14:24:38,935] [INFO] [Run CMD]cjc -O2   --import-path /home/helongfei/workspace/log4cj2/build/log4cj/.. -L /home/helongfei/workspace/log4cj2/build/log4cj -l log4cj_config -l log4cj_appender -l log4cj_logger -l log4cj_utils  --import-path /home/helongfei/workspace/log4cj2/build/zip4cj/.. -L /home/helongfei/workspace/log4cj2/build/zip4cj -l zip4cj_zip4cj.zip -l zip4cj_zip4cj.utils  --import-path /home/helongfei/workspace/log4cj2/build/charset/.. -L /home/helongfei/workspace/log4cj2/build/charset -l charset_charset.simplechinese -l charset_charset.korean -l charset_charset.japanese -l charset_charset.unicode -l charset_charset -l charset_charset.encoding -l charset_charset.singlebyte -l charset_charset.traditionchinese   HLT/log_test_01.cj  -o tmp/HLT/log_test_01.cj.out --test
[2023-07-11 14:24:41,181] [INFO] [Run CMD]cd tmp/HLT;./log_test_01.cj.out  
[2023-07-11 14:24:41,197] [INFO] enter default...
[2023-07-11 14:24:41,198] [INFO] 
[2023-07-11 14:24:41,198] [INFO] [2023/07/11 14:24:41 CST 190] [ALL] [logRecord_02] (source) message
[2023-07-11 14:24:41,198] [INFO] 
[2023-07-11 14:24:41,198] [INFO] 
[2023-07-11 14:24:41,198] [INFO] 2023/07/11 14:24:41 CST 190 ALL logRecord_02 source message
[2023-07-11 14:24:41,198] [INFO] 
[2023-07-11 14:24:41,198] [INFO] +++++2023/07/11 14:24:41 CST55 190+-- ##ALL#$ logRecord_02 (source) message
[2023-07-11 14:24:41,198] [INFO] 
[2023-07-11 14:24:41,198] [INFO] [2023/07/11 14:24:41 CST 190] [TRACE] [] ()
[2023-07-11 14:24:41,198] [INFO] 
[2023-07-11 14:24:41,198] [INFO] [2023/07/11 14:24:41 CST 190] [DEBUG] [@#$^,;[^&^%**(] (_+(^^&/\@$@&) %^&*' '&(*@#
[2023-07-11 14:24:41,198] [INFO] 
[2023-07-11 14:24:41,198] [INFO] --------------------------------------------------------------------------------------------------
[2023-07-11 14:24:41,198] [INFO] TP: test, time elapsed: 309691 ns, Result:
[2023-07-11 14:24:41,198] [INFO] TCS: LogTestA, time elapsed: 307865 ns, RESULT:
[2023-07-11 14:24:41,198] [INFO] [ PASSED ] CASE: log_test_001 (25973 ns)
[2023-07-11 14:24:41,199] [INFO] [ PASSED ] CASE: log_test_002 (17959 ns)
[2023-07-11 14:24:41,199] [INFO] [ PASSED ] CASE: log_test_003 (180057 ns)
[2023-07-11 14:24:41,199] [INFO] [ PASSED ] CASE: log_test_004 (11569 ns)
[2023-07-11 14:24:41,199] [INFO] [ PASSED ] CASE: log_test_005 (14248 ns)
[2023-07-11 14:24:41,199] [INFO] [ PASSED ] CASE: log_test_006 (29315 ns)
[2023-07-11 14:24:41,199] [INFO] [ PASSED ] CASE: log_test_007 (15873 ns)
[2023-07-11 14:24:41,199] [INFO] Summary: TOTAL: 7
[2023-07-11 14:24:41,199] [INFO] PASSED: 7, SKIPPED: 0, ERROR: 0
[2023-07-11 14:24:41,199] [INFO] FAILED: 0
[2023-07-11 14:24:41,199] [INFO] --------------------------------------------------------------------------------------------------
[2023-07-11 14:24:41,203] [INFO] **************************************************
[2023-07-11 14:24:41,203] [INFO] Test Summary
[2023-07-11 14:24:41,203] [INFO] Total  : 7
[2023-07-11 14:24:41,204] [INFO] Passed : 7
[2023-07-11 14:24:41,204] [INFO] Failed : 0
[2023-07-11 14:24:41,204] [INFO] Error  : 0
[2023-07-11 14:24:41,204] [INFO] Skipped: 0
[2023-07-11 14:24:41,204] [INFO] Ratio  : 100.0%
[2023-07-11 14:24:41,204] [INFO] **************************************************
[2023-07-11 14:24:41,204] [INFO] View the full log in log/all.log, or view the log of each case under log/split_log
```