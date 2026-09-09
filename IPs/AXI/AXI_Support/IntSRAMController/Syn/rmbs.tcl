set verilogout_single_bit false

define_name_rules willisn -type net -allow {a-z A-Z 0-9 _} -first_restrict {_ 0-9}
define_name_rules willisn -type port -allow {a-z A-Z 0-9 _ [ ]} -first_restrict {_ 0-9}
define_name_rules willisn -type cell -allow {a-z A-Z 0-9 _ } -first_restrict {_ 0-9}
define_name_rules willisn -reserved [list always and assign begin buf bufif0 bufif1 case casex casez cmos deassign default defparam disable edge else end endattribute endcase endfunction endmodule endprimitive endspecify endtable endtask event for force forever fork function highz0 highz1 if initial inout input integer join large macromodule medium module nand negedge nmos nor not notif0 notif1 or output parameter pmos posedge primitive pull0 pull1 pullup pulldown rcmos reg release repeat rnmos rpmos rtran rtranif0 rtranif1 scalared small specify specparam strength strong0 strong1 supply0 supply1 table task time tran tranif0 tranif1 tri tri0 tri1 triand trior trireg use vectored wait wand weak0 weak1 while wire wor xor xnor] -collapse_name_space -case_insensitive -map {{{"[?*]?*$", ""}}}

change_names -hierarchy -rules willisn
