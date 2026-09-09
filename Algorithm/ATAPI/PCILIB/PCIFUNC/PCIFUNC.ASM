;
; PCI functions for IBM-AT or compatible machine's with PCI BUS
;

;use  TASM.EXE V2.01 or later
;
;      TASM /jSMART /jJUMPS /uM520 /jLOCALS /m8 /t
;
.386p
CGROUP	GROUP _TEXT,TEXT

_TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
_TEXT ENDS

TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
     ASSUME  CS:CGROUP,DS:NOTHING,ES:NOTHING

;**************************
; Get PCI BIOS information
;
;unsigned int _pciGetSts(unsigned char *pciConfigMechanism,
;                        unsigned int *pciVersion,
;                        unsigned char *pciBusNumber,
;                        unsigned long int *pciSignature)
;
;       ì¸óÕ    AX	PCI Config Mechanism value store address
;               BX	PCI version value store address
;               CX	number of PCI Bus store address
;               DX	PCI Signature store address
;       èoóÕ    AX	=0:PCI BIOS call successful  !=0:PCI BIOS call faller
;       îjâÛ    None
;**************************
pciGetSts_ PROC C NEAR PUBLIC USES CX EDX SI

	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX

	MOV	AX,0B101h
	INT	1Ah

	POP	SI
	MOV	DS:[SI],EDX
	POP	SI
	MOV	DS:[SI],CL
	POP	SI
	MOV	DS:[SI],BX
	POP	SI
	MOV	DS:[SI],AL
	MOV	AL,AH
	XOR	AH,AH

	RET

pciGetSts_ ENDP

;**************************
; Get PCI BIOS information AX
;
;unsigned int _pciConfigVerison();
;
;       ì¸óÕ    none
;       èoóÕ    AX	return AX value of PCI function 01h
;       îjâÛ    None
;**************************
pciConfigVersion_ PROC C NEAR PUBLIC USES CX EDX

	MOV	AX,0B101h
	INT	1Ah
	RET

pciConfigVersion_ ENDP

;**************************
; Get PCI BIOS information BX
;
;unsigned int _pciBusVersion();
;
;       ì¸óÕ    none
;       èoóÕ    AX	return BX value of PCI function 01h
;       îjâÛ    None
;**************************
pciBusVersion_ PROC C NEAR PUBLIC USES CX EDX

	MOV	AX,0B101h
	INT	1Ah
	MOV	AX,BX
	RET

pciBusVersion_ ENDP

;**************************
; Get PCI BIOS information CL
;
;unsigned char _pciMaxBusNo();
;
;       ì¸óÕ    none
;       èoóÕ    CL	return CL value of PCI function 01h
;       îjâÛ    None
;**************************
pciMaxBusNo_ PROC C NEAR PUBLIC USES CX EDX

	MOV	AX,0B101h
	INT	1Ah
	MOV	AL,CL
	RET

pciMaxBusNo_ ENDP

;**************************
; Get PCI BIOS information EDX
;
;unsigned long int _pciSigPCI();
;
;       ì¸óÕ    none
;       èoóÕ    BX:AX	return EDX value of PCI function 01h
;       îjâÛ    None
;**************************
pciSigPCI_ PROC C NEAR PUBLIC USES CX EDX

	MOV	AX,0B101h
	INT	1Ah
	PUSH	EDX
	POP	AX
	POP	BX
	RET

pciSigPCI_ ENDP

;**************************
; Find PCI device
;
;unsigned long int _pciFindPciDevice(unsigned int vendorID,
;                                    unsigned int deviceID,
;                                    unsigned int index);
;       ì¸óÕ    AX      vendor ID
;               BX      device ID
;               CX      index
;       èoóÕ    BX	found PCI device address
;		AL      function return code
;       îjâÛ    None
;**************************
pciFindPciDevice_ PROC C NEAR PUBLIC USES CX DX SI

	MOV	SI,CX
	MOV	DX,AX
	MOV	CX,BX
	MOV	AX,0B102h
	INT	1Ah
	MOV	AL,AH
	XOR	AH,AH
	RET

pciFindPciDevice_ ENDP

;**************************
; Find PCI class
;
;unsigned long int _pciFindPciClass(unsigned char classCode,
;                                   unsigned char subClassCode,
;                                   unsigned char progIF,
;                                   unsigned int index);
;       ì¸óÕ    AL      Class code
;               BL      Sub class code
;               CL      Programming interface code
;               DX      index
;       èoóÕ    BX	found PCI device address
;		AL      function return code
;       îjâÛ    None
;**************************
pciFindPciClass_ PROC C NEAR PUBLIC USES ECX SI

	MOV	SI,DX
	MOV	CH,BL
	XOR	AH,AH
	PUSH	AX
	PUSH	CX
	POP	ECX
	MOV	AX,0B103h
	INT	1Ah
	MOV	AL,AH
	XOR	AH,AH
	RET

pciFindPciClass_ ENDP

;**************************
; Read PCI configuration register byte
;
;unsigned char _pciConfigReadByte(unsigned int BusDevFunc,
;                               unsigned int regNumber)
;       ì¸óÕ    AX      bit15..8 Bus number
;                       bit7..3  Device number
;                       bit2..0  Function number
;               BX      read register number
;       èoóÕ    AL	Read value
;       îjâÛ    None
;**************************
pciConfigReadByte_ PROC C NEAR PUBLIC USES CX DI

	MOV	DI,BX
	MOV	BX,AX
	MOV	AX,0B108h
	INT	1Ah
	MOV	AL,CL
	RET

pciConfigReadByte_ ENDP

;**************************
; Read PCI configuration register word
;
;unsigned int _pciConfigReadWord(unsigned int BusDevFunc,
;                          unsigned int regNumber)
;       ì¸óÕ    AX      bit15..8 Bus number
;                       bit7..3  Device number
;                       bit2..0  Function number
;               BX      read register number
;       èoóÕ    AX	Read value
;       îjâÛ    None
;**************************
pciConfigReadWord_ PROC C NEAR PUBLIC USES CX DI

	MOV	DI,BX
	MOV	BX,AX
	MOV	AX,0B109h
	INT	1Ah
	MOV	AX,CX
	RET

pciConfigReadWord_ ENDP

;**************************
; Read PCI configuration register double word
;
;unsigned long int _pciConfigReadLong(unsigned int BusDevFunc,
;                          unsigned int regNumber)
;       ì¸óÕ    AX      bit15..8 Bus number
;                       bit7..3  Device number
;                       bit2..0  Function number
;               BX      read register number
;       èoóÕ    BX:AX	Read value
;       îjâÛ    None
;**************************
pciConfigReadLong_ PROC C NEAR PUBLIC USES ECX DI

	MOV	DI,BX
	MOV	BX,AX
	MOV	AX,0B10Ah
	INT	1Ah
	PUSH	ECX
	POP	AX
	POP	BX
	RET

pciConfigReadLong_ ENDP

;**************************
; Write PCI configuration register byte
;
;void _pciConfigWriteByte(unsigned int BusDevFunc,
;                         unsigned int regNumber,
;                         unsigned char data)
;       ì¸óÕ    AX      bit15..8 Bus number
;                       bit7..3  Device number
;                       bit2..0  Function number
;               BX      register number
;               CL      write value
;       èoóÕ    None
;       îjâÛ    None
;**************************
pciConfigWriteByte_ PROC C NEAR PUBLIC USES DI

	MOV	DI,BX
	MOV	BX,AX
	MOV	AX,0B10Bh
	INT	1Ah
	RET

pciConfigWriteByte_ ENDP

;**************************
; Write PCI configuration register word
;
;void _pciConfigWriteWord(unsigned int BusDevFunc,
;                         unsigned int regNumber,
;                         unsigned int data)
;       ì¸óÕ    AX      bit15..8 Bus number
;                       bit7..3  Device number
;                       bit2..0  Function number
;               BX      register number
;               CX      write value
;       èoóÕ    None
;       îjâÛ    None
;**************************
pciConfigWriteWord_ PROC C NEAR PUBLIC USES DI

	MOV	DI,BX
	MOV	BX,AX
	MOV	AX,0B10Ch
	INT	1Ah
	RET

pciConfigWriteWord_ ENDP

;**************************
; Write PCI configuration register double word
;
;void _pciConfigWriteLong(unsigned int BusDevFunc,
;                         unsigned int regNumber,
;                         unsigned long int data)
;       ì¸óÕ    AX      bit15..8 Bus number
;                       bit7..3  Device number
;                       bit2..0  Function number
;               BX      register number
;               DX:CX   write value
;       èoóÕ    None
;       îjâÛ    None
;**************************
pciConfigWriteLong_ PROC C NEAR PUBLIC USES ECX DI

	PUSH	DX
	PUSH	CX
	POP	ECX
	MOV	DI,BX
	MOV	BX,AX
	MOV	AX,0B10Dh
	INT	1Ah
	RET

pciConfigWriteLong_ ENDP

;**************************
; Get IRQ routing
;
;unsigned char _pciGetIrqRoute(unsigned int BIOSSeg,
;                              unsigned char tableAdrs);
;       ì¸óÕ    AX      BIOS segment address
;               DX:CX   IRQ routing table store address
;       èoóÕ    None
;       îjâÛ    None
;**************************
pciGetIrqRoute_ PROC C NEAR PUBLIC USES DI DS ES

	PUSH	AX
	POP	DS
	MOV	DI,CX
	PUSH	DX
	POP	ES
	MOV	AX,0B10Eh
	INT	1Ah
	MOV	AL,AH
	RET

pciGetIrqRoute_ ENDP

TEXT ENDS
     END
