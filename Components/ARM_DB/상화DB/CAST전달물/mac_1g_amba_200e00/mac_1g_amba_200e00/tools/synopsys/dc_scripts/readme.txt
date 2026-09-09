Please follow the steps to execute scripts for Synopsys.
Design Compiler on UNIX/Linux machine:

1. Change Directory to your work directory for example:
    ./mac_1g/         
2. For only "Analyze Process" in batch mode, 
   execute command :
    dc_shell -f ./tools/synopsys/dc_scripts/compile.scr
3. For "Synthesis with medium time effort" in batch mode, 
   execute command :
    dc_shell -f ./tools/synopsys/dc_scripts/optimize_time.scr      
4. For "Synthesis with high time effort" in batch mode, 
   execute command :
    dc_shell -f ./tools/synopsys/dc_scripts/optimize_time_max.scr          
5. For "Synthesis with medium area effort" in batch mode, 
   execute command :
    dc_shell -f ./tools/synopsys/dc_scripts/optimize_area.scr   
6. For "Synthesis with high area effort" in batch mode, 
   execute command :
    dc_shell -f ./tools/synopsys/dc_scripts/optimize_area_max.scr   


   Report files are written to directory :
    ./tools/synopsys/dc_reports
   Results files are written to directory :
    ./tools/synopsys/dc_results