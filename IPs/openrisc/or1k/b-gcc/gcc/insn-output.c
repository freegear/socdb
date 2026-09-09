/* Generated automatically by the program `genoutput'
   from the machine description file `md'.  */

#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "flags.h"
#include "ggc.h"
#include "rtl.h"
#include "expr.h"
#include "insn-codes.h"
#include "tm_p.h"
#include "function.h"
#include "regs.h"
#include "hard-reg-set.h"
#include "real.h"
#include "insn-config.h"

#include "conditions.h"
#include "insn-attr.h"

#include "recog.h"

#include "toplev.h"
#include "output.h"
#include "target.h"

static const char * const output_1[] = {
  "l.j     \t%S0%(\t    # sibcall s",
  "l.jr    \t%0%(\t     # sibcall r",
};

static const char * const output_2[] = {
  "l.sb    \t%0,%1\t    # movqi",
  "l.ori   \t%0,%1,0\t  # movqi: move reg to reg",
  "l.addi  \t%0,r0,%1\t # movqi: move immediate",
  "l.ori   \t%0,r0,%1\t # movqi: move immediate",
  "l.lbz   \t%0,%1\t    # movqi",
};

static const char * const output_3[] = {
  "l.sh    \t%0,%1\t # movhi",
  "l.ori   \t%0,%1,0\t # movhi: move reg to reg",
  "l.addi  \t%0,r0,%1\t # movhi: move immediate",
  "l.ori   \t%0,r0,%1\t # movhi: move immediate",
  "l.lhz   \t%0,%1\t # movhi",
};

static const char * const output_4[] = {
  "l.addi  \t%0,r0,%1\t # move immediate I",
  "l.ori   \t%0,r0,%1\t # move immediate K",
  "l.movhi \t%0,hi(%1)\t # move immediate M",
  "l.ori   \t%0,%1,0\t # move reg to reg",
  "l.lwz   \t%0,%1\t # SI load",
  "l.sw    \t%0,%1\t # SI store",
};

static const char *
output_8 (rtx *operands ATTRIBUTE_UNUSED, rtx insn ATTRIBUTE_UNUSED)
{

{ output_cmov(operands); }
}

static const char * const output_9[] = {
  "l.sfeqi\t%0,%1",
  "l.sfeq \t%0,%1",
};

static const char * const output_10[] = {
  "l.sfnei\t%0,%1",
  "l.sfne \t%0,%1",
};

static const char * const output_11[] = {
  "l.sfgtsi\t%0,%1",
  "l.sfgts \t%0,%1",
};

static const char * const output_12[] = {
  "l.sfgtui\t%0,%1",
  "l.sfgtu \t%0,%1",
};

static const char * const output_13[] = {
  "l.sfltsi\t%0,%1",
  "l.sflts \t%0,%1",
};

static const char * const output_14[] = {
  "l.sfltui\t%0,%1",
  "l.sfltu \t%0,%1",
};

static const char * const output_15[] = {
  "l.sfgesi\t%0,%1",
  "l.sfges \t%0,%1",
};

static const char * const output_16[] = {
  "l.sfgeui\t%0,%1",
  "l.sfgeu \t%0,%1",
};

static const char * const output_17[] = {
  "l.sflesi\t%0,%1",
  "l.sfles \t%0,%1",
};

static const char * const output_18[] = {
  "l.sfleui\t%0,%1",
  "l.sfleu \t%0,%1",
};

static const char *
output_19 (rtx *operands ATTRIBUTE_UNUSED, rtx insn ATTRIBUTE_UNUSED)
{

{ output_bf(operands); }
}

static const char *
output_20 (rtx *operands ATTRIBUTE_UNUSED, rtx insn ATTRIBUTE_UNUSED)
{

         return or32_output_move_double (operands);
	
}

static const char *
output_21 (rtx *operands ATTRIBUTE_UNUSED, rtx insn ATTRIBUTE_UNUSED)
{

         return or32_output_move_double (operands);
        
}

static const char * const output_22[] = {
  "l.ori   \t%0,%1,0\t # movsf",
  "l.lwz   \t%0,%1\t # movsf",
  "l.sw    \t%0,%1\t # movsf",
};

static const char * const output_23[] = {
  "l.extbs \t%0,%1\t # extendqisi2_has_signed_extend",
  "l.lbs   \t%0,%1\t # extendqisi2_has_signed_extend",
};

static const char * const output_25[] = {
  "l.exths \t%0,%1\t # extendhisi2_has_signed_extend",
  "l.lhs   \t%0,%1\t # extendhisi2_has_signed_extend",
};

static const char * const output_27[] = {
  "l.andi  \t%0,%1,0xff\t # zero_extendqisi2",
  "l.lbz   \t%0,%1\t # zero_extendqisi2",
};

static const char * const output_28[] = {
  "l.andi  \t%0,%1,0xffff\t # zero_extendqisi2",
  "l.lhz   \t%0,%1\t # zero_extendqisi2",
};

static const char * const output_29[] = {
  "l.sll   \t%0,%1,%2",
  "l.slli  \t%0,%1,%2",
};

static const char * const output_30[] = {
  "l.sra   \t%0,%1,%2",
  "l.srai  \t%0,%1,%2",
};

static const char * const output_31[] = {
  "l.srl   \t%0,%1,%2",
  "l.srli  \t%0,%1,%2",
};

static const char * const output_32[] = {
  "l.ror   \t%0,%1,%2",
  "l.rori  \t%0,%1,%2",
};

static const char * const output_33[] = {
  "l.and   \t%0,%1,%2",
  "l.andi  \t%0,%1,%2",
};

static const char * const output_34[] = {
  "l.or    \t%0,%1,%2",
  "l.ori   \t%0,%1,%2",
};

static const char * const output_35[] = {
  "l.xor   \t%0,%1,%2",
  "l.xori  \t%0,%1,%2",
};

static const char * const output_39[] = {
  "l.add   \t%0,%1,%2",
  "l.addi  \t%0,%1,%2",
};

static const char * const output_40[] = {
  "l.sub   \t%0,%1,%2",
  "l.addi  \t%0,%1,%n2",
};



static const struct insn_operand_data operand_data[] = 
{
  {
    0,
    "",
    VOIDmode,
    0,
    0
  },
  {
    pmode_register_operand,
    "",
    VOIDmode,
    0,
    1
  },
  {
    sibcall_insn_operand,
    "s,r",
    SImode,
    0,
    1
  },
  {
    0,
    "",
    VOIDmode,
    0,
    1
  },
  {
    nonimmediate_operand,
    "=m,r,r,r,r",
    QImode,
    0,
    1
  },
  {
    general_operand,
    "r,r,I,K,m",
    QImode,
    0,
    1
  },
  {
    nonimmediate_operand,
    "=m,r,r,r,r",
    HImode,
    0,
    1
  },
  {
    general_operand,
    "r,r,I,K,m",
    HImode,
    0,
    1
  },
  {
    nonimmediate_operand,
    "=r,r,r,r,r,m",
    SImode,
    0,
    1
  },
  {
    input_operand,
    "I,K,M,r,m,r",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "r",
    SImode,
    0,
    1
  },
  {
    immediate_operand,
    "i",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    SImode,
    0,
    1
  },
  {
    immediate_operand,
    "i",
    SImode,
    0,
    1
  },
  {
    nonimmediate_operand,
    "=r",
    SImode,
    0,
    1
  },
  {
    immediate_operand,
    "i",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    SImode,
    0,
    1
  },
  {
    comparison_operator,
    "",
    VOIDmode,
    0,
    0
  },
  {
    register_operand,
    "r",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "r",
    SImode,
    0,
    1
  },
  {
    cc_reg_operand,
    "",
    VOIDmode,
    0,
    1
  },
  {
    register_operand,
    "r,r",
    SImode,
    0,
    1
  },
  {
    nonmemory_operand,
    "I,r",
    SImode,
    0,
    1
  },
  {
    0,
    "",
    VOIDmode,
    0,
    1
  },
  {
    comparison_operator,
    "",
    VOIDmode,
    0,
    0
  },
  {
    cc_reg_operand,
    "",
    VOIDmode,
    0,
    1
  },
  {
    nonimmediate_operand,
    "=r,r,m,r",
    DImode,
    0,
    1
  },
  {
    general_operand,
    "r,m,r,i",
    DImode,
    0,
    1
  },
  {
    nonimmediate_operand,
    "=r,r,m,r",
    DFmode,
    0,
    1
  },
  {
    general_operand,
    "r,m,r,i",
    DFmode,
    0,
    1
  },
  {
    general_operand,
    "=r,r,m",
    SFmode,
    0,
    1
  },
  {
    general_operand,
    "r,m,r",
    SFmode,
    0,
    1
  },
  {
    register_operand,
    "=r,r",
    SImode,
    0,
    1
  },
  {
    nonimmediate_operand,
    "r,m",
    QImode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    SImode,
    0,
    1
  },
  {
    memory_operand,
    "m",
    QImode,
    0,
    1
  },
  {
    register_operand,
    "=r,r",
    SImode,
    0,
    1
  },
  {
    nonimmediate_operand,
    "r,m",
    HImode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    SImode,
    0,
    1
  },
  {
    memory_operand,
    "m",
    HImode,
    0,
    1
  },
  {
    register_operand,
    "=r,r",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "r,r",
    SImode,
    0,
    1
  },
  {
    nonmemory_operand,
    "r,L",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "=r,r",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "%r,r",
    SImode,
    0,
    1
  },
  {
    nonmemory_operand,
    "r,K",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "=r,r",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "%r,r",
    SImode,
    0,
    1
  },
  {
    nonmemory_operand,
    "r,I",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    QImode,
    0,
    1
  },
  {
    register_operand,
    "r",
    QImode,
    0,
    1
  },
  {
    register_operand,
    "=r,r",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "r,r",
    SImode,
    0,
    1
  },
  {
    nonmemory_operand,
    "r,I",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "r",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "r",
    SImode,
    0,
    1
  },
  {
    sym_ref_mem_operand,
    "",
    SImode,
    0,
    1
  },
  {
    0,
    "i",
    VOIDmode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    VOIDmode,
    0,
    1
  },
  {
    sym_ref_mem_operand,
    "",
    SImode,
    0,
    1
  },
  {
    0,
    "i",
    VOIDmode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    VOIDmode,
    0,
    1
  },
  {
    register_operand,
    "r",
    SImode,
    0,
    1
  },
  {
    0,
    "i",
    VOIDmode,
    0,
    1
  },
  {
    register_operand,
    "r",
    SImode,
    0,
    1
  },
  {
    0,
    "",
    VOIDmode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    SFmode,
    0,
    1
  },
  {
    register_operand,
    "r",
    SFmode,
    0,
    1
  },
  {
    register_operand,
    "r",
    SFmode,
    0,
    1
  },
  {
    register_operand,
    "=r",
    DFmode,
    0,
    1
  },
  {
    register_operand,
    "r",
    DFmode,
    0,
    1
  },
  {
    register_operand,
    "r",
    DFmode,
    0,
    1
  },
  {
    0,
    "",
    VOIDmode,
    0,
    1
  },
  {
    0,
    "",
    VOIDmode,
    0,
    1
  },
  {
    0,
    "",
    VOIDmode,
    0,
    1
  },
  {
    0,
    "",
    VOIDmode,
    0,
    1
  },
  {
    0,
    "",
    SImode,
    0,
    1
  },
  {
    0,
    "",
    VOIDmode,
    0,
    1
  },
  {
    general_operand,
    "",
    QImode,
    0,
    1
  },
  {
    general_operand,
    "",
    QImode,
    0,
    1
  },
  {
    general_operand,
    "",
    HImode,
    0,
    1
  },
  {
    general_operand,
    "",
    HImode,
    0,
    1
  },
  {
    general_operand,
    "",
    SImode,
    0,
    1
  },
  {
    general_operand,
    "",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "",
    SImode,
    0,
    1
  },
  {
    comparison_operator,
    "",
    VOIDmode,
    0,
    1
  },
  {
    register_operand,
    "",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "",
    HImode,
    0,
    1
  },
  {
    comparison_operator,
    "",
    VOIDmode,
    0,
    1
  },
  {
    register_operand,
    "",
    HImode,
    0,
    1
  },
  {
    register_operand,
    "",
    HImode,
    0,
    1
  },
  {
    register_operand,
    "",
    QImode,
    0,
    1
  },
  {
    comparison_operator,
    "",
    VOIDmode,
    0,
    1
  },
  {
    register_operand,
    "",
    QImode,
    0,
    1
  },
  {
    register_operand,
    "",
    QImode,
    0,
    1
  },
  {
    register_operand,
    "",
    SImode,
    0,
    1
  },
  {
    nonmemory_operand,
    "",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "",
    SImode,
    0,
    1
  },
  {
    nonimmediate_operand,
    "",
    QImode,
    0,
    1
  },
  {
    register_operand,
    "",
    SImode,
    0,
    1
  },
  {
    register_operand,
    "",
    QImode,
    0,
    1
  },
  {
    register_operand,
    "",
    SImode,
    0,
    1
  },
  {
    nonimmediate_operand,
    "",
    HImode,
    0,
    1
  },
};


#if GCC_VERSION >= 2007
__extension__
#endif

const struct insn_data insn_data[] = 
{
  {
    "return_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.jr    \t%0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_return_internal,
    &operand_data[1],
    1,
    0,
    0,
    1
  },
  {
    "sibcall_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_1 },
#else
    { 0, output_1, 0 },
#endif
    (insn_gen_fn) gen_sibcall_internal,
    &operand_data[2],
    2,
    0,
    2,
    2
  },
  {
    "*movqi_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_2 },
#else
    { 0, output_2, 0 },
#endif
    0,
    &operand_data[4],
    2,
    0,
    5,
    2
  },
  {
    "*movhi_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_3 },
#else
    { 0, output_3, 0 },
#endif
    0,
    &operand_data[6],
    2,
    0,
    5,
    2
  },
  {
    "*movsi_insn",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_4 },
#else
    { 0, output_4, 0 },
#endif
    0,
    &operand_data[8],
    2,
    0,
    6,
    2
  },
  {
    "*movsi_lo_sum",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.ori   \t%0,%1,lo(%2)",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    0,
    &operand_data[10],
    3,
    0,
    1,
    1
  },
  {
    "*movsi_high",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.movhi  \t%0,hi(%1)",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    0,
    &operand_data[13],
    2,
    0,
    1,
    1
  },
  {
    "movsi_insn_big",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.movhi \t%0,hi(%1)\n\tl.ori   \t%0,%0,lo(%1)",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_movsi_insn_big,
    &operand_data[15],
    2,
    0,
    1,
    1
  },
  {
    "cmov",
#if HAVE_DESIGNATED_INITIALIZERS
    { .function = output_8 },
#else
    { 0, 0, output_8 },
#endif
    (insn_gen_fn) gen_cmov,
    &operand_data[17],
    5,
    0,
    1,
    3
  },
  {
    "*cmpsi_eq",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_9 },
#else
    { 0, output_9, 0 },
#endif
    0,
    &operand_data[22],
    2,
    0,
    2,
    2
  },
  {
    "*cmpsi_ne",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_10 },
#else
    { 0, output_10, 0 },
#endif
    0,
    &operand_data[22],
    2,
    0,
    2,
    2
  },
  {
    "*cmpsi_gt",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_11 },
#else
    { 0, output_11, 0 },
#endif
    0,
    &operand_data[22],
    2,
    0,
    2,
    2
  },
  {
    "*cmpsi_gtu",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_12 },
#else
    { 0, output_12, 0 },
#endif
    0,
    &operand_data[22],
    2,
    0,
    2,
    2
  },
  {
    "*cmpsi_lt",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_13 },
#else
    { 0, output_13, 0 },
#endif
    0,
    &operand_data[22],
    2,
    0,
    2,
    2
  },
  {
    "*cmpsi_ltu",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_14 },
#else
    { 0, output_14, 0 },
#endif
    0,
    &operand_data[22],
    2,
    0,
    2,
    2
  },
  {
    "*cmpsi_ge",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_15 },
#else
    { 0, output_15, 0 },
#endif
    0,
    &operand_data[22],
    2,
    0,
    2,
    2
  },
  {
    "*cmpsi_geu",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_16 },
#else
    { 0, output_16, 0 },
#endif
    0,
    &operand_data[22],
    2,
    0,
    2,
    2
  },
  {
    "*cmpsi_le",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_17 },
#else
    { 0, output_17, 0 },
#endif
    0,
    &operand_data[22],
    2,
    0,
    2,
    2
  },
  {
    "*cmpsi_leu",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_18 },
#else
    { 0, output_18, 0 },
#endif
    0,
    &operand_data[22],
    2,
    0,
    2,
    2
  },
  {
    "*bf",
#if HAVE_DESIGNATED_INITIALIZERS
    { .function = output_19 },
#else
    { 0, 0, output_19 },
#endif
    0,
    &operand_data[24],
    3,
    0,
    0,
    3
  },
  {
    "movdi",
#if HAVE_DESIGNATED_INITIALIZERS
    { .function = output_20 },
#else
    { 0, 0, output_20 },
#endif
    (insn_gen_fn) gen_movdi,
    &operand_data[27],
    2,
    0,
    4,
    3
  },
  {
    "movdf",
#if HAVE_DESIGNATED_INITIALIZERS
    { .function = output_21 },
#else
    { 0, 0, output_21 },
#endif
    (insn_gen_fn) gen_movdf,
    &operand_data[29],
    2,
    0,
    4,
    3
  },
  {
    "movsf",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_22 },
#else
    { 0, output_22, 0 },
#endif
    (insn_gen_fn) gen_movsf,
    &operand_data[31],
    2,
    0,
    3,
    2
  },
  {
    "extendqisi2_sext",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_23 },
#else
    { 0, output_23, 0 },
#endif
    (insn_gen_fn) gen_extendqisi2_sext,
    &operand_data[33],
    2,
    0,
    2,
    2
  },
  {
    "extendqisi2_no_sext_mem",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.lbs   \t%0,%1\t # extendqisi2_no_sext_mem",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_extendqisi2_no_sext_mem,
    &operand_data[35],
    2,
    0,
    1,
    1
  },
  {
    "extendhisi2_sext",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_25 },
#else
    { 0, output_25, 0 },
#endif
    (insn_gen_fn) gen_extendhisi2_sext,
    &operand_data[37],
    2,
    0,
    2,
    2
  },
  {
    "extendhisi2_no_sext_mem",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.lhs   \t%0,%1\t # extendhisi2_no_sext_mem",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_extendhisi2_no_sext_mem,
    &operand_data[39],
    2,
    0,
    1,
    1
  },
  {
    "zero_extendqisi2",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_27 },
#else
    { 0, output_27, 0 },
#endif
    (insn_gen_fn) gen_zero_extendqisi2,
    &operand_data[33],
    2,
    0,
    2,
    2
  },
  {
    "zero_extendhisi2",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_28 },
#else
    { 0, output_28, 0 },
#endif
    (insn_gen_fn) gen_zero_extendhisi2,
    &operand_data[37],
    2,
    0,
    2,
    2
  },
  {
    "ashlsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_29 },
#else
    { 0, output_29, 0 },
#endif
    (insn_gen_fn) gen_ashlsi3,
    &operand_data[41],
    3,
    0,
    2,
    2
  },
  {
    "ashrsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_30 },
#else
    { 0, output_30, 0 },
#endif
    (insn_gen_fn) gen_ashrsi3,
    &operand_data[41],
    3,
    0,
    2,
    2
  },
  {
    "lshrsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_31 },
#else
    { 0, output_31, 0 },
#endif
    (insn_gen_fn) gen_lshrsi3,
    &operand_data[41],
    3,
    0,
    2,
    2
  },
  {
    "rotrsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_32 },
#else
    { 0, output_32, 0 },
#endif
    (insn_gen_fn) gen_rotrsi3,
    &operand_data[41],
    3,
    0,
    2,
    2
  },
  {
    "andsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_33 },
#else
    { 0, output_33, 0 },
#endif
    (insn_gen_fn) gen_andsi3,
    &operand_data[44],
    3,
    0,
    2,
    2
  },
  {
    "iorsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_34 },
#else
    { 0, output_34, 0 },
#endif
    (insn_gen_fn) gen_iorsi3,
    &operand_data[44],
    3,
    0,
    2,
    2
  },
  {
    "xorsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_35 },
#else
    { 0, output_35, 0 },
#endif
    (insn_gen_fn) gen_xorsi3,
    &operand_data[47],
    3,
    0,
    2,
    2
  },
  {
    "one_cmplqi2",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.xori  \t%0,%1,0x00ff",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_one_cmplqi2,
    &operand_data[50],
    2,
    0,
    1,
    1
  },
  {
    "one_cmplsi2",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.xori  \t%0,%1,0xffff",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_one_cmplsi2,
    &operand_data[10],
    2,
    0,
    1,
    1
  },
  {
    "negsi2",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.sub   \t%0,r0,%1",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_negsi2,
    &operand_data[10],
    2,
    0,
    1,
    1
  },
  {
    "addsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_39 },
#else
    { 0, output_39, 0 },
#endif
    (insn_gen_fn) gen_addsi3,
    &operand_data[47],
    3,
    0,
    2,
    2
  },
  {
    "subsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .multi = output_40 },
#else
    { 0, output_40, 0 },
#endif
    (insn_gen_fn) gen_subsi3,
    &operand_data[52],
    3,
    0,
    2,
    2
  },
  {
    "mulsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.mul   \t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_mulsi3,
    &operand_data[55],
    3,
    0,
    1,
    1
  },
  {
    "divsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.div   \t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_divsi3,
    &operand_data[55],
    3,
    0,
    1,
    1
  },
  {
    "udivsi3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.divu  \t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_udivsi3,
    &operand_data[55],
    3,
    0,
    1,
    1
  },
  {
    "jump_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.j     \t%l0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_jump_internal,
    &operand_data[3],
    1,
    0,
    0,
    1
  },
  {
    "jump_aligned",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    ".balignl 0x8,0x15000015,0x4\n\tl.j     \t%l0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_jump_aligned,
    &operand_data[3],
    1,
    0,
    0,
    1
  },
  {
    "indirect_jump_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.jr    \t%0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_indirect_jump_internal,
    &operand_data[11],
    1,
    0,
    1,
    1
  },
  {
    "indirect_jump_aligned",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    ".balignl 0x8,0x15000015,0x4\n\tl.jr    \t%0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_indirect_jump_aligned,
    &operand_data[11],
    1,
    0,
    1,
    1
  },
  {
    "call_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.jal   \t%S0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_call_internal,
    &operand_data[58],
    2,
    0,
    1,
    1
  },
  {
    "call_aligned",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    ".balignl 0x8,0x15000015,0x4\n\tl.jal   \t%S0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_call_aligned,
    &operand_data[58],
    2,
    0,
    1,
    1
  },
  {
    "call_value_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.jal   \t%S1%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_call_value_internal,
    &operand_data[60],
    3,
    0,
    1,
    1
  },
  {
    "call_value_aligned",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    ".balignl 0x8,0x15000015,0x4\n\tl.jal   \t%S1%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_call_value_aligned,
    &operand_data[60],
    3,
    0,
    1,
    1
  },
  {
    "call_value_indirect_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.jalr  \t%1%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_call_value_indirect_internal,
    &operand_data[63],
    3,
    0,
    1,
    1
  },
  {
    "call_value_indirect_aligned",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    ".balignl 0x8,0x15000015,0x4\n\tl.jalr  \t%1%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_call_value_indirect_aligned,
    &operand_data[63],
    3,
    0,
    1,
    1
  },
  {
    "call_indirect_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.jalr  \t%0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_call_indirect_internal,
    &operand_data[64],
    2,
    0,
    1,
    1
  },
  {
    "call_indirect_aligned",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    ".balignl 0x8,0x15000015,0x4\n\tl.jalr  \t%0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_call_indirect_aligned,
    &operand_data[64],
    2,
    0,
    1,
    1
  },
  {
    "tablejump_internal",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.jr    \t%0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_tablejump_internal,
    &operand_data[66],
    2,
    0,
    1,
    1
  },
  {
    "tablejump_aligned",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    ".balignl 0x8,0x15000015,0x4\n\tl.jr    \t%0%(",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_tablejump_aligned,
    &operand_data[66],
    2,
    0,
    1,
    1
  },
  {
    "nop",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "l.nop",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_nop,
    &operand_data[0],
    0,
    0,
    0,
    1
  },
  {
    "addsf3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "lf.add.s\t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_addsf3,
    &operand_data[68],
    3,
    0,
    1,
    1
  },
  {
    "adddf3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "lf.add.d\t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_adddf3,
    &operand_data[71],
    3,
    0,
    1,
    1
  },
  {
    "subsf3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "lf.sub.s\t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_subsf3,
    &operand_data[68],
    3,
    0,
    1,
    1
  },
  {
    "subdf3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "lf.sub.d\t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_subdf3,
    &operand_data[71],
    3,
    0,
    1,
    1
  },
  {
    "mulsf3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "lf.mul.s\t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_mulsf3,
    &operand_data[68],
    3,
    0,
    1,
    1
  },
  {
    "muldf3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "lf.mul.d\t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_muldf3,
    &operand_data[71],
    3,
    0,
    1,
    1
  },
  {
    "divsf3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "lf.div.s\t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_divsf3,
    &operand_data[68],
    3,
    0,
    1,
    1
  },
  {
    "divdf3",
#if HAVE_DESIGNATED_INITIALIZERS
    { .single =
#else
    {
#endif
    "lf.div.d\t%0,%1,%2",
#if HAVE_DESIGNATED_INITIALIZERS
    },
#else
    0, 0 },
#endif
    (insn_gen_fn) gen_divdf3,
    &operand_data[71],
    3,
    0,
    1,
    1
  },
  {
    "prologue",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_prologue,
    &operand_data[0],
    0,
    0,
    0,
    0
  },
  {
    "epilogue",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_epilogue,
    &operand_data[0],
    0,
    0,
    0,
    0
  },
  {
    "sibcall_epilogue",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_sibcall_epilogue,
    &operand_data[0],
    0,
    0,
    0,
    0
  },
  {
    "sibcall",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_sibcall,
    &operand_data[74],
    4,
    0,
    0,
    0
  },
  {
    "sibcall_value",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_sibcall_value,
    &operand_data[77],
    3,
    0,
    0,
    0
  },
  {
    "movqi",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_movqi,
    &operand_data[80],
    2,
    0,
    0,
    0
  },
  {
    "movhi",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_movhi,
    &operand_data[82],
    2,
    0,
    0,
    0
  },
  {
    "movsi",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_movsi,
    &operand_data[84],
    2,
    0,
    0,
    0
  },
  {
    "addsicc",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_addsicc,
    &operand_data[86],
    4,
    0,
    0,
    0
  },
  {
    "addhicc",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_addhicc,
    &operand_data[90],
    4,
    0,
    0,
    0
  },
  {
    "addqicc",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_addqicc,
    &operand_data[94],
    4,
    0,
    0,
    0
  },
  {
    "movsicc",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_movsicc,
    &operand_data[86],
    4,
    0,
    0,
    0
  },
  {
    "movhicc",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_movhicc,
    &operand_data[90],
    4,
    0,
    0,
    0
  },
  {
    "movqicc",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_movqicc,
    &operand_data[94],
    4,
    0,
    0,
    0
  },
  {
    "cmpsi",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_cmpsi,
    &operand_data[98],
    2,
    0,
    0,
    0
  },
  {
    "beq",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_beq,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "bne",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_bne,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "bgt",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_bgt,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "bgtu",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_bgtu,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "blt",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_blt,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "bltu",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_bltu,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "bge",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_bge,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "bgeu",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_bgeu,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "ble",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_ble,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "bleu",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_bleu,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "extendqisi2",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_extendqisi2,
    &operand_data[100],
    2,
    0,
    0,
    0
  },
  {
    "extendqisi2_no_sext_reg",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_extendqisi2_no_sext_reg,
    &operand_data[102],
    2,
    2,
    0,
    0
  },
  {
    "extendhisi2",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_extendhisi2,
    &operand_data[104],
    2,
    0,
    0,
    0
  },
  {
    "extendhisi2_no_sext_reg",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_extendhisi2_no_sext_reg,
    &operand_data[89],
    2,
    2,
    0,
    0
  },
  {
    "jump",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_jump,
    &operand_data[3],
    1,
    0,
    0,
    0
  },
  {
    "indirect_jump",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_indirect_jump,
    &operand_data[11],
    1,
    0,
    1,
    0
  },
  {
    "call",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_call,
    &operand_data[58],
    2,
    0,
    1,
    0
  },
  {
    "call_value",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_call_value,
    &operand_data[60],
    3,
    0,
    1,
    0
  },
  {
    "call_value_indirect",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_call_value_indirect,
    &operand_data[63],
    3,
    0,
    1,
    0
  },
  {
    "call_indirect",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_call_indirect,
    &operand_data[64],
    2,
    0,
    1,
    0
  },
  {
    "tablejump",
#if HAVE_DESIGNATED_INITIALIZERS
    { 0 },
#else
    { 0, 0, 0 },
#endif
    (insn_gen_fn) gen_tablejump,
    &operand_data[66],
    2,
    0,
    1,
    0
  },
};


const char *
get_insn_name (int code)
{
  if (code == NOOP_MOVE_INSN_CODE)
    return "NOOP_MOVE";
  else
    return insn_data[code].name;
}
