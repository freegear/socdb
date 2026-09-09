/*
;-------------------------------------------------------------------------------
;
;  File: cachefunc.s
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
;  Function:  void smtFlushDCache()
;
*/
.global smtFlushDCache

smtFlushDCache:

        /*; Test, clean and invalidate entire data cache*/
10:     mrc p15, 0, r15, c7, c14, 3
        bne 10b

	    mov     pc, lr
        /* RETURN */
/*
;-------------------------------------------------------------------------------
;
;  Function:  void smtFlushICache()
;
*/
.global smtFlushICache

smtFlushICache:

        mov     r0, #0
        mcr     p15, 0, r0, c7, c5, 0

	    mov     pc, lr
        /* RETURN */
/*
;-------------------------------------------------------------------------------
;
;  Function:  void smtFlushDCacheLines(void *pAddr, UINT32 size, UINT32 linesize)
;
*/
.global smtFlushDCacheLines

smtFlushDCacheLines:

10:     mcr     p15, 0, r0, c7, c14, 1          /*; clean and invalidate entry*/
        add     r0, r0, r2                      /*; move to next*/
        subs    r1, r1, r2
        bgt     10b                            /*; loop while > 0 bytes left*/

		mov     pc, lr
        /* RETURN */

/*
;-------------------------------------------------------------------------------
;
;  Function:  void smtFlushICacheLines(void *pAddr, UINT32 size, UINT32 linesize)
;
*/
.global smtFlushICacheLines

smtFlushICacheLines:

10:     mcr     p15, 0, r0, c7, c5, 1           /*; invalidate entry*/
        add     r0, r0, r2                      /*; move to next*/
        subs    r1, r1, r2
        bgt     10b                            /*; loop while > 0 bytes left*/

	    mov     pc, lr
        /* RETURN */
/*
;-------------------------------------------------------------------------------
;
;  Function:  void smtCleanDCache()
;
*/
.global smtCleanDCache

smtCleanDCache:

        /*; Test and clean entire data cache*/
10:     mrc p15, 0, r15, c7, c10, 3
        bne 10b

	    mov     pc, lr
        /*RETURN*/

/*
;-------------------------------------------------------------------------------
;
;  Function:  void smtClearDCacheLines(void *pAddr, UINT32 size, UINT32 linesize)
;
*/
.global smtCleanDCacheLines

smtCleanDCacheLines:

10:     mcr     p15, 0, r0, c7, c10, 1          /*; clean entry*/
        add     r0, r0, r2                      /*; move to next entry*/
        subs    r1, r1, r2
        bgt     10b                            /*; loop while > 0 bytes left*/

        mov     r2, #0
        mcr     p15, 0, r2, c7, c10, 4          /*; drain write buffer*/

	    mov     pc, lr
        /*RETURN*/



/*
      Enable only I-Cache
*/

.global smtEnableIcache
smtEnableIcache:
	    mrc     p15, 0, r1, c1, c0, 0
	    ldr     r0, =0x00001004
	    orr     r1, r0, #0
        mcr     p15, 0, r1, c1, c0, 0

   	    mov     pc, lr

