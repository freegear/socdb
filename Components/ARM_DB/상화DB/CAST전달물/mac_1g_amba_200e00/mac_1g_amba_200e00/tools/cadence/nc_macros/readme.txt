Please follow the steps to execute scripts for Cadence.
NC-SIM simulator in GUI mode on UNIX/Linux machine:


1. Change Directory to your work directory for example:
   ./mac_ahb/
2. Execute batch file compile.do from shell to compile
   all source files.  
3. Execute batch file simulate.do from shell to start 
   NC-SIM in GUI mode.
4. Enter command to start simulation, for example:
   run 100 us

 Before simulating make sure to copy the contents of the 
 desired test directory to tests/default 
 (ie. cp tests/m4d32/m4d32_bd1/* tests/default)

 Run the simulation for the amount shown in the time.txt 
 file for each test.
 
 ----------------------------------------------------------