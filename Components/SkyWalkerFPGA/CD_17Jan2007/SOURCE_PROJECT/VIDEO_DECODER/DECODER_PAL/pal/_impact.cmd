setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
loadProjectFile -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIDEO_DECODER/DECODER_PAL/pal/pal.ipf"
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
setCurrentCollection -collection "ntsc"
setCurrentDesign -version 0
setMode -acecf
setCurrentDeviceChain -index 0
setCurrentCollection -collection "ntsc"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
cutDevice -p 1
addDevice -p 1 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/NONE_VIERTEX/xc4vlx200_ff1513.bsd"
addDevice -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIDEO_DECODER/DECODER_PAL/pal/i2c_av_config.bit"
setAttribute -configdevice -attr path -value "E:\GAGA\pal\pal\/"
generate -active ntsc
saveProjectFile -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIDEO_DECODER/DECODER_PAL/pal/pal.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setCurrentCollection -collection "ntsc"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
deleteDevice -position 1
deleteDevice -position 1
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "ntsc"
setAttribute -configdevice -attr size -value "0"
setMode -acecf
setMode -acempm
setMode -pff
setMode -acecf
setAttribute -configdevice -attr size -value "0"
setMode -acecf
addConfigDevice  -name "PAL" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\VIDEO_DECODER\DECODER_PAL\pal\"
addCollection -name "PAL"
addDesign -version 0 -name "rev0"
setCurrentDesign -version 0
setMode -acecf
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setCurrentDesign -version 0
setCurrentCollection -collection "PAL"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
deleteCollection -name "PAL"
setAttribute -configdevice -attr size -value "128000000"
setMode -acecf
addConfigDevice -size 128000000 -name "XCACECF" -path "E:\RTL_COMPLETE\SOURCE_PROJECT\VIDEO_DECODER\DECODER_PAL\pal\/PAL"
addCollection -name "PAL"
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
addDevice -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIDEO_DECODER/DECODER_PAL/pal/i2c_av_config.bit"
setAttribute -configdevice -attr path -value "E:\RTL_COMPLETE\SOURCE_PROJECT\VIDEO_DECODER\DECODER_PAL\pal\/"
generate -active PAL
saveProjectFile -file "E:\RTL_COMPLETE\SOURCE_PROJECT\VIDEO_DECODER\DECODER_PAL\pal\default.ipf"
