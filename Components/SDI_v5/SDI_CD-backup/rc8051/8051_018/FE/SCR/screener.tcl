#############################################################################
# Copyright (c) 1999, 2000 by Taiwan Semiconductor Manufacturing Company Ltd.
# All Rights Reserved. No part of this publication may be reproduced in
# whole or part by any means without the prior written consent.
#
# FILE    : screener2000.tcl
# AUTHOR  : Ching-Yao Chung
# ABSTRACT: this file contains lots of TCL procedures developed by TSMC DSDAD
# VERSION : 2.0 (Tue Mar 14 09:33:24 CST 2000)
#
#############################################################################
# Contents of exported procedures:   
#	tsmc_naming_rule
#	tsmc_report_hier
#	write_ndf
#	screener

###############################################################################
#
# PROC:		 tsmc_naming_rule
# ABSTRACT:	 apply tsmc naming rule
# AUTHOR:        1. Created by H.C. Huang on 03/10/2000
#
###############################################################################
proc tsmc_naming_rule {} {
# Bus manipulation 
set bus_dimension_separator_style {][}
set bus_extraction_style {%s[%d:%d]}
set bus_inference_descending_sort {true}
set bus_naming_style {%s[%d]}
set bus_range_separator_style {:}
set change_names_dont_change_bus_members {false}

# Internal bus Inference #
# Don't form internal bus #
set hdlout_internal_busses {false}
set bus_inference_style {%s[%d]}

# Verilog Interface #
set verilogout_higher_designs_first {true}
set verilogout_no_tri {true}
set verilogout_single_bit {false}

# TSMC naming rules for Verilog netlist #
define_name_rules TSMC_VERILOG_RULE -reserved_words {always, and, assign, \
begin, buf, bufif0, bufif1, case, casex, casez, cmos, deassign, default, \
defparam, disable, edge, else, end, endattribute, endcase, endfunction, \
endmodule, endprimitive, endspecify, endtable, endtask, event, for, force, \
forever, fork, function, highz0, highz1, if, initial, inout, input, integer, \
join, large, macromodule, medium, module, nand, negedge, nmos, nor, not, \
notif0, notif1, or, output, parameter, pmos, posedge, primitive, pull0, \
pull1, pullup, pulldown, reg, rcmos, reg, release, repeat, rnmos, rpmos, \
rtran, rtranif0, rtranif1, scalared, small, specify, specparam, strength, \
strong0, strong1, supply0, supply1, table, task, time, tran, tranif0, tranif1, \
tri, tri0, tri1, trinand, trior, trireg, use, vectored, wait, wand, weak0, \
weak1, while, wire, wor, xor, xnor}
#
define_name_rules TSMC_VERILOG_RULE -allowed {a-zA-Z0-9_[]!} \
-first_restricted {0-9\\[]/!} \
-last_restricted {[/!} \
-max_length 255 \
-replacement_char {_} \
-case_insensitive \
-equal_ports_nets \
-inout_ports_equal_nets 
#
define_name_rules TSMC_VERILOG_RULE -type port \
-allowed {a-zA-Z0-9_[]} \
-first_restricted {0-9 []} \
-last_restricted {[} \
-map {{{"[?*]?*$", ""}}} \
-max_length 32

redirect TSMC_VERILOG_RULE.log {change_names -verbose -hierarchy -rule TSMC_VERILOG_RULE}

echo "/***************************************************************/"
echo "/* Please check the log file TSMC_VERILOG_RULE.log for details */"
echo "/***************************************************************/"
}
define_proc_attributes tsmc_naming_rule -hide_body -info "TSMC Verilog Naming Rule"

############################################################################
#
# PROC:          write_ndf
# ABSTRACT:      write out a NDF file required by testgen
# AUTHOR:        1. Created by H.C Li on 11/05/1999
#                2. Edited by C.Y Chung on 12/06/1999
#                3. Edited by C.Y Chung on 12/21/1999
#                4. Edited by C.Y Chung on 12/22/1999
#
############################################################################
proc write_ndf {args} {
#####   Parse Procedure Argumenets   #####
  parse_proc_arguments -args $args resarr
 
  suppress_message CMD-041
  global sh_dev_null
  global search_path
  redirect $sh_dev_null {set cur_des [get_object_name [current_design]]}
  if { $cur_des == "" } {
    unsuppress_message CMD-041
    return -code error "Current design is not defined"
  }

  set keyfile "keyword.pad"
  if {[info exists resarr(-key)]} {
    set keyfile $resarr(-key)
  }
  set pass_or_not 0
  foreach tmp_dir $search_path {
    set tmp_file_name "$tmp_dir/$keyfile"
    if {![catch {open $tmp_file_name "r"} keyfd]} {
      set pass_or_not 1
      break
    }
  }
  if {$pass_or_not == 0} {
    return -code error "Cannot open keyword file $keyfile in search_path \n{$search_path} for reading"
  }

  set ndffile "$cur_des.ndf"
  if {[info exists resarr(-ndf)]} {
    set ndffile $resarr(-ndf)
  }
  if [catch {open $ndffile "w"} ndffd] {
    return -code error "Cannot open node definition file $ndffile for output"
  }

  puts stderr "***Notice*** : this procedure will flatten the netlist. Don't write out the flatten netlist accidently"
  redirect $sh_dev_null {ungroup -flatten -all}
  puts stderr "Generating NDF file '$ndffile' for testgen"

  while {[gets $keyfd line] >= 0} {
    regsub -all "\[ \t\n]+" $line { } line
    set elements [split $line]
    switch -regexp -- [lindex $elements 0] {
      MACRO {
        set celltype [lindex $elements 1]
        set buffer [ join [lrange $elements 2 [llength $elements]]]
        set macrodef($celltype) $buffer
      }
    }
  }
  close $keyfd

  set type(in)      "I"
  set type(out)     "O"
  set type(inout)   "B"
  set type(unknown) "X"
  foreach_in_collection port [find port] {
    set portname [get_object_name $port]
    set portdir [get_attribute $port port_direction]
    set connected_pins [find pin [all_connected [find net [all_connected $port]]]]
    if {[sizeof_collection $connected_pins] <= 0} {
      puts stderr "Error: $portdir port {$portname} is floating"
      continue;
    }
    set count 1
    foreach_in_collection pin $connected_pins {
      set fullpinname [get_object_name $pin]
      set pindir [get_attribute $pin pin_direction]
      if { ($portdir == "in") && ($pindir == "out") } {
        puts stderr "Error: $portdir port {$portname} connects to $pindir pin {$fullpinname}"
      } elseif { ($portdir == "out") && ($pindir == "in") } {
        puts stderr "Error: $portdir port {$portname} connects to $pindir pin {$fullpinname}"
      } elseif {$count == 1} {
        regsub -all "^.+\/" $fullpinname {} pinname
        regsub "\/\[^\/]+$" $fullpinname {} cellname
        set celltype [get_attribute [find cell $cellname] ref_name]
        set cell_list($celltype) ""
        set matchpin 0
        set keyword {}
        if {[array get macrodef $celltype] != ""} {
          foreach key [split $macrodef($celltype)] {
            switch -regexp $key {
              {^\?} {
                regsub {^\?} $key {} pin1
                set matchpin [ string compare $pin1 $pinname]
              }
              {^\@} {
                if {$matchpin==0} {
                  regsub {^\@} $key {} pin1
                  set key "$cellname/$pin1"
                  set key [get_object_name [find net [all_connected [find pin $key]]]]
	          regsub {\*Logic0\*} $key {VSS} key
		  regsub {\*Logic1\*} $key {VDD} key
                  lappend keyword $key
                  set netlines($key) ""
                }
              }
              {^\%} {
	      }
              default {
                if {$matchpin==0} { lappend keyword $key }
              }
            }
          }
          append iolines [format "%s %-16s MACRO %-12s %s\n" $type($portdir) $portname $celltype [join $keyword]]
          incr count
        }
      }
    }
  }
  puts $ndffd "SOURCE NDF"
  foreach celltype [array names cell_list] {
    if {[array get macrodef $celltype] != ""} {
      puts $ndffd [format "# MACRO %-12s %s" $celltype $macrodef($celltype)]
    } else {
      puts stderr "Error: Cannot find the defintion for '$celltype' in the file '$keyfile'"
    }
  }
  puts $ndffd "\$NODE_INFO"
  if {[info exists iolines] == 1} {
    puts -nonewline $ndffd $iolines
  }
  foreach tmp_net [array names netlines] {
    puts $ndffd [format "N %s" $tmp_net]
  }
  puts $ndffd "\$end_NODE_INFO"
  close $ndffd

  unsuppress_message CMD-041
  puts stderr "NDF file $ndffile generated"
  return
}
define_proc_attributes write_ndf \
  -hide_body \
  -info "Generate a NDF file for testgen" \
  -define_args { \
    {-keyfile "Name of keyword definition file" "keyfile" string optional}
    {-ndffile "Name of NDF file" "ndffile" string optional}}

############################################################################
#
# PROC:          each_design
# ABSTRACT:      for each design below the hierarchy of current design,
#		 report total number of ports, nets, cells, refecences.
# AUTHOR:        1. Created by C.Y Chung on 12/02/1999
#                2. Edited by C.Y Chung on 12/23/1999
#
############################################################################
 
proc each_design {design level outfd flat} {
  global sh_dev_null
  redirect $sh_dev_null {set old_design [get_object_name [current_design]]}
  redirect $sh_dev_null {current_design $design}
  set buffer ""
  for {set blank_no 0} {$blank_no < $level} {incr blank_no} {
    append buffer "   "
  }
  append buffer $design
  if {[string length $buffer] > 40} {
    set buffer [string range $buffer 0 36]
    set buffer "$buffer\.\.\."
  }
  if {$flat == 0} {
    puts $outfd [format "%-40s %7d %7d %7d %7d" \
                        $buffer  \
                        [sizeof_collection [find cell]] \
                        [sizeof_collection [find port]] \
                        [sizeof_collection [find net]] \
                        [sizeof_collection [find reference]]]
  } else {
    puts $outfd [format "%-40s %7d %7d %7d %7d" \
                        $buffer  \
                        [sizeof_collection [find cell -hierarchy -flat]] \
                        [sizeof_collection [find port]] \
                        [sizeof_collection [find net -hierarchy -flat]] \
                        [sizeof_collection [find lib_cell -hierarchy -flat]]]
  }
 
  foreach_in_collection tmp_design [find design -hierarchy] {
    each_design [get_object_name $tmp_design] [expr $level + 1] $outfd $flat
  }
  redirect $sh_dev_null {current_design $old_design}
}
define_proc_attributes each_design -hidden -hide_body

############################################################################
#
# PROC:          tsmc_report_hier
# ABSTRACT:      for each design below the hierarchy of current design, report
#                total number of ports, nets, cells, refecences.
# AUTHOR:        1. Created by C.Y Chung on 12/02/1999
#
############################################################################
 
proc tsmc_report_hier {args} {
#####   Parse Procedure Argumenets   #####
  parse_proc_arguments -args $args resarr
 
  suppress_message CMD-041
  global sh_dev_null
  redirect $sh_dev_null {set cur_des [get_object_name [current_design]]}
  if { $cur_des == "" } {
    unsuppress_message CMD-041
    return -code error "Current design is not defined"
  }

  set outfile "$cur_des.report.hier"
  if {[info exists resarr(-output)]} {
    set outfile $resarr(-output)
  }
  if [catch {open $outfile "w"} outfd] {
    return -code error "Cannot open $outfile for output"
  }

  set flat 0
  if {[info exists resarr(-flat)]} {
    set flat 1
  }

  puts stderr "Generating hierarchical report file '$outfile'"
  puts $outfd [format "%-40s %7s %7s %7s %7s" "Design Name" "Cells" "Ports" "Nets" "Refs"]
  puts $outfd [format "%-40s %7s %7s %7s %7s" "----------------------------------------" "-------" "-------" "-------" "-------"]
  each_design $cur_des 0 $outfd $flat
  close $outfd

  unsuppress_message CMD-041
  puts stderr "Hirarchical report file $outfile generated"
  return
}
define_proc_attributes tsmc_report_hier \
  -hide_body \
  -info "TSMC version 'report_hierarchy' command" \
  -define_args { \
    {-output "Name of output file" "outfile" string optional}
    {-flat "Flatten the design first" "" boolean optional}}

############################################################################
#
# PROC:          screener
# ABSTRACT:      screener
# AUTHOR:        1. Created by C.Y Chung on 12/02/1999
#                2. Edited by C.Y Chung on 12/21/1999
#                3. Edited by C.Y Chung on 03/14/1999
#
############################################################################
proc screener {args} {
  parse_proc_arguments -args $args resarr
  global sh_dev_null
  global enable_page_mode

  set enable_page_mode "false"
  suppress_message CMD-041
  suppress_message UID-341
  redirect $sh_dev_null {set cur_des [get_object_name [current_design]]}
  if {$cur_des == ""} {
    unsuppress_message CMD-041
    unsuppress_message UID-341
    return -code error "Current design is not defined"
  }
  set outfile "$cur_des.report"
  if {[info exists resarr(-output)]} {
    set outfile $resarr(-output)
  }
  if [catch {open $outfile "w"} outfd] {
    return -code error "Cannot open $outfile for output"
  }

  set threshold 20
  if {[info exists resarr(-threshold)]} {
    set threshold $resarr(-threshold)
  }

  set noflat false
  if {[info exists resarr(-noflat)]} {
    set noflat true
  }

  puts stderr "[sh date] : procedure screener starts";
  puts stderr "[sh date] : open output file '$outfile'";

  if {$noflat == "false"} {
    puts stderr "***Notice*** : this procedure will flatten the netlist. Don't write out the flatten netlist accidently"
    redirect $sh_dev_null {ungroup -all -flatten}
    puts stderr "[sh date] : 'ungroup' command finished";
  }

  redirect $outfile {report_area -nosplit}
  puts stderr "[sh date] : 'report_area' command  finished";

  redirect -append $outfile {report_reference -nosplit}
  puts stderr "[sh date] : 'report_reference'command finished";

  redirect -append $outfile {report_net -nosplit}
  puts stderr "[sh date] : 'report_net' command finished";

  redirect -append $outfile {report_constraint -all_violators -nosplit}
  puts stderr "[sh date] : 'report_constraint' finished";

  redirect -append $outfile {echo "****************************************\ncheck_design -summary\n****************************************"}
  redirect -append $outfile {check_design -summary}
  redirect -append $outfile {echo "****************************************\ncheck_design\n****************************************"}
  redirect -append $outfile {check_design}
  puts stderr "[sh date] : 'check_design' command finished";

  sh post_processing.pl $outfile $threshold
  puts stderr "[sh date] : 'post_processing.pl' command finished";

  puts stderr "[sh date] : procedure screener finished successfully";
  set enable_page_mode "true"
  unsuppress_message CMD-041
  unsuppress_message UID-341
  return
}
define_proc_attributes screener \
  -hide_body \
  -info "Screener 2000" \
  -define_args { \
    {-output "Name of output file" "outfile" string optional}
    {-threshold "Fanout threshold of listed nets" "threshold" int optional}
    {-noflat "Don't flatten current design" "" boolean optional} }

############################################################################
#
# ABSTRACT:      Main program
# AUTHOR:        1. Created by C.Y Chung on 12/13/1999
#                2. Edited by C.Y Chung on 12/21/1999
#                2. Edited by C.Y Chung on 12/23/1999
#
############################################################################
puts stderr "Procedures provided in this tool kit:"
help -verbose tsmc_naming_rule
help -verbose tsmc_report_hier
help -verbose write_ndf
help -verbose screener
