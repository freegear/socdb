#
# Written by : Transcript, Version V-2004.06 -- May 21, 2004
# Date       : Fri Mar 10 10:21:35 2006
#

#
# Translation of script: Sdf.dcsh
#

#/******************************************************************************/
#/*    Variable Definition                                                     */
#/******************************************************************************/
set TopDesign TimerPWM

read_verilog  ./Netlist/TimerPWM.noscan.v
#read_verilog  ../Scan/SCAN_DB/DTSDI002.scan.v
#/*--========================================================================--*/
#/*    Set current design to a top module.                                     */
#/*--========================================================================--*/
current_design $TopDesign

write_sdf ./sdf/TimerPWM.noscan.sdf
#write_sdf ./sdf/DTSDI002.scan.sdf
#/******************************************************************************/
#/*    Exit Design Compiler.                                                   */
#/******************************************************************************/
quit
