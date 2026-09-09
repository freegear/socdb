setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "USB_CON" -path "E:\ENCODER\USC_CONNECTION\USB_CONNECTION\"
addCollection -name "USB_CON"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "USB_CON"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "USB_CON"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "E:\ENCODER\USC_CONNECTION\USB_CONNECTION\/USB_CON"
addCollection -name "USB_CON"
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
addDevice -p 1 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIERTEX_SKIP_FILE/xc4vlx200_ff1513.bsd"
addDevice -p 2 -file "E:/ENCODER/USC_CONNECTION/USB_CONNECTION/usb_20.bit"
setAttribute -configdevice -attr path -value "E:\ENCODER\USC_CONNECTION\USB_CONNECTION\/"
generate -active USB_CON
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "E:/ENCODER/USC_CONNECTION/USB_CONNECTION/usb_20.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "E:\ENCODER\USC_CONNECTION\USB_CONNECTION\/"
generate -active USB_CON
saveProjectFile -file "E:/ENCODER/USC_CONNECTION/USB_CONNECTION/USB_CONNECTION.ipf"
