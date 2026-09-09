setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
loadProjectFile -file "E:/RTL_COMPLETE/SOURCE_PROJECT/2CH_UART/UART_TEST/UART_TEST.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acempm
setMode -pff
setMode -acecf
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
setCurrentCollection -collection "UART_TX"
setCurrentDesign -version 0
setMode -acecf
setCurrentDeviceChain -index 0
setCurrentCollection -collection "UART_TX"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
saveProjectFile -file "E:/RTL_COMPLETE/SOURCE_PROJECT/2CH_UART/UART_TEST/UART_TEST.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setCurrentCollection -collection "UART_TX"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "UART_TX"
setAttribute -configdevice -attr size -value "0"
setMode -acecf
setMode -acempm
setMode -pff
setMode -acecf
setMode -acecf
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "LOOP_TES" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\2CH_UART\UART_TEST\"
addCollection -name "LOOP_TES"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setCurrentDesign -version 0
setCurrentCollection -collection "LOOP_TES"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "LOOP_TES"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\2CH_UART\UART_TEST\/LOOP_TES"
addCollection -name "LOOP_TES"
setMode -acecf
setAttribute -configdevice -attr size -value "generaic"
setAttribute -configdevice -attr reserveSize -value "0"
setAttribute -configdevice -attr name -value "XCCACE-AUTO"
addDesign -version 0 -name "rev0"
setMode -acecf
addDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
addDevice -p 1 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/NONE_VIERTEX/xc4vlx200_ff1513.bsd"
addDevice -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/2CH_UART/UART_TEST/uart_test.bit"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\2CH_UART\UART_TEST\/"
generate -active LOOP_TES
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/2CH_UART/UART_TEST/uart_test.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
saveProjectFile -file "E:\RTL_COMPLETE\SOURCE_PROJECT\2CH_UART\UART_TEST\default.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setCurrentCollection -collection "LOOP_TES"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
deleteDevice -position 1
deleteDevice -position 1
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "LOOP_TES"
setAttribute -configdevice -attr size -value "0"
setMode -acecf
setMode -acempm
setMode -pff
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "LOOP_2CH" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\2CH_UART\UART_TEST\"
addCollection -name "LOOP_2CH"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setCurrentDesign -version 0
setCurrentCollection -collection "LOOP_2CH"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "LOOP_2CH"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\2CH_UART\UART_TEST\/LOOP_2CH"
addCollection -name "LOOP_2CH"
setMode -acecf
setAttribute -configdevice -attr size -value "generaic"
setAttribute -configdevice -attr reserveSize -value "0"
setAttribute -configdevice -attr name -value "XCCACE-AUTO"
addDesign -version 0 -name "rev0"
setMode -acecf
addDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
addDevice -p 1 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/NONE_VIERTEX/xc4vlx200_ff1513.bsd"
addDevice -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/2CH_UART/UART_TEST/uart_test.bit"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\2CH_UART\UART_TEST\/"
generate -active LOOP_2CH
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/2CH_UART/UART_TEST/uart_test.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\2CH_UART\UART_TEST\/"
generate -active LOOP_2CH
saveProjectFile -file "E:\RTL_COMPLETE\SOURCE_PROJECT\2CH_UART\UART_TEST\default.ipf"
