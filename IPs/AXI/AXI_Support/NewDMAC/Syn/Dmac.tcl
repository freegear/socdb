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
set TopDesign DmacFifo

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

current_design $TopDesign

link

write -f db -h -o [format "%s/$TopDesign.GTECH.db" $DbDir]

check_design > [format "%s/check_design.GTECH.log" $RptDir]

uniquify

write -f db -h -o [format "%s/$TopDesign.GTECH.Uniq.db" $DbDir]

#/*--========================================================================--*/
#/*    Apply Constraint.                                                       */
#/*--========================================================================--*/
source ./dont_touch_net.tcl
#source ./constraints_template.tcl

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

#/******************************************************************************/
#/*    Report about your design.                                               */
#/******************************************************************************/
#/*--========================================================================--*/
#/*    Report quality of results.                                              */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".qor.rpt"] { report_qor }

#/*--========================================================================--*/
#/*    Report area of design.                                                  */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".area.rpt"] { report_area }

#/*--========================================================================--*/
#/*    Report high fan-out nets of design.                                     */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".high_fanout.rpt"] { report_net_fanout -threshold 17 }

#/*--========================================================================--*/
#/*    Report all violations of design.                                        */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".all_viol.rpt"] { report_constraint -all_violators }

#/*--========================================================================--*/
#/*    Report all violation paths of design.                                   */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".all_viol.verbose.rpt"] { report_constraint -all_violators -verbose }

#/*--========================================================================--*/
#/*    Report timing paths with setup violation.                               */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".max.rpt"] { report_timing -tran -cap -net -input -nworst 10 }

#/*--========================================================================--*/
#/*    Report timing paths with hold violation.                                */
#/*--========================================================================--*/
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".min.rpt"] { report_timing -delay min -tran -cap -net -input -nworst 10 }

write_sdc $TopDesign.sdc
#/******************************************************************************/
#/*    Exit Design Compiler.                                                   */
#/******************************************************************************/
quit
