/* Generated automatically by the program `genopinit'
from the machine description file `md'.  */

#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "rtl.h"
#include "flags.h"
#include "insn-config.h"
#include "recog.h"
#include "expr.h"
#include "optabs.h"
#include "reload.h"

void
init_all_optabs (void)
{
#ifdef FIXUNS_TRUNC_LIKE_FIX_TRUNC
  int i, j;
#endif

  mov_optab->handlers[DImode].insn_code = CODE_FOR_movdi;
  mov_optab->handlers[DFmode].insn_code = CODE_FOR_movdf;
  mov_optab->handlers[SFmode].insn_code = CODE_FOR_movsf;
  zext_optab->handlers[SImode][QImode].insn_code = CODE_FOR_zero_extendqisi2;
  zext_optab->handlers[SImode][HImode].insn_code = CODE_FOR_zero_extendhisi2;
  ashl_optab->handlers[SImode].insn_code = CODE_FOR_ashlsi3;
  ashr_optab->handlers[SImode].insn_code = CODE_FOR_ashrsi3;
  lshr_optab->handlers[SImode].insn_code = CODE_FOR_lshrsi3;
  if (HAVE_rotrsi3)
    rotr_optab->handlers[SImode].insn_code = CODE_FOR_rotrsi3;
  and_optab->handlers[SImode].insn_code = CODE_FOR_andsi3;
  ior_optab->handlers[SImode].insn_code = CODE_FOR_iorsi3;
  xor_optab->handlers[SImode].insn_code = CODE_FOR_xorsi3;
  one_cmpl_optab->handlers[QImode].insn_code = CODE_FOR_one_cmplqi2;
  one_cmpl_optab->handlers[SImode].insn_code = CODE_FOR_one_cmplsi2;
  neg_optab->handlers[SImode].insn_code = CODE_FOR_negsi2;
  add_optab->handlers[SImode].insn_code = CODE_FOR_addsi3;
  sub_optab->handlers[SImode].insn_code = CODE_FOR_subsi3;
  if (HAVE_mulsi3)
    smul_optab->handlers[SImode].insn_code = CODE_FOR_mulsi3;
  if (HAVE_divsi3)
    sdiv_optab->handlers[SImode].insn_code = CODE_FOR_divsi3;
  if (HAVE_udivsi3)
    udiv_optab->handlers[SImode].insn_code = CODE_FOR_udivsi3;
  if (HAVE_addsf3)
    addv_optab->handlers[SFmode].insn_code =
    add_optab->handlers[SFmode].insn_code = CODE_FOR_addsf3;
  if (HAVE_adddf3)
    addv_optab->handlers[DFmode].insn_code =
    add_optab->handlers[DFmode].insn_code = CODE_FOR_adddf3;
  if (HAVE_subsf3)
    subv_optab->handlers[SFmode].insn_code =
    sub_optab->handlers[SFmode].insn_code = CODE_FOR_subsf3;
  if (HAVE_subdf3)
    subv_optab->handlers[DFmode].insn_code =
    sub_optab->handlers[DFmode].insn_code = CODE_FOR_subdf3;
  if (HAVE_mulsf3)
    smulv_optab->handlers[SFmode].insn_code =
    smul_optab->handlers[SFmode].insn_code = CODE_FOR_mulsf3;
  if (HAVE_muldf3)
    smulv_optab->handlers[DFmode].insn_code =
    smul_optab->handlers[DFmode].insn_code = CODE_FOR_muldf3;
  if (HAVE_divsf3)
    sdiv_optab->handlers[SFmode].insn_code = CODE_FOR_divsf3;
  if (HAVE_divdf3)
    sdiv_optab->handlers[DFmode].insn_code = CODE_FOR_divdf3;
  mov_optab->handlers[QImode].insn_code = CODE_FOR_movqi;
  mov_optab->handlers[HImode].insn_code = CODE_FOR_movhi;
  mov_optab->handlers[SImode].insn_code = CODE_FOR_movsi;
  addcc_optab->handlers[SImode].insn_code = CODE_FOR_addsicc;
  addcc_optab->handlers[HImode].insn_code = CODE_FOR_addhicc;
  addcc_optab->handlers[QImode].insn_code = CODE_FOR_addqicc;
  if (HAVE_movsicc)
    movcc_gen_code[SImode] = CODE_FOR_movsicc;
  movcc_gen_code[HImode] = CODE_FOR_movhicc;
  movcc_gen_code[QImode] = CODE_FOR_movqicc;
  cmp_optab->handlers[SImode].insn_code = CODE_FOR_cmpsi;
  bcc_gen_fctn[EQ] = gen_beq;
  bcc_gen_fctn[NE] = gen_bne;
  bcc_gen_fctn[GT] = gen_bgt;
  bcc_gen_fctn[GTU] = gen_bgtu;
  bcc_gen_fctn[LT] = gen_blt;
  bcc_gen_fctn[LTU] = gen_bltu;
  bcc_gen_fctn[GE] = gen_bge;
  bcc_gen_fctn[GEU] = gen_bgeu;
  bcc_gen_fctn[LE] = gen_ble;
  bcc_gen_fctn[LEU] = gen_bleu;
  sext_optab->handlers[SImode][QImode].insn_code = CODE_FOR_extendqisi2;
  sext_optab->handlers[SImode][HImode].insn_code = CODE_FOR_extendhisi2;

#ifdef FIXUNS_TRUNC_LIKE_FIX_TRUNC
  /* This flag says the same insns that convert to a signed fixnum
     also convert validly to an unsigned one.  */
  for (i = 0; i < NUM_MACHINE_MODES; i++)
    for (j = 0; j < NUM_MACHINE_MODES; j++)
      ufixtrunc_optab->handlers[i][j].insn_code
      = sfixtrunc_optab->handlers[i][j].insn_code;
#endif
}
