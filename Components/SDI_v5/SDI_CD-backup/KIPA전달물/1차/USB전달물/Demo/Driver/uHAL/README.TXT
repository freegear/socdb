Copyright (C) ARM Limited 1999,2000. All rights reserved.

Software for ARM uHAL library
=============================

History:
========

version 1.0:	16th July 1999
version 1.1:	7th February 2000

This README introduces the software for the ARM uHAL library.
For a much more detailed description, see the ARM Firmware Suite
Reference Guide.

1. Building the Software
========================

General:

This software can either built to load and run under ARM's remote
debuggers, Angel/Multi-ICE as semihosted images or blown into flash
as standalone images.  Use the ARM Flash Utility to program images
into flash.

Building Using GNU Make:

The board specific build files are in

	uHAL/Build/<board-name>.b/makefile.

These include a board definition file 
	
	uHAL/Build/<board-name>.b/board.in.

Building using ARM Project Manager:

The project files are in the board specific directory:

	uHAL/Build/<board-name>.b/uHALlibrary.apj

Building using ARM Developer Suite:

The project files are in the board specific directory:

	uHAL/Build/<board-name>.b/uHALlibrary.mcp

2. Supported Platforms
======================

The following platforms are supported:

	Integrator (ARM7TDMI, ARM720T, ARM740T, ARM920T, ARM966T
		and ARM940T)
	Prospector (SA-1100)
	PID (ARM7TDMI, ARM740T, ARM940T)

3. Revision Details
===================

This is version 1.1 of uHAL.

4. Warnings
===========

See RELNOTES.TXT




