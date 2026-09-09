#ifndef GCC_TM_H
#define GCC_TM_H
#ifdef IN_GCC
# include "config/or32/or32.h"
# include "config/dbxelf.h"
# include "config/elfos.h"
# include "config/or32/or32.h"
# include "config/or32/elf.h"
# include "config/or32/linux-gas.h"
# include "config/or32/linux-elf.h"
# include "defaults.h"
#endif
#if defined IN_GCC && !defined GENERATOR_FILE && !defined USED_FOR_TARGET
# include "insn-constants.h"
# include "insn-flags.h"
#endif
#endif /* GCC_TM_H */
