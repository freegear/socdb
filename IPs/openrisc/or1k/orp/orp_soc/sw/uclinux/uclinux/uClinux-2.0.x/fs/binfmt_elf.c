/*
 * linux/fs/binfmt_elf.c
 *
 * These are the functions used to load ELF format executables as used
 * on SVr4 machines.  Information on the format may be found in the book
 * "UNIX SYSTEM V RELEASE 4 Programmers Guide: Ansi C and Programming Support
 * Tools".
 *
 * Copyright 1993, 1994: Eric Youngdale (ericy@cais.com).
 */

#include <linux/module.h>

#include <linux/fs.h>
#include <linux/stat.h>
#include <linux/sched.h>
#include <linux/mm.h>
#include <linux/mman.h>
#include <linux/a.out.h>
#include <linux/errno.h>
#include <linux/signal.h>
#include <linux/binfmts.h>
#include <linux/string.h>
#include <linux/fcntl.h>
#include <linux/ptrace.h>
#include <linux/malloc.h>
#include <linux/shm.h>
#include <linux/personality.h>
#include <linux/elfcore.h>

#include <asm/segment.h>
#include <asm/pgtable.h>

#include <linux/config.h>

#define DLINFO_ITEMS 12

#include <linux/elf.h>

#define JUMP_TO_MAIN 0
#define STACK_SIZE (64*PAGE_SIZE)

static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);

#define ELF_PAGESTART(_v) ((_v) & ~(unsigned long)(ELF_EXEC_PAGESIZE-1))
#define ELF_PAGEOFFSET(_v) ((_v) & (ELF_EXEC_PAGESIZE-1))

static struct linux_binfmt elf_format =
{
#ifndef MODULE
	NULL, NULL, load_elf_binary, NULL, NULL
#else
  NULL, &mod_use_count_, load_elf_binary, load_elf_library, elf_core_dump
#endif
};

struct sec_add {
	unsigned long pm_add;
	unsigned long vm_add;
	int len;
} sec[ELF_SECTION_NB];

unsigned short *or32_consth_add = (unsigned short *)NULL;
unsigned long or32_consth_rel;

#if JUMP_TO_MAIN
unsigned long *create_elf_tables(char *p, int argc, int envc, struct pt_regs *regs)
{
	unsigned long *argv, *envp;
	unsigned long *sp;

	/*
	 * Force 16 byte alignment here for generality.
	 */
	sp = (unsigned long *) (~15UL & (unsigned long) p);
	sp -= 2;
	sp -= envc + 1;
	envp = sp;
	sp -= argc + 1;
	argv = sp;

	regs->gprs[1] = argc;
	put_user((unsigned long) argc, --sp);
	current->mm->arg_start = (unsigned long) p;
	regs->gprs[2] = (unsigned long) argv;
	while (argc-- > 0) {
		put_user(p, argv++);
		while (get_user(p++))	/* nothing */
			;
	}
	put_user(0, argv);
	current->mm->arg_end = current->mm->env_start = (unsigned long) p;
	regs->gprs[3] = (unsigned long) envp;
	while (envc-- > 0) {
		put_user(p, envp++);
		while (get_user(p++))	/* nothing */
			;
	}
	put_user(0, envp);
	current->mm->env_end = (unsigned long) p;
	return sp;
}
#else
unsigned long *create_elf_tables(char *p, int argc, int envc, struct pt_regs *regs)
{
	unsigned long *argv, *envp;
	unsigned long *sp;

	/*
	 * Force 16 byte alignment here for generality.
	 */
	sp = (unsigned long *) (~15UL & (unsigned long) p);
	sp -= 2;
	sp -= envc + 1;
	envp = sp;
	sp -= argc + 1;
	argv = sp;

	regs->gprs[1] = sp;
	put_user((unsigned long) argc, --sp);
	current->mm->arg_start = (unsigned long) p;
	while (argc-- > 0) {
		put_user(p, argv++);
		while (get_user(p++))	/* nothing */
			;
	}
	put_user(0, argv);
	current->mm->arg_end = current->mm->env_start = (unsigned long) p;
	while (envc-- > 0) {
		put_user(p, envp++);
		while (get_user(p++))	/* nothing */
			;
	}
	put_user(0, envp);
	current->mm->env_end = (unsigned long) p;
	return sp;
}
#endif

static unsigned long putstring(unsigned long p, char * string)
{
	unsigned long l = strlen(string)+1;
	p -= l;
	memcpy((void*)p, string, l);
	return p;
}

static unsigned long putstringarray(unsigned long p, int count, char ** array)
{
	while(count) {
		p=putstring(p, array[--count]);
	}
	return p;
}

static unsigned long stringarraylen(int count, char ** array)
{
	int l = 4;
	while(count) {
		l += strlen(array[--count]);
		l++;
		l+=4;
	}
	return l;
}

int do_relocate(int dst_indx,
		int rel_nb,
		struct elf32_rel *rel_ptr, 
		struct elf32_sym *sym_ptr,
		struct sec_add *sec)
{
	struct elf32_sym *sym_tab;
	void *rel_loc;
	unsigned long tmp;
	int src_indx;
	int i;
 
	for(i = 0; i < rel_nb; i++, rel_ptr++) {
 
		/* Symbol tab */
		sym_tab = sym_ptr + (rel_ptr->r_info >> 8); 
		/* Section index of section that contains symbol */
		src_indx = sym_tab->st_shndx;
		/* Location in physical memory to which this relocation 
		   is refering to */
		rel_loc = (void *)(rel_ptr->r_offset + sec[dst_indx].pm_add);
		if((rel_ptr->r_info & 0x000000ff) == R_OR32_32) {
_print("R_OR32_32:       rel_loc %.8lx vm_add = %.8lx pm_add = %.8lx val = %.8lx\n", rel_loc, sec[src_indx].vm_add, sec[src_indx].pm_add, sym_tab->st_value);
			*(unsigned long *)rel_loc = *(unsigned long *)rel_loc 
						- sec[src_indx].vm_add
						+ sec[src_indx].pm_add
                                                + sym_tab->st_value;
		}
		else if((rel_ptr->r_info & 0x000000ff) == R_OR32_16) {
_print("R_OR32_16:       rel_loc %.8lx vm_add = %.8lx pm_add = %.8lx\n", rel_loc, sec[src_indx].vm_add, sec[src_indx].pm_add);
			*(unsigned short *)rel_loc = *(unsigned short *)rel_loc
                                                - sec[src_indx].vm_add
                                                + sec[src_indx].pm_add
                                                + sym_tab->st_value;
		}
		else if((rel_ptr->r_info & 0x000000ff) == R_OR32_8) {
_print("R_OR32_8:        rel_loc %.8lx vm_add = %.8lx pm_add = %.8lx\n", rel_loc, sec[src_indx].vm_add, sec[src_indx].pm_add);
			*(unsigned char *)rel_loc = *(unsigned char *)rel_loc
                                                - sec[src_indx].vm_add
                                                + sec[src_indx].pm_add
                                                + sym_tab->st_value;
		}
		else if((rel_ptr->r_info & 0x000000ff) == R_OR32_CONSTH) {
_print("R_OR32_CONSTH:   rel_loc %.8lx *rel_loc %.8lx\n", rel_loc, *(((unsigned short *)rel_loc) + 1));
_print("                 vm_add  %.8lx pm_add   %.8lx\n", sec[src_indx].vm_add, sec[src_indx].pm_add);
			or32_consth_add = (((unsigned short *)rel_loc) + 1);
			or32_consth_rel = *or32_consth_add << 16;
		}
		else if((rel_ptr->r_info & 0x000000ff) == R_OR32_CONST) {
_print("R_OR32_CONST:    rel_loc %.8lx *rel_loc %.8lx\n", rel_loc, *(((unsigned short *)rel_loc) + 1));
_print("                 vm_add  %.8lx pm_add   %.8lx\n", sec[src_indx].vm_add, sec[src_indx].pm_add);
_print("                 consth  %.8lx st_value %.8lx\n", or32_consth_rel, sym_tab->st_value);

			tmp = or32_consth_rel | *(((unsigned short *)rel_loc) + 1);
                        tmp = tmp + sym_tab->st_value - sec[src_indx].vm_add +
						sec[src_indx].pm_add;
			*(((unsigned short *)rel_loc) + 1) = tmp & 0x0000ffff;
			if(or32_consth_add != (unsigned short *)NULL) {
				*or32_consth_add = tmp >> 16;
				or32_consth_add = (unsigned short *)NULL;
				or32_consth_rel = 0;	
			}
                }
		else if((rel_ptr->r_info & 0x000000ff) == R_OR32_JUMPTARG) {
_print("R_OR32_JUMPTARG: rel_loc %.8lx vm_add = %.8lx pm_add = %.8lx\n", rel_loc, sec[src_indx].vm_add, sec[src_indx].pm_add);
_print("                 pm_add  %.8lx\n", sec[dst_indx].pm_add);
                       	tmp = ((*(unsigned long *)rel_loc) & 0x03ffffff);
			tmp = (tmp & 0x02000000) ? (tmp | 0xfc000000) : tmp;
			tmp = tmp + ((sym_tab->st_value - 
				sec[src_indx].vm_add + 
				sec[src_indx].pm_add -
				sec[dst_indx].pm_add) >> 2);
			*(unsigned long *)rel_loc = 
				((*(unsigned long *)rel_loc) & 0xfc000000) |
				(tmp & 0x03ffffff);
		}
		else {
			return -ELNRNG; 
		}
	}
	return 0;
}

#if JUMP_TO_MAIN
unsigned long do_find_main(int sym_nb, struct elf32_sym *sym_prt, char *str_ptr)
{
	int i;

	for(i = 0; i < sym_nb; i++, sym_prt++) {
		if(sym_prt->st_name == 0)
			continue;

		if(strcmp(&str_ptr[sym_prt->st_name], "_main") == 0) 
			return (sym_prt->st_value + sec[sym_prt->st_shndx].pm_add);
	}
	return 0;
}
#else
unsigned long do_find_start(int sym_nb, struct elf32_sym *sym_prt, char *str_ptr)
{
	int i;

	for(i = 0; i < sym_nb; i++, sym_prt++) {
		if(sym_prt->st_name == 0)
			continue;

		if(strcmp(&str_ptr[sym_prt->st_name], "_start") == 0) 
			return (sym_prt->st_value + sec[sym_prt->st_shndx].pm_add);
	}
	return 0;
}
#endif
/*
 * These are the functions used to load ELF style executables and shared
 * libraries.  There is no binary dependent code anywhere else.
 */

#define INTERPRETER_NONE 0
#define INTERPRETER_AOUT 1
#define INTERPRETER_ELF 2


static inline int do_load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
{
	struct elfhdr elf_ex;
	struct file *file;
	int i,j;
	int old_fs;
	struct elf32_shdr *elf_spnt, *elf_shdata;
	int elf_exec_fileno;
	unsigned long elf_entry = 0;
	unsigned long code_start, code_end, code_len = 0;
	unsigned long data_start, data_end, data_len = 0;
	unsigned long bss_start, bss_end, bss_len = 0;
	unsigned long stack_len = 0;
	int rel_indx, symtab_indx = 0, strtab_indx = 0;
	struct elf32_rel *rel_ptr;
	struct elf32_sym *sym_ptr = (struct elf32_sym *)0;
	char *str_ptr = (char *)0;
	int retval;

	or32_consth_add = 0;
	or32_consth_rel = 0;

	current->personality = PER_LINUX;

	elf_exec_fileno = open_inode(bprm->inode, O_RDONLY);

	if (elf_exec_fileno < 0)
		return elf_exec_fileno;

	file = current->files->fd[elf_exec_fileno];


	elf_ex = *((struct elfhdr *) bprm->buf);	/* exec-header */

	/* First of all, some simple consistency checks */
	if (elf_ex.e_type != ET_REL ||
			0 /*!elf_check_arch(elf_ex.e_machine)*/ ||
	    		!bprm->inode->i_op || 
			!bprm->inode->i_op->default_file_ops ||
			!bprm->inode->i_op->default_file_ops->mmap ||
			elf_ex.e_ident[0] != 0x7f ||
			strncmp(&elf_ex.e_ident[1], "ELF", 3) != 0) {
		return -ENOEXEC;
	}

	if (flush_old_exec(bprm)) {
		return -ENOMEM;
	}

	if(elf_ex.e_shnum > ELF_SECTION_NB)
		return -ETOOMANYSECT;

	for(i = 0; i < ELF_SECTION_NB; i++)
		sec[i].len = 0;

	/* Now read in all of the header information */
	elf_shdata = (struct elf32_shdr *) kmalloc(elf_ex.e_shnum *
			elf_ex.e_shentsize, GFP_KERNEL);

	if (elf_shdata == NULL)
		return -ENOMEM;

	retval = read_exec(bprm->inode, elf_ex.e_shoff, (char *) elf_shdata,
			   elf_ex.e_shentsize * elf_ex.e_shnum, 1);

	if (retval < 0) {
		kfree(elf_shdata);
		return retval;
	}

	/* OK, This is the point of no return */

	current->mm->end_data = 0;
	current->mm->end_code = 0;

	/* Now we do a little grungy work by mmaping the ELF image into
	   the memory.  At this point, we assume that at a variable
	   address. */

	old_fs = get_fs();
	set_fs(get_ds());

	/* Calculate the total size of memory needed */
	for(i = 0, elf_spnt = elf_shdata; i < elf_ex.e_shnum; i++, elf_spnt++) {
		if(elf_spnt->sh_type == SHT_PROGBITS) {
			if(elf_spnt->sh_flags & SHF_EXECINSTR)
				code_len += (elf_spnt->sh_size + 3) & ~(3);
			else if(elf_spnt->sh_flags & SHF_ALLOC)
				data_len += (elf_spnt->sh_size + 3) & ~(3);
		}
		else if(elf_spnt->sh_type == SHT_NOBITS) {
			if(elf_spnt->sh_flags & SHF_ALLOC)
				bss_len += (elf_spnt->sh_size + 3) & ~(3);
		}
	}

	/* Make room on stack for arguments & environment */
	stack_len = STACK_SIZE;
	stack_len += strlen(bprm->filename) + 1;
	stack_len += stringarraylen(bprm->envc, bprm->envp);
	stack_len += stringarraylen(bprm->argc, bprm->argv);

	/* Allocate space */
	retval = (unsigned long)do_mmap(NULL, 
					0,
					code_len + code_len + bss_len + stack_len,
					PROT_EXEC | PROT_WRITE | PROT_READ,
					0,
					0);

	if(retval > (unsigned long)-4096) {
		kfree(elf_shdata);
		return retval; 
	}

	code_start = retval;
	code_end = code_start;
	data_start = code_start + code_len;
	data_end = data_start;
	bss_start = data_start + data_len;
	bss_end = bss_start;

      	current->mm->executable = 0;

	/* Now copy sections in memory */

 	for(i = 0, elf_spnt = elf_shdata; i < elf_ex.e_shnum; i++, elf_spnt++) {

		if(elf_spnt->sh_type == SHT_PROGBITS && elf_spnt->sh_flags & SHF_EXECINSTR) {

			if(elf_spnt->sh_size == 0)
				continue;

			retval = read_exec(bprm->inode, elf_spnt->sh_offset,
					(char *)code_end, elf_spnt->sh_size, 1);

			if (retval < 0) {
				do_munmap(code_start, code_len + code_len + bss_len + stack_len);
				kfree(elf_shdata);
                                return retval;
			}
			
			sec[i].pm_add = code_end;
			sec[i].vm_add = elf_spnt->sh_addr;

			code_end = code_end + ((elf_spnt->sh_size + 3) & ~(3));
		}
		else if (elf_spnt->sh_type == SHT_PROGBITS && elf_spnt->sh_flags & SHF_ALLOC) {

			if(elf_spnt->sh_size == 0)
				continue;

			retval = read_exec(bprm->inode, elf_spnt->sh_offset,
					(char *)data_end, elf_spnt->sh_size, 1);

			if (retval < 0) {
				do_munmap(code_start, code_len + code_len + bss_len + stack_len);
				kfree(elf_shdata);
                                return retval;
			}
			
			sec[i].pm_add = data_end;
			sec[i].vm_add = elf_spnt->sh_addr;

			data_end = data_end + ((elf_spnt->sh_size + 3) & ~(3));
		}
		else if (elf_spnt->sh_type == SHT_NOBITS && elf_spnt->sh_flags & SHF_ALLOC) {

			if(elf_spnt->sh_size == 0)
				continue;

			sec[i].pm_add = bss_end;
			sec[i].vm_add = elf_spnt->sh_addr;

			bss_end = bss_end + ((elf_spnt->sh_size + 3) & ~(3));
		}
	}

	/* Set bss and stack to zero */
	memset((void*)(bss_start), 0, bss_len + stack_len);

	for(i = 0, elf_spnt = elf_shdata; i < elf_ex.e_shnum; elf_spnt++, i++) {
                if(elf_spnt->sh_type == SHT_SYMTAB && (elf_spnt->sh_size != 0)) {
			struct elf32_shdr *link_shdr;
			int sym_nb;
			unsigned long retval;
	
			/* Map symtab section */
			retval = (unsigned long)do_mmap(NULL,
							0,
							elf_spnt->sh_size,
							PROT_READ,
							0,
							0);
			if(retval > (unsigned long)-4096) {
				for(j = 0; j < elf_ex.e_shnum; j++)
						if(sec[j].len)
							do_munmap(sec[j].pm_add, sec[j].len);
				do_munmap(code_start, code_len + code_len + bss_len + stack_len);
				kfree(elf_shdata);
				return retval;
			}

			symtab_indx = i;
			sec[symtab_indx].pm_add = retval;
			sym_ptr = (struct elf32_sym *)retval;
			sec[symtab_indx].len = elf_spnt->sh_size;

			retval = read_exec(bprm->inode, elf_spnt->sh_offset, 
					(char *)retval, elf_spnt->sh_size, 1);
        		if (retval < 0) {
				for(j = 0; j < elf_ex.e_shnum; j++)
                                        if(sec[j].len)
                                                do_munmap(sec[j].pm_add, sec[j].len);
				do_munmap(code_start, code_len + code_len + bss_len + stack_len);
                		kfree(elf_shdata);
                		return retval;
        		} 
	 
			strtab_indx = elf_spnt->sh_link;
			link_shdr = elf_shdata + strtab_indx;

			/* Map strtab section */
			retval = (unsigned long)do_mmap(NULL,
							0,
							link_shdr->sh_size,
							PROT_READ,
							0,
							0);
			if(retval > (unsigned long)-4096) {
				for(j = 0; j < elf_ex.e_shnum; j++)
					if(sec[j].len)
						do_munmap(sec[j].pm_add, sec[j].len);
				do_munmap(code_start, code_len + code_len + bss_len + stack_len);
				kfree(elf_shdata);
				return retval;
			}
 
			sec[strtab_indx].pm_add = retval;
			str_ptr = (char *)retval;
			sec[strtab_indx].len = link_shdr->sh_size;

			retval = read_exec(bprm->inode, link_shdr->sh_offset, 
					(char *)retval, link_shdr->sh_size, 1);
        		if (retval < 0) {
				for(j = 0; j < elf_ex.e_shnum; j++)
                                        if(sec[j].len)
                                                do_munmap(sec[j].pm_add, sec[j].len);
				do_munmap(code_start, code_len + code_len + bss_len + stack_len);
                		kfree(elf_shdata);
                		return retval;
        		} 

			sym_nb = sec[symtab_indx].len / sizeof(struct elf32_sym);
#if JUMP_TO_MAIN
			elf_entry = do_find_main(sym_nb, sym_ptr, str_ptr);
#else
			elf_entry = do_find_start(sym_nb, sym_ptr, str_ptr);
#endif
			break;
		}
	}
	
	for(i = 0, elf_spnt = elf_shdata; i < elf_ex.e_shnum; elf_spnt++, i++) {
		if(elf_spnt->sh_type == SHT_REL && (elf_spnt->sh_size != 0)) {
			struct elf32_shdr *link_shdr;
			int rel_nb;
			unsigned long retval;

			/* Map rel section */
			retval = (unsigned long)do_mmap(NULL,
							0,
							elf_spnt->sh_size,
							PROT_READ,
							0,
       						      	0);	
			if(retval > (unsigned long)-4096) {
				for(j = 0; j < elf_ex.e_shnum; j++)
       					if(sec[j].len)
						do_munmap(sec[j].pm_add, sec[j].len);
				do_munmap(code_start, code_len + code_len + bss_len + stack_len);
				kfree(elf_shdata);
				return retval;
			}
		
			sec[i].pm_add = retval;
			rel_ptr = (struct elf32_rel *)retval;
			sec[i].len = elf_spnt->sh_size;

			retval = read_exec(bprm->inode, elf_spnt->sh_offset, 
					(char *)retval, elf_spnt->sh_size, 1);
        		if (retval < 0) {
				for(j = 0; j < elf_ex.e_shnum; j++)
                                        if(sec[j].len)
                                                do_munmap(sec[j].pm_add, sec[j].len);
				do_munmap(code_start, code_len + code_len + bss_len + stack_len);
                		kfree(elf_shdata);
                		return retval;
        		} 
	
			rel_indx = i;
			link_shdr = elf_shdata + symtab_indx;

			/* Now do relocations for the n-th section. n is read from 
			   real setiona hader info field. */

			rel_nb = sec[rel_indx].len / sizeof(struct elf32_rel);
			retval = do_relocate(elf_spnt->sh_info, rel_nb, rel_ptr, sym_ptr,  sec);

			if (retval < 0) {
                                for(j = 0; j < elf_ex.e_shnum; j++)
                                        if(sec[j].len)
                                                do_munmap(sec[j].pm_add, sec[j].len);
				do_munmap(code_start, code_len + code_len + bss_len + stack_len);
                                kfree(elf_shdata);
                                return retval;
                        }

			/* Now unmap rel section */
			do_munmap(sec[rel_indx].pm_add, sec[rel_indx].len);
			sec[rel_indx].len = 0;
		}
	}

	/* Now unmap sym and str sections */
	do_munmap(sec[symtab_indx].pm_add, sec[symtab_indx].len);
	sec[symtab_indx].len = 0;
	do_munmap(sec[strtab_indx].pm_add, sec[strtab_indx].len);
	sec[strtab_indx].len = 0;

	set_fs(old_fs);
	kfree(elf_shdata);

	if (current->exec_domain && current->exec_domain->use_count)
		(*current->exec_domain->use_count)--;
	if (current->binfmt && current->binfmt->use_count)
		(*current->binfmt->use_count)--;
	current->exec_domain = lookup_exec_domain(current->personality);
	current->binfmt = &elf_format;
	if (current->exec_domain && current->exec_domain->use_count)
		(*current->exec_domain->use_count)++;
	if (current->binfmt && current->binfmt->use_count)
		(*current->binfmt->use_count)++;

	bprm->p = bss_end + stack_len - 4;

	bprm->p = putstringarray(bprm->p, 1, &bprm->filename);

	bprm->p = putstringarray(bprm->p, bprm->envc, bprm->envp);

	bprm->p = putstringarray(bprm->p, bprm->argc, bprm->argv);

	current->suid = current->euid = current->fsuid = bprm->e_uid;
	current->sgid = current->egid = current->fsgid = bprm->e_gid;
	current->flags &= ~PF_FORKNOEXEC;
	bprm->p = (unsigned long)create_elf_tables((char *) bprm->p, bprm->argc, bprm->envc, regs);

	current->mm->brk = bss_end;
	current->mm->start_code	 = code_start;
	current->mm->end_code = code_end;
	current->mm->start_data	 = data_start;
	current->mm->end_data = data_end;
	current->mm->start_stack = bprm->p;

_print("%s - %s:%d\n",__FILE__,__FUNCTION__,__LINE__);
_print("   start_code = %x\n", current->mm->start_code);
_print("   end_code = %x\n", current->mm->end_code);
_print("   start_data = %x\n", current->mm->start_data);
_print("   end_data = %x\n", current->mm->end_data);
_print("   start_brk = %x\n", current->mm->start_brk);
_print("   brk = %x\n", current->mm->brk);
_print("   start_stack = %x\n", current->mm->start_stack);
_print("   arg_start = %x\n", current->mm->arg_start);
_print("   env_start = %x\n", current->mm->env_start);
_print("   env_end = %x\n", current->mm->env_end);
_print("   elf_entry = %x\n", elf_entry);

	start_thread(regs, elf_entry, bprm->p);

	if (current->flags & PF_PTRACED)
		send_sig(SIGTRAP, current, 0);

	return 0;
}

static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
{
	int retval;

	MOD_INC_USE_COUNT;
	retval = do_load_elf_binary(bprm, regs);
	MOD_DEC_USE_COUNT;
	return retval;
}

int init_elf_binfmt(void)
{
	return register_binfmt(&elf_format);
}

#ifdef MODULE

int init_module(void)
{
	/* Install the COFF, ELF and XOUT loaders.
	 * N.B. We *rely* on the table being the right size with the
	 * right number of free slots...
	 */
	return init_elf_binfmt();
}


void cleanup_module(void)
{
	/* Remove the COFF and ELF loaders. */
	unregister_binfmt(&elf_format);
}

#endif
