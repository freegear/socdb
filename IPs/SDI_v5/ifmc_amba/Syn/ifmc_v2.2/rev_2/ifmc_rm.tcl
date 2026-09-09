if {[cmp get_assignment_value "" "" "" ROOT] != ""} {
  cmp remove_assignment "" "" "" ROOT ""
}
if {[cmp get_assignment_value "" "" "" FAMILY] !=  ""} {
  cmp remove_assignment "" "" "" FAMILY ""
}
if {[cmp get_assignment_value "ifmc_top" "" "" DEVICE] !=  ""} {
  cmp remove_assignment "ifmc_top" "" "" DEVICE ""
}
if {[project get_assignment_value "" "clk_setting" "" "" "DUTY_CYCLE"] != ""} {
  project remove_assignment "" "clk_setting" "" "" "DUTY_CYCLE" ""
}
if {[project get_assignment_value "ifmc_top" "" "" "clk" "GLOBAL_SIGNAL"] !=  ""} {
  project remove_assignment "ifmc_top" "" "" "clk" "GLOBAL_SIGNAL" ""
}
if {[project get_assignment_value "ifmc_top" "" "" "clk" "USE_CLOCK_SETTINGS"] != ""} {
  project remove_assignment "ifmc_top" "" "" "clk" "USE_CLOCK_SETTINGS" ""
}
if {[project get_assignment_value "" "clk_setting" "" "" "FMAX_REQUIREMENT"] != ""} {
  project remove_assignment "" "clk_setting" "" "" "FMAX_REQUIREMENT" ""
}
if {[project get_assignment_value "" "apb_clk_setting" "" "" "DUTY_CYCLE"] != ""} {
  project remove_assignment "" "apb_clk_setting" "" "" "DUTY_CYCLE" ""
}
if {[project get_assignment_value "ifmc_top" "" "" "apb_clk" "GLOBAL_SIGNAL"] !=  ""} {
  project remove_assignment "ifmc_top" "" "" "apb_clk" "GLOBAL_SIGNAL" ""
}
if {[project get_assignment_value "ifmc_top" "" "" "apb_clk" "USE_CLOCK_SETTINGS"] != ""} {
  project remove_assignment "ifmc_top" "" "" "apb_clk" "USE_CLOCK_SETTINGS" ""
}
if {[project get_assignment_value "" "apb_clk_setting" "" "" "FMAX_REQUIREMENT"] != ""} {
  project remove_assignment "" "apb_clk_setting" "" "" "FMAX_REQUIREMENT" ""
}
if {[project get_assignment_value "" "" "" "TAO_FILE" "myresults.tao"] != ""} {
  project remove_assignment "" "" "" "TAO_FILE" "myresults.tao" ""
}
if {[project get_assignment_value "" "" "" "SOURCES_PER_DESTINATION_INCLUDE_COUNT" "1000"] != ""} {
  project remove_assignment "" "" "" "SOURCES_PER_DESTINATION_INCLUDE_COUNT" "1000" ""
}
if {[project get_assignment_value "" "" "" "ROUTER_REGISTER_DUPLICATION" "ON"] != ""} {
  project remove_assignment "" "" "" "ROUTER_REGISTER_DUPLICATION" "ON" ""
}
foreach a [project get_all_assignments "ifmc_top" "" "" ""] {
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_10" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_8" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_9" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_66" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_11" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_67" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_15" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_68" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_65" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_58" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_60" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_61" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_62" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_69" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_63" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_81" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_98" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_99" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_100" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_101" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_102" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_104" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_105" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_106" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_107" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_130" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_131" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_132" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_133" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_70" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_71" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_72" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_108" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_109" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_110" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_111" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_112" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_113" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_114" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_115" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_116" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_117" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_118" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_119" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_120" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_103" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_51" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_49" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_56" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_84" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_122" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_121" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_80" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_79" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_78" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_77" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_76" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_91" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_90" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_89" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_88" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_87" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_86" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_85" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_75" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_74" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_92" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_129" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_128" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_127" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_126" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_125" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_124" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_123" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_82" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_42" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_50" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_13" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_97" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_96" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_95" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_94" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_93" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_83" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_57" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_55" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_7" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_16" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_18" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_25" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_30" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_37" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_38" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_31" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_32" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_39" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_23" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_17" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_20" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_6" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_36" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_5" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_35" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_26" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_14" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_21" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_12" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_27" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_28" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_24" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_29" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_33" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_34" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_59" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_4" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_73" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_53" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_54" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_44" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_43" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_41" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_46" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_48" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_47" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_52" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_19" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_22" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_40" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_64" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_1" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_2" == [lindex $a 0] } {
		project remove_assignment "ifmc_top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
}
