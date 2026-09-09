 ¡á Description ::

    ¡ã Rtl :: TestSlave.v --> TestSlave 32bit or 64bit
            
        ¢¡ 32bit setting :: parameter DATA_WIDTH = 32;
        ¢¡ 64bit setting :: parameter DATA_WIDTH = 64;

    ¡ã Sim :: ncverilog simulation environment

        ¢¡ script :: run

    ¡ã Tb :: Testbench 

        ¢¡ ChMergeTestMaster.v :: 
               the one of AWVALID or ARVALID is valid inforamtion.
               if AWVLID is 'High', ARVALID is 'Low'

