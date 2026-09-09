;/***************************************************************************
; * Copyright © ARM Limited 1998.  All rights reserved.
; ***************************************************************************/


	TTL     Memory map for target-specific MMU initialisation    > memmap.s
	; ---------------------------------------------------------------------
	; This file provides the memory map table for MMU initialisation 
	; for the Integrator boards. The SETUP_MMU macro references this
	; table to build the TLBs on power-up.
	;
	; $Revision: 1.11 $
	;   $Author: asims $
	;     $Date: 1999/10/18 13:32:13 $
	;
	; Copyright ARM Limited, 1998.
	; All Rights Reserved
	;

	INCLUDE bits.s
	INCLUDE sizes.s
	INCLUDE	platform.s
	INCLUDE	mmu_h.s
	INCLUDE	mmumacro.s

	; Note: Table must end with all zeros
	; WindowsCE uses a table of the same format, but without the access
	; word. If OEMAddressTable exists, but uHAL_Level1Table doesn't, the
	; MMU setup code should use the truncated format.
	;
	; MMU Mapping tables of the format:
	;
	; Virtual Address, Physical Address, Access Permissions, Area Size
	; Level 2 areas are more complex to define: 
	; Virt Addr, L2 Table & type, Phys Addr + L2 Access Perms, Area Size

	AREA    |C$$code$$__mmutable|, CODE, READONLY

	LTORG

	IMPORT	Level2tab_ROM

	EXPORT	uHAL_AddressTable	; Address map for MMUs
	EXPORT	uHAL_MappingTable	; Mapping for MPUs

uHAL_MappingTable

	; Define MPU regions/areas
	; Format is region number, base address, size and access permissions
	DCD	0,          0,   MPU_SZ_4G, IO_ACCESS
	DCD	1,          0, MPU_SZ_256M, DRAM_ACCESS
	DCD	2, 0x20000000, MPU_SZ_128M, FLASH_ACCESS

	DCD	0,	0,	0,	0	; End of Table (MUST BE ZEROS!)


uHAL_AddressTable

	; NOTE: DRAM size isn't used for Integrator. SETUPMMU expects the DRAM
	;	entry to be the first value in the table and uses the auto
	;	memory setup size.

 IF :LNOT: :DEF: ARM7T

	; Map RAM 1-1 from DRAM_BASE, cachable & bufferable
	DCD	INTEGRATOR_SSRAM_BASE, INTEGRATOR_SSRAM_BASE, DRAM_ACCESS, SZ_256M

	; Level 2 areas are more complex to define: 
	; Virt Addr, L2 Table & type, Phys Addr + L2 Access Perms, Area Size
	DCD	EPROM_BASE, Level2tab_ROM + EPROM_PAGE
	DCD		EPROM_BASE + EPROM_ACCESS, EPROM_SIZE

	; Configure Flash space (1 to 1 mapping)
	DCD	FLASH_BASE, FLASH_BASE,	FLASH_ACCESS, SZ_32M

	; Configure Integrator CSR section accesses 
	DCD	INTEGRATOR_CSR_BASE, INTEGRATOR_CSR_BASE, IO_ACCESS, INTEGRATOR_CSR_SIZE

	; PCI spaces
	DCD	PCI_V3_BASE, PCI_V3_BASE, IO_ACCESS, SZ_1M
	DCD	PCI_CONFIG_BASE, PCI_CONFIG_BASE, IO_ACCESS, SZ_16M
	DCD	PCI_MEM_BASE, PCI_MEM_BASE, IO_ACCESS, SZ_512M
	DCD	PCI_IO_BASE, PCI_IO_BASE, IO_ACCESS, SZ_16M

	; Motherboard SSRAM
	DCD     INTEGRATOR_MBRD_SSRAM_BASE, INTEGRATOR_MBRD_SSRAM_BASE
	DCD             DRAM_ACCESS, INTEGRATOR_MBRD_SSRAM_SIZE

	; Angel is linked to run from the top 64K of DRAM space.
	DCD	INTEGRATOR_SSRAM_BASE+SZ_256M-SZ_64K, INTEGRATOR_SSRAM_BASE+SZ_256M-SZ_64K
	DCD		DRAM_ACCESS, SZ_64K

	; Make DRAM alias areas and logic modules all IO_ACCESS.
	DCD	INTEGRATOR_SDRAM_ALIAS_BASE, INTEGRATOR_SDRAM_ALIAS_BASE
	DCD		IO_ACCESS, SZ_1G

	DCD	INTEGRATOR_LOGIC_MODULES_BASE, INTEGRATOR_LOGIC_MODULES_BASE
	DCD		IO_ACCESS, SZ_1G


 ENDIF
	DCD	0,	0,	0,	0	; End of Table (MUST BE ZEROS!)

	END