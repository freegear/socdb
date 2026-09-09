setPreference -pref UserLevel:NOVICE
setPreference -pref MessageLevel:DETAILED
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref ConfigOnFailure:STOP
setPreference -pref StartupCLock:AUTO_CORRECTION
setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref svfUseTime:FALSE
setPreference -pref UserLevel:NOVICE
setPreference -pref MessageLevel:DETAILED
setPreference -pref ConcurrentMode:FALSE
setPreference -pref UseHighz:FALSE
setPreference -pref ConfigOnFailure:STOP
setPreference -pref StartupCLock:AUTO_CORRECTION
setPreference -pref AutoSignature:FALSE
setPreference -pref KeepSVF:FALSE
setPreference -pref svfUseTime:FALSE
setMode -bs
setPreference -pref UserLevel:Novice
setMode -pff
setMode -mpm
setMode -cf
addConfigDevice -size 402653184 -name "XCCACE-AUTO" -path "d:\project\uwb\atk_d\etri_uwb\2007524\xilinx"
setAttribute -configdevice -attr size -value "402653184"
setAttribute -configdevice -attr reseveSize -value "0"
setAttribute -configdevice -attr activeCollection -value "UWB_AHBS"
addCollection -name "UWB_AHBS"
addDesign -version 0 -name "rev0"
addDeviceChain -index 0
addDevice -position 1 -file "D:\Project\UWB\ATK_D\ETRI_UWB\2007524\xilinx\etri_uwbfpga.bit"

addDevice -position 2 -file "D:\Project\UWB\ATK_D\ETRI_UWB\2007524\xilinx1\fpga1.bit"

setMode -dtconfig
setMode -bsfile
setMode -sm
setMode -ss
setMode -bs
setMode -cf
setMode -bs
setMode -ss
setMode -sm
setMode -bsfile
setMode -dtconfig
setMode -cf
setCurrentDeviceChain -index 0
setMode -mpm
setMode -pff
setMode -cf
setAttribute -configdevice -attr path -value "d:\project\uwb\atk_d\etri_uwb\2007524\xilinx"
setMode -cf
generate -active UWB_AHBS
setMode -pff
setMode -sm
setMode -cf
setMode -bs
setMode -ss
setMode -sm
setMode -bsfile
setMode -dtconfig
setMode -cf
setMode -mpm
setMode -pff
setMode -cf
setMode -cf
