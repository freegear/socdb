/*
 *  linux/fs/binfmt_flat.c
 *
 *  Copyright (C) 1998  Kenneth Albanowski <kjahds@kjahds.com>
 *                      The Silver Hammer Group, Ltd.
 *
 *  This is a relatively simple binary format, intended solely to contain
 *  the bare minimum needed to load and execute simple binaries, with
 *  special attention to executing from ROM, when possible.
 *
 *  Originally based on:
 *
 *  linux/fs/binfmt_aout.c
 *
 *  Copyright (C) 1991, 1992, 1996  Linus Torvalds
 */
 

#include <linux/module.h>

#include <linux/fs.h>
#include <linux/sched.h>
#include <linux/kernel.h>
#include <linux/mm.h>
#include <linux/mman.h>
#include <linux/a.out.h>
#include <linux/errno.h>
#include <linux/signal.h>
#include <linux/string.h>
#include <linux/stat.h>
#include <linux/fcntl.h>
#include <linux/ptrace.h>
#include <linux/user.h>
#include <linux/malloc.h>
#include <linux/binfmts.h>
#include <linux/personality.h>

#include <asm/system.h>
#include <asm/segment.h>
#include <asm/pgtable.h>
#include <asm/flat.h>

#undef DEBUG

static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);

extern void dump_thread(struct pt_regs *, struct user *);

static struct linux_binfmt flat_format = {
#ifndef MODULE
	NULL, NULL, load_flat_binary, NULL, NULL
#else
	NULL, &mod_use_count_, load_flat_binary, NULL, NULL
#endif
};

static unsigned long putstring(unsigned long p, char * string)
{
	unsigned long l = strlen(string)+1;
#ifdef DEBUG
	printk("put_string '%s'\n", string);
#endif
	p -= l;
	memcpy((void*)p, string, l);
	return p;
}

static unsigned long putstringarray(unsigned long p, int count, char ** array)
{
	/*p=putstring(p, "");*/
	/*printk("p1=%x, array=%x\n", p, array);
	printk("array[0]=%x\n", array[0]);*/
#ifdef DEBUG
	printk("putstringarray(%d)\n", count);
#endif
	while(count) {
		p=putstring(p, array[--count]);
#ifdef DEBUG
		printk("p2=%x\n", p);
#endif
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

/*
 * create_flat_tables() parses the env- and arg-strings in new user
 * memory and creates the pointer tables from them, and puts their
 * addresses on the "stack", returning the new stack pointer value.
 */
static unsigned long create_flat_tables(unsigned long pp, struct linux_binprm * bprm)
{
	unsigned long *argv,*envp;
	unsigned long * sp;
	char * p = (char*)pp;
	int argc = bprm->argc;
	int envc = bprm->envc;

	sp = (unsigned long *) ((-(unsigned long)sizeof(char *)) & (unsigned long) p);
#ifdef __alpha__
/* whee.. test-programs are so much fun. */
	put_user(0, --sp);
	put_user(0, --sp);
	if (bprm->loader) {
		put_user(0, --sp);
		put_user(0x3eb, --sp);
		put_user(bprm->loader, --sp);
		put_user(0x3ea, --sp);
	}
	put_user(bprm->exec, --sp);
	put_user(0x3e9, --sp);
#endif
	sp -= envc+1;
	envp = sp;
	sp -= argc+1;
	argv = sp;
#if defined(__i386__) || defined(__mc68000__)
	put_user(envp,--sp);
	put_user(argv,--sp);
#endif
	put_user(argc,--sp);
	current->mm->arg_start = (unsigned long) p;
	while (argc-->0) {
		put_user(p,argv++);
		while (get_user(p++)) /* nothing */ ;
	}
	put_user(NULL,argv);
	current->mm->arg_end = current->mm->env_start = (unsigned long) p;
	while (envc-->0) {
		put_user(p,envp++);
		while (get_user(p++)) /* nothing */ ;
	}
	put_user(NULL,envp);
	current->mm->env_end = (unsigned long) p;
	return (unsigned long)sp;
}

void do_reloc(struct flat_reloc * r)
{
	unsigned long * ptr = (unsigned long*)
		(current->mm->start_data + r->offset);


#ifdef DEBUG
	printk("Relocation of variable at DATASEG+%x (address %p, currently %x) into segment %x+%x\n",
		r->offset, ptr, *ptr, r->type, *ptr);

	printk("TEXTSEG=%x, DATASEG=%x, BSSSEG=%x\n",
		current->mm->start_code,
		current->mm->start_data,
		current->mm->end_data);

	printk("Relocation type = %d, offset = %d\n", r->type, r->offset);
#endif
	
	switch (r->type) {
	case FLAT_RELOC_TYPE_TEXT:
		*ptr += current->mm->start_code;
		break;
	case FLAT_RELOC_TYPE_DATA:
		*ptr += current->mm->start_data;
		break;
	case FLAT_RELOC_TYPE_BSS:
		*ptr += current->mm->end_data;
		break;
	default:
		printk("Unknown relocation\n");
	}

 
#ifdef DEBUG
	printk("Relocation became %x\n", *ptr);
#endif
}		


/*
 * These are the functions used to load a.out style executables and shared
 * libraries.  There is no binary dependent code anywhere else.
 */

inline int
do_load_flat_binary(struct linux_binprm * bprm, struct pt_regs * regs)
{
	struct flat_hdr * hdr;
	struct file * file;
	unsigned long error;
	unsigned long pos;
	unsigned long p = bprm->p;
	unsigned long data_len, bss_len, stack_len, code_len;


	current->personality = PER_LINUX;
	
	file = current->files->fd[open_inode(bprm->inode, O_RDONLY)];
	
#ifdef DEBUG
	printk("BINFMT_FLAT: Loading file: %x\n", file);
	show_free_areas();
#endif

	hdr = (struct flat_hdr*)bprm->buf;
	
	if (strncmp(hdr->magic, "bFLT", 4) || (hdr->rev != 2)) {
		printk("bad magic/rev (%ld, need %d)\n", hdr->rev, 2);
		return -ENOEXEC;
	}

	if (flush_old_exec(bprm)) {
		printk("unable to flush\n");
		return -ENOMEM;
	}
	
	/*printk("hdr->entry = %d, hdr->data_start = %d, hdr->data_end = %d, hdr->bss_end = %d, hdr->stack_size = %d\n",
		hdr->entry, hdr->data_start, hdr->data_end,
		hdr->bss_end, hdr->stack_size);*/

	/* OK, This is the point of no return */

	code_len = hdr->data_start;
	data_len = hdr->data_end - hdr->data_start;
	bss_len = hdr->bss_end - hdr->data_end;
	stack_len = hdr->stack_size;
	
	/* Make room on stack for arguments & environment */
	stack_len += strlen(bprm->filename) + 1;
	stack_len += stringarraylen(bprm->envc, bprm->envp);
	stack_len += stringarraylen(bprm->argc, bprm->argv);
	
	/*stack_len += 4-((pos+data_len+bss_len+stack_len) & 3);*/ /* Align stack */

	/*printk("Stack = %d, (%d)\n", stack_len, stack_len & 3);*/

	error = do_mmap(file,
		0,
               code_len + data_len + bss_len + stack_len,
               PROT_READ|PROT_EXEC | ((hdr->flags & FLAT_FLAG_RAM) ? PROT_WRITE : 0),
               0 /* MAP_* */,
               0);
        
        if (error >= -4096) {
          printk("Unable to map flat executable, errno %d\n", (int)-error);
          return error; /* Beyond point of no return? Oh well... */
        }

#ifdef DEBUG
        printk("BINFMT_FLAT: mmap returned: %x\n", error);
	show_free_areas();
#endif

       	current->mm->executable = 0;
	
	if (is_in_rom(error)) {
		unsigned long result;
#ifdef DEBUG
		printk("BINFMT_FLAT: ROM mapping of file\n");
#endif
		/* do_mmap returned a ROM mapping, so allocate RAM for data + bss + stack */
		/*pos = kmalloc(data_len+bss_len+stack_len, GFP_KERNEL);*/
		pos = do_mmap(0, 0, data_len+bss_len+stack_len, PROT_READ|PROT_WRITE|PROT_EXEC, 0, 0);
		if (pos >= (unsigned long)-4096) {
			printk("Unable to allocate RAM for process, errno %d\n", (int)-pos);
			return pos;
		}
		
#ifdef DEBUG
		printk("BINFMT_FLAT: Allocated data+bss+stack (%d bytes): %x\n", data_len+bss_len+stack_len, pos);
		show_free_areas();
#endif

		/* And then fill it in */

	 	/*printk("Reading data from %d-%d to %x\n", hdr->data_start, hdr->data_end - hdr->data_start, pos);*/

		result = read_exec(bprm->inode, hdr->data_start, (char *)pos,
			  data_len, 0);
		if (result >= (unsigned long)-4096) {
			  do_munmap(pos, 0);
			  printk("Unable to read data+bss, errno %d\n", (int)-result);
		}

 		/*printk("Clearing %x to %x\n", pos+data_len, pos+data_len+bss_len+stack_len);*/

	        memset((void*)(pos + data_len), 0, bss_len + stack_len);
	        
	        if (bprm->inode->i_sb->s_flags & MS_SYNCHRONOUS) {
#ifdef DEBUG
	        	printk("Retaining inode\n");
#endif
		 	current->mm->executable = bprm->inode;
		 	bprm->inode->i_count++;
	        }

	} else {
#ifdef DEBUG
		printk("BINFMT_FLAT: RAM mapping of file\n");
#endif
		
		/* Since we got a RAM mapping, mmap has already allocated a block for us, and
		   read in the data. . */

		pos = error + code_len;
		
	}
	
#ifdef DEBUG
	printk("ROM mapping is %x, Entry point is %x, data_start is %x\n", error, hdr->entry, hdr->data_start);
#endif
	
	current->mm->start_code = error + hdr->entry;
	current->mm->end_code = error + hdr->data_start;
	current->mm->start_data = pos;
	
	current->mm->end_data = pos + data_len;
	current->mm->brk = pos + data_len + bss_len;

	/*printk("start_code: %x, end_code: %x\n", current->mm->start_code,current->mm->end_code);
	printk("start_data: %x, end_data: %x\n", current->mm->start_data,current->mm->end_data);*/
	
	/*printk("Loaded flat file, BSS=%x, DATA=%x, TEXT=%x\n",
		current->mm->end_data,
		current->mm->start_data,
		current->mm->start_code);*/

	if (is_in_rom(error)) {
		int r;
		for(r=0;r<hdr->reloc_count;r++) {
			struct flat_reloc * reloc = (struct flat_reloc*)
				(error + hdr->reloc_start + (sizeof(struct flat_reloc)*r));
			do_reloc(reloc);
		}
	} else {
		int r;
		for(r=0;r<hdr->reloc_count;r++) {
			struct flat_reloc reloc;
			unsigned long result = read_exec(bprm->inode, 
				hdr->reloc_start + (sizeof(struct flat_reloc)*r), 
				(char *)&reloc,
			  	sizeof(struct flat_reloc), 
			  	0);
			if (result >= (unsigned long)-4096) {
				printk("Failure reloading relocation\n");
			} else
				do_reloc(&reloc);
		}
	}

	current->mm->rss = 0;
	current->suid = current->euid = current->fsuid = bprm->e_uid;
	current->sgid = current->egid = current->fsgid = bprm->e_gid;
 	current->flags &= ~PF_FORKNOEXEC;
 	
 	
        
	/*for(i=0;i<16;i++) {
		printk("%.2x ", ((char*)pos)[i] & 0xff);
	}
	printk("\n");*/
	


	if (current->exec_domain && current->exec_domain->use_count)
		(*current->exec_domain->use_count)--;
	if (current->binfmt && current->binfmt->use_count)
		(*current->binfmt->use_count)--;
	current->exec_domain = lookup_exec_domain(current->personality);
	current->binfmt = &flat_format;
	if (current->exec_domain && current->exec_domain->use_count)
		(*current->exec_domain->use_count)++;
	if (current->binfmt && current->binfmt->use_count)
		(*current->binfmt->use_count)++;

	/*set_brk(current->mm->start_brk, current->mm->brk);*/

	p = pos + data_len + bss_len + stack_len - 4;
	
#ifdef DEBUG
	printk("p=%x\n", p);
#endif
	
	p = putstringarray(p, 1, &bprm->filename);

#ifdef DEBUG
	printk("p(filename)=%x\n", p);
#endif

	p = putstringarray(p, bprm->envc, bprm->envp);

#ifdef DEBUG
	printk("p(envp)=%x\n", p);
#endif

	p = putstringarray(p, bprm->argc, bprm->argv);

#ifdef DEBUG
	printk("p(argv)=%x\n", p);
#endif

	p = create_flat_tables(p, bprm);

#ifdef DEBUG
	printk("p(create_flat_tables)=%x\n", p);
	
	printk("arg_start = %x\n", current->mm->arg_start);
	printk("arg_end = %x\n", current->mm->arg_end);
	printk("env_start = %x\n", current->mm->env_start);
	printk("env_end = %x\n", current->mm->env_end);
#endif

	current->mm->start_stack = p;

	/*printk("start_stack: %x\n", current->mm->start_stack);*/
	
	/*(*(volatile unsigned char *)0xdeadbee0) = 1;*/

#ifdef DEBUG	
	show_free_areas();
#endif

	start_thread(regs, current->mm->start_code /*, current->mm->start_data*/ /*- hdr->data_start*/, p);
	
	if (current->flags & PF_PTRACED)
		send_sig(SIGTRAP, current, 0);
	return 0;
}

static int
load_flat_binary(struct linux_binprm * bprm, struct pt_regs * regs)
{
	int retval;

	MOD_INC_USE_COUNT;
	retval = do_load_flat_binary(bprm, regs);
	MOD_DEC_USE_COUNT;
	return retval;
}

int init_flat_binfmt(void) {
	return register_binfmt(&flat_format);
}

#ifdef MODULE
int init_module(void) {
	return init_flat_binfmt();
}

void cleanup_module( void) {
	unregister_binfmt(&flat_format);
}
#endif

