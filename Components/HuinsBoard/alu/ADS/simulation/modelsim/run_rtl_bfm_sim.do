restart -f
force -drive -repeat 10ns  /arm_top/HCLOCK 0 0ns, 1 5ns
force -drive /arm_top/HSEL 0 0ns, 1 10ns
force -drive /arm_top/HRESETn 0 0ns, 1 10ns
force -drive /arm_top/HGRANT 0 0ns, 1 10ns
run 14000ns











