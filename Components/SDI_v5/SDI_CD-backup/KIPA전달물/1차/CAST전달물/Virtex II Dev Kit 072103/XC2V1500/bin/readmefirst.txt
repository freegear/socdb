#readmefirst.txt

The bin folder contains two different sets of bit files for the DDR SDRAM test, the HG and the HDG.  The HG file should be used if the MT8VDDT1664HG module is populated and the HDG file should be used with the MT8VDDT1664HDG module.

The MPM file programmed into the System ACE MPM device uses the bit file that corresponds to the DIMM module that was installed.  If the user erases the System ACE device, the MPM file in the "bin" folder has the HDG bit file programmed at address 0x4 and the HG file at address 0x5.  Set the System ACE address on the board to point to the file version corresponding to the DIMM module installed. (Check the underside of the DIMM module for the part number by removing the DIMM module, be sure the module fits securely in the socket when re-installing).  The correct bit file could be determined by process of elimination if the user does not wish to remove the DIMM module (memory test will fail if wrong bit file is used).

