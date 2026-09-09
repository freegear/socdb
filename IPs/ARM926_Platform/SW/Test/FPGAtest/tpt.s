







	; alignment 2^14 for Translating Page Tables
	.align 14
	; SMC
	.word   smc
	










	; For SMC
smc:
	.word (0x00000000 + 0x0c1e)   ; AP : all access, c b: wirte back
	

    <slave start_addr="0x40000000" area_addr="0x800 00000" end_addr="0x80000000">DDRCtrl</slave>
    <slave start_addr="0x20000000" area_addr="0x30000000" end_addr="0x30000000">APB0</slave>
    <slave start_addr="0x30000000" area_addr="0x40000000" end_addr="0x40000000">APB1</slave>
    <slave start_addr="0x00000000" area_addr="0x10000000" end_addr="0x10000000">SMC</slave>
    <slave start_addr="0x10000000" area_addr="0x20000000" end_addr="0x20000000">IntSRAM</slave>



	; init domain register
	ldr r1, enable_all_domain
	mcr p15, 0,r1, c3, c0, 0
		
enable_all_domain:
	.word 0xffffffff