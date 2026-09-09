/* Generated automatically by the program `genattrtab'
from the machine description file `md'.  */

#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "rtl.h"
#include "tm_p.h"
#include "insn-config.h"
#include "recog.h"
#include "regs.h"
#include "real.h"
#include "output.h"
#include "insn-attr.h"
#include "toplev.h"
#include "flags.h"
#include "function.h"

#define operands recog_data.operand

int
insn_current_length (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 0;

    }
}

int
insn_variable_length_p (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 0;

    }
}

int
insn_default_length (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case 21:
    case 20:
      extract_constrain_insn_cached (insn);
      if (((1 << which_alternative) & 0x7))
        {
	  return 2;
        }
      else
        {
	  return 3;
        }

    case 7:
      return 2;

    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 1;

    }
}

int
bypass_p (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 0;

    }
}

int
insn_default_latency (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 0;

    }
}


#if AUTOMATON_ALTS
int
insn_alts (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 0;

    }
}

#endif

static int
internal_dfa_insn_code (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 1;

    }
}

int
result_ready_cost (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case 43:
    case 42:
    case 41:
      return 16 /* 0x10 */;

    case 32:
    case 31:
    case 30:
    case 29:
    case 26:
    case 24:
      return 3;

    case 28:
    case 27:
    case 25:
    case 23:
      extract_constrain_insn_cached (insn);
      if (which_alternative != 0)
        {
	  return 3;
        }
      else
        {
	  return 2;
        }

    case 58:
    case 40:
    case 39:
    case 38:
    case 37:
    case 36:
    case 35:
    case 34:
    case 33:
    case 7:
    case 6:
    case 5:
      return 2;

    case 22:
    case 4:
      extract_constrain_insn_cached (insn);
      if (which_alternative == 1)
        {
	  return 3;
        }
      else
        {
	  return 2;
        }

    case 3:
    case 2:
      extract_constrain_insn_cached (insn);
      if (!((1 << which_alternative) & 0xf))
        {
	  return 3;
        }
      else
        {
	  return 2;
        }

    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 1;

    }
}

static int
mul_unit_unit_ready_cost (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 16 /* 0x10 */;

    }
}

static int
alu_unit_ready_cost (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 2;

    }
}

static int
lsu_unit_ready_cost (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case 22:
      extract_constrain_insn_cached (insn);
      if (!((1 << which_alternative) & 0x3))
        {
	  return 2;
        }
      else
        {
	  return 3;
        }

    case 4:
      extract_constrain_insn_cached (insn);
      if (which_alternative == 2)
        {
	  return 2;
        }
      else
        {
	  return 3;
        }

    case 3:
    case 2:
      extract_constrain_insn_cached (insn);
      if (which_alternative == 0)
        {
	  return 2;
        }
      else
        {
	  return 3;
        }

    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 3;

    }
}

static unsigned int
lsu_unit_blockage_range (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 65539 /* min 1, max 3 */;

    }
}

static int
bit_unit_unit_ready_cost (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 3;

    }
}

int
function_units_used (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case 43:
    case 42:
    case 41:
      return 3 /* units: mul_unit */;

    case 32:
    case 31:
    case 30:
    case 29:
      return 0 /* units: bit_unit */;

    case 26:
    case 24:
      return 1 /* units: lsu */;

    case 28:
    case 27:
    case 25:
    case 23:
    case 22:
      extract_constrain_insn_cached (insn);
      if (which_alternative != 0)
        {
	  return 1 /* units: lsu */;
        }
      else
        {
	  return 2 /* units: alu */;
        }

    case 58:
    case 40:
    case 39:
    case 38:
    case 37:
    case 36:
    case 35:
    case 34:
    case 33:
    case 7:
    case 6:
    case 5:
      return 2 /* units: alu */;

    case 4:
      extract_constrain_insn_cached (insn);
      if (((1 << which_alternative) & 0x6))
        {
	  return 1 /* units: lsu */;
        }
      else
        {
	  return 2 /* units: alu */;
        }

    case 3:
    case 2:
      extract_constrain_insn_cached (insn);
      if (!((1 << which_alternative) & 0xe))
        {
	  return 1 /* units: lsu */;
        }
      else
        {
	  return 2 /* units: alu */;
        }

    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return -1 /* units: none */;

    }
}

int
num_delay_slots (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case 57:
    case 56:
    case 55:
    case 54:
    case 53:
    case 52:
    case 51:
    case 50:
    case 49:
    case 48:
    case 47:
    case 46:
    case 45:
    case 44:
    case 19:
    case 1:
    case 0:
      return 1;

    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 0;

    }
}

enum attr_type
get_attr_type (rtx insn ATTRIBUTE_UNUSED)
{
  switch (recog_memoized (insn))
    {
    case 3:
    case 2:
      extract_constrain_insn_cached (insn);
      if (which_alternative == 0)
        {
	  return TYPE_STORE;
        }
      else if (((1 << which_alternative) & 0x6))
        {
	  return TYPE_ADD;
        }
      else if (which_alternative == 3)
        {
	  return TYPE_LOGIC;
        }
      else
        {
	  return TYPE_LOAD;
        }

    case 4:
      extract_constrain_insn_cached (insn);
      if (which_alternative == 0)
        {
	  return TYPE_ADD;
        }
      else if (which_alternative == 1)
        {
	  return TYPE_LOAD;
        }
      else if (which_alternative == 2)
        {
	  return TYPE_STORE;
        }
      else if (which_alternative == 3)
        {
	  return TYPE_ADD;
        }
      else if (which_alternative == 4)
        {
	  return TYPE_LOGIC;
        }
      else
        {
	  return TYPE_MOVE;
        }

    case 22:
      extract_constrain_insn_cached (insn);
      if (which_alternative == 0)
        {
	  return TYPE_MOVE;
        }
      else if (which_alternative == 1)
        {
	  return TYPE_LOAD;
        }
      else
        {
	  return TYPE_STORE;
        }

    case 23:
    case 25:
      extract_constrain_insn_cached (insn);
      if (which_alternative == 0)
        {
	  return TYPE_EXTEND;
        }
      else
        {
	  return TYPE_LOAD;
        }

    case 27:
    case 28:
      extract_constrain_insn_cached (insn);
      if (which_alternative == 0)
        {
	  return TYPE_LOGIC;
        }
      else
        {
	  return TYPE_LOAD;
        }

    case 59:
    case 60:
    case 61:
    case 62:
    case 63:
    case 64:
    case 65:
    case 66:
      return TYPE_FP;

    case 19:
      return TYPE_BRANCH;

    case 29:
    case 30:
    case 31:
    case 32:
      return TYPE_SHIFT;

    case 41:
    case 42:
    case 43:
      return TYPE_MUL;

    case 38:
    case 39:
    case 40:
      return TYPE_ADD;

    case 5:
    case 33:
    case 34:
    case 35:
    case 36:
    case 37:
    case 58:
      return TYPE_LOGIC;

    case 6:
    case 7:
      return TYPE_MOVE;

    case 24:
    case 26:
      return TYPE_LOAD;

    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    case 8:
    case 9:
    case 10:
    case 11:
    case 12:
    case 13:
    case 14:
    case 15:
    case 16:
    case 17:
    case 18:
    case 20:
    case 21:
      return TYPE_UNKNOWN;

    default:
      return TYPE_JUMP;

    }
}

int
eligible_for_delay (rtx delay_insn ATTRIBUTE_UNUSED, int slot, rtx candidate_insn, int flags ATTRIBUTE_UNUSED)
{
  rtx insn;

  if (slot >= 1)
    abort ();

  insn = candidate_insn;
  switch (recog_memoized (insn))
    {
    case 57:
    case 56:
    case 55:
    case 54:
    case 53:
    case 52:
    case 51:
    case 50:
    case 49:
    case 48:
    case 47:
    case 46:
    case 45:
    case 44:
    case 21:
    case 20:
    case 19:
    case 7:
    case 1:
    case 0:
      return 0;

    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      return 1;

    }
}

static int
lsu_unit_blockage (rtx executing_insn, rtx candidate_insn)
{
  rtx insn;
  int casenum;

  insn = executing_insn;
  switch (recog_memoized (insn))
    {
    case 26:
    case 24:
      casenum = 0;
      break;

    case 28:
    case 27:
    case 25:
    case 23:
      extract_constrain_insn_cached (insn);
      casenum = 0;
      break;

    case 22:
    case 4:
      extract_constrain_insn_cached (insn);
      if (which_alternative == 1)
        {
	  casenum = 0;
        }
      else
        {
	  casenum = 1;
        }
      break;

    case 3:
    case 2:
      extract_constrain_insn_cached (insn);
      if (!((1 << which_alternative) & 0xf))
        {
	  casenum = 0;
        }
      else
        {
	  casenum = 1;
        }
      break;

    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      casenum = 1;
      break;

    }

  insn = candidate_insn;
  switch (casenum)
    {
    case 0:
      return 3;

    case 1:
      return 1;

    default:
      abort ();
    }
}

static int
lsu_unit_conflict_cost (rtx executing_insn, rtx candidate_insn)
{
  rtx insn;
  int casenum;

  insn = executing_insn;
  switch (recog_memoized (insn))
    {
    case 26:
    case 24:
      casenum = 0;
      break;

    case 28:
    case 27:
    case 25:
    case 23:
      extract_constrain_insn_cached (insn);
      casenum = 0;
      break;

    case 22:
    case 4:
      extract_constrain_insn_cached (insn);
      if (which_alternative == 1)
        {
	  casenum = 0;
        }
      else
        {
	  casenum = 1;
        }
      break;

    case 3:
    case 2:
      extract_constrain_insn_cached (insn);
      if (!((1 << which_alternative) & 0xf))
        {
	  casenum = 0;
        }
      else
        {
	  casenum = 1;
        }
      break;

    case -1:
      if (GET_CODE (PATTERN (insn)) != ASM_INPUT
          && asm_noperands (PATTERN (insn)) < 0)
        fatal_insn_not_found (insn);
    default:
      casenum = 1;
      break;

    }

  insn = candidate_insn;
  switch (casenum)
    {
    case 0:
      return 3;

    case 1:
      return 1;

    default:
      abort ();
    }
}

const struct function_unit_desc function_units[] = {
  {"bit_unit", 1, 1, 0, 1, 1, bit_unit_unit_ready_cost, 0, 1, 0, 0}, 
  {"lsu", 2, 1, 0, 0, 3, lsu_unit_ready_cost, lsu_unit_conflict_cost, 3, lsu_unit_blockage_range, lsu_unit_blockage}, 
  {"alu", 4, 1, 0, 1, 1, alu_unit_ready_cost, 0, 1, 0, 0}, 
  {"mul_unit", 8, 1, 0, 16, 16, mul_unit_unit_ready_cost, 0, 16, 0, 0}, 
};


int max_dfa_issue_rate = 0;
/* Vector translating external insn codes to internal ones.*/
static const unsigned char translate_0[] ATTRIBUTE_UNUSED = {
    0};

/* Vector for state transitions.  */
static const unsigned char transitions_0[] ATTRIBUTE_UNUSED = {
    0};


#if AUTOMATON_STATE_ALTS
/* Vector for state insn alternatives.  */
static const unsigned char state_alts_0[] ATTRIBUTE_UNUSED = {
    1};


#endif /* #if AUTOMATON_STATE_ALTS */

/* Vector of min issue delay of insns.  */
static const unsigned char min_issue_delay_0[] ATTRIBUTE_UNUSED = {
    0};

/* Vector for locked state flags.  */
static const unsigned char dead_lock_0[] = {
    1};


#if CPU_UNITS_QUERY

/* Vector for reserved units of states.  */
static const unsigned char reserved_units_0[] = {
0 /* This is dummy el because the vect is empty */};


#endif /* #if CPU_UNITS_QUERY */


#define DFA__ADVANCE_CYCLE 0

struct DFA_chip
{
  unsigned char automaton_state_0;
};


int max_insn_queue_index = 1;

static int
internal_min_issue_delay (int insn_code, struct DFA_chip *chip ATTRIBUTE_UNUSED)
{
  int temp ATTRIBUTE_UNUSED;
  int res = -1;

  switch (insn_code)
    {
    case 0: /* $advance_cycle */
      break;


    default:
      res = -1;
      break;
    }
  return res;
}

static int
internal_state_transition (int insn_code, struct DFA_chip *chip ATTRIBUTE_UNUSED)
{
  int temp ATTRIBUTE_UNUSED;

  switch (insn_code)
    {
    case 0: /* $advance_cycle */
      {
        return -1;
      }

    default:
      return -1;
    }
}


static int *dfa_insn_codes;

static int dfa_insn_codes_length;

static void
dfa_insn_code_enlarge (int uid)
{
  int i = dfa_insn_codes_length;
  dfa_insn_codes_length = 2 * uid;
  dfa_insn_codes = xrealloc (dfa_insn_codes,
                 dfa_insn_codes_length * sizeof(int));
  for (; i < dfa_insn_codes_length; i++)
    dfa_insn_codes[i] = -1;
}

static inline int
dfa_insn_code (rtx insn)
{
  int uid = INSN_UID (insn);
  int insn_code;

  if (uid >= dfa_insn_codes_length)
    dfa_insn_code_enlarge (uid);

  insn_code = dfa_insn_codes[uid];
  if (insn_code < 0)
    {
      insn_code = internal_dfa_insn_code (insn);
      dfa_insn_codes[uid] = insn_code;
    }
  return insn_code;
}

int
state_transition (state_t state, rtx insn)
{
  int insn_code;

  if (insn != 0)
    {
      insn_code = dfa_insn_code (insn);
      if (insn_code > DFA__ADVANCE_CYCLE)
        return -1;
    }
  else
    insn_code = DFA__ADVANCE_CYCLE;

  return internal_state_transition (insn_code, state);
}


#if AUTOMATON_STATE_ALTS

static int
internal_state_alts (int insn_code, struct DFA_chip *chip)
{
  int res;

  switch (insn_code)
    {
    case 0: /* $advance_cycle */
      {
        break;
      }


    default:
      res = 0;
      break;
    }
  return res;
}

int
state_alts (state, insn)
	state_t state;
	rtx insn;
{
  int insn_code;

  if (insn != 0)
    {
      insn_code = dfa_insn_code (insn);
      if (insn_code > DFA__ADVANCE_CYCLE)
        return 0;
    }
  else
    insn_code = DFA__ADVANCE_CYCLE;

  return internal_state_alts (insn_code, state);
}


#endif /* #if AUTOMATON_STATE_ALTS */

int
min_issue_delay (state_t state, rtx insn)
{
  int insn_code;

  if (insn != 0)
    {
      insn_code = dfa_insn_code (insn);
      if (insn_code > DFA__ADVANCE_CYCLE)
        return 0;
    }
  else
    insn_code = DFA__ADVANCE_CYCLE;

  return internal_min_issue_delay (insn_code, state);
}

static int
internal_state_dead_lock_p (struct DFA_chip *chip)
{
  if (dead_lock_0 [chip->automaton_state_0])
    return 1/* TRUE */;
  return 0/* FALSE */;
}

int
state_dead_lock_p (state_t state)
{
  return internal_state_dead_lock_p (state);
}

int
state_size (void)
{
  return sizeof (struct DFA_chip);
}

static inline void
internal_reset (struct DFA_chip *chip)
{
  memset (chip, 0, sizeof (struct DFA_chip));
}

void
state_reset (state_t state)
{
  internal_reset (state);
}

int
min_insn_conflict_delay (state_t state, rtx insn, rtx insn2)
{
  struct DFA_chip DFA_chip;
  int insn_code, insn2_code;

  if (insn != 0)
    {
      insn_code = dfa_insn_code (insn);
      if (insn_code > DFA__ADVANCE_CYCLE)
        return 0;
    }
  else
    insn_code = DFA__ADVANCE_CYCLE;


  if (insn2 != 0)
    {
      insn2_code = dfa_insn_code (insn2);
      if (insn2_code > DFA__ADVANCE_CYCLE)
        return 0;
    }
  else
    insn2_code = DFA__ADVANCE_CYCLE;

  memcpy (&DFA_chip, state, sizeof (DFA_chip));
  internal_reset (&DFA_chip);
  if (internal_state_transition (insn_code, &DFA_chip) > 0)
    abort ();
  return internal_min_issue_delay (insn2_code, &DFA_chip);
}

static int
internal_insn_latency (int insn_code ATTRIBUTE_UNUSED,
	int insn2_code ATTRIBUTE_UNUSED,
	rtx insn ATTRIBUTE_UNUSED,
	rtx insn2 ATTRIBUTE_UNUSED)
{
  return 0;
}

int
insn_latency (rtx insn, rtx insn2)
{
  int insn_code, insn2_code;

  if (insn != 0)
    {
      insn_code = dfa_insn_code (insn);
      if (insn_code > DFA__ADVANCE_CYCLE)
        return 0;
    }
  else
    insn_code = DFA__ADVANCE_CYCLE;


  if (insn2 != 0)
    {
      insn2_code = dfa_insn_code (insn2);
      if (insn2_code > DFA__ADVANCE_CYCLE)
        return 0;
    }
  else
    insn2_code = DFA__ADVANCE_CYCLE;

  return internal_insn_latency (insn_code, insn2_code, insn, insn2);
}

void
print_reservation (FILE *f, rtx insn ATTRIBUTE_UNUSED)
{
  fputs ("nothing", f);
}


#if CPU_UNITS_QUERY

int
get_cpu_unit_code (cpu_unit_name)
	const char *cpu_unit_name;
{
  struct name_code {const char *name; int code;};
  int cmp, l, m, h;
  static struct name_code name_code_table [] =
    {
    };

  /* The following is binary search: */
  l = 0;
  h = sizeof (name_code_table) / sizeof (struct name_code) - 1;
  while (l <= h)
    {
      m = (l + h) / 2;
      cmp = strcmp (cpu_unit_name, name_code_table [m].name);
      if (cmp < 0)
        h = m - 1;
      else if (cmp > 0)
        l = m + 1;
      else
        return name_code_table [m].code;
    }
  return -1;
}

int
cpu_unit_reservation_p (state, cpu_unit_code)
	state_t state;
	int cpu_unit_code;
{
  if (cpu_unit_code < 0 || cpu_unit_code >= 0)
    abort ();
  if ((reserved_units_0 [((struct DFA_chip *) state)->automaton_state_0 * 0 + cpu_unit_code / 8] >> (cpu_unit_code % 8)) & 1)
    return 1;
  return 0;
}


#endif /* #if CPU_UNITS_QUERY */

void
dfa_clean_insn_cache (void)
{
  int i;

  for (i = 0; i < dfa_insn_codes_length; i++)
    dfa_insn_codes [i] = -1;
}

void
dfa_start (void)
{
  dfa_insn_codes_length = get_max_uid ();
  dfa_insn_codes = xmalloc (dfa_insn_codes_length * sizeof (int));
  dfa_clean_insn_cache ();
}

void
dfa_finish (void)
{
  free (dfa_insn_codes);
}

int
const_num_delay_slots (rtx insn)
{
  switch (recog_memoized (insn))
    {
    default:
      return 1;
    }
}

int length_unit_log = 0;
