#!/bin/csh -f

set iter = 1;
set failed = 0;
set all_tests = 0;

# List all test cases
set alldirs=( ../../sw/basic ../../sw/mul ../../sw/except \
		../../sw/cbasic ../../sw/tick ../../sw/syscall )

if ($1 == "clean") then
	rm -rf ../log/s-*
	foreach dir ($alldirs)
		@ i += 1;
		/bin/echo -e ""
		/bin/echo -e "\t###"
		/bin/echo -e "\t### Clean: $dir"
		/bin/echo -e "\t###"
		cd $dir
		make clean
	end
	/bin/echo -e ""
	/bin/echo -e "\t###"
	/bin/echo -e "\t### Clean: ../../sw/support"
	/bin/echo -e "\t###"
	cd ../../sw/support
	make clean
	/bin/echo -e ""
	/bin/echo -e "\t###"
	/bin/echo -e "\t### Clean: ../../sw/utils"
	/bin/echo -e "\t###"
	cd ../../sw/utils
	make clean
	exit 0;
else
	/bin/echo -e ""
	/bin/echo -e "\t###"
	/bin/echo -e "\t### Build: ../../sw/utils"
	/bin/echo -e "\t###"
	cd ../../sw/utils
	make
	/bin/echo -e ""
	/bin/echo -e "\t###"
	/bin/echo -e "\t### Build: ../../sw/support"
	/bin/echo -e "\t###"
	cd ../../sw/support
	make
	foreach dir ($alldirs)
		@ i += 1;
		/bin/echo -e ""
		/bin/echo -e "\t###"
		/bin/echo -e "\t### Build: $dir"
		/bin/echo -e "\t###"
		cd $dir
		make
	end
	exit 0;
endif
