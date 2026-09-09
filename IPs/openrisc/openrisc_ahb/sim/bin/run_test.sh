#!/bin/csh -f

set failed = 0;
set all_tests = 0;

set simpletests=`cat ../bin/tests`
set complextests=()

set complextimes=(500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 )

# Process arguments
set tests=(${simpletests} ${complextests})
set maxtimes=()
foreach test ($simpletests)
	set maxtimes=(${maxtimes} 5)	# simple tests : 5 ms
end
set maxtimes=(${maxtimes} ${complextimes})	# add complex tests time 

if ($1 == "clean") then
	rm -rf ../log/*
	exit 0;
else if ($1 == "sim") then
	goto sim;
endif

# Print HW clock
/sbin/hwclock

# List all selected tests
set i = 0;
foreach test ($tests)
	@ i += 1;
	/bin/echo -n -e " Test ${i}: ${test}, $maxtimes[$i] ms\t"
	if ((${i} % 2) == 0) then
		/bin/echo -e ""
	endif
end

# Run compiler
/bin/echo -e ""
/bin/echo -e "\t@@@"
/bin/echo -e "\t@@@ Compiling sources"
/bin/echo -e "\t@@@"
../bin/compile.sh >& vlog.out
if ($status != 0) then
  /bin/echo -e "\t@@@ FAILED"
  /bin/echo -e ""
  cat vlog.out
  exit
else
  /bin/echo -e "\t@@@ Passed"
  rm vlog.out
endif

# Run the simulator (simulate the design)
sim:
set i = 0;
foreach test ($tests)
	@ i += 1;
	/bin/echo -e ""
	/bin/echo -e "\t###"
	/bin/echo -e "\t### Running test ${i}: ${test}, $maxtimes[$i] ms"
	/bin/echo -e "\t###"

	cp ../src/${test}.hex ../rom/program.rom
	vsim -quiet -c or1200_monitor tb -do "run ${maxtimes[$i]} ms;quit" > vsim.log
	if ($status != 0) then
	  cat vsim.log
	  exit
	else
	  set magic=`grep report general.log | tail -1 | cut -d'(' -f2 | cut -d')' -f1 | cut -d' ' -f1`
	  set magictime=`tail -1 general.log | cut -d'n' -f1`
	  if ($magic == "deaddead") then
		/bin/echo -e "\t### Passed (@time $magictime)"
		@ all_tests += 1;
	  else
		/bin/echo -e "\t### FAILED (@time $magictime, magic# 0x$magic)"
		/bin/echo ../log/${test}-general.log:
		cat general.log
		@ failed += 1;
		@ all_tests += 1;
	  endif
	  mv vsim.log ../log/${test}-vsim.log
	  mv executed.log ../log/${test}-executed.log
	  mv sprs.log ../log/${test}-sprs.log
	  mv general.log ../log/${test}-general.log
	  mv lookup.log ../log/${test}-lookup.log
	endif
end

/bin/echo -e ""
/bin/echo -e "<<<"
/bin/echo -e "<<< End of Regression Iterations"
/bin/echo -e "<<<"
/bin/echo -e "<<< Failed $failed out of $all_tests"
/bin/echo -e "<<<"
/sbin/hwclock

