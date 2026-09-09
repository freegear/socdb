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
setMode -cf
setMode -cf
setAttribute -configdevice -attr path -value "d:\etri_uwb\adk_pci_test\xilinx"
setMode -cf
setAttribute -configdevice -attr size -value "402653184"
setAttribute -configdevice -attr reseveSize -value "0"
setAttribute -configdevice -attr name -value "XCCACE-AUTO"
addCollection -name "adk1"
addDesign -version 0 -name "rev0"
addDeviceChain -index 0
setCurrentDesign -version 0
addDevice -position 1 -file "D:\ETRI_UWB\adk_pci_test\xilinx\etri_uwbfpga.bit"
addDevice -position 2 -file "D:\ETRI_UWB\adk_pci_test\xilinx1\fpga1.bit"
setAttribute -configdevice -attr path -value "d:\etri_uwb\adk_pci_test\xilinx"
setMode -cf
generate -active adk1
