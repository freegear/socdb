Please follow the steps described below in order to execute scripts with
Synopsys Design Compiler (UNIX/Linux architecture).

1. Enter your working directory. For instance:
    cd ./mac_1g_amba/
2. Execute the following command if you only intend to analyze source files:
    dc_shell -f ./tools/synopsys/dc_scripts/compile.scr
3. To run "Synthesis with time effort" (see the specification for the details)
   in batch mode, please execute command :
    dc_shell -f ./tools/synopsys/dc_scripts/optimize_time.scr
4. To run "Synthesis with area effort" (see the specification for the
   details) in batch mode, please execute command :
    dc_shell -f ./tools/synopsys/dc_scripts/optimize_area.scr
5. To run "Synthesis with scan insertion" in batch mode please issue command:
   dc_shell -f ./tools/synopsys/dc_scripts/optimize_scan.scr

   Report files are written to directory :
    ./tools/synopsys/reports
   Result files are written to directory :
    ./tools/synopsys/results

