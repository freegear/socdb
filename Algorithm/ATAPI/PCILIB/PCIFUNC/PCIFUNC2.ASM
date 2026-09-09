;
; PCI functions for IBM-AT or compatible machines with PCI BUS
;

;
; This object for TurboC V2.01 compiler.
;

;use  TASM.EXE V2.01 or later
;
;      TASM /jSMART /jJUMPS /uM520 /jLOCALS /m8 /t
;
.386p
CGROUP	GROUP _TEXT,TEXT

TEXT SEGMENT BYTE PUBLIC 'CODE' USE16

	EXTRN	C pciGetSts_:NEAR
	EXTRN	C pciConfigVersion_:NEAR
	EXTRN	C pciBusVersion_:NEAR
	EXTRN	C pciMaxBusNo_:NEAR
	EXTRN	C pciSigPCI_:NEAR
	EXTRN	C pciFindPciDevice_:NEAR
	EXTRN	C pciFindPciClass_:NEAR
	EXTRN	C pciConfigReadByte_:NEAR
	EXTRN	C pciConfigReadWord_:NEAR
	EXTRN	C pciConfigReadLong_:NEAR
	EXTRN	C pciConfigWriteByte_:NEAR
	EXTRN	C pciConfigWriteWord_:NEAR
	EXTRN	C pciConfigWriteLong_:NEAR
	EXTRN	C pciGetIrqRoute_:NEAR

TEXT ENDS

_TEXT SEGMENT BYTE PUBLIC 'CODE' USE16
     ASSUME  CS:CGROUP,DS:NOTHING,ES:NOTHING

;**************************
; Get PCI BIOS information
;
;unsigned int _pciGetSts(unsigned int *pciVersion,
;                        unsigned char *pciBusNumber,
;                        unsigned long *pciSignature)
;
;       ì¸óÕ    [SP-2].W	PCI Config Mechanism value store address
;               [SP-4].W	PCI version value store address
;               [SP-6].W	number of PCI Bus store address
;               [SP-8].W        PCI Signature store address
;       èoóÕ    AX    AX	=0:PCI BIOS call successful  !=0:PCI BIOS call faller
;       îjâÛ    None
;**************************
_pciGetSts PROC C NEAR PUBLIC USES BX CX DX,pPciMech:WORD,pPciVer:WORD,pPciBusNum:WORD,pPciSign:WORD

	MOV	AX, [pPciMech]
	MOV	BX, [pPciVer]
	MOV	CX, [pPciBusNum]
	MOV	DX, [pPciSign]
	CALL	pciGetSts_
	RET

_pciGetSts ENDP

;**************************
; Get PCI BIOS information AX
;
;unsigned int _pciGetStsAX;
;
;       ì¸óÕ    none
;       èoóÕ    AX	return AX value of PCI function 01h
;       îjâÛ    None
;**************************
_pciConfigVersion PROC C NEAR PUBLIC USES BX

	CALL	pciConfigVersion_
	RET

_pciConfigVersion ENDP

;**************************
; Get PCI BIOS information BX
;
;unsigned int _pciBusVersion;
;
;       ì¸óÕ    none
;       èoóÕ    AX	return BX value of PCI function 01h
;       îjâÛ    None
;**************************
_pciBusVersion PROC C NEAR PUBLIC USES BX

	CALL	pciBusVersion_
	RET

_pciBusVersion ENDP

;**************************
; Get PCI BIOS information CL
;
;unsigned char _pciMaxBusNo;
;
;       ì¸óÕ    none
;       èoóÕ    AL	return CL value of PCI function 01h
;       îjâÛ    None
;**************************
_pciMaxBusNo PROC C NEAR PUBLIC USES BX

	CALL	pciMaxBusNo_
	RET

_pciMaxBusNo ENDP

;**************************
; Get PCI BIOS information EDX
;
;unsigned long int _pciSigPCI;
;
;       ì¸óÕ    none
;       èoóÕ    DX:AX	return EDX value of PCI function 01h
;       îjâÛ    None
;**************************
_pciSigPCI PROC C NEAR PUBLIC USES BX

	CALL	pciSigPCI_
	MOV	DX, BX
	RET

_pciSigPCI ENDP

;**************************
; Find PCI device
;
;unsigned long int _pciFindPciDevice(unsigned int deviceID,
;                                    unsigned int vendorID,
;                                    unsigned int index);
;       ì¸óÕ    [SP-2].W      device ID
;               [SP-4].W      vendor ID
;               [Sp-6].W      index
;       èoóÕ    DX	found PCI device address
;		AL      function return code
;       îjâÛ    None
;**************************
_pciFindPciDevice PROC C NEAR PUBLIC USES BX CX, deviceID:WORD,vendorID:WORD,index:WORD

	MOV	AX, [deviceID]
	MOV	BX, [vendorID]
	MOV	CX, [index]
	CALL	pciFindPciDevice_
	MOV	DX, BX
	RET

_pciFindPciDevice ENDP

;**************************
; Find PCI class
;
;unsigned long int _pciFindPciClass(unsigned char progIF,
;                                   unsigned char subClassCode,
;                                   unsigned char classCode,
;                                   unsigned int index);
;       ì¸óÕ    [SP-2].B      Programming interface code
;               [SP-4].B      Sub class code
;               [SP-6].B      Class code
;               [SP-8].W      index
;       èoóÕ    DX	found PCI device address
;		AL      function return code
;       îjâÛ    None
;**************************
_pciFindPciClass PROC C NEAR PUBLIC USES BX CX,progIF:BYTE, subClassCode:BYTE, classCode:BYTE, index:WORD

	MOV	AL, progIF
	MOV	BL, subClassCode
	MOV	CL, classCode
	MOV	DX, index
	CALL	pciFindPciClass_
	MOV	DX, BX
	RET

_pciFindPciClass ENDP

;**************************
; Read PCI configuration register byte
;
;unsigned char _pciConfigReadByte(unsigned int BusDevFunc,
;                               unsigned int regNumber)
;       ì¸óÕ    [SP-2].W      bit15..8 Bus number
;                             bit7..3  Device number
;                             bit2..0  Function number
;               [SP-4].W      read register number
;       èoóÕ    AL	Read value
;       îjâÛ    None
;**************************
_pciConfigReadByte PROC C NEAR PUBLIC USES BX, busDevFunc:WORD,regNum:WORD

	MOV	AX, busDevFunc
	MOV	BX, regNum
	CALL	pciConfigReadByte_
	RET

_pciConfigReadByte ENDP

;**************************
; Read PCI configuration register word
;
;unsigned int _pciConfigReadWord(unsigned int BusDevFunc,
;                          unsigned int regNumber)
;       ì¸óÕ    [SP-2].W      bit15..8 Bus number
;                             bit7..3  Device number
;                             bit2..0  Function number
;               [SP-4].W      read register number
;       èoóÕ    AX	Read value
;       îjâÛ    None
;**************************
_pciConfigReadWord PROC C NEAR PUBLIC USES BX, busDevFunc:WORD,regNum:WORD

	MOV	AX, busDevFunc
	MOV	BX, regNum
	CALL	pciConfigReadWord_
	RET

_pciConfigReadWord ENDP

;**************************
; Read PCI configuration register double word
;
;unsigned long int _pciConfigReadLong(unsigned int BusDevFunc,
;                          unsigned int regNumber)
;       ì¸óÕ    [SP-2].W      bit15..8 Bus number
;                             bit7..3  Device number
;                             bit2..0  Function number
;               [SP-4].W      read register number
;       èoóÕ    DX:AX	Read value
;       îjâÛ    None
;**************************
_pciConfigReadLong PROC C NEAR PUBLIC USES BX, busDevFunc:WORD,regNum:WORD

	MOV	AX, busDevFunc
	MOV	BX, regNum
	CALL	pciConfigReadLong_
	MOV	DX, BX
	RET

_pciConfigReadLong ENDP

;**************************
; Write PCI configuration register byte
;
;unsigned char _pciConfigWriteByte(unsigned int BusDevFunc,
;                            unsigned int regNumber,
;                            unsigned char data)
;       ì¸óÕ    [SP-2].W      bit15..8 Bus number
;                             bit7..3  Device number
;                             bit2..0  Function number
;               [SP-4].W      register number
;               [SP-6].B      write value
;       èoóÕ    None
;       îjâÛ    None
;**************************
_pciConfigWriteByte PROC C NEAR PUBLIC USES AX BX CX, busDevFunc:WORD,regNum:WORD,writeData:BYTE

	MOV	AX, busDevFunc
	MOV	BX, regNum
	MOV	CL, writeData
	CALL	pciConfigWriteByte_
	RET

_pciConfigWriteByte ENDP

;**************************
; Write PCI configuration register word
;
;unsigned int _pciConfigWriteWord(unsigned int BusDevFunc,
;                            unsigned int regNumber,
;                            unsigned char data)
;       ì¸óÕ    [SP-2].W      bit15..8 Bus number
;                             bit7..3  Device number
;                             bit2..0  Function number
;               [SP-4].W      register number
;               [SP-6].W      write value
;       èoóÕ    None
;       îjâÛ    None
;**************************
_pciConfigWriteWord PROC C NEAR PUBLIC USES AX BX CX, busDevFunc:WORD,regNum:WORD,writeData:WORD

	MOV	AX, busDevFunc
	MOV	BX, regNum
	MOV	CX, writeData
	CALL	pciConfigWriteWord_
	RET

_pciConfigWriteWord ENDP

;**************************
; Write PCI configuration register double word
;
;unsigned long int _pciConfigWriteLong(unsigned int BusDevFunc,
;                            unsigned int regNumber,
;                            unsigned char data)
;       ì¸óÕ    [SP-2].W      bit15..8 Bus number
;                             bit7..3  Device number
;                             bit2..0  Function number
;               [SP-4].W      register number
;               [SP-6].L      write value
;       èoóÕ    None
;       îjâÛ    None
;**************************
_pciConfigWriteLong PROC C NEAR PUBLIC USES AX BX CX DX, busDevFunc:WORD,regNum:WORD,writeData:DWORD

	MOV	AX, busDevFunc
	MOV	BX, regNum
	MOV	CX, WORD PTR writeData
	MOV	DX, WORD PTR writeData+2
	CALL	pciConfigWriteLong_
	RET

_pciConfigWriteLong ENDP

;**************************
; Get IRQ routing
;
;unsigned char _pciGetIrqRoute(unsigned int BIOSSeg,
;                              unsigned char tableAdrs);
;       ì¸óÕ    [SP-2].W AX      BIOS segment address
;               [SP-4].L CX:BX   IRQ routing table store far address
;       èoóÕ    AL      function return code
;		DX	PCI IRQ mapping
;       îjâÛ    None
;**************************
_pciGetIrqRoute PROC C NEAR PUBLIC USES BX CX, BIOSSeg:WORD,tableAdrs:DWORD

	MOV	AX, BIOSSeg
	MOV	BX, WORD PTR tableAdrs
	MOV	CX, WORD PTR tableAdrs+2
	CALL	pciGetIrqRoute_
	MOV	DX, BX
	RET

_pciGetIrqRoute ENDP

_TEXT ENDS


     END

