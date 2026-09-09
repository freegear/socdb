/* op_mftspr_op.h -- Micro operations template for the m{f,t}spr operations
   Copyright (C) 2005 György `nog' Jeney, nog@sdf.lonestar.org

This file is part of OpenRISC 1000 Architectural Simulator.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. */

#ifdef OP_2T
__or_dynop void glue(op_mfspr, T)(void)
{
  /* FIXME: NPC/PPC Handling is br0ke */
  if(env->sprs[SPR_SR] & SPR_SR_SM)
    T0 = mfspr(T1 + OP_PARAM1);
}
#endif

#ifdef OP_1T
__or_dynop void glue(op_mfspr_imm, T)(void)
{
  /* FIXME: NPC/PPC Handling is br0ke */
  if(env->sprs[SPR_SR] & SPR_SR_SM)
    T0 = mfspr(OP_PARAM1);
}
#endif

#ifdef OP_2T
__or_dynop void glue(op_mtspr, T)(void)
{
  /* FIXME: NPC handling DOES NOT WORK like this */
  if(env->sprs[SPR_SR] & SPR_SR_SM)
    mtspr(T0 + OP_PARAM1, T1);
}
#endif

#ifdef OP_1T
__or_dynop void glue(op_mtspr_clear, T)(void)
{
  /* FIXME: NPC handling DOES NOT WORK like this */
  if(env->sprs[SPR_SR] & SPR_SR_SM)
    mtspr(T0 + OP_PARAM1, 0);
}

__or_dynop void glue(op_mtspr_imm, T)(void)
{
  /* FIXME: NPC handling DOES NOT WORK like this */
  if(env->sprs[SPR_SR] & SPR_SR_SM)
    mtspr(OP_PARAM1, T0);
}
#endif

#if !defined(OP_1T) && !defined(OP_2T)
__or_dynop void op_mtspr_imm_clear(void)
{
  /* FIXME: NPC handling DOES NOT WORK like this */
  if(env->sprs[SPR_SR] & SPR_SR_SM)
    mtspr(OP_PARAM1, 0);
}
#endif
