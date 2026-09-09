;**********MEMORY CONTROL PARAMETERS*******************************

;Bank 0 parameter
B0_Tacsr		EQU	0x3	;
B0_Tcosr		EQU	0x3	;
B0_Taccr		EQU	0xf	;
B0_Tcohr		EQU	0x3	;
B0_Tacsw	EQU	0x3	;
B0_Tcosw	EQU	0x3	;
B0_Taccw	EQU	0xf	;
B0_Tcohw	EQU	0x3	;
B0_Shift        EQU 0x1 ; No addr shift
B0_Width        EQU 0x1 ; Memory bus 16bit

;Bank 1 parameter
B1_Tacsr		EQU	0x2	;
B1_Tcosr		EQU	0x2	;
B1_Taccr		EQU	0x2	;
B1_Tcohr		EQU	0x2	;
B1_Tacsw	EQU	0x1	;
B1_Tcosw	EQU	0x1	;
B1_Taccw	EQU	0x1	;
B1_Tcohw	EQU	0x1	;
B1_Shift        EQU 0x0 ; No addr shift
B1_Width        EQU 0x1

;Bank 2 parameter
B2_Tacsr		EQU	0x2	;
B2_Tcosr		EQU	0x2	;
B2_Taccr        EQU	0x2	;
B2_Tcohr		EQU	0x2	;
B2_Tacsw	EQU	0x1	;
B2_Tcosw	EQU	0x1	;
B2_Taccw       EQU	0x1	;
B2_Tcohw	EQU	0x1	;
B2_Shift        EQU 0x0 ;
B2_Width        EQU 0x1 ;

;Bank 3 parameter
B3_Tacsr		EQU	0x2	;
B3_Tcosr		EQU	0x2	;
B3_Taccr		EQU	0x2	;
B3_Tcohr		EQU	0x2	;
B3_Tacsw	EQU	0x1	;
B3_Tcosw	EQU	0x1	;
B3_Taccw	EQU	0x1	;
B3_Tcohw	EQU	0x1	;
B3_Shift        EQU 0x1 ;
B3_Width        EQU 0x1 ;
;************************************************
	END
