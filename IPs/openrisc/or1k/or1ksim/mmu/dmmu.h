/* dmmu.h -- Data MMU header file
   Copyright (C) 1999 Damjan Lampret, lampret@opencores.org
   
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

/* FIXME: Move to dmmu.c once the dust settles */
struct dmmu {
  int enabled;                      /* Whether DMMU is enabled */
  int nways;                        /* Number of DTLB ways */
  int nsets;                        /* Number of DTLB sets */
  int pagesize;                     /* DTLB page size */
  int pagesize_log2;                /* DTLB page size (log2(pagesize)) */
  oraddr_t page_offset_mask;        /* Address mask to get page offset */
  oraddr_t page_mask;               /* Page number mask (diff. from vpn) */
  oraddr_t vpn_mask;                /* Address mask to get vpn */
  int lru_reload;                   /* What to reload the lru value to */
  oraddr_t set_mask;                /* Mask to get set of an address */
  int entrysize;                    /* DTLB entry size */
  int ustates;                      /* number of DTLB usage states */
  int missdelay;                    /* How much cycles does the miss cost */
  int hitdelay;                     /* How much cycles does the hit cost */
};
#define DADDR_PAGE(addr) ((addr) & dmmu_state->page_mask)
/* FIXME: Remove the need for this global */
extern struct dmmu *dmmu_state;

oraddr_t dmmu_translate(oraddr_t virtaddr, int write_access);
oraddr_t dmmu_simulate_tlb(oraddr_t virtaddr, int write_access);
oraddr_t peek_into_dtlb(oraddr_t virtaddr, int write_access, int through_dc);
