*****************************************************************
*           _   ___   _ ___    ___        _                     *
*          /_\ |_ _| | |_ _|  / __|_ _ __| |_ ___ _ __          *
*         / _ \ | | || || |   \__ \ ||(_-<  _/ -_) '  \         *
*        /_/ \_\___\__/|___| |___/\_,/__/\__\___|_|_|_|         *
*                                |__/                           *
*                                                               *
*              __  ______  ___   ___ ____ ____ ___              *
*             /  |/  / _ )/ _ | |_  / / // / // _ \             *
*            / /|_/ / _  / __ |/ __/_  _/_  _/ // /             *
*           /_/  /_/____/_/ |_/____//_/  /_/ \___/              *
*                                                               *
*                                                               *
*                MBA2440 Release Note CD v2.0                   *
*                       (2006. 3. 10)				*
*                 (http://www.aijisytem.com)                   	*
*****************************************************************


This file contains information on directory structure in the MBA2440 CD.
Each files or directories might be updated later. 

The latest files will be found in AIJI Systme Website.
( http://www.aijisystem.com or http://www.mculand.com)  

---------------------
Directory Structure
---------------------
	/documents		
		/datasheet	-- hardware device datasheets
		/manual		-- MBA2440 board manual
		/schemetic	-- MBA2440 schemetic file

	/firmware
		/nboot		-- nand boot loader source and image
		/test_program	-- MBA2440 test program source and image

	/UbiFOS			-- UbiFOS image only(not support source)

	/linux
		/application	-- RTC test application source and image
		/filesystem	-- cramfs, ramdisk file system image
		/kernel		-- linux 2.4.20 source and image
		/toolchain	-- cross compiler (gcc for ARM)
		/u-boot		-- u-boot source and image

	utility
		/Activesync	-- utility for WinCE (version 3.8)
		/devicefile	-- MBA2440 device file for spider and OPENice
		/DNW		-- serial console emulator
		/TFT4win	-- TFT server utility for Windows
		/USB_driver	-- USB driver

	WinCE5.0		-- WinCE 5.0 BSP and images



---------------------
Technical Support
---------------------
If you have any question, contact AIJI System 
 
  /* AIJI System Co., Ltd. */
    - Tel:   82-31-223-6611
    - Fax:   82-31-223-6613
    - email: openice@aijisystem.com
    - web:   www.aijisystem.com
             www.mculand.com

     
