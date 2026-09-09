[README]

* History
- SkyWalker50_20060922-v0.1
	Just configuration & File name change
	(
		Vender	: SMT
		Chip	: SMT926 or SMT926A
		Platform: SKYWALKER
	)

	SMDK2440 2440		-> SKYWALKER

	S3C2440 / SC2440	-> SMT926

- SkyWalker50_20060926-v0.2
	v0.1 -> Function & variable name change
	S3C2440 / SC2440	-> SMT926
	24400 / S2440		-> SMT
	SMDK2440			-> SKYWALKER

	* ROM image 생성 키 위해 임시 처리한 부분
	1. SkyWalker50\Src\Kernel\
		KernKitl\
		KERNKITLPROF\
		-> sources
		: TARGETLIBS macro에서 kitlUSBSer_lib.lib delete (임시적으로)
	2. SkyWalker50\Src\Kernel\oal\
		kitl.c
		kitlusbser.c
		-> kitlUSBSer_lib.lib의 function call commnet함 (임시적으로)
	3. SkyWalker50\Src\Common\KitlUsbSer\
		kitlusbser_lib.lib
		kitlusbser_lib.pdb
		-> Delete (임시적으로)
	
	* 결국 kitlUSBSer_lib.lib에 대한 문제 해결해야
	추후 분석 후 해결 요망

- SkyWalker50_20060929-v0.3
	v0.2 -> SkyWalker register mapping
	PUBLIC\COMMON\OAK\CSP\ARM\SMT\SMT926A\Inc\
	header files modify with SkyWalker register map

- SkyWalker50_20060929-v0.4
	v0.3 -> PLATFORM directory modify
	PUBLIC\COMMON\OAK\CSP\ARM\SMT\SMT926A\Timer\timer.c modify
	PUBLIC\SkyWalker50\Src\Drivers\LAN91C111 directory add
	Relative files modify

- SkyWalker50_20061010-v0.5
	v0.4 -> PLATFORM\SkyWalker50 BSP directory modify
	source file (C & Header & Inc file C-level 수정)
	
	Further work (2006/10/10)
	(PLATFORM\SkyWalker50\ directory)
	Ebootloader\eboot\ & Ebootloader\stepldr\ & kernel\oal\ startup.s
	MMU & cache manipulate function
	OAL layer function
	Register level F/W
	Configuration files (.bib / .reg)

- SkyWalker50_20061023-v0.6-pre
	v0.5 -> PLATFORM\COMMON\SRC\ARM\SMT\SMT926A\ directory modify
		 -> PLATFROM\SkyWalker50 BSP directory modify
		 (1. bootloader & kernel startup code
		  2. MMU manipulation
		  3. OAL layer function)

	Further work (2006/10/23)
		Page tables
		Configuration files (.bib / .reg)

- SkyWalker50_20061023-v0.6
	v0.6-pre -> Serial & Ethernet driver added
			 -> Refer to
			 		README_SkyWalker50_EthernetDriver_v0.1.txt
			 		README_SkyWalker50_SerialDriver_v0.1.txt

- SkyWalker50_20061023-v0.7
	v0.6	-> Display driver added
		PUBLIC\COMMON\OAK\CSP\ARM\SMT\SMT926A\DISPLAY\ directory modify
		PLATFORM\SkyWalker50\Cesysgen
							\Files
		-> Modified platform.reg file
* v0.7 부터는 FPGA version을 naming 한다.
즉, SkyWalker50-FPGAv0.1로 한다.