/* Generated automatically by the program `genextract'
from the machine description file `md'.  */

#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "rtl.h"
#include "insn-config.h"
#include "recog.h"
#include "toplev.h"

static rtx junk ATTRIBUTE_UNUSED;
void
insn_extract (rtx insn)
{
  rtx *ro = recog_data.operand;
  rtx **ro_loc = recog_data.operand_loc;
  rtx pat = PATTERN (insn);
  int i ATTRIBUTE_UNUSED;

  switch (INSN_CODE (insn))
    {
    case -1:
      fatal_insn_not_found (insn);

    case 58:  /* nop */
      break;

    case 57:  /* tablejump_aligned */
    case 56:  /* tablejump_internal */
      ro[0] = *(ro_loc[0] = &XEXP (XVECEXP (pat, 0, 0), 1));
      ro[1] = *(ro_loc[1] = &XEXP (XEXP (XVECEXP (pat, 0, 1), 0), 0));
      break;

    case 53:  /* call_value_indirect_aligned */
    case 52:  /* call_value_indirect_internal */
      ro[0] = *(ro_loc[0] = &XEXP (XVECEXP (pat, 0, 0), 0));
      ro[1] = *(ro_loc[1] = &XEXP (XEXP (XEXP (XVECEXP (pat, 0, 0), 1), 0), 0));
      ro[2] = *(ro_loc[2] = &XEXP (XEXP (XVECEXP (pat, 0, 0), 1), 1));
      break;

    case 51:  /* call_value_aligned */
    case 50:  /* call_value_internal */
      ro[0] = *(ro_loc[0] = &XEXP (XVECEXP (pat, 0, 0), 0));
      ro[1] = *(ro_loc[1] = &XEXP (XEXP (XVECEXP (pat, 0, 0), 1), 0));
      ro[2] = *(ro_loc[2] = &XEXP (XEXP (XVECEXP (pat, 0, 0), 1), 1));
      break;

    case 49:  /* call_aligned */
    case 48:  /* call_internal */
      ro[0] = *(ro_loc[0] = &XEXP (XVECEXP (pat, 0, 0), 0));
      ro[1] = *(ro_loc[1] = &XEXP (XVECEXP (pat, 0, 0), 1));
      break;

    case 47:  /* indirect_jump_aligned */
    case 46:  /* indirect_jump_internal */
      ro[0] = *(ro_loc[0] = &XEXP (pat, 1));
      break;

    case 45:  /* jump_aligned */
    case 44:  /* jump_internal */
      ro[0] = *(ro_loc[0] = &XEXP (XEXP (pat, 1), 0));
      break;

    case 19:  /* *bf */
      ro[0] = *(ro_loc[0] = &XEXP (XEXP (XEXP (pat, 1), 1), 0));
      ro[1] = *(ro_loc[1] = &XEXP (XEXP (pat, 1), 0));
      ro[2] = *(ro_loc[2] = &XEXP (XEXP (XEXP (pat, 1), 0), 0));
      break;

    case 18:  /* *cmpsi_leu */
    case 17:  /* *cmpsi_le */
    case 16:  /* *cmpsi_geu */
    case 15:  /* *cmpsi_ge */
    case 14:  /* *cmpsi_ltu */
    case 13:  /* *cmpsi_lt */
    case 12:  /* *cmpsi_gtu */
    case 11:  /* *cmpsi_gt */
    case 10:  /* *cmpsi_ne */
    case 9:  /* *cmpsi_eq */
      ro[0] = *(ro_loc[0] = &XEXP (XEXP (pat, 1), 0));
      ro[1] = *(ro_loc[1] = &XEXP (XEXP (pat, 1), 1));
      break;

    case 8:  /* cmov */
      ro[0] = *(ro_loc[0] = &XEXP (pat, 0));
      ro[1] = *(ro_loc[1] = &XEXP (XEXP (pat, 1), 0));
      ro[2] = *(ro_loc[2] = &XEXP (XEXP (pat, 1), 1));
      ro[3] = *(ro_loc[3] = &XEXP (XEXP (pat, 1), 2));
      ro[4] = *(ro_loc[4] = &XEXP (XEXP (XEXP (pat, 1), 0), 0));
      break;

    case 38:  /* negsi2 */
    case 37:  /* one_cmplsi2 */
    case 36:  /* one_cmplqi2 */
    case 28:  /* zero_extendhisi2 */
    case 27:  /* zero_extendqisi2 */
    case 26:  /* extendhisi2_no_sext_mem */
    case 25:  /* extendhisi2_sext */
    case 24:  /* extendqisi2_no_sext_mem */
    case 23:  /* extendqisi2_sext */
    case 6:  /* *movsi_high */
      ro[0] = *(ro_loc[0] = &XEXP (pat, 0));
      ro[1] = *(ro_loc[1] = &XEXP (XEXP (pat, 1), 0));
      break;

    case 66:  /* divdf3 */
    case 65:  /* divsf3 */
    case 64:  /* muldf3 */
    case 63:  /* mulsf3 */
    case 62:  /* subdf3 */
    case 61:  /* subsf3 */
    case 60:  /* adddf3 */
    case 59:  /* addsf3 */
    case 43:  /* udivsi3 */
    case 42:  /* divsi3 */
    case 41:  /* mulsi3 */
    case 40:  /* subsi3 */
    case 39:  /* addsi3 */
    case 35:  /* xorsi3 */
    case 34:  /* iorsi3 */
    case 33:  /* andsi3 */
    case 32:  /* rotrsi3 */
    case 31:  /* lshrsi3 */
    case 30:  /* ashrsi3 */
    case 29:  /* ashlsi3 */
    case 5:  /* *movsi_lo_sum */
      ro[0] = *(ro_loc[0] = &XEXP (pat, 0));
      ro[1] = *(ro_loc[1] = &XEXP (XEXP (pat, 1), 0));
      ro[2] = *(ro_loc[2] = &XEXP (XEXP (pat, 1), 1));
      break;

    case 22:  /* movsf */
    case 21:  /* movdf */
    case 20:  /* movdi */
    case 7:  /* movsi_insn_big */
    case 4:  /* *movsi_insn */
    case 3:  /* *movhi_internal */
    case 2:  /* *movqi_internal */
      ro[0] = *(ro_loc[0] = &XEXP (pat, 0));
      ro[1] = *(ro_loc[1] = &XEXP (pat, 1));
      break;

    case 55:  /* call_indirect_aligned */
    case 54:  /* call_indirect_internal */
    case 1:  /* sibcall_internal */
      ro[0] = *(ro_loc[0] = &XEXP (XEXP (XVECEXP (pat, 0, 0), 0), 0));
      ro[1] = *(ro_loc[1] = &XEXP (XVECEXP (pat, 0, 0), 1));
      break;

    case 0:  /* return_internal */
      ro[0] = *(ro_loc[0] = &XEXP (XVECEXP (pat, 0, 1), 0));
      break;

    default:
      abort ();
    }
}
