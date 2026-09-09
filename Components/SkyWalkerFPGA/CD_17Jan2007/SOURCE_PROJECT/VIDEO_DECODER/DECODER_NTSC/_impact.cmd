setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "DECODER" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\VIDEO_DECODER\DECODER_NTSC\"
addCollection -name "DECODER"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setMode -acecf
setCurrentDesign -version 0
setCurrentCollection -collection "DECODER"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "DECODER"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\VIDEO_DECODER\DECODER_NTSC\/DECODER"
addCollection -name "DECODER"
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
addDevice -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIDEO_DECODER/DECODER_NTSC/i2c_av_config.bit"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\VIDEO_DECODER\DECODER_NTSC\/"
generate -active DECODER
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
saveProjectFile -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIDEO_DECODER/DECODER_NTSC/GAGA.ipf"
