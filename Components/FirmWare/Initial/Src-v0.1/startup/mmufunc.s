;-------------------------------------------------------------------------------
;
;  File: mmufunc.s
;-------------------------------------------------------------------------------
    MACRO
    RETURN
    mov     pc, lr
    MEND

;-------------------------------------------------------------------------------

;    AREA |C$$code|, CODE, READONLY
    AREA |.text|, CODE, READONLY
;-------------------------------------------------------------------------------
;
;  Function:  void smtClearDTLB()
;
smtClearDTLB

        mov     r0, #0
        mcr     p15, 0, r0, c8, c6, 0   ; flush data TLB

        RETURN

;-------------------------------------------------------------------------------
;
;  Function:  void smtClearITLB()
;
smtClearITLB

        mov     r0, #0
        mcr     p15, 0, r0, c8, c5, 0   ; flush instruction TLB

        RETURN

;-------------------------------------------------------------------------------
;
;  Function:  void smtClearUTLB()
;
smtClearUTLB

        mov     r0, #0
        mcr     p15, 0, r0, c8, c7, 0   ; flush unified TLB

        RETURN

;-------------------------------------------------------------------------------
;
;  Function:  void smtClearDTLBEntry(void *pAddr)
;
smtClearDTLBEntry

        mcr     p15, 0, r0, c8, c6, 1           ; clear data TLB entry

        RETURN

;-------------------------------------------------------------------------------
;
;  Function:  void smtClearITLBEntry(void *pAddr)
;
smtClearITLBEntry

        mcr     p15, 0, r0, c8, c5, 1           ; clear instruction TLB entry

        RETURN

;-------------------------------------------------------------------------------
;
;  Function:  void smtClearUTLBEntry(void *pAddr)
;
smtClearUTLBEntry

        mcr     p15, 0, r0, c8, c7, 1           ; clear unified TLB entry

        RETURN

        END