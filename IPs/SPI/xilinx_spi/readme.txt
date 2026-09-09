**************************************************************************************************************************
Readme File for "Confuguring Xilinx FPGAs with SPI Flash Memories using CoolRunner-II CPLDs" Customer Pack

Created: 3/2/2004  JRH

**************************************************************************************************************************
**************************************************************************************************************************
DISCLAIMER
**************************************************************************************************************************
THIS DESIGN IS PROVIDED TO YOU "AS IS". XILINX MAKES AND YOU RECEIVE NO WARRANTIES OR 
CONDITIONS, EXPRESS, IMPLIED, STATUTORY OR OTHERWISE, AND XILINX SPECIFICALLY DISCLAIMS ANY 
IMPLIED WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR 
PURPOSE. This design should be used only as an example design, not as a fully functional core. 
XILINX does not warrant the performance, functionality, or operation of 
this Design will meet your requirements, or that the operation of the Design 
will be uninterrupted or error free, or that defects in the Design will be corrected. 
Furthermore, XILINX does not warrant or make any representations regarding use or 
the results of the use of the Design in terms of correctness, accuracy, reliability or otherwise. 

THIRD PARTIES INCLUDING MOTOROLA MAY HAVE PATENTS ON THE SERIAL PERIPHERAL INTERFACE ("SPI") 
BUS.  BY PROVIDING THIS HDL CODE AS ONE POSSIBLE IMPLEMENTATION OF THIS STANDARD, XILINX IS 
MAKING NO REPRESENTATION THAT THE PROVIDED IMPLEMENTATION OF THE SPI BUS IS FREE FROM ANY 
CLAIMS OF INFRINGEMENT BY ANY THIRD PARTY.  XILINX EXPRESSLY DISCLAIMS ANY WARRANTY OR 
CONDITIONS, EXPRESS, IMPLIED, STATUTORY OR OTHERWISE, AND XILINX SPECIFICALLY DISCLAIMS ANY 
IMPLIED WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR 
PURPOSE. THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTY OR 
REPRESENTATION THAT THE IMPLEMENTATION IS FREE FROM CLAIMS OF ANY THIRD PARTY.  
FURTHERMORE, XILINX IS PROVIDING THIS REFERENCE DESIGNS "AS IS" AS A COURTESY TO YOU.

**************************************************************************************************************************
File Contents
**************************************************************************************************************************
This zip file contains the following folders:

	\work		-- XST and ModelSim compiled VHDL files

	-- VHDL Source Files:
		STMicroelectronics M25020 simulation files:		
			ACDC_check.vhd
			Internal_Logic.vhd
			M25P20.vhd
			mem_util_pkg.vhd
			Memory_Access.vhd
		
		CPLD files:
			spi_cpld.vhd		- Main state machine
			varcount.vhd		- Variable bit width up counter
			spi_cpld_timesim.vhd	- Post fit timing simulation file
					
		init.txt		- SPI Memory contents initialization file
					
	-- VHDL Testbench Files:
		spi_tb.vhd		- testbench for the SPI interface

	-- ModelSim DO files:	
		func_sim.do		- functional simulation script file
		wave_func.do		- configures wave window for functional simulation
		post_sim.do		- post-fit simulation script file 
		wave_post.do		- configures wave window for post-fit simulation

	-- Xilinx Project Navigator Files
		spi_cpld.npl		- SPI interface design file
		spi_cpld.cxt		- XPower design input file
		spi_cpld.jed		- Programming file for XC2C32-4-VQ44
		spi_cpld.rpt		- Device utilization report file
		spi_cpld.ucf		- User Constraints File
	
	-- Xilinx Software Utilities
		x_spi.exe		- x_spi(tm) Version 1.08 (c) 2003-2004 Xilinx, Inc.
					  Xilinx SPI Programming Utility
		xmcsutil.exe		- xxmcsutil(tm) Version 1.07 (c) 2001-2004 Xilinx, Inc.
					  Xilinx MCS/HEX Byte Data Utility
					  
	-- Other Files
		readme.txt		- This file
		readme.doc		- The contents of this file formatted for Microsoft Word
**************************************************************************************************************************
Design Notes
**************************************************************************************************************************
The CoolRunner-II "Confuguring Xilinx FPGAs with SPI Flash Memories using CoolRunner-II CPLDs" reference design is based
upon the STMicroelectronics SPI Flash memory M25P20.  All simulation files for this device were downloaded from the 
STMicroelectronics website located at http://www.st.com/stonline/products/families/memories/fl_ser/snvm_fo.htm

This design can be easily modified to support other families of SPI Flash memories.  Included in the source code 
spi_cpld.vhd is a list of other memories and their associated instructions for your convenience.

Please also note that portions this design have been verified using actual hardware, whereas others were verified through 
simulations only.

**************************************************************************************************************************
Technical Support
**************************************************************************************************************************
Technical support for this design and any other CoolRunner CPLD issues can be obtained as follows:

North American Support
(Mon,Tues,Wed,Fri 6:30am-5pm  
  Thr 6:30am - 4:00pm Pacific Standard Time)
Hotline: 1-800-255-7778 
or (408) 879-5199 
Fax: (408) 879-4442 
Email: hotline@xilinx.com 
 
United Kingdom Support
(Mon,Tues,Wed,Thr 9:00am-12:00pm, 1:00-5:30pm
  Fri 9:00am-12:00pm, 1:00-3:30pm)    
Hotline: +44 1932 820821
Fax: +44 1932 828522 
Email : ukhelp@xilinx.com 
 
France Support
(Mon,Tues,Wed,Thr,Fri 9:30am-12:30pm, 2:00-5:30pm)
Hotline: +33 1 3463 0100 
Fax: +33 1 3463 0959
Email : frhelp@xilinx.com 
 
Germany Support
(Mon,Tues,Wed,Thr 8:00am-12:00pm, 1:00-5:00pm, 
   Fri  8:00am-12:00pm, 1:00pm-3:00pm)
Hotline: +49 89 991 54930 
Fax: +49 89 904 4748 
Email : dlhelp@xilinx.com 
 
Japan Support
(Mon,Tues,Thu,Fri  9:00am -5:00pm ()
 Wed    9:00am -4:00pm)
Hotline: (81)3-3297-9163
Fax:: (81)3-3297-0067
Email: jhotline@xilinx.com
