Disclaimer of Warranty:
-----------------------
This software code and all associated documentation, comments
or other information (collectively "Software") is provided 
"AS IS" without warranty of any kind. MICRON TECHNOLOGY, INC. 
("MTI") EXPRESSLY DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO, NONINFRINGEMENT OF THIRD PARTY
RIGHTS, AND ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS
FOR ANY PARTICULAR PURPOSE. MTI DOES NOT WARRANT THAT THE
SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE OPERATION OF
THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. FURTHERMORE,
MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR THE
RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS,
ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT
OF USE OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO
EVENT SHALL MTI, ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE
LIABLE FOR ANY DIRECT, INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR
SPECIAL DAMAGES (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS
OF PROFITS, BUSINESS INTERRUPTION, OR LOSS OF INFORMATION)
ARISING OUT OF YOUR USE OF OR INABILITY TO USE THE SOFTWARE,
EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
Because some jurisdictions prohibit the exclusion or limitation
of liability for consequential or incidental damages, the above
limitation may not apply to you.

Copyright 2005 Micron Technology, Inc. All rights reserved.
Getting Started:
----------------
Unzip nand_model.zip to a folder.
Point your simulator to the folder where you located the files.
At the ModelSim command prompt, type "do tb.8.do" or "tb.16.do", 
for the x8 and x16 models respectively.

File Descriptions:
------------------
nand_model_0.v        --nand model 
parameters.v        --File that contains all parameters used by the model
readme.txt          --This file
tb.v                --Test bench
tb.do               --File that compiles and runs the above files

Dual Die File Descriptions:
------------------
top.v               --Wrapper to combine two dual die models into one quad die model
nand_model_1.v      --nand model #2
tb_dual8.do         --File that compiles and runs the above files
tb.do               --File that compiles and runs the above files
tb_dual.v           --Dual die test bench

Defining Voltage:
--------------------------
Only 3.3V parts do Power On Auto Read, selected by the PRE pin.
Thus, the only valid define associated with voltage is V33, or
the absense of this define.

The following is an example of defining the organization using the 
ModelSim simulator.

    vlog +define+V33 nand_model.v

Defining the Organization:
--------------------------
The verilog compiler directive "`define" may be used to choose between 
multiple organizations supported by the model.  Valid 
organizations include "x16" and "x8", and are listed in the 
parameters.v file.  The organization is used to select the port sizes 
of the model.  The following is an example of defining the organization 
using the ModelSim simulator.

    vlog +define+x16 nand_model.v

All combinations of speed grade and organization are considered valid 
by the model even though a Micron part may not exist for every 
combination.

Allocating Memory:
------------------
A set associative array has been implemented to reduce the amount of 
static memory allocated by the model.  The number of 
entries in the array is controlled by the num_row 
parameter, and is equal to (num_row*num_col), it helps to think of rows
as pages.  So a block would be 64 pages or rows.  For example, if the 
num_row parameter is equal to 128, the array will be 
have 128 pages (two blocks).   Directly edit this paramater in the
paramater.v file.

It is possible to allocate memory for every address supported by the 
model by using the verilog compiler directive "`define FULL_MEM".
This procedure will improve simulation performance at the expense of 
system memory.  The following is an example of allocating memory for
every address using the ModelSim simulator.

	vlog +define+FullMem nand_model.v
