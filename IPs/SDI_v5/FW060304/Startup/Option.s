;**********OPTIONS*******************************
;_RAM_STARTADDRESS  EQU   0x01ff0000 ; SRAM 24kB - 0x01ff0000~0x01ff5fff
_ISR_STARTADDRESS  EQU   0x01ff5f60 ;


;BUSWIDTH; 16,32
                GBLA    BUSWIDTH
BUSWIDTH	SETA    16


;"DRAM","SDRAM"
                GBLS    BDRAMTYPE
BDRAMTYPE	SETS    "SDRAM"


;This value has to be TRUE on ROM program.
;This value has to be FALSE in RAM program.
                GBLL    PLLONSTART
PLLONSTART      SETL    {TRUE}

	GBLA	PLLCLK
; Edit your code.   2006/02/27
;;;;;;;;;;;;;;;;;;;



;************************************************
	END