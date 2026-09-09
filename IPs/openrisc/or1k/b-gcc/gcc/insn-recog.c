/* Generated automatically by the program `genrecog' from the target
   machine description file.  */

#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "rtl.h"
#include "tm_p.h"
#include "function.h"
#include "insn-config.h"
#include "recog.h"
#include "real.h"
#include "output.h"
#include "flags.h"
#include "hard-reg-set.h"
#include "resource.h"
#include "toplev.h"
#include "reload.h"



/* `recog' contains a decision tree that recognizes whether the rtx
   X0 is a valid instruction.

   recog returns -1 if the rtx is not valid.  If the rtx is valid, recog
   returns a nonnegative number which is the insn code number for the
   pattern that matched.  This is the same as the order in the machine
   description of the entry that matched.  This number can be used as an
   index into `insn_data' and other tables.

   The third argument to recog is an optional pointer to an int.  If
   present, recog will accept a pattern if it matches except for missing
   CLOBBER expressions at the end.  In that case, the value pointed to by
   the optional pointer will be set to the number of CLOBBERs that need
   to be added (it should be initialized to zero by the caller).  If it
   is set nonzero, the caller should allocate a PARALLEL of the
   appropriate size, copy the initial entries, and call add_clobbers
   (found in insn-emit.c) to fill in the CLOBBERs.


   The function split_insns returns 0 if the rtl could not
   be split or the split rtl as an INSN list if it can be.

   The function peephole2_insns returns 0 if the rtl could not
   be matched. If there was a match, the new rtl is returned in an INSN list,
   and LAST_INSN will point to the last recognized insn in the old sequence.
*/





static int
recog_1 (rtx x0 ATTRIBUTE_UNUSED,
	rtx insn ATTRIBUTE_UNUSED,
	int *pnum_clobbers ATTRIBUTE_UNUSED)
{
  rtx * const operands ATTRIBUTE_UNUSED = &recog_data.operand[0];
  rtx x1 ATTRIBUTE_UNUSED;
  rtx x2 ATTRIBUTE_UNUSED;
  rtx x3 ATTRIBUTE_UNUSED;
  rtx x4 ATTRIBUTE_UNUSED;
  int tem ATTRIBUTE_UNUSED;

  x1 = XEXP (x0, 0);
  switch (GET_MODE (x1))
    {
    case QImode:
      goto L436;
    case HImode:
      goto L437;
    case SImode:
      goto L438;
    case CCEQmode:
      goto L440;
    case CCNEmode:
      goto L441;
    case CCGTmode:
      goto L442;
    case CCGTUmode:
      goto L443;
    case CCLTmode:
      goto L444;
    case CCLTUmode:
      goto L445;
    case CCGEmode:
      goto L446;
    case CCGEUmode:
      goto L447;
    case CCLEmode:
      goto L448;
    case CCLEUmode:
      goto L449;
    case DImode:
      goto L450;
    case DFmode:
      goto L451;
    case SFmode:
      goto L453;
    default:
      break;
    }
 L95: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == PC)
    goto L228;
  if (general_operand (x1, SFmode))
    {
      operands[0] = x1;
      goto L111;
    }
 L263: ATTRIBUTE_UNUSED_LABEL
  if (register_operand (x1, VOIDmode))
    {
      operands[0] = x1;
      goto L264;
    }
  goto ret0;

 L436: ATTRIBUTE_UNUSED_LABEL
  if (nonimmediate_operand (x1, QImode))
    {
      operands[0] = x1;
      goto L14;
    }
 L452: ATTRIBUTE_UNUSED_LABEL
  if (register_operand (x1, QImode))
    {
      operands[0] = x1;
      goto L178;
    }
  goto L95;

 L14: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (general_operand (x1, QImode))
    {
      operands[1] = x1;
      return 2;
    }
  x1 = XEXP (x0, 0);
  goto L452;

 L178: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == QImode
      && GET_CODE (x1) == NOT)
    goto L179;
  x1 = XEXP (x0, 0);
  goto L95;

 L179: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, QImode))
    {
      operands[1] = x2;
      return 36;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L437: ATTRIBUTE_UNUSED_LABEL
  if (nonimmediate_operand (x1, HImode))
    {
      operands[0] = x1;
      goto L17;
    }
  goto L95;

 L17: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (general_operand (x1, HImode))
    {
      operands[1] = x1;
      return 3;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L438: ATTRIBUTE_UNUSED_LABEL
  if (nonimmediate_operand (x1, SImode))
    {
      operands[0] = x1;
      goto L20;
    }
 L439: ATTRIBUTE_UNUSED_LABEL
  if (register_operand (x1, SImode))
    {
      operands[0] = x1;
      goto L24;
    }
  goto L95;

 L20: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (input_operand (x1, SImode))
    {
      operands[1] = x1;
      goto L21;
    }
 L33: ATTRIBUTE_UNUSED_LABEL
  if (immediate_operand (x1, SImode))
    {
      operands[1] = x1;
      goto L34;
    }
  x1 = XEXP (x0, 0);
  goto L439;

 L21: ATTRIBUTE_UNUSED_LABEL
  if (((register_operand (operands[0], SImode)
    || register_operand (operands[1], SImode)
    || (operands[1] == const0_rtx))))
    {
      return 4;
    }
  x1 = XEXP (x0, 1);
  goto L33;

 L34: ATTRIBUTE_UNUSED_LABEL
  if ((GET_CODE(operands[1]) != CONST_INT))
    {
      return 7;
    }
  x1 = XEXP (x0, 0);
  goto L439;

 L24: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == SImode)
    goto L455;
  x1 = XEXP (x0, 0);
  goto L95;

 L455: ATTRIBUTE_UNUSED_LABEL
  switch (GET_CODE (x1))
    {
    case LO_SUM:
      goto L25;
    case HIGH:
      goto L30;
    case IF_THEN_ELSE:
      goto L38;
    case SIGN_EXTEND:
      goto L115;
    case ZERO_EXTEND:
      goto L135;
    case ASHIFT:
      goto L143;
    case ASHIFTRT:
      goto L148;
    case LSHIFTRT:
      goto L153;
    case ROTATERT:
      goto L158;
    case AND:
      goto L164;
    case IOR:
      goto L169;
    case XOR:
      goto L174;
    case NOT:
      goto L183;
    case NEG:
      goto L187;
    case PLUS:
      goto L191;
    case MINUS:
      goto L196;
    case MULT:
      goto L201;
    case DIV:
      goto L207;
    case UDIV:
      goto L213;
    default:
     break;
   }
  x1 = XEXP (x0, 0);
  goto L95;

 L25: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L26;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L26: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (immediate_operand (x2, SImode))
    {
      operands[2] = x2;
      return 5;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L30: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (immediate_operand (x2, SImode))
    {
      operands[1] = x2;
      return 6;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L38: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (comparison_operator (x2, VOIDmode))
    {
      operands[1] = x2;
      goto L39;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L39: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 0);
  if (cc_reg_operand (x3, VOIDmode))
    {
      operands[4] = x3;
      goto L40;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L40: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 1);
  if (GET_CODE (x3) == CONST_INT
      && XWINT (x3, 0) == 0L)
    goto L41;
  x1 = XEXP (x0, 0);
  goto L95;

 L41: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, SImode))
    {
      operands[2] = x2;
      goto L42;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L42: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 2);
  if (register_operand (x2, SImode))
    {
      operands[3] = x2;
      goto L43;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L43: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_CMOV))
    {
      return 8;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L115: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  switch (GET_MODE (x2))
    {
    case QImode:
      goto L474;
    case HImode:
      goto L476;
    default:
      break;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L474: ATTRIBUTE_UNUSED_LABEL
  if (nonimmediate_operand (x2, QImode))
    {
      operands[1] = x2;
      goto L116;
    }
 L475: ATTRIBUTE_UNUSED_LABEL
  if (memory_operand (x2, QImode))
    {
      operands[1] = x2;
      goto L121;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L116: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_SEXT))
    {
      return 23;
    }
  x1 = XEXP (x0, 1);
  x2 = XEXP (x1, 0);
  goto L475;

 L121: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_SEXT))
    {
      return 24;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L476: ATTRIBUTE_UNUSED_LABEL
  if (nonimmediate_operand (x2, HImode))
    {
      operands[1] = x2;
      goto L126;
    }
 L477: ATTRIBUTE_UNUSED_LABEL
  if (memory_operand (x2, HImode))
    {
      operands[1] = x2;
      goto L131;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L126: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_SEXT))
    {
      return 25;
    }
  x1 = XEXP (x0, 1);
  x2 = XEXP (x1, 0);
  goto L477;

 L131: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_SEXT))
    {
      return 26;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L135: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  switch (GET_MODE (x2))
    {
    case QImode:
      goto L478;
    case HImode:
      goto L479;
    default:
      break;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L478: ATTRIBUTE_UNUSED_LABEL
  if (nonimmediate_operand (x2, QImode))
    {
      operands[1] = x2;
      return 27;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L479: ATTRIBUTE_UNUSED_LABEL
  if (nonimmediate_operand (x2, HImode))
    {
      operands[1] = x2;
      return 28;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L143: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L144;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L144: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[2] = x2;
      return 29;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L148: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L149;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L149: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[2] = x2;
      return 30;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L153: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L154;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L154: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[2] = x2;
      return 31;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L158: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L159;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L159: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[2] = x2;
      goto L160;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L160: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ROR))
    {
      return 32;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L164: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L165;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L165: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[2] = x2;
      return 33;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L169: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L170;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L170: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[2] = x2;
      return 34;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L174: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L175;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L175: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[2] = x2;
      return 35;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L183: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      return 37;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L187: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      return 38;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L191: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L192;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L192: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[2] = x2;
      return 39;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L196: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L197;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L197: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[2] = x2;
      return 40;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L201: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L202;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L202: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, SImode))
    {
      operands[2] = x2;
      goto L203;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L203: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_MUL))
    {
      return 41;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L207: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L208;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L208: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, SImode))
    {
      operands[2] = x2;
      goto L209;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L209: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_DIV))
    {
      return 42;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L213: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L214;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L214: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, SImode))
    {
      operands[2] = x2;
      goto L215;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L215: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_DIV))
    {
      return 43;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L440: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == REG
      && XINT (x1, 0) == 32)
    goto L46;
  goto L95;

 L46: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == CCEQmode
      && GET_CODE (x1) == COMPARE)
    goto L47;
  x1 = XEXP (x0, 0);
  goto L95;

 L47: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L48;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L48: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[1] = x2;
      return 9;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L441: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == REG
      && XINT (x1, 0) == 32)
    goto L51;
  goto L95;

 L51: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == CCNEmode
      && GET_CODE (x1) == COMPARE)
    goto L52;
  x1 = XEXP (x0, 0);
  goto L95;

 L52: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L53;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L53: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[1] = x2;
      return 10;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L442: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == REG
      && XINT (x1, 0) == 32)
    goto L56;
  goto L95;

 L56: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == CCGTmode
      && GET_CODE (x1) == COMPARE)
    goto L57;
  x1 = XEXP (x0, 0);
  goto L95;

 L57: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L58;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L58: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[1] = x2;
      return 11;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L443: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == REG
      && XINT (x1, 0) == 32)
    goto L61;
  goto L95;

 L61: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == CCGTUmode
      && GET_CODE (x1) == COMPARE)
    goto L62;
  x1 = XEXP (x0, 0);
  goto L95;

 L62: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L63;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L63: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[1] = x2;
      return 12;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L444: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == REG
      && XINT (x1, 0) == 32)
    goto L66;
  goto L95;

 L66: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == CCLTmode
      && GET_CODE (x1) == COMPARE)
    goto L67;
  x1 = XEXP (x0, 0);
  goto L95;

 L67: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L68;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L68: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[1] = x2;
      return 13;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L445: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == REG
      && XINT (x1, 0) == 32)
    goto L71;
  goto L95;

 L71: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == CCLTUmode
      && GET_CODE (x1) == COMPARE)
    goto L72;
  x1 = XEXP (x0, 0);
  goto L95;

 L72: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L73;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L73: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[1] = x2;
      return 14;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L446: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == REG
      && XINT (x1, 0) == 32)
    goto L76;
  goto L95;

 L76: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == CCGEmode
      && GET_CODE (x1) == COMPARE)
    goto L77;
  x1 = XEXP (x0, 0);
  goto L95;

 L77: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L78;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L78: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[1] = x2;
      return 15;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L447: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == REG
      && XINT (x1, 0) == 32)
    goto L81;
  goto L95;

 L81: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == CCGEUmode
      && GET_CODE (x1) == COMPARE)
    goto L82;
  x1 = XEXP (x0, 0);
  goto L95;

 L82: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L83;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L83: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[1] = x2;
      return 16;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L448: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == REG
      && XINT (x1, 0) == 32)
    goto L86;
  goto L95;

 L86: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == CCLEmode
      && GET_CODE (x1) == COMPARE)
    goto L87;
  x1 = XEXP (x0, 0);
  goto L95;

 L87: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L88;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L88: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[1] = x2;
      return 17;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L449: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == REG
      && XINT (x1, 0) == 32)
    goto L91;
  goto L95;

 L91: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == CCLEUmode
      && GET_CODE (x1) == COMPARE)
    goto L92;
  x1 = XEXP (x0, 0);
  goto L95;

 L92: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L93;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L93: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (nonmemory_operand (x2, SImode))
    {
      operands[1] = x2;
      return 18;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L450: ATTRIBUTE_UNUSED_LABEL
  if (nonimmediate_operand (x1, DImode))
    {
      operands[0] = x1;
      goto L105;
    }
  goto L95;

 L105: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (general_operand (x1, DImode))
    {
      operands[1] = x1;
      return 20;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L451: ATTRIBUTE_UNUSED_LABEL
  if (nonimmediate_operand (x1, DFmode))
    {
      operands[0] = x1;
      goto L108;
    }
 L454: ATTRIBUTE_UNUSED_LABEL
  if (register_operand (x1, DFmode))
    {
      operands[0] = x1;
      goto L363;
    }
  goto L95;

 L108: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (general_operand (x1, DFmode))
    {
      operands[1] = x1;
      return 21;
    }
  x1 = XEXP (x0, 0);
  goto L454;

 L363: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == DFmode)
    goto L480;
  x1 = XEXP (x0, 0);
  goto L95;

 L480: ATTRIBUTE_UNUSED_LABEL
  switch (GET_CODE (x1))
    {
    case PLUS:
      goto L364;
    case MINUS:
      goto L376;
    case MULT:
      goto L388;
    case DIV:
      goto L400;
    default:
     break;
   }
  x1 = XEXP (x0, 0);
  goto L95;

 L364: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, DFmode))
    {
      operands[1] = x2;
      goto L365;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L365: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, DFmode))
    {
      operands[2] = x2;
      goto L366;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L366: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_FLOAT))
    {
      return 60;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L376: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, DFmode))
    {
      operands[1] = x2;
      goto L377;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L377: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, DFmode))
    {
      operands[2] = x2;
      goto L378;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L378: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_FLOAT))
    {
      return 62;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L388: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, DFmode))
    {
      operands[1] = x2;
      goto L389;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L389: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, DFmode))
    {
      operands[2] = x2;
      goto L390;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L390: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_FLOAT))
    {
      return 64;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L400: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, DFmode))
    {
      operands[1] = x2;
      goto L401;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L401: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, DFmode))
    {
      operands[2] = x2;
      goto L402;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L402: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_FLOAT))
    {
      return 66;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L453: ATTRIBUTE_UNUSED_LABEL
  if (register_operand (x1, SFmode))
    {
      operands[0] = x1;
      goto L357;
    }
  goto L95;

 L357: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_MODE (x1) == SFmode)
    goto L484;
  x1 = XEXP (x0, 0);
  goto L95;

 L484: ATTRIBUTE_UNUSED_LABEL
  switch (GET_CODE (x1))
    {
    case PLUS:
      goto L358;
    case MINUS:
      goto L370;
    case MULT:
      goto L382;
    case DIV:
      goto L394;
    default:
     break;
   }
  x1 = XEXP (x0, 0);
  goto L95;

 L358: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SFmode))
    {
      operands[1] = x2;
      goto L359;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L359: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, SFmode))
    {
      operands[2] = x2;
      goto L360;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L360: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_FLOAT))
    {
      return 59;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L370: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SFmode))
    {
      operands[1] = x2;
      goto L371;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L371: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, SFmode))
    {
      operands[2] = x2;
      goto L372;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L372: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_FLOAT))
    {
      return 61;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L382: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SFmode))
    {
      operands[1] = x2;
      goto L383;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L383: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, SFmode))
    {
      operands[2] = x2;
      goto L384;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L384: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_FLOAT))
    {
      return 63;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L394: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SFmode))
    {
      operands[1] = x2;
      goto L395;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L395: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, SFmode))
    {
      operands[2] = x2;
      goto L396;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L396: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_HARD_FLOAT))
    {
      return 65;
    }
  x1 = XEXP (x0, 0);
  goto L95;

 L228: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (register_operand (x1, SImode))
    {
      operands[0] = x1;
      goto L229;
    }
  switch (GET_CODE (x1))
    {
    case IF_THEN_ELSE:
      goto L97;
    case LABEL_REF:
      goto L219;
    default:
     break;
   }
  goto ret0;

 L229: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS))
    {
      return 46;
    }
 L233: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS))
    {
      return 47;
    }
  goto ret0;

 L97: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (comparison_operator (x2, VOIDmode))
    {
      operands[1] = x2;
      goto L98;
    }
  goto ret0;

 L98: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 0);
  if (cc_reg_operand (x3, VOIDmode))
    {
      operands[2] = x3;
      goto L99;
    }
  goto ret0;

 L99: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 1);
  if (GET_CODE (x3) == CONST_INT
      && XWINT (x3, 0) == 0L)
    goto L100;
  goto ret0;

 L100: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (GET_CODE (x2) == LABEL_REF)
    goto L101;
  goto ret0;

 L101: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 0);
  operands[0] = x3;
  goto L102;

 L102: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 2);
  if (GET_CODE (x2) == PC)
    {
      return 19;
    }
  goto ret0;

 L219: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  operands[0] = x2;
  goto L220;

 L220: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS))
    {
      return 44;
    }
 L225: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS))
    {
      return 45;
    }
  goto ret0;

 L111: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (general_operand (x1, SFmode))
    {
      operands[1] = x1;
      return 22;
    }
  x1 = XEXP (x0, 0);
  goto L263;

 L264: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  if (GET_CODE (x1) == CALL)
    goto L265;
  goto ret0;

 L265: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (GET_MODE (x2) == SImode)
    goto L488;
  goto ret0;

 L488: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x2) == MEM)
    goto L490;
 L489: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x2) == MEM)
    goto L295;
  goto ret0;

 L490: ATTRIBUTE_UNUSED_LABEL
  if (sym_ref_mem_operand (x2, SImode))
    {
      operands[1] = x2;
      goto L266;
    }
  goto L489;

 L266: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  operands[2] = x2;
  goto L267;

 L267: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS)
      && pnum_clobbers != NULL)
    {
      *pnum_clobbers = 1;
      return 50;
    }
 L281: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS)
      && pnum_clobbers != NULL)
    {
      *pnum_clobbers = 1;
      return 51;
    }
  x1 = XEXP (x0, 1);
  x2 = XEXP (x1, 0);
  goto L489;

 L295: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 0);
  if (register_operand (x3, SImode))
    {
      operands[1] = x3;
      goto L296;
    }
  goto ret0;

 L296: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  operands[2] = x2;
  goto L297;

 L297: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS)
      && pnum_clobbers != NULL)
    {
      *pnum_clobbers = 1;
      return 52;
    }
 L313: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS)
      && pnum_clobbers != NULL)
    {
      *pnum_clobbers = 1;
      return 53;
    }
  goto ret0;
 ret0:
  return -1;
}

int
recog (rtx x0 ATTRIBUTE_UNUSED,
	rtx insn ATTRIBUTE_UNUSED,
	int *pnum_clobbers ATTRIBUTE_UNUSED)
{
  rtx * const operands ATTRIBUTE_UNUSED = &recog_data.operand[0];
  rtx x1 ATTRIBUTE_UNUSED;
  rtx x2 ATTRIBUTE_UNUSED;
  rtx x3 ATTRIBUTE_UNUSED;
  rtx x4 ATTRIBUTE_UNUSED;
  int tem ATTRIBUTE_UNUSED;
  recog_data.insn = NULL_RTX;

  switch (GET_CODE (x0))
    {
    case PARALLEL:
      goto L403;
    case SET:
      goto L13;
    case CALL:
      goto L241;
    case CONST_INT:
      goto L404;
    default:
     break;
   }
  goto ret0;

 L403: ATTRIBUTE_UNUSED_LABEL
  if (XVECLEN (x0, 0) == 2)
    goto L1;
  goto ret0;

 L1: ATTRIBUTE_UNUSED_LABEL
  x1 = XVECEXP (x0, 0, 0);
  switch (GET_CODE (x1))
    {
    case RETURN:
      goto L2;
    case CALL:
      goto L7;
    case SET:
      goto L340;
    default:
     break;
   }
  goto ret0;

 L2: ATTRIBUTE_UNUSED_LABEL
  x1 = XVECEXP (x0, 0, 1);
  if (GET_CODE (x1) == USE)
    goto L3;
  goto ret0;

 L3: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (pmode_register_operand (x2, VOIDmode))
    {
      operands[0] = x2;
      goto L4;
    }
  goto ret0;

 L4: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_SCHED_LOGUE))
    {
      return 0;
    }
  goto ret0;

 L7: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (GET_MODE (x2) == SImode)
    goto L405;
  goto ret0;

 L405: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x2) == MEM)
    goto L8;
 L406: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x2) == MEM)
    goto L408;
 L407: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x2) == MEM)
    goto L317;
  goto ret0;

 L8: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 0);
  if (sibcall_insn_operand (x3, SImode))
    {
      operands[0] = x3;
      goto L9;
    }
  goto L406;

 L9: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  operands[1] = x2;
  goto L10;

 L10: ATTRIBUTE_UNUSED_LABEL
  x1 = XVECEXP (x0, 0, 1);
  if (GET_CODE (x1) == USE)
    goto L11;
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 0);
  goto L406;

 L11: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (GET_MODE (x2) == SImode
      && GET_CODE (x2) == REG
      && XINT (x2, 0) == 9
      && (TARGET_SIBCALL))
    {
      return 1;
    }
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 0);
  goto L406;

 L408: ATTRIBUTE_UNUSED_LABEL
  if (sym_ref_mem_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L237;
    }
  goto L407;

 L237: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  operands[1] = x2;
  goto L238;

 L238: ATTRIBUTE_UNUSED_LABEL
  x1 = XVECEXP (x0, 0, 1);
  if (GET_CODE (x1) == CLOBBER)
    goto L239;
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 0);
  goto L407;

 L239: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (GET_MODE (x2) == SImode)
    goto L409;
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 0);
  goto L407;

 L409: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x2) == REG)
    goto L411;
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 0);
  goto L407;

 L411: ATTRIBUTE_UNUSED_LABEL
  if (XINT (x2, 0) == 9)
    goto L413;
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 0);
  goto L407;

 L413: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS))
    {
      return 48;
    }
 L414: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS))
    {
      return 49;
    }
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 0);
  goto L407;

 L317: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 0);
  if (register_operand (x3, SImode))
    {
      operands[0] = x3;
      goto L318;
    }
  goto ret0;

 L318: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  operands[1] = x2;
  goto L319;

 L319: ATTRIBUTE_UNUSED_LABEL
  x1 = XVECEXP (x0, 0, 1);
  if (GET_CODE (x1) == CLOBBER)
    goto L320;
  goto ret0;

 L320: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (GET_MODE (x2) == SImode)
    goto L415;
  goto ret0;

 L415: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x2) == REG)
    goto L417;
  goto ret0;

 L417: ATTRIBUTE_UNUSED_LABEL
  if (XINT (x2, 0) == 9)
    goto L419;
  goto ret0;

 L419: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS))
    {
      return 54;
    }
 L420: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS))
    {
      return 55;
    }
  goto ret0;

 L340: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (GET_CODE (x2) == PC)
    goto L341;
  if (register_operand (x2, VOIDmode))
    {
      operands[0] = x2;
      goto L257;
    }
  goto ret0;

 L341: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L342;
    }
  goto ret0;

 L342: ATTRIBUTE_UNUSED_LABEL
  x1 = XVECEXP (x0, 0, 1);
  if (GET_CODE (x1) == USE)
    goto L343;
  goto ret0;

 L343: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (GET_CODE (x2) == LABEL_REF)
    goto L344;
  goto ret0;

 L344: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 0);
  operands[1] = x3;
  goto L345;

 L345: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS))
    {
      return 56;
    }
 L353: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS))
    {
      return 57;
    }
  goto ret0;

 L257: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 1);
  if (GET_CODE (x2) == CALL)
    goto L258;
  goto ret0;

 L258: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 0);
  if (GET_MODE (x3) == SImode)
    goto L421;
  goto ret0;

 L421: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x3) == MEM)
    goto L423;
 L422: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x3) == MEM)
    goto L287;
  goto ret0;

 L423: ATTRIBUTE_UNUSED_LABEL
  if (sym_ref_mem_operand (x3, SImode))
    {
      operands[1] = x3;
      goto L259;
    }
  goto L422;

 L259: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 1);
  operands[2] = x3;
  goto L260;

 L260: ATTRIBUTE_UNUSED_LABEL
  x1 = XVECEXP (x0, 0, 1);
  if (GET_CODE (x1) == CLOBBER)
    goto L261;
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 1);
  x3 = XEXP (x2, 0);
  goto L422;

 L261: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (GET_MODE (x2) == SImode)
    goto L424;
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 1);
  x3 = XEXP (x2, 0);
  goto L422;

 L424: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x2) == REG)
    goto L426;
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 1);
  x3 = XEXP (x2, 0);
  goto L422;

 L426: ATTRIBUTE_UNUSED_LABEL
  if (XINT (x2, 0) == 9)
    goto L428;
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 1);
  x3 = XEXP (x2, 0);
  goto L422;

 L428: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS))
    {
      return 50;
    }
 L429: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS))
    {
      return 51;
    }
  x1 = XVECEXP (x0, 0, 0);
  x2 = XEXP (x1, 1);
  x3 = XEXP (x2, 0);
  goto L422;

 L287: ATTRIBUTE_UNUSED_LABEL
  x4 = XEXP (x3, 0);
  if (register_operand (x4, SImode))
    {
      operands[1] = x4;
      goto L288;
    }
  goto ret0;

 L288: ATTRIBUTE_UNUSED_LABEL
  x3 = XEXP (x2, 1);
  operands[2] = x3;
  goto L289;

 L289: ATTRIBUTE_UNUSED_LABEL
  x1 = XVECEXP (x0, 0, 1);
  if (GET_CODE (x1) == CLOBBER)
    goto L290;
  goto ret0;

 L290: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (GET_MODE (x2) == SImode)
    goto L430;
  goto ret0;

 L430: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x2) == REG)
    goto L432;
  goto ret0;

 L432: ATTRIBUTE_UNUSED_LABEL
  if (XINT (x2, 0) == 9)
    goto L434;
  goto ret0;

 L434: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS))
    {
      return 52;
    }
 L435: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS))
    {
      return 53;
    }
  goto ret0;

 L13: ATTRIBUTE_UNUSED_LABEL
  return recog_1 (x0, insn, pnum_clobbers);

 L241: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 0);
  if (GET_MODE (x1) == SImode)
    goto L491;
  goto ret0;

 L491: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == MEM)
    goto L493;
 L492: ATTRIBUTE_UNUSED_LABEL
  if (GET_CODE (x1) == MEM)
    goto L323;
  goto ret0;

 L493: ATTRIBUTE_UNUSED_LABEL
  if (sym_ref_mem_operand (x1, SImode))
    {
      operands[0] = x1;
      goto L242;
    }
  goto L492;

 L242: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  operands[1] = x1;
  goto L243;

 L243: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS)
      && pnum_clobbers != NULL)
    {
      *pnum_clobbers = 1;
      return 48;
    }
 L253: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS)
      && pnum_clobbers != NULL)
    {
      *pnum_clobbers = 1;
      return 49;
    }
  x1 = XEXP (x0, 0);
  goto L492;

 L323: ATTRIBUTE_UNUSED_LABEL
  x2 = XEXP (x1, 0);
  if (register_operand (x2, SImode))
    {
      operands[0] = x2;
      goto L324;
    }
  goto ret0;

 L324: ATTRIBUTE_UNUSED_LABEL
  x1 = XEXP (x0, 1);
  operands[1] = x1;
  goto L325;

 L325: ATTRIBUTE_UNUSED_LABEL
  if ((!TARGET_ALIGNED_JUMPS)
      && pnum_clobbers != NULL)
    {
      *pnum_clobbers = 1;
      return 54;
    }
 L337: ATTRIBUTE_UNUSED_LABEL
  if ((TARGET_ALIGNED_JUMPS)
      && pnum_clobbers != NULL)
    {
      *pnum_clobbers = 1;
      return 55;
    }
  goto ret0;

 L404: ATTRIBUTE_UNUSED_LABEL
  if (XWINT (x0, 0) == 0L)
    {
      return 58;
    }
  goto ret0;
 ret0:
  return -1;
}

rtx
split_insns (rtx x0 ATTRIBUTE_UNUSED, rtx insn ATTRIBUTE_UNUSED)
{
  rtx * const operands ATTRIBUTE_UNUSED = &recog_data.operand[0];
  rtx x1 ATTRIBUTE_UNUSED;
  rtx x2 ATTRIBUTE_UNUSED;
  rtx x3 ATTRIBUTE_UNUSED;
  rtx x4 ATTRIBUTE_UNUSED;
  rtx tem ATTRIBUTE_UNUSED;
  recog_data.insn = NULL_RTX;
  goto ret0;
 ret0:
  return 0;
}

