------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001-2002 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
------------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           :readme.txt,v
--  File Revision       :1.4
--
--  Release Information :ADK_REL1v1
--  
------------------------------------------------------------------------------

Also see ADK Release Notes for release information on EASY Software.


0 Quick Start
==============

It is intended that the EASY software is built as part of the process of 
simulating an EASY testbench. However, the software alone may be built.


0.1 Windows platform
--------------------
- Load the ADS CodeWarrior project file EASY.mcp, into CodeWarrior

- Select the desired target from the pull-down menu

- From the Project menu, select Make (or click on the Make icon)


0.2 Unix platform
-----------------
- Set up the ARM Developer Suite
- Set up the required environment variables:

    ADSCODE must point to:
     /path_to_install/ARM_ADK_<release>/ADScode

    TEST_NAME_ROM must be set to one of:
      easy_7_hw
      easy_7_it
      easy_92_hw
      easy_92_it

-Issue the following commands:

  cd $ADSCODE/build
  make



1 EASY Example Application Code
===============================
Two examples of application code are provided, which run on the ARM processor
model in an EASY system:

- the first example performs integration testing of the EASY system,
- the second is a simple "Hello World" demonstration.

The applications use the same system initialization code.

The purpose of the integration test application is to confirm that the EASY 
system integration has been successful. Connections between blocks are 
verified and EASY system peripherals are accessed. Other aspects of system 
operation, such as remapping, watchdog reset, and exception handling are also 
tested.

Note: Full functional operation of each block is not verified.

If you modify the EASY system, it should not be difficult to modify the 
integration test code to match the new system.

The purpose of the "Hello World" application is to demonstrate the basic 
operation of the simulation environment and indicate that no fundamental 
errors have been made during the preparation and compilation of the HDL.

The applications are written mainly in 'C', with some assembler files. 
The code is compiled into ARM native binary format, then converted into a 
memory image which is read in by the HDL test bench.

2 Building the Application
==========================


2.1 Directories
---------------

build           - Contains ADS project file (EASY.mcp), the top level
                  makefile, and scatter loading description files.

build/EASY_Data/<target>
                - Data directory. At the end of a successful build, this 
                  directory will contain the ROM image (rom0, rom1, rom2, 
                  rom3), and the executable image (.axf).

build/EASY_Data/<target>/ObjectCode
                - Object code directory. Contains the makefile and object code
                  for <target>.

common          - Files that are common to both the Integration Test 
                  application and the "Hello World" demonstration, files such 
                  as initialization code and memory map control.

helloworld      - Contains C code for "Hello World" demonstration

memory_ctrl     - Contains C and assembler code for memory management using an
                  MMU/PU, caches, and write buffers.

peripherals     - Files defining peripheral registers 

test_app        - Contains C and assembler code for the integration test 
                  application


2.2 Files
---------
Files relating to building the software are located in the build directory:

EASY.mcp        - Code Warrior project file.
makefile        - Make file (for Unix)
StdMakefile.mk  - Make include file
<target>.scf    - Scatter loading description file for the target <target>.


2.3 Targets
-----------
The EASY software application code can be built to run on different EASY 
systems. Each combination of application code and EASY system is a target, 
and has the following:

- a data directory
- and object code directory
- a scatter loading description file.

Currently supported targets are:

easy_92_it      - Integration Test application on ARM922T EASY (EASY_ML)
easy_92_hw      - "Hello World" demonstration  on ARM922T EASY (EASY_ML)
easy_7_it       - Integration Test application on ARM7TDMI EASY (EASY_ARM7)
easy_7_hw       - "Hello World" demonstration on ARM7TDMI EASY (EASY_ARM7)


2.4 ROM image
-------------

The ARM fromELF utility is used to convert the executable image to hex data 
file format for loading into an HDL simulator.


2.5 Unix platform
-----------------
The example code can be built by executing the top-level makefile in the 
build directory 

The makefiles require environment variables to determine the target and the 
location of the EASY software. These are set up as part of the ADK system 
initialization.

The makefiles are designed to work with Solaris make and gnumake.

The file StdMakefile is included by all other makefiles.


2.6 Windows platform
--------------------
An ADS CodeWarrior project file (EASY.mcp) can be used to build the software 
on a Windows Platform. EASY.mcp supports several targets and enables either 
the Integration Test application or the "Hello World" demonstration to be 
built for a particular EASY system.

The CodeWarrior project uses the Post Linker facility to run the ARM fromELF
utility as the final step in the link process.


2.7 Cleaning the ADScode area
-----------------------------
The top level makefile has a target called clean. Issuing the command 
"make clean" the the build directory will remove the object files (.o), the 
executable image (.axf), and the ROM image files (rom*) for the EASY target
currently specified.

Note: The environment variables that determine the target and the location of 
the EASY software must be set up before the "make clean" command is issued.


2.8 Code generation options
---------------------------
When adding your own code to the EASY application software, be aware that the 
compiler/linker flags specified in StdMakefile.mk do not specify ARM/Thumb 
interworking and that no floating-point option is specified.

If you need to support ARM?Thumb interworking or use floating-point 
architecture, the compiler/linker flags must be changed.


2.9 Tool versions
-----------------
The code has been designed to be built using ADS 1.1 or later. It is not 
possible to build the code using any version of SDT.



3 Memory Map
============

The ADK address map is as follows:


               Normal          Reset
  Address    Memory Map     Memory Map

0xFFFFFFFF +-----------+  +------------+
           | Interrupt |  |  Interrupt |
           |Controller |  | Controller |
0xF0000000 +-----------+  +------------+
           |  Unused   |  |   Unused   |
0xE0000000 +-----------+  +------------+           APB              Address
           |  Retry    |  |   Retry    |         Peripheral
0xD0000000 +-----------+  +------------+-------+-----------------+ 0xD0000000
           |   APB     |  |    APB     |       |   Example APB   |
           |Peripherals|  | Peripheral |       |     Slave       |
0xC0000000 +-----------+  +------------+       +-----------------+ 0xCF000000
           |           |  |            |\      |     Unused      |
           |           |  |            | \     +-----------------+ 0xC9000000
           |  Unused   |  |   Unused   |  \    |  Remap & Pause  |
           |           |  |            |   |   +-----------------+ 0xC8000000
0x80000000 +-----------+  +------------+   |   |Unused (reserved |
           | Internal  |  |  Internal  |   |   |  for extra GPIO)|
           |  Memory   |  |   Memory   |   |   +-----------------+ 0xC5000000
0x70000000 +-----------+  +------------+   |   |     GPIO        |
           |           |  |            |   |   +-----------------+ 0xC4000000
           |           |  |            |   |   |Unused (reserved |
           |  Unused   |  |   Unused   |   |   |    for extra    |
           |           |  |            |   |   |      Timers)    |
0x40000000 +-----------+  +------------+   |   +-----------------+ 0xC3000000
           | External  |  |  External  |   |   |     Timers      |
           |  Static   |  |   Static   |   |   +-----------------+ 0xC2000000
           |  Memory   |  |   Memory   |   |   |    Watchdog     |
0x30000000 +-----------+  +------------+   |   +-----------------+ 0xC1000000
           |           |  |            |    \  |Unused (reserved |
           |  Unused   |  |   Unused   |     \ |  for system     |
           |           |  |            |      \|   controller)   |
0x10000000 +-----------+  +------------+       +-----------------+ 0xC0000000
           |  Unused   |  |   Unused   |
           |(reserved  |  | (reserved  |
           | for SDRAM)|  | for SDRAM) |
0x00100000 +-----------+  +------------+
           | Internal  |  |  External  |
           |  Memory   |  |  Static    |
           |   Alias   |  |Memory Alias|
0x00000000 +-----------+  +------------+


3.1 Remap
---------
On reset, an aliased copy of the ROM appears at 0x00.
Following reset, this alias of the ROM can be removed so that RAM appears at 
address 0x00 by writing to Remap register in the Remap Pause Controller.


3.2 Scatter loading
-------------------
The locating of the application code and data to match the memory map is 
controlled using armlink's scatter loading mechanism. This uses a text file 
description of where each block of code and data should be located in memory, 
both at reset and then during normal execution. 

The scatter loading description files are contained in files with the
extension .scf, in the build directory.


3.3 MMU translation table
-------------------------
The application code for EASY systems based on a processor model with a Memory
Management Unit (MMU), for example the ARM922T, use a Translation Table to
control the MMU. This Translation Table is stored in memory and determines:

- Virtual to physical address mapping
- Memory access permissions
- Use of caches and buffers

The Translation Table contains only section descriptors, which describe how
each 1MB address range is mapped.

A flat Translation Table is used, that is virtual and physical addresses are 
the same.

MMU accesses are primarily controlled through the use of domains. All 
sections are associated with a single domain. The access control bits for 
this domain are set for Client Access, which means that accesses are checked 
against the access permission bits in the Translation Table descriptors.

Unused sections of the memory map have their access permission bits set to 
No Access. All other sections have their access permission bits set to allow
read/write access in both Supervisor and User modes.

The section of memory map containing the external ROM is marked as 
read-through cacheable. The rest of the accessible memory map is marked as 
being non-cachable and non-bufferable.



4.0 Application Overview
========================

For more detailed information refer to the ADK User Guide.


4.1 Initialization
------------------
The the initialization code, exception vector table, and retargeting of low 
level I/O are common to the Integration Test application and the Hello World 
demonstration. The following functions are performed:

- Reset vector
- Address remapping
- Initialization of stack pointers and memory system
- Enabling interrupts


4.2 Memory System
-----------------
If the EASY system has a processor model with a MMU or PU, it is configured 
and enabled by code contained in the memory_ctrl directory. This code also 
enables the caches.


4.3 Peripherals
-----------------
The files containing the peripheral installations are located in the 
"peripherals" directory.


4.4 Low Level I/O
-----------------
The Tube is used to pass system messages from a test application to the 
simulator display and a text file. The text file is called "Tube.txt" and is 
located in the directory in which the simulator is invoked.

In order to do this, a retarget layer for the low level I/O function fputc() 
is implemented. If required, you may also implement your own target dependent
I/O functions such as ferror().


4.5 Exception Handlers
----------------------
In the example applications, a default handler is installed in each exception
vector at initialization. This default handler simply reports that an 
unexpected exception has occurred and  exits the application.

Where the example applications use exceptions, a new exception handler is 
installed at the appropriate exception vector. This is possible as the 
exception vector table is located in RAM.


4.6 Integration Test
--------------------

The integration tests specifically test the following EASY system components:

 - Interrupt Controller
 - Remap and Pause Controller
 - Example APB Slave
 - Watchdog Unit
 - Dual Input Timer
 - Memory Models
 - PrimeCell GPIO
 - ARM Processor Exception Handling
 - Example AHB Master and File Reader (EASY_ML only)


4.7 Hello World Demonstration
-----------------------------

The Hello World demonstration simply prints out "Hello World" to the Tube.


5 Supporting New EASY Components
================================

See the section "Supporting New EASY Components" in the ADK User Guide for 
guidelines on how to add software support for new EASY system components. 
