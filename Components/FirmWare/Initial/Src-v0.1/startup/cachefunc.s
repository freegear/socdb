;-------------------------------------------------------------------------------
;
;  File: cachefunc.s
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
;  Function:  void smtFlushDCache()
;
smtFlushDCache

        ; Test, clean and invalidate entire data cache
10      mrc p15, 0, r15, c7, c14, 3
        bne %b10

        RETURN

;-------------------------------------------------------------------------------
;
;  Function:  void smtFlushICache()
;
smtFlushICache

        mov     r0, #0
        mcr     p15, 0, r0, c7, c5, 0

        RETURN

;-------------------------------------------------------------------------------
;
;  Function:  void smtFlushDCacheLines(void *pAddr, UINT32 size, UINT32 linesize)
;
smtFlushDCacheLines

10      mcr     p15, 0, r0, c7, c14, 1          ; clean and invalidate entry
        add     r0, r0, r2                      ; move to next
        subs    r1, r1, r2
        bgt     %b10                            ; loop while > 0 bytes left

        RETURN

;-------------------------------------------------------------------------------
;
;  Function:  void smtFlushICacheLines(void *pAddr, UINT32 size, UINT32 linesize)
;
smtFlushICacheLines

10      mcr     p15, 0, r0, c7, c5, 1           ; invalidate entry
        add     r0, r0, r2                      ; move to next
        subs    r1, r1, r2
        bgt     %b10                            ; loop while > 0 bytes left

        RETURN

;-------------------------------------------------------------------------------
;
;  Function:  void smtCleanDCache()
;
smtCleanDCache

        ; Test and clean entire data cache
10      mrc p15, 0, r15, c7, c10, 3
        bne %b10

        RETURN

;-------------------------------------------------------------------------------
;
;  Function:  void smtClearDCacheLines(void *pAddr, UINT32 size, UINT32 linesize)
;
smtCleanDCacheLines

10      mcr     p15, 0, r0, c7, c10, 1          ; clean entry
        add     r0, r0, r2                      ; move to next entry
        subs    r1, r1, r2
        bgt     %b10                            ; loop while > 0 bytes left

        mov     r2, #0
        mcr     p15, 0, r2, c7, c10, 4          ; drain write buffer

        RETURN

        END