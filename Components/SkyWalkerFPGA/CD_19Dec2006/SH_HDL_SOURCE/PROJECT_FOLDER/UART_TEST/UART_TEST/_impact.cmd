setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
loadProjectFile -file "D:/SANG_WHA/PROJECT_FOLDER/UART_TEST/UART_TEST/UART_TEST.ipf"
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
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
cutDevice -p 2
addDevice -p 2 -file "D:/SANG_WHA/PROJECT_FOLDER/UART_TEST/UART_TEST/uart_test.bit"
setAttribute -configdevice -attr path -value "D:\UART_TEST\UART_TEST\/"
generate -active UART_TX
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
saveProjectFile -file "D:/SANG_WHA/PROJECT_FOLDER/UART_TEST/UART_TEST/UART_TEST.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setCurrentCollection -collection "UART_TX"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
deleteDevice -position 1
deleteDevice -position 1
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
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
setMode -acempm
setMode -pff
setMode -acecf
setMode -acecf
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "UART_LOP" -path "D:\SANG_WHA\PROJECT_FOLDER\UART_TEST\UART_TEST\"
addCollection -name "UART_LOP"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setCurrentDesign -version 0
setCurrentCollection -collection "UART_LOP"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "UART_LOP"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "D:\SANG_WHA\PROJECT_FOLDER\UART_TEST\UART_TEST\/UART_LOP"
addCollection -name "UART_LOP"
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
addDevice -p 1 -file "D:/SANG_WHA/U51_LED_TEST/led_test.bit"
addDevice -p 2 -file "D:/SANG_WHA/PROJECT_FOLDER/UART_TEST/UART_TEST/uart_test.bit"
setAttribute -configdevice -attr path -value "D:\SANG_WHA\PROJECT_FOLDER\UART_TEST\UART_TEST\/"
generate -active UART_LOP
saveProjectFile -file "D:\SANG_WHA\PROJECT_FOLDER\UART_TEST\UART_TEST\default.ipf"
