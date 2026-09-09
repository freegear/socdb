;/***************************************************************************
; * Copyright © ARM Limited 1998, 1999.  All rights reserved.
; ***************************************************************************/
;/*****************************************************************************
;
;   Generic aliases for COPROCESSOR access macros for ARM processors.
;
;	$Id: retmacro.s,v 1.1 1999/11/04 15:57:10 dbrooke Exp $
;
;******************************************************************************/

 IF :LNOT: :DEF: __retmacros
__retmacros             EQU     1

;standard return command with Thumb aware alternative

	MACRO
	RETURN 	$reg
  
 IF :DEF: THUMB_AWARE   ; if interworking is required
   BX    $reg           ; return and change state if required
 ELSE                   ; some processors are not Thumb aware
   MOV   pc, $reg	      ; just return
 ENDIF
   MEND
	

;Conditional return 

	MACRO
	RETURN_COND    $cond
  
 IF :DEF: THUMB_AWARE   ; if interworking is required
   BX$cond    lr        ; return and change state if required
 ELSE                   ; some processors are not Thumb aware
   MOV$cond   pc,lr     ; just return
 ENDIF
   MEND
	
	MACRO
	POP_RETURN 	$reglist
  
 IF :DEF: THUMB_AWARE   ; if interworking is required
   
   LDMFD    sp!, {$reglist, lr} ; restore registers 
   BX    lr                      ; return and change state if required
 ELSE                            ; some processors are not Thumb aware
   LDMFD    sp!, {$reglist, pc} ; restore registers 
 ENDIF
   MEND
	

   MACRO
   POP_RETURN_EXTEND $reglist1,$reglist2
   
 IF :DEF: THUMB_AWARE           ; if interworking is required
   LDMFD    sp!, {$reglist1,$reglist2, lr} ; restore registers 
   BX       lr                  ; & return
 ELSE                           ; some processors are not Thumb aware
   LDMFD    sp!, {$reglist1,$reglist2, pc} ; restore registers & return
 ENDIF
   MEND


 ENDIF
	END
