/* Generated automatically by the program `genconditions' from the target
   machine description file.  */

#include "bconfig.h"
#include "insn-constants.h"

/* Do not allow checking to confuse the issue.  */
#undef ENABLE_CHECKING
#undef ENABLE_TREE_CHECKING
#undef ENABLE_RTL_CHECKING
#undef ENABLE_RTL_FLAG_CHECKING
#undef ENABLE_GC_CHECKING
#undef ENABLE_GC_ALWAYS_COLLECT

#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "rtl.h"
#include "tm_p.h"
#include "function.h"

/* Fake - insn-config.h doesn't exist yet.  */
#define MAX_RECOG_OPERANDS 10
#define MAX_DUP_OPERANDS 10
#define MAX_INSNS_PER_SPLIT 5

#include "regs.h"
#include "recog.h"
#include "real.h"
#include "output.h"
#include "flags.h"
#include "hard-reg-set.h"
#include "resource.h"
#include "toplev.h"
#include "reload.h"
#include "gensupport.h"

#include "except.h"

/* Dummy external declarations.  */
extern rtx insn;
extern rtx ins1;
extern rtx operands[];

/* If we don't have __builtin_constant_p, or it's not acceptable in
   array initializers, fall back to assuming that all conditions
   potentially vary at run time.  It works in 3.0.1 and later; 3.0
   only when not optimizing.  */
#if (GCC_VERSION >= 3001) || ((GCC_VERSION == 3000) && !__OPTIMIZE__)
# define MAYBE_EVAL(expr) (__builtin_constant_p(expr) ? (int) (expr) : -1)
#else
# define MAYBE_EVAL(expr) -1
#endif

/* This table lists each condition found in the machine description.
   Each condition is mapped to its truth value (0 or 1), or -1 if that
   cannot be calculated at compile time. */

const struct c_test insn_conditions[] = {
  { "!TARGET_ALIGNED_JUMPS",
    MAYBE_EVAL (!TARGET_ALIGNED_JUMPS) },
  { "!TARGET_SEXT",
    MAYBE_EVAL (!TARGET_SEXT) },
  { "(register_operand (operands[0], SImode)\n\
    || register_operand (operands[1], SImode)\n\
    || (operands[1] == const0_rtx))",
    MAYBE_EVAL ((register_operand (operands[0], SImode)
    || register_operand (operands[1], SImode)
    || (operands[1] == const0_rtx))) },
  { "TARGET_SEXT",
    MAYBE_EVAL (TARGET_SEXT) },
  { "TARGET_HARD_DIV",
    MAYBE_EVAL (TARGET_HARD_DIV) },
  { "GET_CODE(operands[1]) != CONST_INT",
    MAYBE_EVAL (GET_CODE(operands[1]) != CONST_INT) },
  { "TARGET_ALIGNED_JUMPS",
    MAYBE_EVAL (TARGET_ALIGNED_JUMPS) },
  { "TARGET_CMOV",
    MAYBE_EVAL (TARGET_CMOV) },
  { "TARGET_HARD_MUL",
    MAYBE_EVAL (TARGET_HARD_MUL) },
  { "TARGET_HARD_FLOAT",
    MAYBE_EVAL (TARGET_HARD_FLOAT) },
  { "TARGET_SCHED_LOGUE",
    MAYBE_EVAL (TARGET_SCHED_LOGUE) },
  { "TARGET_ROR",
    MAYBE_EVAL (TARGET_ROR) },
  { "TARGET_SIBCALL",
    MAYBE_EVAL (TARGET_SIBCALL) },
};

const size_t n_insn_conditions = 13;
const int insn_elision_unavailable = 0;
