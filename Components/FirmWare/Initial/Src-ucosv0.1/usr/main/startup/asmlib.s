;****************************************************************************
;* file name	: asmlib.s
;* Date			: 07. 04. 2006
;* Version		: 1.0
;* Description	: Define library function (assembly code)
;*				  
;****************************************************************************/


	EXPORT 	Enable_IRQ
	EXPORT	Disable_IRQ

;-------------------------------------------------------------

   AREA |C$$code|, CODE, READONLY

Enable_IRQ
	  nop
	  stmfd sp!, {r1} 
	  MRS r1 , cpsr 
	  BIC r1,r1,#0x80
	  MSR cpsr_cxsf,r1
	
	  ldmfd sp!, {r1} 
	  mov pc,lr

Disable_IRQ
	  nop
	  stmfd sp!, {r1} 
	  MRS r1 , cpsr 
	  ORR r1,r1,#0x80
	  MSR cpsr_cxsf,r1
	
	  ldmfd sp!, {r1} 
	  mov pc,lr

   END
