#!/bin/csh -f

set iter = 1;
set failed = 0;
set all_tests = 0;
# List all test cases
#set simpletests=(buserr-nocache immu-nocache dmmu-nocache basic-nocache mul-nocache-O2 syscall-nocache cbasic-nocache-O2 ints1-nocache ints2-nocache \
#		buserr-icdc immu-icdc dmmu-icdc basic-icdc mul-icdc-O2 syscall-icdc cbasic-icdc-O2 ints1-icdc ints2-icdc)

#set simpletests=(basic-nocache mul-nocache-O2 cbasic-nocache-O2 ints1-nocache ints2-nocache \
#		basic-icdc mul-icdc-O2 cbasic-icdc-O2 ints1-icdc ints2-icdc)

#set simpletests=(icm-icdc icm-nocache dhry-nocache-O2 dhry-icdc-O2 mmu-nocache mmu-icdc basic-icdc basic-nocache mul-nocache-O2 mul-icdc-O2 basic-ic basic-dc)
#set simpletests=(crc32-icdc-O0 minimad dhry-nocache-O2 dhry-icdc-O2 mmu-nocache mmu-icdc basic-icdc basic-nocache mul-nocache-O2 mul-icdc-O2 basic-ic basic-dc)
#set complextests=(buserr-ic immu-ic dmmu-ic basic-ic mul-ic-O2 syscall-ic cbasic-ic-O2 ints1-ic ints2-ic \
#		buserr-dc immu-dc dmmu-dc basic-dc mul-dc-O2 syscall-dc cbasic-dc-O2 ints1-dc ints2-dc \
#		mul-nocache-O0 cbasic-nocache-O0 \
#		mul-icdc-O0 cbasic-icdc-O0 \
#		mul-ic-O0 cbasic-ic-O0 \
#		mul-dc-O0 cbasic-dc-O0)

#set complextests=(except-nocache except-icdc cbasic-nocache-O2 cbasic-icdc-O0 tick-nocache tick-icdc \
#		syscall-nocache syscall-icdc uart-nocache uart-icdc debug-nocache debug-dc )

set simpletests=`cat ../bin/tests`
set complextests=()

set simpletimes=(500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 500 )
set complextimes=(40 40 \
		 400 140 \
		  100 40 \
		  40 40 \
		  40 40 )

# Process arguments
if ($1 == "simple") then
	set tests=(${simpletests})
	set maxtimes=(${simpletimes})
else
	set tests=(${simpletests} ${complextests})
	set maxtimes=(${simpletimes} ${complextimes})
endif
if ($1 == "single") then
	set tests=(${simpletests} ${complextests})
	set maxtimes=(${simpletimes} ${complextimes})
	set tests=${tests[$2]}
	set maxtimes=${maxtimes[$2]}
endif
if ($1 == "clean") then
	rm -rf ../log/*
	rm -rf ../out/wave/*
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
../bin/compile_or1200.sh >& vlog.out
if ($status != 0) then
  /bin/echo -e "\t@@@ FAILED"
  /bin/echo -e ""
  cat vlog.out
  exit
else
  /bin/echo -e "\t@@@ Passed"
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
	vsim -quiet -c or1200_monitor tb -do "run 500ms;quit" > vsim.out
	if ($status != 0) then
	  cat vsim.out
	  exit
	else
	  set magic=`grep report general.log | tail -1 | cut -d'(' -f2 | cut -d')' -f1 | cut -d' ' -f1`
	  set magictime=`tail -1 general.log | cut -d'n' -f1`
	  if ($magic == "deaddead") then
		/bin/echo -e "\t### Passed (@time $magictime)"
		@ all_tests += 1;
	  else
		/bin/echo -e "\t### FAILED (@time $magictime, magic# 0x$magic)"
		/bin/echo ../log/i${iter}-${test}-general.log:
		cat general.log
		@ failed += 1;
		@ all_tests += 1;
	  endif
	  mv executed.log ../log/i${iter}-${test}-executed.log
	  mv sprs.log ../log/i${iter}-${test}-sprs.log
	  mv general.log ../log/i${iter}-${test}-general.log
	  mv lookup.log ../log/i${iter}-${test}-lookup.log
	endif
end

/bin/echo -e ""
/bin/echo -e "<<<"
/bin/echo -e "<<< End of Regression Iterations"
/bin/echo -e "<<<"
/bin/echo -e "<<< Failed $failed out of $all_tests"
/bin/echo -e "<<<"
/sbin/hwclock

