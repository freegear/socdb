#
# Written by : DC-Transcript, Version V-2004.06-SP2 -- Aug 25, 2004
# Date       : Tue Feb 22 23:38:57 2005
#

#
# Translation of script: 4_ungroup.scr
#

read_file -f db /user/cklee/PRJ/8051_013/FE/SYN/SYN_DB/rc8051RtlTop_compile.db

current_design rc8051RtlTop
link

set dc_shell_status [ set all_designs [find design "*"] ]

foreach_in_collection temp_design $all_designs {
  current_design $temp_design
  set dc_shell_status [ redirect /dev/null { set dware [find reference "*DW*"] } ]
  foreach_in_collection temp_dware $dware {
    set dc_shell_status [ redirect /dev/null { filter [find cell "*"] "@ref_name==$temp_dware" } ]
    ungroup $dc_shell_status -flatten
    echo [concat {NOTE: UNGROUPING DW COMPONENT } [format "%s%s"  [format "%s%s" [get_object_name $temp_dware] { IN DESIGN }] [get_object_name $temp_design]]]
  }
}


current_design rc8051RtlTop

#/* include /prj1/sm2501/FE/SYN/constraints/eliminate_backslash.scr */

set_fix_multiple_port_nets -all
set_fix_multiple_port_nets -feedthroughs -constants -outputs -buffer_constants

current_design rc8051RtlTop

write -f db -hier -o ./SYN_DB/rc8051RtlTop_ung.db
write -f verilog -hier -o   ./SYN_DB/rc8051RtlTop_ung.v 

exit
