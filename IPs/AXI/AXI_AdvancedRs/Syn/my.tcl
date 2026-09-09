#/******************************************************************************/
#/*    Variable Definition                                                     */
#/******************************************************************************/
#/*--========================================================================--*/
#/*    In case of initial synthesis, define these variables.                   */
#/*    These variables are to prohibit reading and writing of caches.          */
#/*    Merit: Turn around time for logic synthesis can be reduced.             */
#/*    Demerit: Better result of re-synthesis may not be achieved.             */
#/*--========================================================================--*/
set cache_read {}
set cache_write {}

set hdlin_enable_presto false

#/*--========================================================================--*/
#/*    Define a top module name variable.                                      */
#/*--========================================================================--*/
set TopDesign SBUS

#/*--========================================================================--*/
#/*    Define directory variables                                              */
#/*    to save log files, db files, and report files.                          */
#/*--========================================================================--*/
set LogDir ./log
set DbDir ./db
set RptDir ./rpt
set NetDir ./Netlist

#/*--========================================================================--*/
#/*    Make directories if no directory.                                       */
#/*--========================================================================--*/
set dc_shell_status [ which $LogDir ]
if {  $dc_shell_status == [list] } {
   sh mkdir $LogDir
}

set dc_shell_status [ which $DbDir ]
if {  $dc_shell_status == [list] } {
   sh mkdir $DbDir
}

set dc_shell_status [ which $RptDir ]
if {  $dc_shell_status == [list] } {
   sh mkdir $RptDir
}

set dc_shell_status [ which $NetDir ]
if {  $dc_shell_status == [list] } {
   sh mkdir $NetDir
}

#/*--========================================================================--*/
#/*    Read design.                                                            */
#/*--========================================================================--*/
source ./ReadDesign.scr

link

write -f db -h -o [format "%s/$TopDesign.GTECH.db" $DbDir]

check_design > [format "%s/check_design.GTECH.log" $RptDir]

uniquify

write -f db -h -o [format "%s/$TopDesign.GTECH.Uniq.db" $DbDir]

#/*--========================================================================--*/
#/*    Apply Constraint.                                                       */
#/*--========================================================================--*/
#source ./dont_touch_net.tcl
source ./constraints_template.tcl

#/*--========================================================================--*/
#/*    First Compile With Low Effort.                                          */
#/*--========================================================================--*/
compile -map_effort low -area_effort none -no_design_rule

current_design $TopDesign

#write -f db -h -o [format "%s/$TopDesign.FirstCom.db" $DbDir]
#/*--========================================================================--*/
#/*    Apply UnGroup DesignWare.                                               */
#/*--========================================================================--*/

source ./UngroupDW.tcl
current_design $TopDesign

#write -f db -h -o [format "%s/$TopDesign.FirstCom.UngDW.db" $DbDir]
#/*--========================================================================--*/
#/*    Compile With High Effort.                                               */
#/*--========================================================================--*/
compile -inc -map_effort high -area_effort none
current_design $TopDesign

### Remove BackSlash
source rmbs.tcl
tsmc_naming_rule

#write -f db -h -o [format "%s/$TopDesign.noscan.db" $DbDir]
write -f verilog -h -o [format "%s/$TopDesign.noscan.v" $NetDir]

#/*--========================================================================--*/
#/*    Compile With Scan High Effort.                                          */
#/*--========================================================================--*/
#compile -inc -map_effort high -area_effort none -scan

#current_design $TopDesign

#source rmbs.tcl
#tsmc_naming_rule

##write -f db -h -o [format "%s/$TopDesign.scan.db" $DbDir]
#write -f verilog -h -o [format "%s/$TopDesign.scan.v" $NetDir]

#--==========================================================================--#
#     Check timing constraints of design.                                      #
#--==========================================================================--#
check_timing > [format "%s/$TopDesign.check_timing.worst.rpt" $RptDir]

#--==========================================================================--#
#     Report exceptions of design.                                             #
#--==========================================================================--#
report_disable_timing > [format "%s/$TopDesign.disable_timing.worst.rpt" $RptDir]

#--==========================================================================--#
#     Report timing paths with setup or hold violation.                        #
#--==========================================================================--#
report_timing -delay max -tran -max_paths 32 -nworst 20 -nosplit \
 > [format "%s/$TopDesign.report_timing.worst.rpt" $RptDir]

#--==========================================================================--#
#     Report all timing paths with timing violation.                           #
#--==========================================================================--#
report_timing -delay min_max -slack_lesser 0 -max_paths 10000 -nworst 1000 \
 -nosplit -input -net -tran -cap > [format "%s/worst.lesser_than0.rpt" $RptDir]

#--==========================================================================--#
#     Report all violations of design.                                         #
#--==========================================================================--#
report_constraints -all_viol \
 > [format "%s/$TopDesign.all_violations.verbose.worst.rpt" $RptDir]

write_sdc SBUS.sdc
#/******************************************************************************/
#/*    Exit Design Compiler.                                                   */
#/******************************************************************************/
quit
