setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref svfUseTime:FALSE
loadProjectFile -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIDEO_ENCODER/ENCODER/ENCODER.ipf"
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
setCurrentCollection -collection "ENCODER"
setCurrentDesign -version 0
setMode -acecf
setCurrentDeviceChain -index 0
setCurrentCollection -collection "ENCODER"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 1 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIERTEX_SKIP_FILE/xc4vlx200_ff1513.bsd"
setAttribute -position 1 -attr devicePartName -value "xc4vlx200"
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIDEO_ENCODER/ENCODER/encoder.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "E:\ENCODER\ENCODER\/"
generate -active ENCODER
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
assignFile -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIDEO_ENCODER/ENCODER/encoder.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "E:\ENCODER\ENCODER\/"
generate -active ENCODER
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
assignFile -p 2 -file "E:/RTL_COMPLETE/SOURCE_PROJECT/VIDEO_ENCODER/ENCODER/encoder.bit"
setAttribute -position 2 -attr devicePartName -value "xc4vlx200"
setAttribute -configdevice -attr path -value "E:\ENCODER\ENCODER\/"
generate -active ENCODER
