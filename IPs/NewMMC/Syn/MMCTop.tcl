#--****************************************************************************--
#--    Variable Definition                                                     --
#--****************************************************************************--
#----========================================================================----
#--    In case of initial synthesis, define these variables.                   --
#--    These variables are to prohibit reading and writing of caches.          --
#--    Merit: Turn around time for logic synthesis can be reduced.             --
#--    Demerit: Better result of re-synthesis may not be achieved.             --
#----========================================================================----
set cache_read {}
set cache_write {}

set hdlin_enable_presto false

#----========================================================================----
#--    Define a top module name variable.                                      --
#----========================================================================----
set TopDesign MMCTop

#----========================================================================----
#--    Define directory variables                                              --
#--    to save log files, db files, and report files.                          --
#----========================================================================----
set TclDir ./Tcl
set LogDir ./Log
set DbDir  ./DB
set RptDir ./Rpt
set NetDir ./Net
set SdfDir ./Sdf
set WorkDir ./Work

#----========================================================================----
#--    Make directories if no directory.                                       --
#----========================================================================----
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

set dc_shell_status [ which $SdfDir ]
if {  $dc_shell_status == [list] } {
   sh mkdir $SdfDir
}

set dc_shell_status [ which $WorkDir ]
if {  $dc_shell_status == [list] } {
   sh mkdir $WorkDir
}
#----========================================================================----
#--    Read design.                                                            --
#----========================================================================----
source -echo -verbose $TclDir/ImportDesign.tcl

link

check_design > [format "%s/$TopDesign.check_design.GTECH.log" $RptDir]

uniquify

#----========================================================================----
#--    Apply Constraint.                                                       --
#----========================================================================----
source -echo -verbose $TclDir/Function.tcl
source -echo -verbose $TclDir/ConstraintTemplate.tcl

#----========================================================================----
#--    First Compile With Low Effort.                                          --
#----========================================================================----
current_design $TopDesign
compile -map_effort low -area_effort none -no_design_rule

#----========================================================================----
#--    Apply UnGroup DesignWare.                                               --
#----========================================================================----
current_design $TopDesign
source -echo -verbose $TclDir/UngroupDW.tcl

#-- Fix minimum timing violations
set_fix_hold [all_clocks]

#------------------------------------------------------------------------------
#-- The following command optimizes the paths which are below the top-most
#-- violating path by a margin of 0.5 ns.
#------------------------------------------------------------------------------
set_critical_range 0.5 $TopDesign

#----========================================================================----
#--    Compile With High Effort.                                               --
#----========================================================================----
current_design $TopDesign
compile -map_effort high

#----========================================================================----
#--    Apply Name Rule
#----========================================================================----
#-- Remove BackSlash
source -echo -verbose $TclDir/rmbs.tcl

#-- Apply TSMC Naming Rule
tsmc_naming_rule

write -f verilog -h -o [format "%s/$TopDesign.noscan.v" $NetDir]

#----========================================================================----
#--    Generate SDF For PreSim                                                 --
#----========================================================================----
current_design $TopDesign

write_sdf -context verilog -version 2.1 $SdfDir/temp.sdf

#--****************************************************************************--
#--    Report about your design.                                               --
#--****************************************************************************--
#----========================================================================----
#--    Report quality of results.                                              --
#----========================================================================----
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".qor.rpt"] { report_qor }

#----========================================================================----
#--    Report area of design.                                                  --
#----========================================================================----
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".area.rpt"] { report_area }

#----========================================================================----
#--    Report high fan-out nets of design.                                     --
#----========================================================================----
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".high_fanout.rpt"] { report_net_fanout -threshold 8 }

#----========================================================================----
#--    Report all violations of design.                                        --
#----========================================================================----
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".all_viol.rpt"] { report_constraint -all_violators }

#----========================================================================----
#--    Report all violation paths of design.                                   --
#----========================================================================----
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".all_viol.verbose.rpt"] { report_constraint -all_violators -verbose }

#----========================================================================----
#--    Report timing paths with setup violation.                               --
#----========================================================================----
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".max.rpt"] { report_timing -tran -cap -net -input -nworst 10 }

#----========================================================================----
#--    Report timing paths with hold violation.                                --
#----========================================================================----
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $RptDir "/"] $TopDesign] ".min.rpt"] { report_timing -delay min -tran -cap -net -input -nworst 10 }

write_sdc $TopDesign.sdc


#--****************************************************************************--
#--    Exit Design Compiler.                                                   --
#--****************************************************************************--
quit
