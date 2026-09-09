/*
;-------------------------------------------------------------------------------
;
;  File: mmufunc.s
;------------------------------------------------------------------------------- 

    MACRO
    RETURN
    mov     pc, lr
    MEND
*/
/*
;-------------------------------------------------------------------------------

;    AREA |C$$code|, CODE, READONLY
    AREA |.text|, CODE, READONLY
;-------------------------------------------------------------------------------
;
;  Function:  void smtClearDTLB()
;
*/
.global smtClearDTLB

smtClearDTLB:

        mov     r0, #0
        mcr     p15, 0, r0, c8, c6, 0   /*; flush data TLB */

	    mov     pc, lr
        /* RETURN */

/*
;-------------------------------------------------------------------------------
;
;  Function:  void smtClearITLB()
;
*/
.global smtClearITLB

smtClearITLB:

        mov     r0, #0
        mcr     p15, 0, r0, c8, c5, 0   /*; flush instruction TLB*/

	    mov     pc, lr
        /* RETURN */

/*
;-------------------------------------------------------------------------------
;
;  Function:  void smtClearUTLB()
;
*/
.global smtClearUTLB

smtClearUTLB:

        mov     r0, #0
        mcr     p15, 0, r0, c8, c7, 0   /*; flush unified TLB*/

	    mov     pc, lr
        /* RETURN */

/*
;-------------------------------------------------------------------------------
;
;  Function:  void smtClearDTLBEntry(void *pAddr)
;
*/
.global smtClearDTLBEntry

smtClearDTLBEntry:

        mcr     p15, 0, r0, c8, c6, 1    /*; clear data TLB entry */

	    mov     pc, lr
        /* RETURN */

/*
;-------------------------------------------------------------------------------
;
;  Function:  void smtClearITLBEntry(void *pAddr)
;
*/
.global smtClearITLBEntry
smtClearITLBEntry:

        mcr     p15, 0, r0, c8, c5, 1     /* ; clear instruction TLB entry */

	    mov     pc, lr
        /* RETURN */

/*
;-------------------------------------------------------------------------------
;
;  Function:  void smtClearUTLBEntry(void *pAddr)
;
*/
.global smtClearUTLBEntry

smtClearUTLBEntry:

        mcr     p15, 0, r0, c8, c7, 1       /* ; clear unified TLB entry */

	    mov     pc, lr
        /* RETURN */

