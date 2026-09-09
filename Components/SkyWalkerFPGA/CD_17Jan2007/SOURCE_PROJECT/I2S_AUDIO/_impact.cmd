setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "I2S_AUD" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\I2S_AUDIO\"
addCollection -name "I2S_AUD"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "I2S_AUD"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "I2S_AUD"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\I2S_AUDIO\/I2S_AUD"
addCollection -name "I2S_AUD"
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
addDevice -p 1 -file "D:/Xilinx/virtex4/data/xc4vlx200_ff1513.bsd"
addDevice -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/I2S_AUDIO/audio.bit"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\I2S_AUDIO\/"
generate -active I2S_AUD
saveProjectFile -file "E:/RTL_COMPLETE/SOURCE_PROJECT/I2S_AUDIO/I2S_AUDIO.ipf"
