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
set TopDesign SDRTop

read_verilog  ./Net/SDRTop.noscan.v

#/*--========================================================================--*/
#/*    Set current design to a top module.                                     */
#/*--========================================================================--*/
current_design $TopDesign

#set_ideal_network [list uDTSDI002Top/uResetCntl/WRSTBUF/Y]

current_design $TopDesign

write_sdf -context verilog -version 2.1 ./Sdf/temp.sdf

#/******************************************************************************/
#/*    Exit Design Compiler.                                                   */
#/******************************************************************************/
quit
