------------------------------------------------------------------------
   Copyright (c) 2001-2003 CAST, Inc.

   Please review the terms of the license agreement before using this
   file.  If you are not an authorized user, please destroy this source
   code file and notify CAST immediately that you inadvertently received
   an unauthorized copy.
------------------------------------------------------------------------

  Project       : PCI-M64AHB

  File          : readme.txt

  Description   : PCI-M64AHB RTL Source Deliverables 

  Designer      : AS

  QA Engineer   : 

  Creation Date : 17-September-2003

  Last Update   : 24-November-2003

  Version       : 1.0.1V
------------------------------------------------------------------------


Supplied files
--------------

                                   
.\doc\        - documentation
	cast_pci-m64ahb_ug.pdf 		- PCI-M64AHB User's Guide

.\scripts\    - synthesis and simulation scripts
	compile_mti		- ModelSim simulation script for example1 testbench
	wave_mti.do		- ModelSim Waveform script for example1 testbench
	exemplar_virtex2.tcl	- Example synthesis script for Exemplar Leonardo Spectrum
	synopsys.scr		- Design Compiler sample synthesis script 

.\src\        - source files  

	\m64core\  - PCI-M64 Core source files
		pci_barreg.vhd		- Base Address Register (BAR)
		pci_cead.v		- AD output FFs clock enable
		pci_cfgebar.v		- Expansion ROM BAR
		pci_cfgspace.vdh	- Configuration space top level entity
		pci_gclkbuf.v		- PCI clock buffer
		pci_genack64.v		- ACK64# generator
		pci_gendevsel.v		- DEVSEL# generator
		pci_genframe.v		- FRAME# generator
		pci_genirdy.v		- IRDY# generator
		pci_genotad.v		- AD lines tri-state control 
		pci_genotcbe.v		- C/BE lines tri-state control
		pci_genpar64.v		- parity generator
		pci_genreq64.v		- REQ64# generator
		pci_genstop.v		- STOP# generator
		pci_gentrdy.v		- TRDY# generator
		pci_chkpar64.v		- parity checker
		pci_ibuf.v		- PCI input buffer
		pci_iobuf.v		- PCI bidirectional buffer
		pci_m64_package.v	- core parameter constants (template)
		pci_m64core.v		- Core top level entity
		pci_mtfsm64.v		- Core control FSM
		pci_obuf.v		- PCI output buffer
		pci_obuft.v		- PCI output tri-state buffer
		pci_obufoc.v		- PCI output buffer - open collector

	\ahb\   - AHB Interface source files
		dma64_fiforam.v		- RAM used in FIFOs
		dma64rdfifo.v		- Read FIFO
		dma64wrfifo.v		- Write FIFO
		dma64regs.v		- DMA registers
		dma64txctrl.v		- DMA control
		dma64ahb.v		- DMA core top level entity
		ahbmaster.v		- AHB Master
		ahbslave.v		- AHB slave
		fifo_async.v		- Asynchronous FIFO
		fifosram.v		- Asynchronous dual-port RAM
		intctrl.v		- Interrupt controller
		mailbox.v		- Mailbox
		mailboxblk.v		- Mailbox set
		mt64ahb.v		- AHB bridge module
		pci_m64_params.v	- Core parameters
		pcim64ahb.v		- PCI-M64AHB core
		pcim64ahbw.v		- PCI-M64AHB core I/O wrapper
		psync.v			- asynchronous clock domain pulse sync.
		t64ahb.v		- PCI-AHB target controller

.\tb\         - testbench files
	pci64_package.v			- PCI constants
	pci64_busmonitor.v		- Bus monitor
	pci_arbiter_model.v		- PCI bus arbiter
	pci_master64model.v		- PCI master simulation model
	pci_target64model.v		- PCI target simulation model
	ahbslaveram_model.v		- AHB Slave RAM model
	pcim64ahbw_tb.v			- testbench 
	ram_burst.vec                   - simulation vector file 
	t64_t1.vec			- simulation vector file
	t64_t2.vec			- simulation vector file
	pci_m64.sim.log			- simulation log file
	bus_monitor.log			- bus monitor logfile
	t64_t1.log			- simulation log file
	t64_t2.log			- simulation log file


Simulation Notes
----------------
   The simulation scripts should be invoked from the tb directory or a parallel directory to tb.
   Please ensure to copy the vector files to the same directory where the simulation scripts
   are invoked.


Support
-------
   Although every effort has been made to ensure that this core functions
   correctly, if a problem is encountered please contact CAST:
 
      Technical Support Hotline: +1-201-391-8300
      Fax: +1-201-391-8694
      E-mail: support@cast-inc.com
 
