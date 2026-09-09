        ____________________________________ 
       /                                    |
      |                                     |
      |      __________________   __________|
      |     |                 |   |
       \     \                |   |   _______________________________________________________
        \     \               |   |
         \     \              |   |                                                
          \     \             |   |                                                NAND512W3A   
           \     \            |   |      
            \     \           |   |                                               512Gbit (x8)       
             \     \          |   |                    528 Byte Page, 3V, NAND Flash Memories
              \     \         |   |       
               \     \        |   |                                     VHDL Behavioral Model
                |     \       |   |                                               Version 1.0
                |     |       |   |                                               
  ______________|     |       |   |                     Copyright (c) 2005 STMicroelectronics
 |                    |       |   |  
 |                    |       |   |  _________________________________________________________
 |___________________/        |___|
 
 
 ********************************************************************************************* 
 

********************************************************************************************* 


This README provides information on the following topics :

- VHDL Behavioral Model description
- Version History
- Install / uninstall information
- File list
- Get support
- Bug reports
- Send feedback / requests for features
- Known issues
- Ordering information


------------------------------------
VHDL BEHAVIORAL MODEL DESCRIPTION
------------------------------------

Behavioral modeling is a technic for the description of an hardware architecture at an 
algorithmic level where the designers do not necessarily think in terms of
logic gates or data flow, but in terms of the algorithm and its performance.
Only after the high-level architecture and algorithm are finalized, do designers 
start focusing on building the digital circuit to implement the algorithm.
To obtain this behavioral model we used VHDL HDL Language.

---------------
VERSION HISTORY
---------------

  Version 1.0  

        Date    :  11/03/2005
        Note    :  First Release

        Author  : 
                        Giampaolo Giacopelli
                        Antonella Cavadi
                             
                        Tel    : 
                                        +39 91 6689948
                                        +39 91 6689946
                                
                        e-mail : 
                                        giampaolo.giacopelli@st.com
                                        antonella.cavadi@st.com



  This version is based on the Target Specification Datasheet (December 2004)   


---------------------------------
INSTALL / UNINSTALL INFORMATION
---------------------------------

For installing the model you have to process the ST_NAND512W3A_V1.0.tar.gz delivery package.  
By gzip application you can unzip the package (apply to it the "gzip -d" command), and then
you can untar the so obtained tar archive (apply to it the "tar -vfx" command)

Compatibility: the model has been tested by Cadence NCsim 5.3 simulator, on SUN OS environment.

IMPORTANT:

******************************************************************************   
  
    THIS PROGRAM IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,        
    EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO, THE        
    IMPLIED WARRANTY OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR      
    PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF         
    THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU      
    ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.     
  
******************************************************************************

--------------
FILE LIST
--------------

code (source code files) 
        -       code/NAND512W3A.vhd

lib (source library files)
        -       lib/BlockLib.vhd
        -       lib/CUIcommandData.vhd
        -       lib/MemoryLib.vhd
        -       lib/StringLib.vhd
        -       lib/TimingData.vhd
        -       lib/UserData.vhd
        -       lib/data.vhd
        -       lib/def.vhd

doc (model documentation) 

	-	doc/NANDXXX-A.pdf
	-	doc/ApplicationNote.pdf 

sim (files for simulation) 

	-	sim/memory_file
        -       ./run_ncsim

stim (stimuli and testbench files for simulation) 

        -	stim/erase/block_erase.vhd
        -	stim/erase/block_erase_err.vhd
        -       stim/program/copy_back-adv.vhd
        -	stim/program/copy_back-nodata.vhd
        -	stim/program/copy_back.vhd
        -	stim/program/double-pageprogram-areaA.vhd
        -	stim/program/double-pageprogram-areaB.vhd
        -	stim/program/double-pageprogram-areaC.vhd
        -	stim/program/double_pageprogram.vhd
        -	stim/program/page_erase.vhd
        -	stim/program/page_limit.vhd
        -	stim/program/page_program-areaA.vhd
        -	stim/program/page_program-areaB.vhd
        -	stim/program/page_program-areaC.vhd
        -	stim/program/page_program_err.vhd
        -	stim/program/page_read-areaABC.vhd
        -	stim/program/page_read.vhd
        -       stim/read/latch.vhd
        - 	stim/read/read-A.vhd
        -	stim/read/read-B.vhd
        -	stim/read/read-C.vhd
        -	stim/read/read-err.vhd
        -	stim/read/read_signature.vhd
        -	stim/read/read_status_reg.vhd
        -	stim/read/reset.vhd

-------------
GET SUPPORT
-------------

Please mail any questions, comments or problems you might have concerning
this VHDL Behavioral Model to :

        giampaolo.giacopelli@st.com 
	antonella.cavadi@st.com

If you are having technical difficulties then please include some basic 
information in your email:
        Simulator Version and Operative System you have used; 
        Memory (RAM);
        Free Disk Space on installation drive;

-------------
BUG REPORTS
-------------

If you experience something you think might be a bug in the VHDL
Behavioral Model, please report it by sending a message to :

        giampaolo.giacopelli@st.com
	antonella.cavadi@st.com

Describe what you did (if anything), what happened
and what version of the Model you have. Please use the form
below for bug reports:

Error message :
Memory (RAM) :
Free Disk Space on installation drive :
Simulator Version and Operative System you have used :
Stimulus source file :
Waveform Image file (gif or jpeg format) :


---------------------------------------
SEND FEEDBACK / REQUESTS FOR FEATURES
---------------------------------------

Please let us know how to improve the behavioral model

        giampaolo.giacopelli@st.com
	antonella.cavadi@st.com

--------------
KNOWN ISSUES
--------------


---------------
HOW TO REQUEST?
---------------

http://mpgstest.rou.st.com/stonline/products/support/memory/flash/model_fo.htm


