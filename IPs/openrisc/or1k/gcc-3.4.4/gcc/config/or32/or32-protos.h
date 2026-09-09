/* Definitions of target machine for GNU compiler, Argonaut ARC cpu.
   Copyright (C) 2000 Free Software Foundation, Inc.

This file is part of GNU CC.

GNU CC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

GNU CC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU CC; see the file COPYING.  If not, write to
the Free Software Foundation, 59 Temple Place - Suite 330,
Boston, MA 02111-1307, USA.  */

#ifdef RTX_CODE
#ifdef TREE_CODE
#endif /* TREE_CODE */

extern void print_operand PARAMS ((FILE *, rtx, int));
extern void print_operand_address PARAMS ((FILE *, register rtx));
extern const char *or1k_output_move_double PARAMS ((rtx *operands));

extern rtx or1k_cmp_op[];

#endif /* RTX_CODE */

#ifdef TREE_CODE

#endif /* TREE_CODE */

extern int print_operand_punct_valid_p PARAMS ((int));
