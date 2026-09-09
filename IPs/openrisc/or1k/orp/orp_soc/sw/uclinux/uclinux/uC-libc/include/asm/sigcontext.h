#ifndef _ASMor1k_SIGCONTEXT_H
#define _ASMor1k_SIGCONTEXT_H

struct sigcontext_struct {
        unsigned long   _unused[4];
        int             signal;
        unsigned long   handler;
        unsigned long   oldmask;
        struct pt_regs  *regs;
};
#endif
