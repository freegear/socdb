/* Generated automatically by the program `genemit'
from the machine description file `md'.  */

#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "rtl.h"
#include "tm_p.h"
#include "function.h"
#include "expr.h"
#include "optabs.h"
#include "real.h"
#include "flags.h"
#include "output.h"
#include "insn-config.h"
#include "hard-reg-set.h"
#include "recog.h"
#include "resource.h"
#include "reload.h"
#include "toplev.h"
#include "ggc.h"

#define FAIL return (end_sequence (), _val)
#define DONE return (_val = get_insns (), end_sequence (), _val)

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:85 */
rtx
gen_return_internal (rtx operand0 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode, gen_rtvec (2,
		gen_rtx_RETURN (VOIDmode),
		gen_rtx_USE (VOIDmode,
	operand0)));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:120 */
rtx
gen_sibcall_internal (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode, gen_rtvec (2,
		gen_rtx_CALL (VOIDmode,
	gen_rtx_MEM (SImode,
	operand0),
	operand1),
		gen_rtx_USE (VOIDmode,
	gen_rtx_REG (SImode,
	9))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:299 */
rtx
gen_movsi_insn_big (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	operand1);
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:380 */
rtx
gen_cmov (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED,
	rtx operand3 ATTRIBUTE_UNUSED,
	rtx operand4 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_IF_THEN_ELSE (SImode,
	gen_rtx (GET_CODE (operand1), VOIDmode,
		operand4,
		const0_rtx),
	operand2,
	operand3));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:614 */
rtx
gen_movdi (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	operand1);
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:623 */
rtx
gen_movdf (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	operand1);
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:633 */
rtx
gen_movsf (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	operand1);
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:667 */
rtx
gen_extendqisi2_sext (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_SIGN_EXTEND (SImode,
	operand1));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:677 */
rtx
gen_extendqisi2_no_sext_mem (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_SIGN_EXTEND (SImode,
	operand1));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:721 */
rtx
gen_extendhisi2_sext (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_SIGN_EXTEND (SImode,
	operand1));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:731 */
rtx
gen_extendhisi2_no_sext_mem (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_SIGN_EXTEND (SImode,
	operand1));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:757 */
rtx
gen_zero_extendqisi2 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_ZERO_EXTEND (SImode,
	operand1));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:768 */
rtx
gen_zero_extendhisi2 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_ZERO_EXTEND (SImode,
	operand1));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:782 */
rtx
gen_ashlsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_ASHIFT (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:793 */
rtx
gen_ashrsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_ASHIFTRT (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:804 */
rtx
gen_lshrsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_LSHIFTRT (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:815 */
rtx
gen_rotrsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_ROTATERT (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:830 */
rtx
gen_andsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_AND (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:841 */
rtx
gen_iorsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_IOR (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:852 */
rtx
gen_xorsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_XOR (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:863 */
rtx
gen_one_cmplqi2 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_NOT (QImode,
	operand1));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:871 */
rtx
gen_one_cmplsi2 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_NOT (SImode,
	operand1));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:883 */
rtx
gen_negsi2 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_NEG (SImode,
	operand1));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:891 */
rtx
gen_addsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_PLUS (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:902 */
rtx
gen_subsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_MINUS (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:917 */
rtx
gen_mulsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_MULT (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:926 */
rtx
gen_divsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_DIV (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:935 */
rtx
gen_udivsi3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_UDIV (SImode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:963 */
rtx
gen_jump_internal (rtx operand0 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	pc_rtx,
	gen_rtx_LABEL_REF (VOIDmode,
	operand0));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:971 */
rtx
gen_jump_aligned (rtx operand0 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	pc_rtx,
	gen_rtx_LABEL_REF (VOIDmode,
	operand0));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:994 */
rtx
gen_indirect_jump_internal (rtx operand0 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	pc_rtx,
	operand0);
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1001 */
rtx
gen_indirect_jump_aligned (rtx operand0 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	pc_rtx,
	operand0);
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1028 */
rtx
gen_call_internal (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_CALL (VOIDmode,
	operand0,
	operand1),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1037 */
rtx
gen_call_aligned (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_CALL (VOIDmode,
	operand0,
	operand1),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1063 */
rtx
gen_call_value_internal (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_CALL (VOIDmode,
	operand1,
	operand2)),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1073 */
rtx
gen_call_value_aligned (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_CALL (VOIDmode,
	operand1,
	operand2)),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1100 */
rtx
gen_call_value_indirect_internal (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_CALL (VOIDmode,
	gen_rtx_MEM (SImode,
	operand1),
	operand2)),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1110 */
rtx
gen_call_value_indirect_aligned (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_CALL (VOIDmode,
	gen_rtx_MEM (SImode,
	operand1),
	operand2)),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1136 */
rtx
gen_call_indirect_internal (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_CALL (VOIDmode,
	gen_rtx_MEM (SImode,
	operand0),
	operand1),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1145 */
rtx
gen_call_indirect_aligned (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_CALL (VOIDmode,
	gen_rtx_MEM (SImode,
	operand0),
	operand1),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1169 */
rtx
gen_tablejump_internal (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode, gen_rtvec (2,
		gen_rtx_SET (VOIDmode,
	pc_rtx,
	operand0),
		gen_rtx_USE (VOIDmode,
	gen_rtx_LABEL_REF (VOIDmode,
	operand1))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1177 */
rtx
gen_tablejump_aligned (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED)
{
  return gen_rtx_PARALLEL (VOIDmode, gen_rtvec (2,
		gen_rtx_SET (VOIDmode,
	pc_rtx,
	operand0),
		gen_rtx_USE (VOIDmode,
	gen_rtx_LABEL_REF (VOIDmode,
	operand1))));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1188 */
rtx
gen_nop (void)
{
  return const0_rtx;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1199 */
rtx
gen_addsf3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_PLUS (SFmode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1208 */
rtx
gen_adddf3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_PLUS (DFmode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1217 */
rtx
gen_subsf3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_MINUS (SFmode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1226 */
rtx
gen_subdf3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_MINUS (DFmode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1235 */
rtx
gen_mulsf3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_MULT (SFmode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1244 */
rtx
gen_muldf3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_MULT (DFmode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1253 */
rtx
gen_divsf3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_DIV (SFmode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1262 */
rtx
gen_divdf3 (rtx operand0 ATTRIBUTE_UNUSED,
	rtx operand1 ATTRIBUTE_UNUSED,
	rtx operand2 ATTRIBUTE_UNUSED)
{
  return gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_DIV (DFmode,
	operand1,
	operand2));
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:55 */
rtx
gen_prologue (void)
{
  rtx _val = 0;
  start_sequence ();
  {
{
  or32_expand_prologue ();
  DONE;
}
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	const1_rtx));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:69 */
rtx
gen_epilogue (void)
{
  rtx _val = 0;
  start_sequence ();
  {
{
  or32_expand_epilogue (false);
  DONE;
}
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	GEN_INT (2L)));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:77 */
rtx
gen_sibcall_epilogue (void)
{
  rtx _val = 0;
  start_sequence ();
  {
{
  or32_expand_epilogue (true);
  DONE;
}
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	GEN_INT (2L)));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:97 */
rtx
gen_sibcall (rtx operand0,
	rtx operand1,
	rtx operand2,
	rtx operand3)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[4];
    operands[0] = operand0;
    operands[1] = operand1;
    operands[2] = operand2;
    operands[3] = operand3;

{
  or32_expand_sibcall (0, XEXP (operands[0], 0), operands[1]); 
  DONE;
}
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
    operand3 = operands[3];
  }
  emit_call_insn (gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (3,
		gen_rtx_CALL (VOIDmode,
	operand0,
	operand1),
		gen_rtx_USE (VOIDmode,
	operand2),
		gen_rtx_USE (VOIDmode,
	operand3))));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:109 */
rtx
gen_sibcall_value (rtx operand0,
	rtx operand1,
	rtx operand2)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[3];
    operands[0] = operand0;
    operands[1] = operand1;
    operands[2] = operand2;

{
  or32_expand_sibcall (operands[0], XEXP (operands[1], 0), operands[2]); 
  DONE; 
}
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
  }
  emit_call_insn (gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_CALL (VOIDmode,
	operand1,
	operand2)));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:136 */
rtx
gen_movqi (rtx operand0,
	rtx operand1)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[2];
    operands[0] = operand0;
    operands[1] = operand1;

      if (!no_new_pseudos)
        {
          if (GET_CODE (operands[1]) == CONST_INT)
	    {
	      rtx reg = gen_reg_rtx (SImode);

	      emit_insn (gen_movsi (reg, operands[1]));
	      operands[1] = gen_lowpart (QImode, reg);
	    }
	  if (GET_CODE (operands[1]) == MEM && optimize > 0)
	    {
	      rtx reg = gen_reg_rtx (SImode);

	      emit_insn (gen_rtx_SET (SImode, reg,
				  gen_rtx_ZERO_EXTEND (SImode,
						       operands[1])));

	      operands[1] = gen_lowpart (QImode, reg);
	    }
          if (GET_CODE (operands[0]) != REG)
	    operands[1] = force_reg (QImode, operands[1]);
        }

    operand0 = operands[0];
    operand1 = operands[1];
  }
  emit_insn (gen_rtx_SET (VOIDmode,
	operand0,
	operand1));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:182 */
rtx
gen_movhi (rtx operand0,
	rtx operand1)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[2];
    operands[0] = operand0;
    operands[1] = operand1;

      if (!no_new_pseudos)
        {
          if (GET_CODE (operands[1]) == CONST_INT)
	    {
	      rtx reg = gen_reg_rtx (SImode);

	      emit_insn (gen_movsi (reg, operands[1]));
	      operands[1] = gen_lowpart (HImode, reg);
	    }
	  if (GET_CODE (operands[1]) == MEM && optimize > 0)
	    {
	      rtx reg = gen_reg_rtx (SImode);

	      emit_insn (gen_rtx_SET (SImode, reg,
				      gen_rtx_ZERO_EXTEND (SImode,
					   	           operands[1])));
	      operands[1] = gen_lowpart (HImode, reg);
	    }
          if (GET_CODE (operands[0]) != REG)
	    operands[1] = force_reg (HImode, operands[1]);
        }

    operand0 = operands[0];
    operand1 = operands[1];
  }
  emit_insn (gen_rtx_SET (VOIDmode,
	operand0,
	operand1));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:222 */
rtx
gen_movsi (rtx operand0,
	rtx operand1)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[2];
    operands[0] = operand0;
    operands[1] = operand1;
{
  /* Working with CONST_INTs is easier, so convert
     a double if needed.  */

     if (GET_CODE (operands[1]) == CONST_DOUBLE) {
	   operands[1] = GEN_INT (CONST_DOUBLE_LOW (operands[1]));
  }

  /* Handle sets of MEM first.  */
  if (GET_CODE (operands[0]) == MEM)
  {
   if (register_operand(operands[1], SImode) 
		       || (operands[1] == const0_rtx))
	goto movsi_is_ok;

      if (! reload_in_progress)
	{
	  operands[0] = validize_mem (operands[0]);
	  operands[1] = force_reg (SImode, operands[1]);
	}
    }

  /* This makes sure we will not get rematched due to splittage.  */
  if (! CONSTANT_P (operands[1]) || input_operand (operands[1], SImode))
    ;
  else if (CONSTANT_P (operands[1])
	   && GET_CODE (operands[1]) != HIGH
	   && GET_CODE (operands[1]) != LO_SUM)
    {
      or32_emit_set_const32 (operands[0], operands[1]);
      DONE;
    }
 movsi_is_ok:
  ;
}
    operand0 = operands[0];
    operand1 = operands[1];
  }
  emit_insn (gen_rtx_SET (VOIDmode,
	operand0,
	operand1));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:312 */
rtx
gen_addsicc (rtx operand0,
	rtx operand1,
	rtx operand2,
	rtx operand3)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[4];
    operands[0] = operand0;
    operands[1] = operand1;
    operands[2] = operand2;
    operands[3] = operand3;
FAIL;
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
    operand3 = operands[3];
  }
  emit (operand0);
  emit (operand1);
  emit (operand2);
  emit (operand3);
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:320 */
rtx
gen_addhicc (rtx operand0,
	rtx operand1,
	rtx operand2,
	rtx operand3)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[4];
    operands[0] = operand0;
    operands[1] = operand1;
    operands[2] = operand2;
    operands[3] = operand3;
FAIL;
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
    operand3 = operands[3];
  }
  emit (operand0);
  emit (operand1);
  emit (operand2);
  emit (operand3);
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:328 */
rtx
gen_addqicc (rtx operand0,
	rtx operand1,
	rtx operand2,
	rtx operand3)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[4];
    operands[0] = operand0;
    operands[1] = operand1;
    operands[2] = operand2;
    operands[3] = operand3;
FAIL;
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
    operand3 = operands[3];
  }
  emit (operand0);
  emit (operand1);
  emit (operand2);
  emit (operand3);
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:341 */
rtx
gen_movsicc (rtx operand0,
	rtx operand1,
	rtx operand2,
	rtx operand3)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[4];
    operands[0] = operand0;
    operands[1] = operand1;
    operands[2] = operand2;
    operands[3] = operand3;

{
  if (or32_emit_cmove (operands[0], operands[1], operands[2], operands[3]))
    DONE;
}
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
    operand3 = operands[3];
  }
  emit_insn (gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_IF_THEN_ELSE (SImode,
	operand1,
	operand2,
	operand3)));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:353 */
rtx
gen_movhicc (rtx operand0,
	rtx operand1,
	rtx operand2,
	rtx operand3)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[4];
    operands[0] = operand0;
    operands[1] = operand1;
    operands[2] = operand2;
    operands[3] = operand3;

{
    FAIL;
}
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
    operand3 = operands[3];
  }
  emit_insn (gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_IF_THEN_ELSE (SImode,
	operand1,
	operand2,
	operand3)));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:364 */
rtx
gen_movqicc (rtx operand0,
	rtx operand1,
	rtx operand2,
	rtx operand3)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[4];
    operands[0] = operand0;
    operands[1] = operand1;
    operands[2] = operand2;
    operands[3] = operand3;

{
    FAIL;
}
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
    operand3 = operands[3];
  }
  emit_insn (gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_IF_THEN_ELSE (SImode,
	operand1,
	operand2,
	operand3)));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:422 */
rtx
gen_cmpsi (rtx operand0,
	rtx operand1)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[2];
    operands[0] = operand0;
    operands[1] = operand1;
{
  if (GET_CODE (operands[0]) == MEM && GET_CODE (operands[1]) == MEM)
    operands[0] = force_reg (SImode, operands[0]);
  or32_compare_op0 = operands[0];
  or32_compare_op1 = operands[1];
  DONE;
}
    operand0 = operands[0];
    operand1 = operands[1];
  }
  emit_insn (gen_rtx_SET (VOIDmode,
	gen_rtx_REG (CCmode,
	32),
	gen_rtx_COMPARE (CCmode,
	operand0,
	operand1)));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:441 */
rtx
gen_beq (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;
or32_expand_branch (EQ, operands[0]); DONE;
    operand0 = operands[0];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:446 */
rtx
gen_bne (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;
or32_expand_branch (NE, operands[0]); DONE;
    operand0 = operands[0];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:451 */
rtx
gen_bgt (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;
or32_expand_branch (GT, operands[0]); DONE;
    operand0 = operands[0];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:456 */
rtx
gen_bgtu (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;
or32_expand_branch (GTU, operands[0]); DONE;
    operand0 = operands[0];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:461 */
rtx
gen_blt (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;
or32_expand_branch (LT, operands[0]); DONE;
    operand0 = operands[0];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:466 */
rtx
gen_bltu (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;
or32_expand_branch (LTU, operands[0]); DONE;
    operand0 = operands[0];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:471 */
rtx
gen_bge (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;
or32_expand_branch (GE, operands[0]); DONE;
    operand0 = operands[0];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:476 */
rtx
gen_bgeu (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;
or32_expand_branch (GEU, operands[0]); DONE;
    operand0 = operands[0];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:481 */
rtx
gen_ble (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;
or32_expand_branch (LE, operands[0]); DONE;
    operand0 = operands[0];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:486 */
rtx
gen_bleu (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;
or32_expand_branch (LEU, operands[0]); DONE;
    operand0 = operands[0];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:648 */
rtx
gen_extendqisi2 (rtx operand0,
	rtx operand1)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[2];
    operands[0] = operand0;
    operands[1] = operand1;

{
  if (TARGET_SEXT)
    emit_insn (gen_extendqisi2_sext(operands[0], operands[1]));
  else {
    if ( GET_CODE(operands[1]) == MEM ) {
      emit_insn (gen_extendqisi2_no_sext_mem(operands[0], operands[1]));
    }
    else {
      emit_insn (gen_extendqisi2_no_sext_reg(operands[0], operands[1]));
    }
 }
 DONE;
}
    operand0 = operands[0];
    operand1 = operands[1];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  emit_insn (gen_rtx_USE (VOIDmode,
	operand1));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:685 */
rtx
gen_extendqisi2_no_sext_reg (rtx operand0,
	rtx operand1)
{
  rtx operand2;
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[3];
    operands[0] = operand0;
    operands[1] = operand1;

{
  operands[1] = gen_lowpart (SImode, operands[1]);
  operands[2] = gen_reg_rtx (SImode); }
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
  }
  emit_insn (gen_rtx_SET (VOIDmode,
	operand2,
	gen_rtx_ASHIFT (SImode,
	operand1,
	GEN_INT (24L))));
  emit_insn (gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_ASHIFTRT (SImode,
	operand2,
	GEN_INT (24L))));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:702 */
rtx
gen_extendhisi2 (rtx operand0,
	rtx operand1)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[2];
    operands[0] = operand0;
    operands[1] = operand1;

{
  if (TARGET_SEXT)
    emit_insn (gen_extendhisi2_sext(operands[0], operands[1]));
  else {
    if ( GET_CODE(operands[1]) == MEM ) {
      emit_insn (gen_extendhisi2_no_sext_mem(operands[0], operands[1]));
    }
    else {
      emit_insn (gen_extendhisi2_no_sext_reg(operands[0], operands[1]));
    }
 }
 DONE;
}
    operand0 = operands[0];
    operand1 = operands[1];
  }
  emit_insn (gen_rtx_USE (VOIDmode,
	operand0));
  emit_insn (gen_rtx_USE (VOIDmode,
	operand1));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:739 */
rtx
gen_extendhisi2_no_sext_reg (rtx operand0,
	rtx operand1)
{
  rtx operand2;
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[3];
    operands[0] = operand0;
    operands[1] = operand1;

{
  operands[1] = gen_lowpart (SImode, operands[1]);
  operands[2] = gen_reg_rtx (SImode); }
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
  }
  emit_insn (gen_rtx_SET (VOIDmode,
	operand2,
	gen_rtx_ASHIFT (SImode,
	operand1,
	GEN_INT (16L))));
  emit_insn (gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_ASHIFTRT (SImode,
	operand2,
	GEN_INT (16L))));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:950 */
rtx
gen_jump (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;

{
  if (!TARGET_ALIGNED_JUMPS)
    emit_jump_insn (gen_jump_internal (operands[0]));
  else
    emit_jump_insn (gen_jump_aligned (operands[0]));
  DONE;
}
    operand0 = operands[0];
  }
  emit_jump_insn (gen_rtx_SET (VOIDmode,
	pc_rtx,
	gen_rtx_LABEL_REF (VOIDmode,
	operand0)));
  emit_barrier ();  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:981 */
rtx
gen_indirect_jump (rtx operand0)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[1];
    operands[0] = operand0;

{
  if (!TARGET_ALIGNED_JUMPS)
    emit_jump_insn (gen_indirect_jump_internal (operands[0]));
  else
    emit_jump_insn (gen_indirect_jump_aligned (operands[0]));
  DONE;

}
    operand0 = operands[0];
  }
  emit_jump_insn (gen_rtx_SET (VOIDmode,
	pc_rtx,
	operand0));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1014 */
rtx
gen_call (rtx operand0,
	rtx operand1)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[2];
    operands[0] = operand0;
    operands[1] = operand1;

{
  if (!TARGET_ALIGNED_JUMPS)
    emit_call_insn (gen_call_internal (operands[0], operands[1]));
  else
    emit_call_insn (gen_call_aligned (operands[0], operands[1]));
  DONE;
}
    operand0 = operands[0];
    operand1 = operands[1];
  }
  emit_call_insn (gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_CALL (VOIDmode,
	operand0,
	operand1),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9)))));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1048 */
rtx
gen_call_value (rtx operand0,
	rtx operand1,
	rtx operand2)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[3];
    operands[0] = operand0;
    operands[1] = operand1;
    operands[2] = operand2;

{
  if (!TARGET_ALIGNED_JUMPS)
    emit_call_insn (gen_call_value_internal (operands[0], operands[1], operands[2]));
  else
    emit_call_insn (gen_call_value_aligned (operands[0], operands[1], operands[2]));
  DONE;
}
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
  }
  emit_call_insn (gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_CALL (VOIDmode,
	operand1,
	operand2)),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9)))));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1085 */
rtx
gen_call_value_indirect (rtx operand0,
	rtx operand1,
	rtx operand2)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[3];
    operands[0] = operand0;
    operands[1] = operand1;
    operands[2] = operand2;

{
  if (!TARGET_ALIGNED_JUMPS)
    emit_call_insn (gen_call_value_indirect_internal (operands[0], operands[1], operands[2]));
  else
    emit_call_insn (gen_call_value_indirect_aligned (operands[0], operands[1], operands[2]));
  DONE;
}
    operand0 = operands[0];
    operand1 = operands[1];
    operand2 = operands[2];
  }
  emit_call_insn (gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_SET (VOIDmode,
	operand0,
	gen_rtx_CALL (VOIDmode,
	gen_rtx_MEM (SImode,
	operand1),
	operand2)),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9)))));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1122 */
rtx
gen_call_indirect (rtx operand0,
	rtx operand1)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[2];
    operands[0] = operand0;
    operands[1] = operand1;

{
  if (!TARGET_ALIGNED_JUMPS)
    emit_call_insn (gen_call_indirect_internal (operands[0], operands[1]));
  else
    emit_call_insn (gen_call_indirect_aligned (operands[0], operands[1]));
  DONE;
}
    operand0 = operands[0];
    operand1 = operands[1];
  }
  emit_call_insn (gen_rtx_PARALLEL (VOIDmode,
	gen_rtvec (2,
		gen_rtx_CALL (VOIDmode,
	gen_rtx_MEM (SImode,
	operand0),
	operand1),
		gen_rtx_CLOBBER (VOIDmode,
	gen_rtx_REG (SImode,
	9)))));
  _val = get_insns ();
  end_sequence ();
  return _val;
}

/* ../../gcc-3.4.4/gcc/config/or32/or32.md:1156 */
rtx
gen_tablejump (rtx operand0,
	rtx operand1)
{
  rtx _val = 0;
  start_sequence ();
  {
    rtx operands[2];
    operands[0] = operand0;
    operands[1] = operand1;

{
  if (!TARGET_ALIGNED_JUMPS)
    emit_jump_insn (gen_tablejump_internal (operands[0], operands[1]));
  else
    emit_jump_insn (gen_tablejump_aligned (operands[0], operands[1]));
  DONE;
}
    operand0 = operands[0];
    operand1 = operands[1];
  }
  emit_jump_insn (gen_rtx_SET (VOIDmode,
	pc_rtx,
	operand0));
  emit_insn (gen_rtx_USE (VOIDmode,
	gen_rtx_LABEL_REF (VOIDmode,
	operand1)));
  _val = get_insns ();
  end_sequence ();
  return _val;
}



void
add_clobbers (rtx pattern ATTRIBUTE_UNUSED, int insn_code_number)
{
  switch (insn_code_number)
    {
    default:
      abort ();
    }
}


int
added_clobbers_hard_reg_p (int insn_code_number)
{
  switch (insn_code_number)
    {
    default:
      abort ();
    }
}
