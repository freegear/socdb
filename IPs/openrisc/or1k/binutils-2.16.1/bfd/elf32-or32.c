/* OR32-specific support for 32-bit ELF
   Copyright (C) 2002, 2003, 2004, 2005  Free Software Foundation, Inc.

   Contributed by Ivan Guzvinec  <ivang@opencores.org>
   Modified by Gyorgy Jeney <nog@sdf.lonestar.org>
	       Balint Cristian <rezso@rdsor.ro>
	       
   This file is part of BFD, the Binary File Descriptor library.

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
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */

#include "bfd.h"
#include "sysdep.h"
#include "libbfd.h"
#include "elf-bfd.h"
#include "elf/or32.h"
#include "elf/common.h"
#include "libiberty.h"


static reloc_howto_type *bfd_elf32_bfd_reloc_type_lookup
  PARAMS ((bfd *, bfd_reloc_code_real_type));
static void or32_info_to_howto_rel
  PARAMS ((bfd *, arelent *, Elf_Internal_Rela *));
static bfd_boolean or32_elf_object_p
  PARAMS ((bfd *));
static void or32_elf_final_write_processing
  PARAMS ((bfd *, bfd_boolean));
static bfd_reloc_status_type or32_elf_const_reloc
  PARAMS ((bfd *, arelent *, asymbol *, PTR, asection *, bfd *, char **));
static bfd_reloc_status_type or32_elf_consth_reloc
  PARAMS ((bfd *, arelent *, asymbol *, PTR, asection *, bfd *, char **));
static bfd_reloc_status_type _bfd_or32_elf_generic_reloc
  PARAMS ((bfd *, arelent *, asymbol *, void *, asection *, bfd *, char **));

#define ELF_R_SYM(i)  (ELF32_R_SYM (i))


/* Try to minimize the amount of space occupied by relocation tables
   on the ROM (not that the ROM won't be swamped by other ELF overhead).  */
#define USE_REL 	1

static reloc_howto_type elf_or32_howto_table[] =
{
  /* This reloc does nothing.  */
  HOWTO (R_OR32_NONE,		/* type */
	 0,			/* rightshift */
	 2,			/* size (0 = byte, 1 = short, 2 = long) */
	 32,			/* bitsize */
	 FALSE,			/* pc_relative */
	 0,			/* bitpos */
	 complain_overflow_bitfield, /* complain_on_overflow */
	 bfd_elf_generic_reloc,	/* special_function */
	 "R_OR32_NONE",		/* name */
	 FALSE,			/* partial_inplace */
	 0,			/* src_mask */
	 0,			/* dst_mask */
	 FALSE),		/* pcrel_offset */

  /* A standard 32 bit relocation.  */
  HOWTO (R_OR32_32,		/* type */
	 0,	                /* rightshift */
	 2,	                /* size (0 = byte, 1 = short, 2 = long) */
	 32,	                /* bitsize */
	 FALSE,	                /* pc_relative */
	 0,	                /* bitpos */
	 complain_overflow_bitfield, /* complain_on_overflow */
	 bfd_elf_generic_reloc,	/* special_function */
	 "R_OR32_32",		/* name */
	 TRUE,	                /* partial_inplace */
	 0xffffffff,	        /* src_mask */
	 0xffffffff,   		/* dst_mask */
	 FALSE),                /* pcrel_offset */

  /* A standard 16 bit relocation.  */
  HOWTO (R_OR32_16,		/* type */
	 0,	                /* rightshift */
	 1,	                /* size (0 = byte, 1 = short, 2 = long) */
	 16,	                /* bitsize */
	 FALSE,	                /* pc_relative */
	 0,	                /* bitpos */
	 complain_overflow_bitfield, /* complain_on_overflow */
	 bfd_elf_generic_reloc,	/* special_function */
	 "R_OR32_16",		/* name */
	 TRUE,	                /* partial_inplace */
	 0x0000ffff,	        /* src_mask */
	 0x0000ffff,   		/* dst_mask */
	 FALSE),                /* pcrel_offset */

  /* A standard 8 bit relocation.  */
  HOWTO (R_OR32_8,		/* type */
	 0,	                /* rightshift */
	 0,	                /* size (0 = byte, 1 = short, 2 = long) */
	 8,	                /* bitsize */
	 FALSE,	                /* pc_relative */
	 0,	                /* bitpos */
	 complain_overflow_bitfield, /* complain_on_overflow */
	 bfd_elf_generic_reloc,	/* special_function */
	 "R_OR32_8",		/* name */
	 TRUE,	                /* partial_inplace */
	 0x000000ff,	        /* src_mask */
	 0x000000ff,   		/* dst_mask */
	 FALSE),                /* pcrel_offset */

  /* A standard low 16 bit relocation.  */
  HOWTO (R_OR32_CONST,		/* type */
	 0,			/* rightshift */
	 2,			/* size (0 = byte, 1 = short, 2 = long) */
	 16,			/* bitsize */
	 FALSE,			/* pc_relative */
	 0,			/* bitpos */
	 complain_overflow_dont, /* complain_on_overflow */
	 or32_elf_const_reloc,	/* special_function */
	 "R_OR32_CONST",	/* name */
	 TRUE,			/* partial_inplace */
	 0x0000ffff,		/* src_mask */
	 0x0000ffff,		/* dst_mask */
	 FALSE),		/* pcrel_offset */

  /* A standard high 16 bit relocation.  */
  HOWTO (R_OR32_CONSTH,		/* type */
	 16,			/* rightshift */
	 2,			/* size (0 = byte, 1 = short, 2 = long) */
	 16,			/* bitsize */
	 FALSE,			/* pc_relative */
	 0,			/* bitpos */
	 complain_overflow_dont, /* complain_on_overflow */
	 or32_elf_consth_reloc,	/* special_function */
	 "R_OR32_CONSTH",	/* name */
	 TRUE,			/* partial_inplace */
	 0x0000ffff,		/* src_mask */
	 0x0000ffff,		/* dst_mask */
	 FALSE),		/* pcrel_offset */

  /* A standard branch relocation.  */
  HOWTO (R_OR32_JUMPTARG,	/* type */
	 2,			/* rightshift */
	 2,			/* size (0 = byte, 1 = short, 2 = long) */
	 28,			/* bitsize */
	 TRUE,			/* pc_relative */
	 0,			/* bitpos */
	 complain_overflow_signed, /* complain_on_overflow */
	 _bfd_or32_elf_generic_reloc,	/* special_function */
	 "R_OR32_JUMPTARG",	/* name */
	 TRUE,			/* partial_inplace */
	 0x03ffffff,		/* src_mask *//* markom, was: 0 */
	 0x03ffffff,		/* dst_mask */
	 TRUE), 		/* pcrel_offset */

  /* GNU extension to record C++ vtable hierarchy.  */
  HOWTO (R_OR32_GNU_VTINHERIT, /* type */
         0,                     /* rightshift */
         2,                     /* size (0 = byte, 1 = short, 2 = long) */
         0,                     /* bitsize */
         FALSE,                 /* pc_relative */
         0,                     /* bitpos */
         complain_overflow_dont, /* complain_on_overflow */
         NULL,                  /* special_function */
         "R_OR32_GNU_VTINHERIT", /* name */
         FALSE,                 /* partial_inplace */
         0,                     /* src_mask */
         0,                     /* dst_mask */
         FALSE),                /* pcrel_offset */

  /* GNU extension to record C++ vtable member usage.  */
  HOWTO (R_OR32_GNU_VTENTRY,     /* type */
         0,                     /* rightshift */
         2,                     /* size (0 = byte, 1 = short, 2 = long) */
         0,                     /* bitsize */
         FALSE,                 /* pc_relative */
         0,                     /* bitpos */
         complain_overflow_dont, /* complain_on_overflow */
         _bfd_elf_rel_vtable_reloc_fn,  /* special_function */
         "R_OR32_GNU_VTENTRY",   /* name */
         FALSE,                 /* partial_inplace */
         0,                     /* src_mask */
         0,                     /* dst_mask */
         FALSE),                /* pcrel_offset */
};

/* Map BFD reloc types to OR32 ELF reloc types.  */

struct or32_reloc_map
{
  bfd_reloc_code_real_type  bfd_reloc_val;
  unsigned char             elf_reloc_val;
};

static const struct or32_reloc_map or32_reloc_map[] =
{
  { BFD_RELOC_NONE, R_OR32_NONE },
  { BFD_RELOC_32, R_OR32_32 },
  { BFD_RELOC_16, R_OR32_16 },
  { BFD_RELOC_8, R_OR32_8 },
  { BFD_RELOC_LO16, R_OR32_CONST },
  { BFD_RELOC_HI16, R_OR32_CONSTH },
  { BFD_RELOC_28_PCREL_S2, R_OR32_JUMPTARG },
  { BFD_RELOC_VTABLE_INHERIT, R_OR32_GNU_VTINHERIT },
  { BFD_RELOC_VTABLE_ENTRY, R_OR32_GNU_VTENTRY },
};

static reloc_howto_type *
bfd_elf32_bfd_reloc_type_lookup (abfd, code)
     bfd *abfd ATTRIBUTE_UNUSED;
     bfd_reloc_code_real_type code;
{
  unsigned int i;

  for (i = ARRAY_SIZE (or32_reloc_map); i--;)
    {
      if (or32_reloc_map[i].bfd_reloc_val == code)
	return &elf_or32_howto_table[or32_reloc_map[i].elf_reloc_val];
    }

  return NULL;
}

/* Set the howto pointer for an OR32 ELF reloc.  */

static void
or32_info_to_howto_rel (abfd, cache_ptr, dst)
     bfd *abfd ATTRIBUTE_UNUSED;
     arelent *cache_ptr;
     Elf_Internal_Rela *dst;
{
  unsigned int r_type;

//static void or32_elf_info_to_howto_rel
//  (bfd *bfd, 
//   arelent *relent, 
//   Elf_Internal_Rela *rela)

  r_type = ELF32_R_TYPE (dst->r_info);
  BFD_ASSERT (r_type < (unsigned int) R_OR32_max);
  cache_ptr->howto = &elf_or32_howto_table[r_type];

      asymbol *s = *(cache_ptr->sym_ptr_ptr);
  if(ELF_R_SYM(dst->r_info) && (s->flags & BSF_SECTION_SYM))
      cache_ptr->sym_ptr_ptr = s->section->symbol_ptr_ptr;

}

/* Set the right machine number for an OR32 ELF file.  */

static bfd_boolean
or32_elf_object_p (abfd)
     bfd *abfd;
{
  (void) bfd_default_set_arch_mach (abfd, bfd_arch_or32, 0);
  return TRUE;
}

/* The final processing done just before writing out an OR32 ELF object file.
   This gets the OR32 architecture right based on the machine number.  */

static void
or32_elf_final_write_processing (abfd, linker)
     bfd *abfd;
     bfd_boolean linker ATTRIBUTE_UNUSED;
{
  int mach;
  unsigned long val;

  switch (mach = bfd_get_mach (abfd))
    {
    /*
    case bfd_mach_arc_base:
      val = E_OR32_MACH_BASE;
      break;
    */
    default:
      val = 0;
      return;
    }

  elf_elfheader (abfd)->e_flags &=~ EF_OR32_MACH;
  elf_elfheader (abfd)->e_flags |= val;
}

static bfd_reloc_status_type
_bfd_or32_elf_generic_reloc (bfd *abfd ATTRIBUTE_UNUSED, arelent *reloc_entry,
			     asymbol *symbol, void *data ATTRIBUTE_UNUSED,
			     asection *input_section, bfd *output_bfd,
			     char **error_message ATTRIBUTE_UNUSED)
{
  bfd_signed_vma val;
  bfd_reloc_status_type status;
  bfd_boolean relocatable;

  relocatable = (output_bfd != NULL);

  if (reloc_entry->address > bfd_get_section_limit (abfd, input_section))
    return bfd_reloc_outofrange;

  /* Build up the field adjustment in VAL.  */
  val = 0;
  if (!relocatable || (symbol->flags & BSF_SECTION_SYM) != 0)
    {
      /* Either we're calculating the final field value or we have a
	 relocation against a section symbol.  Add in the section's
	 offset or address.  */
      val += symbol->section->output_section->vma;
      val += symbol->section->output_offset;
    }

  if (!relocatable)
    {
      /* We're calculating the final field value.  Add in the symbol's value
	 and, if pc-relative, subtract the address of the field itself.  */
      val += symbol->value;
      if (reloc_entry->howto->pc_relative)
	val -= input_section->output_section->vma;
    }

  if (reloc_entry->howto->pc_relative)
    val -= input_section->output_offset;

  /* VAL is now the final adjustment.  If we're keeping this relocation
     in the output file, and if the relocation uses a separate addend,
     we just need to add VAL to that addend.  Otherwise we need to add
     VAL to the relocation field itself.  */
  if (relocatable && !reloc_entry->howto->partial_inplace)
    reloc_entry->addend += val;
  else
    {
      /* Add in the separate addend, if any.  */
      val += reloc_entry->addend;

      /* Add VAL to the relocation field.  */
      status = _bfd_relocate_contents (reloc_entry->howto, abfd, val,
				       (bfd_byte *) data
				       + reloc_entry->address);
      if (status != bfd_reloc_ok)
	return status;
    }

  if (relocatable)
    reloc_entry->address += input_section->output_offset;

  return bfd_reloc_ok;
}


/* Do a R_OR32_CONSTH relocation.  This has to be done in combination
   with a R_OR32_CONST reloc, because there is a carry from the LO16 to
   the HI16.  Here we just save the information we need; we do the
   actual relocation when we see the LO16.  OR32 ELF requires that the
   LO16 immediately follow the HI16.  As a GNU extension, we permit an
   arbitrary number of HI16 relocs to be associated with a single LO16
   reloc.  This extension permits gcc to output the HI and LO relocs
   itself. This code is copied from the elf32-mips.c.  */

struct or32_consth
{
  struct or32_consth *next;
  bfd_byte *data;
  asection *input_section;
  arelent rel;
};

/* FIXME: This should not be a static variable.  */

static struct or32_consth *or32_consth_list;

bfd_reloc_status_type
or32_elf_consth_reloc (abfd, reloc_entry, symbol, data, input_section,
		       output_bfd, error_message)
     bfd *abfd ATTRIBUTE_UNUSED;
     arelent *reloc_entry;
     asymbol *symbol ATTRIBUTE_UNUSED;
     PTR data;
     asection *input_section;
     bfd *output_bfd;
     char **error_message ATTRIBUTE_UNUSED;
{
  struct or32_consth *n;

  if (reloc_entry->address > bfd_get_section_limit (abfd, input_section))
    return bfd_reloc_outofrange;

  /* Save the information, and let LO16 do the actual relocation.  */
  n = (struct or32_consth *) bfd_malloc (sizeof *n);
  if (n == NULL)
    return bfd_reloc_outofrange;

  /* Push this reloc on the list of pending relocations */
  n->next = or32_consth_list;
  n->data = data;
  n->input_section = input_section;
  n->rel = *reloc_entry;
  or32_consth_list = n;

  if (output_bfd != NULL)
    reloc_entry->address += input_section->output_offset;

  return bfd_reloc_ok;
}

/* Do a R_OR32_CONST relocation.  This is a straightforward 16 bit
   inplace relocation; this function exists in order to do the
   R_OR32_CONSTH relocation described above.  */

bfd_reloc_status_type
or32_elf_const_reloc (abfd, reloc_entry, symbol, data, input_section,
		      output_bfd, error_message)
     bfd *abfd;
     arelent *reloc_entry;
     asymbol *symbol;
     PTR data;
     asection *input_section;
     bfd *output_bfd;
     char **error_message;
{
  bfd_vma vallo;

  if (reloc_entry->address > bfd_get_section_limit (abfd, input_section))
    return bfd_reloc_outofrange;

  vallo = bfd_get_32 (abfd, (bfd_byte *) data + reloc_entry->address) & 0xffff;

  while (or32_consth_list != NULL)
    {
      bfd_reloc_status_type ret;
      struct or32_consth *hi;

      hi = or32_consth_list;

      /* VALLO is a signed 16-bit number.  Bias it by 0x8000 so that any
	 carry or borrow will induce a change of +1 or -1 in the high part.  */
      hi->rel.addend += vallo;

      ret = _bfd_or32_elf_generic_reloc (abfd, &hi->rel, symbol, hi->data,
					 hi->input_section, output_bfd,
					 error_message);
      if (ret != bfd_reloc_ok)
	return ret;

      or32_consth_list = hi->next;
      free (hi);
    }

  return _bfd_or32_elf_generic_reloc (abfd, reloc_entry, symbol, data,
				      input_section, output_bfd,
				      error_message);
}

#define TARGET_LITTLE_SYM	bfd_elf32_or32_little_vec
#define TARGET_LITTLE_NAME	"elf32-littleor32"
#define TARGET_BIG_SYM		bfd_elf32_or32_big_vec
#define TARGET_BIG_NAME		"elf32-or32"
#define ELF_ARCH		bfd_arch_or32
#define ELF_MACHINE_CODE	EM_OPENRISC
#define ELF_MACHINE_ALT1	EM_OR32
#define ELF_MAXPAGESIZE		0x2000

#define elf_info_to_howto	0
#define elf_info_to_howto_rel	or32_info_to_howto_rel
//#define bfd_elf32_bfd_link_hash_table_create _bfd_elf_link_hash_table_create
//#define elf_backend_can_gc_sections 1
//#define elf_backend_check_relocs or32_elf_check_relocs
#define elf_backend_object_p	or32_elf_object_p
#define elf_backend_final_write_processing \
				or32_elf_final_write_processing

#include "elf32-target.h"
