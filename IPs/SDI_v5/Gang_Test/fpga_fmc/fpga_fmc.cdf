/* Quartus II Version 4.2 Build 157 12/07/2004 SJ Full Version */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(EPXA10) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(EPC2) Path("") File("fpga_fmc.pof") MfrSpec(OpMask(1));
	P ActionCode(Cfg)
		Device PartName(EPC2) Path("") File("fpga_fmc_1.pof") MfrSpec(OpMask(1));
	P ActionCode(Cfg)
		Device PartName(EPC2) Path("") File("fpga_fmc_2.pof") MfrSpec(OpMask(1));
	P ActionCode(Cfg)
		Device PartName(EPC2) Path("") File("fpga_fmc_3.pof") MfrSpec(OpMask(1));
	P ActionCode(Cfg)
		Device PartName(EPC2) Path("") File("fpga_fmc_4.pof") MfrSpec(OpMask(1));
	P ActionCode(Cfg)
		Device PartName(EPC2) Path("") File("fpga_fmc_5.pof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
