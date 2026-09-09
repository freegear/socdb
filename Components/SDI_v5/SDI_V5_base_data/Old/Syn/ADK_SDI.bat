dc_shell <<! | tee ./Log/ADK_Syn.log

/************ Watchdog ************************************************************/
analyze -f verilog /user/jys/Twin_ARM/ARM_ADK_REL1v1/design/global_ADK/verilog/RevAnd.v
analyze -f verilog WdogPackage.v
analyze -f verilog WdogFrc.v
analyze -f verilog Watchdog.v

elaborate Watchdog
current_design Watchdog
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/Watchdogn_Area.txt
report_power > ./POWER/Watchdogn_Power.txt
write -f db -hier -out ./DB/Watchdog.TSMC_013.db

/************ RemapPause ************************************************************/
read -f verilog /user/jys/Twin_ARM/ARM_ADK_REL1v1/design/global_ADK/verilog/RevAnd.v
read -f verilog RemapPause.v
elaborate RemapPause
current_design RemapPause
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/RemapPause_Area.txt
report_power > ./POWER/RemapPause_Power.txt
write -f db -hier -out ./DB/RemapPause.TSMC_013.db

/************ Arbiter3 ************************************************************/
analyze -f verilog  ArbSchm3.v
analyze -f verilog  Arbiter3.v
elaborate Arbiter3
current_design Arbiter3
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/Arbiter3_Area.txt
report_power > ./POWER/Arbiter3_Power.txt
write -f db -hier -out ./DB/Arbiter3.TSMC_013.db

/************ DefaultSlave ************************************************************/
analyze -f verilog  DefaultSlave.v
elaborate DefaultSlave
current_design DefaultSlave
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/DefaultSlave_Area.txt
report_power > ./POWER/DefaultSlave_Power.txt
write -f db -hier -out ./DB/DefaultSlave.TSMC_013.db

/************ MuxM2S ************************************************************/
analyze -f verilog  MuxM2S.v
elaborate MuxM2S
current_design MuxM2S
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/MuxM2S_Area.txt
report_power > ./POWER/MuxM2S_Power.txt
write -f db -hier -out ./DB/MuxM2S.TSMC_013.db


/************ MuxS2M ************************************************************/
analyze -f verilog  MuxS2M.v
elaborate MuxS2M
current_design MuxS2M
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/MuxS2M_Area.txt
report_power > ./POWER/MuxS2M_Power.txt
write -f db -hier -out ./DB/MuxS2M.TSMC_013.db

/*********** Decoder ************************************************************/
analyze -f verilog  Decoder.v
elaborate Decoder
current_design Decoder
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/Decoder_Area.txt
report_power > ./POWER/Decoder_Power.txt
write -f db -hier -out ./DB/Decoder.TSMC_013.db

/************ TIC ************************************************************/
analyze -f verilog  TIC.v
elaborate TIC
current_design TIC
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/TIC_Area.txt
report_power > ./POWER/TIC_Power.txt
write -f db -hier -out ./DB/TIC.TSMC_013.db

/************ ResetCntl ************************************************************/
analyze -f verilog  ResetCntl.v
elaborate ResetCntl
current_design ResetCntl
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/ResetCntl_Area.txt
report_power > ./POWER/ResetCntl_Power.txt
write -f db -hier -out ./DB/ResetCntl.TSMC_013.db

/************ A7TWrap.v ************************************************************/
analyze -f verilog /user/jys/Twin_ARM/ARM_ADK_REL1v1/design/global_ADK/verilog/ClockNand.v
analyze -f verilog /user/jys/Twin_ARM/ARM_ADK_REL1v1/design/global_ADK/verilog/ClockInv.v
analyze -f verilog /user/jys/Twin_ARM/ARM_ADK_REL1v1/design/global_ADK/verilog/LATS.v
/* Not Synthesis */
/*analyze -f verilog   A7TWrapCtrl.v
analyze -f verilog   A7TWrapTest.v
analyze -f verilog   A7WrapMaster.v
analyze -f verilog   A7WrapSM.v
analyze -f verilog   A7TWrap.v
analyze -f verilog   A7TDMI.v */


/************ Lite2AHB ************************************************************/
analyze -f verilog Lite2AHB.v
elaborate Lite2AHB
current_design Lite2AHB
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/Lite2AHB_Area.txt
report_power > ./POWER/Lite2AHB_Power.txt
write -f db -hier -out ./DB/Lite2AHB.TSMC_013.db


/************ APBif ************************************************************/
analyze -f verilog APBif.v
elaborate APBif
current_design APBif
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/APBif_Area.txt
report_power > ./POWER/APBif_Power.txt
write -f db -hier -out ./DB/APBif.TSMC_013.db


/************ MuxP2B ************************************************************/
analyze -f verilog MuxP2B.v
elaborate MuxP2B
current_design MuxP2B
link
compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/MuxP2B_Area.txt
report_power > ./POWER/MuxP2B_Power.txt
write -f db -hier -out ./DB/MuxP2B.TSMC_013.db

/************ Timers ************************************************************/
analyze -f verilog /user/jys/Twin_ARM/ARM_ADK_REL1v1/design/global_ADK/verilog/RevAnd.v
analyze -f verilog TimersPackage.v
/* Not Synthesis */
analyze -f verilog TimersFrc.v
analyze -f verilog Timers.v
elaborate Timers
current_design Timers
link

compile -map_effort medium
ungroup -all
compile -map_effort medium
ungroup -all
report_area > ./AREA/Timers_Area.txt
report_power > ./POWER/Timers_Power.txt
write -f db -hier -out ./DB/Timers.TSMC_013.db


exit
!

