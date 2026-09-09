

;-------------------------------------------------------------

   AREA |C$$code|, CODE, READONLY

;-------------------------------------------------------------

;=======================================
; MMU Cache/TLB/etc on/off functions[R1]
;=======================================
R1_I    EQU     (1<<12)
R1_C    EQU     (1<<2)
R1_A    EQU     (1<<1)
R1_M    EQU     (1<<0)

;void MMU_EnableMIDCache(void)
   EXPORT MMU_EnableMIDCache
MMU_EnableMIDCache        
   mrc  p15,0,r0,c1,c0,0
   orr  r0,r0,#R1_M
   orr  r0,r0,#R1_I
   orr  r0,r0,#R1_C
   mcr  p15,0,r0,c1,c0,0
   mov pc, lr

;void MMU_EnableICache(void)
   EXPORT MMU_EnableICache
MMU_EnableICache        
   mrc  p15,0,r0,c1,c0,0
   orr  r0,r0,#R1_I
   mcr  p15,0,r0,c1,c0,0
   mov pc, lr

;void MMU_DisableICache(void)
   EXPORT MMU_DisableICache
MMU_DisableICache       
   mrc  p15,0,r0,c1,c0,0
   bic  r0,r0,#R1_I
   mcr  p15,0,r0,c1,c0,0
   mov pc, lr

;void MMU_EnableDCache(void)
   EXPORT MMU_EnableDCache
MMU_EnableDCache        
   mrc  p15,0,r0,c1,c0,0
   orr  r0,r0,#R1_C
   mcr  p15,0,r0,c1,c0,0
   mov pc, lr

;void MMU_DisableDCache(void)
   EXPORT MMU_DisableDCache
MMU_DisableDCache       
   mrc  p15,0,r0,c1,c0,0
   bic  r0,r0,#R1_C
   mcr  p15,0,r0,c1,c0,0
   mov pc, lr

;void MMU_EnableAlignFault(void)
   EXPORT MMU_EnableAlignFault 
MMU_EnableAlignFault
   mrc  p15,0,r0,c1,c0,0
   orr  r0,r0,#R1_A
   mcr  p15,0,r0,c1,c0,0
   mov pc, lr

;void MMU_DisableAlignFault(void)
   EXPORT MMU_DisableAlignFault
MMU_DisableAlignFault
   mrc  p15,0,r0,c1,c0,0
   bic  r0,r0,#R1_A
   mcr  p15,0,r0,c1,c0,0
   mov pc, lr

;void MMU_EnableMMU(void)
   EXPORT MMU_EnableMMU
MMU_EnableMMU
   mrc  p15,0,r0,c1,c0,0
   orr  r0,r0,#R1_M
   mcr  p15,0,r0,c1,c0,0
   mov pc, lr

;void MMU_DisableMMU(void)
   EXPORT MMU_DisableMMU
MMU_DisableMMU
   mrc  p15,0,r0,c1,c0,0
   bic  r0,r0,#R1_M
   mcr  p15,0,r0,c1,c0,0
   mov pc, lr

;=========================
; Set TTBase[R2]
;=========================
;void MMU_SetTTBase(int base)
   EXPORT MMU_SetTTBase
MMU_SetTTBase
   ;r0=TTBase
   mcr  p15,0,r0,c2,c0,0
   mov pc, lr

;=========================
; Set Domain[R3]
;=========================
;void MMU_SetDomain(int domain)
   EXPORT MMU_SetDomain
MMU_SetDomain
   ;r0=domain
   mcr  p15,0,r0,c3,c0,0
   mov pc, lr

;int MMU_ReadDomain(void)
   ;EXPORT MMU_ReadDomain
;MMU_ReadDomain
   ;r0=domain
   ;mrc  p15,0,r0,c3,c0,0
   ;mov pc, lr

;=========================
; FSR[R5]
;=========================
;int MMU_ReadDFSR(void)
   EXPORT MMU_ReadDFSR
MMU_ReadDFSR
   ;r0=DFSR
   mrc  p15,0,r0,c5,c0,0
   mov pc, lr

;int MMU_ReadIFSR(void)
   EXPORT MMU_ReadIFSR
MMU_ReadIFSR
   ;r0=IFSR
   mrc  p15,0,r0,c5,c0,1
   mov pc, lr

;=========================
; FAR[R6]
;=========================
;int MMU_ReadFAR(void)
   EXPORT MMU_ReadFAR
MMU_ReadFAR
   ;r0=FAR
   mrc  p15,0,r0,c6,c0,0
   mov pc, lr
   
;============================
; ICache/DCache functions[R7]
;============================
;void MMU_InvalidateIDCache(void)
   EXPORT MMU_InvalidateIDCache
MMU_InvalidateIDCache
   mov  r0,#0x0 
   mcr  p15,0,r0,c7,c7,0
   mov pc, lr

;void MMU_InvalidateICache(void)
   EXPORT MMU_InvalidateICache
MMU_InvalidateICache
   mov  r0,#0x0 
   mcr  p15,0,r0,c7,c5,0
   mov pc, lr

;void MMU_InvalidateICacheMVA(U32 mva)
   EXPORT MMU_InvalidateICacheMVA
MMU_InvalidateICacheMVA 
   ;r0=mva
   mcr  p15,0,r0,c7,c5,1
   mov pc, lr
        
;void MMU_InvalidateICacheSET(U32 set)
   EXPORT MMU_InvalidateICacheSET
MMU_InvalidateICacheSET 
   ;r0=set/way
   mcr  p15,0,r0,c7,c5,2
   mov pc, lr
        
;void MMU_PrefetchICacheMVA(U32 mva)
   EXPORT MMU_PrefetchICacheMVA
MMU_PrefetchICacheMVA
   ;r0=mva
   mcr  p15,0,r0,c7,c13,1
   mov pc, lr

;void MMU_InvalidateDCache(void)
   EXPORT MMU_InvalidateDCache
MMU_InvalidateDCache
   mov  r0,#0x0
   mcr  p15,0,r0,c7,c6,0
   mov pc, lr

;void MMU_InvalidateDCacheMVA(U32 mva)
   EXPORT MMU_InvalidateDCacheMVA
MMU_InvalidateDCacheMVA
   ;r0=mva
   mcr  p15,0,r0,c7,c6,1
   mov pc, lr

;void MMU_InvalidateDCacheSET(U32 set)
   EXPORT MMU_InvalidateDCacheSET
MMU_InvalidateDCacheSET
   ;r0=set/way
   mcr  p15,0,r0,c7,c6,2
   mov pc, lr

;void MMU_CleanDCacheMVA(U32 mva)
   EXPORT MMU_CleanDCacheMVA
MMU_CleanDCacheMVA
   ;r0=mva
   mcr  p15,0,r0,c7,c10,1
   mov pc, lr

;void MMU_CleanDCacheSET(U32 set)
   EXPORT MMU_CleanDCacheSET
MMU_CleanDCacheSET
   ;r0=set/way
   mcr  p15,0,r0,c7,c10,2
   mov pc, lr

;void MMU_TestCleanDCache(void)
   EXPORT MMU_TestCleanDCache
MMU_TestCleanDCache
   mrc  p15,0,r0,c7,c10,3
   mov pc, lr

;void MMU_CleanInvalidateDCacheMVA(U32 mva)
   EXPORT MMU_CleanInvalidateDCacheMVA
MMU_CleanInvalidateDCacheMVA
   ;r0=mva
   mcr  p15,0,r0,c7,c14,1
   mov pc, lr

;void MMU_CleanInvalidateDCacheSET(U32 set)
   EXPORT MMU_CleanInvalidateDCacheSET
MMU_CleanInvalidateDCacheSET
   ;r0=set/way
   mcr  p15,0,r0,c7,c14,2
   mov pc, lr

;void MMU_TestCleanInvalidateDCache(U32 index) 
   EXPORT MMU_TestCleanInvalidateDCache
MMU_TestCleanInvalidateDCache  
   mrc  p15,0,r0,c7,c14,3
   mov pc, lr

;void MMU_DrainWriteBuffer(void)
   EXPORT MMU_DrainWriteBuffer
MMU_DrainWriteBuffer
   mov  r0,#0x0
   mcr  p15,0,r0,c7,c10,4
   mov pc, lr

;void MMU_WaitForInterrupt(void)
   EXPORT MMU_WaitForInterrupt 
MMU_WaitForInterrupt
	b %F1

1	
	mcr	p15, 0, r0, c7, c10, 4	;drain write buffer
	mrs	r2, cpsr
	orr	r4, r2, #3:SHL:6
	mrc	p15, 0, r0, c1, c0, 0
	bic	r1, r0, #1<<12

	msr	cpsr_c, r4
	mcr	p15, 0, r1, c1, c0, 0
	mcr	p15, 0, r0, c7, c0, 4
	mcr	p15, 0, r0, c1, c0, 0
	msr	cpsr_c, r2
	mov pc, lr

;==================
; TLB functions[R8]
;==================
;void MMU_InvalidateTLB(void)
;void MMU_InvalidateSetAssociativeTLB(void);ARM926EJ-S
   EXPORT MMU_InvalidateTLB
MMU_InvalidateTLB  
   mov  r0,#0x0     
   mcr  p15,0,r0,c8,c7,0
   mov pc, lr

;void MMU_InvalidateTLBMVA(U32 mva)
;void MMU_InvalidateTLBSingleEntry(U32 mva);ARM926EJ-S
   EXPORT MMU_InvalidateTLBMVA
MMU_InvalidateTLBMVA  
   ;r0=mva
   mcr  p15,0,r0,c8,c7,1
   mov pc, lr

;void MMU_InvalidateITLB(void)
;void MMU_InvalidateSetAssociativeTLB(void);ARM926EJ-S
   EXPORT MMU_InvalidateITLB
MMU_InvalidateITLB      
   mcr  p15,0,r0,c8,c5,0
   mov pc, lr

;void MMU_InvalidateITLBMVA(U32 mva)
;void MMU_InvalidateTLBSingleEntry(U32 mva);ARM926EJ-S
   EXPORT MMU_InvalidateITLBMVA
MMU_InvalidateITLBMVA
   ;r0=mva
   mcr  p15,0,r0,c8,c5,1
   mov pc, lr

;void MMU_InvalidateDTLB(void)
;void MMU_InvalidateSetAssociativeTLB(void);ARM926EJ-S
   EXPORT MMU_InvalidateDTLB
MMU_InvalidateDTLB
   mov  r0,#0x0
   mcr  p15,0,r0,c8,c6,0
   mov pc, lr

;void MMU_InvalidateDTLBMVA(U32 mva)
;void MMU_InvalidateTLBSingleEntry(U32 mva);ARM926EJ-S
   EXPORT MMU_InvalidateDTLBMVA 
MMU_InvalidateDTLBMVA
   ;r0=mva
   mcr  p15,0,r0,c8,c6,1
   mov pc, lr

;====================
; Cache lock down[R9]
;====================
;void MMU_SetDCacheLockdownWay(U32 way)
   EXPORT MMU_SetDCacheLockdownWay 
MMU_SetDCacheLockdownWay
   ;r0= way to be lockdown
   mrc  p15,0,r1,c9,c0,0
   orr  r1, r1, r0
   mcr  p15,0,r1,c9,c0,0
   mov pc, lr
   
;void MMU_SetDCacheUnlockdownWay(U32 way)
   EXPORT MMU_SetDCacheUnlockdownWay 
MMU_SetDCacheUnlockdownWay
   ;r0= way to be unlockdown
   mrc  p15,0,r1,c9,c0,0
   bic  r1, r1, r0
   mcr  p15,0,r1,c9,c0,0
   mov pc, lr
   
;void MMU_SetICacheLockdownWay(U32 way)
   EXPORT MMU_SetICacheLockdownWay
MMU_SetICacheLockdownWay
   ;r0= way to be lockdown
   mrc  p15,0,r1,c9,c0,1
   orr  r1, r1, r0
   mcr  p15,0,r1,c9,c0,1
   mov pc, lr

;void MMU_SetICacheUnlockdownWay(U32 way)
   EXPORT MMU_SetICacheUnlockdownWay
MMU_SetICacheUnlockdownWay
   ;r0= way to be unlockdown
   mrc  p15,0,r1,c9,c0,1
   bic  r1, r1, r0
   mcr  p15,0,r1,c9,c0,1
   mov pc, lr

;===================
; TLB lock down[R10]
;===================
;void MMU_SetDTLBLockdown(U32 addr)
   EXPORT MMU_SetDTLBLockdown
MMU_SetDTLBLockdown
   ;r0= the address to be locked down
   mov  r1,r0			; set r1 to the value of the address to be locked down
   mcr  p15,0,r1,c8,c7,1 	; invalidate TLB single entry to ensure that addr is not already in the TLB
   mrc  p15,0,r0,c10,c0,0	; read the lockdown register
   orr  r0,r0,#1		; set the preserve bit
   mcr  p15,0,r0,c10,c0,0	; write to the lockdown register
   ldr  r1,[r1]			; TLB will miss, and entry will be loaded
   mrc  p15,0,r0,c10,c0,0	; read the lockdown register (victim will have incremented)
   bic  r0,r0,#1		; clear preserve bit
   mcr  p15,0,r0,c10,c0,0	; write to the lockdown register
   mov pc, lr

;================
; Process ID[R13]
;================
;void MMU_SetProcessId(U32 pid)
   EXPORT MMU_SetProcessId
MMU_SetProcessId        
   ;r0= pid
   mcr  p15,0,r0,c13,c0,0
   mov pc, lr

;================
; Debug[R15]
;================
;int MMU_DebugRead(void);
   EXPORT MMU_DebugRead
MMU_DebugRead
   ;r0= value
   mrc  p15,0,r0,c15,c0,0
   mov pc, lr

;void MMU_DebugWrite(U32 value);
   EXPORT MMU_DebugWrite
MMU_DebugWrite
   ;r0= value
   mrc  p15,0,r1,c15,c0,0
   orr	r1, r1, r0
   mcr  p15,0,r1,c15,c0,0
   mov pc, lr
        
   END