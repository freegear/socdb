/* dmmu.c -- Data MMU simulation
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

/* DMMU model, perfectly functional. */

#include "config.h"

#ifdef HAVE_INTTYPES_H
#include <inttypes.h>
#endif

#include "port.h"
#include "arch.h"
#include "dmmu.h"
#include "abstract.h"
#include "opcode/or32.h"
#include "spr_defs.h"
#include "execute.h"
#include "stats.h"
#include "sprs.h"
#include "except.h"
#include "sim-config.h"
#include "debug.h"
#include "misc.h"

DEFAULT_DEBUG_CHANNEL(dmmu);

struct dmmu *dmmu_state;

/* Data MMU */

static inline uorreg_t *dmmu_find_tlbmr(oraddr_t virtaddr,
                                        uorreg_t **dtlbmr_lru,
                                        struct dmmu *dmmu)
{
  int set;
  int i;
  oraddr_t vpn;
  uorreg_t *dtlbmr;

  /* Which set to check out? */
  set = DADDR_PAGE(virtaddr) >> dmmu->pagesize_log2;
  set &= dmmu->set_mask;
  vpn = virtaddr & dmmu->vpn_mask;

  dtlbmr = &cpu_state.sprs[SPR_DTLBMR_BASE(0) + set];
  *dtlbmr_lru = dtlbmr;

  /* FIXME: Should this be reversed? */
  for(i = dmmu->nways; i; i--, dtlbmr += (128 * 2)) {
    if(((*dtlbmr & dmmu->vpn_mask) == vpn) && (*dtlbmr & SPR_DTLBMR_V))
      return dtlbmr;
  }

  return NULL;
}

oraddr_t dmmu_translate(oraddr_t virtaddr, int write_access)
{
  int i;
  uorreg_t *dtlbmr;
  uorreg_t *dtlbtr;
  uorreg_t *dtlbmr_lru;
  struct dmmu *dmmu = dmmu_state;

  if (!(cpu_state.sprs[SPR_SR] & SPR_SR_DME) ||
      !(cpu_state.sprs[SPR_UPR] & SPR_UPR_DMP)) {
    data_ci = (virtaddr >= 0x80000000);
    return virtaddr;
  }

  dtlbmr = dmmu_find_tlbmr(virtaddr, &dtlbmr_lru, dmmu);

  /* Did we find our tlb entry? */
  if(dtlbmr) { /* Yes, we did. */
    dmmu_stats.loads_tlbhit++;

    dtlbtr = dtlbmr + 128;
     
    TRACE("DTLB hit (virtaddr=%"PRIxADDR") at %lli.\n", virtaddr,
          runtime.sim.cycles);
    
    /* Set LRUs */
    for(i = 0; i < dmmu->nways; i++, dtlbmr_lru += (128 * 2)) {
      if(*dtlbmr_lru & SPR_DTLBMR_LRU)
        *dtlbmr_lru = (*dtlbmr_lru & ~SPR_DTLBMR_LRU) |
                                        ((*dtlbmr_lru & SPR_DTLBMR_LRU) - 0x40);
    }

    /* This is not necessary `*dtlbmr &= ~SPR_DTLBMR_LRU;' since SPR_DTLBMR_LRU
     * is always decremented and the number of sets is always a power of two and
     * as such lru_reload has all bits set that get touched during decrementing
     * SPR_DTLBMR_LRU */
    *dtlbmr |= dmmu->lru_reload;

    /* Check if page is cache inhibited */
    data_ci = *dtlbtr & SPR_DTLBTR_CI;

    runtime.sim.mem_cycles += dmmu->hitdelay;

    /* Test for page fault */
    if (cpu_state.sprs[SPR_SR] & SPR_SR_SM) {
      if ( (write_access && !(*dtlbtr & SPR_DTLBTR_SWE))
       || (!write_access && !(*dtlbtr & SPR_DTLBTR_SRE)))
        except_handle(EXCEPT_DPF, virtaddr);
    } else {
      if ( (write_access && !(*dtlbtr & SPR_DTLBTR_UWE))
       || (!write_access && !(*dtlbtr & SPR_DTLBTR_URE)))
        except_handle(EXCEPT_DPF, virtaddr);
    }

    TRACE("Returning physical address %"PRIxADDR"\n",
          (*dtlbtr & SPR_DTLBTR_PPN) | (virtaddr & (dmmu->page_offset_mask)));
    return (*dtlbtr & SPR_DTLBTR_PPN) | (virtaddr & (dmmu->page_offset_mask));
  }

  /* No, we didn't. */
  dmmu_stats.loads_tlbmiss++;
#if 0
  for (i = 0; i < dmmu->nways; i++)
    if (((cpu_state.sprs[SPR_DTLBMR_BASE(i) + set] & SPR_DTLBMR_LRU) >> 6) < minlru)
      minway = i;
      
  cpu_state.sprs[SPR_DTLBMR_BASE(minway) + set] &= ~SPR_DTLBMR_VPN;
  cpu_state.sprs[SPR_DTLBMR_BASE(minway) + set] |= vpn << 12;
  for (i = 0; i < dmmu->nways; i++) {
    uorreg_t lru = cpu_state.sprs[SPR_DTLBMR_BASE(i) + set];
    if (lru & SPR_DTLBMR_LRU) {
      lru = (lru & ~SPR_DTLBMR_LRU) | ((lru & SPR_DTLBMR_LRU) - 0x40);
      cpu_state.sprs[SPR_DTLBMR_BASE(i) + set] = lru;
    }
  }
  cpu_state.sprs[SPR_DTLBMR_BASE(way) + set] &= ~SPR_DTLBMR_LRU;
  cpu_state.sprs[SPR_DTLBMR_BASE(way) + set] |= (dmmu->nsets - 1) << 6;

  /* 1 to 1 mapping */
  cpu_state.sprs[SPR_DTLBTR_BASE(minway) + set] &= ~SPR_DTLBTR_PPN;
  cpu_state.sprs[SPR_DTLBTR_BASE(minway) + set] |= vpn << 12;

  cpu_state.sprs[SPR_DTLBMR_BASE(minway) + set] |= SPR_DTLBMR_V;
#endif
  TRACE("DTLB miss (virtaddr=%"PRIxADDR") at %lli.\n", virtaddr,
        runtime.sim.cycles);
  runtime.sim.mem_cycles += dmmu->missdelay;
  /* if tlb refill implemented in HW */
  /* return ((cpu_state.sprs[SPR_DTLBTR_BASE(minway) + set] & SPR_DTLBTR_PPN) >> 12) * dmmu->pagesize + (virtaddr % dmmu->pagesize); */

  except_handle(EXCEPT_DTLBMISS, virtaddr);
  return 0;
}

/* DESC: try to find EA -> PA transaltion without changing 
 *       any of precessor states. if this is not passible gives up 
 *       (without triggering exceptions)
 *
 * PRMS: virtaddr     - EA for which to find translation 
 *
 *       write_access - 0 ignore testing for write access
 *                      1 test for write access, if fails
 *                        do not return translation
 *
 *       through_dc   - 1 go through data cache
 *                      0 ignore data cache
 *
 * RTRN: 0            - no DMMU, DMMU disabled or ITLB miss
 *       else         - appropriate PA (note it DMMU is not present 
 *                      PA === EA)
 */
oraddr_t peek_into_dtlb(oraddr_t virtaddr, int write_access, int through_dc)
{
  uorreg_t *dtlbmr;
  uorreg_t *dtlbtr;
  uorreg_t *dtlbmr_lru;
  struct dmmu *dmmu = dmmu_state;

  if (!(cpu_state.sprs[SPR_SR] & SPR_SR_DME) ||
      !(cpu_state.sprs[SPR_UPR] & SPR_UPR_DMP)) {
    if (through_dc)
      data_ci = (virtaddr >= 0x80000000);
    return virtaddr;
  }

  dtlbmr = dmmu_find_tlbmr(virtaddr, &dtlbmr_lru, dmmu);

  /* Did we find our tlb entry? */
  if (dtlbmr) { /* Yes, we did. */
    dmmu_stats.loads_tlbhit++;

    dtlbtr = dtlbmr + 128;
     
    TRACE("DTLB hit (virtaddr=%"PRIxADDR") at %lli.\n", virtaddr,
          runtime.sim.cycles);
    
    /* Test for page fault */
    if (cpu_state.sprs[SPR_SR] & SPR_SR_SM) {
      if((write_access && !(*dtlbtr & SPR_DTLBTR_SWE)) ||
         (!write_access && !(*dtlbtr & SPR_DTLBTR_SRE)))
	
	/* otherwise exception DPF would be raised */
	return(0);
    } else {
      if((write_access && !(*dtlbtr & SPR_DTLBTR_UWE)) ||
         (!write_access && !(*dtlbtr & SPR_DTLBTR_URE)))
       
	/* otherwise exception DPF would be raised */	
	return(0);
    }

    if (through_dc) {
      /* Check if page is cache inhibited */
      data_ci = *dtlbtr & SPR_DTLBTR_CI;
    }

    return (*dtlbtr & SPR_DTLBTR_PPN) | (virtaddr & (dmmu->page_offset_mask));
  }

  return(0);
}

/* FIXME: Is this comment valid? */
/* First check if virtual address is covered by DTLB and if it is:
    - increment DTLB read hit stats,
    - set 'lru' at this way to dmmu->ustates - 1 and
      decrement 'lru' of other ways unless they have reached 0,
    - check page access attributes and invoke DMMU page fault exception
      handler if necessary
   and if not:
    - increment DTLB read miss stats
    - find lru way and entry and invoke DTLB miss exception handler
    - set 'lru' with dmmu->ustates - 1 and decrement 'lru' of other
      ways unless they have reached 0
*/

static void dtlb_status(void *dat)
{
  struct dmmu *dmmu = dat;
  int set;
  int way;
  int end_set = dmmu->nsets;

  if (!(cpu_state.sprs[SPR_UPR] & SPR_UPR_DMP)) {
    PRINTF("DMMU not implemented. Set UPR[DMP].\n");
    return;
  }

  if (0 < end_set) PRINTF("\nDMMU: ");
  /* Scan set(s) and way(s). */
  for (set = 0; set < end_set; set++) {
    for (way = 0; way < dmmu->nways; way++) {
      PRINTF("%s\n", dump_spr(SPR_DTLBMR_BASE(way) + set,
                              cpu_state.sprs[SPR_DTLBMR_BASE(way) + set]));
      PRINTF("%s\n", dump_spr(SPR_DTLBTR_BASE(way) + set,
                              cpu_state.sprs[SPR_DTLBTR_BASE(way) + set]));
    }
  }
  if (0 < end_set) PRINTF("\n");
}

/*---------------------------------------------------[ DMMU configuration ]---*/
static void dmmu_enabled(union param_val val, void *dat)
{
  struct dmmu *dmmu = dat;

  if(val.int_val)
    cpu_state.sprs[SPR_UPR] |= SPR_UPR_DMP;
  else
    cpu_state.sprs[SPR_UPR] &= ~SPR_UPR_DMP;
  dmmu->enabled = val.int_val;
}

static void dmmu_nsets(union param_val val, void *dat)
{
  struct dmmu *dmmu = dat;

  if (is_power2(val.int_val) && val.int_val <= 256) {
    dmmu->nsets = val.int_val;
    cpu_state.sprs[SPR_DMMUCFGR] &= ~SPR_DMMUCFGR_NTS;
    cpu_state.sprs[SPR_DMMUCFGR] |= log2_int(val.int_val) << 3;
  } else
    CONFIG_ERROR("value of power of two and lower or equal than 256 expected.");
}

static void dmmu_nways(union param_val val, void *dat)
{
  struct dmmu *dmmu = dat;

  if (val.int_val >= 1 && val.int_val <= 4) {
    dmmu->nways = val.int_val;
    cpu_state.sprs[SPR_DMMUCFGR] &= ~SPR_DMMUCFGR_NTW;
    cpu_state.sprs[SPR_DMMUCFGR] |= val.int_val - 1;
  }
  else
    CONFIG_ERROR("value 1, 2, 3 or 4 expected.");
}

static void dmmu_pagesize(union param_val val, void *dat)
{
  struct dmmu *dmmu = dat;

  if (is_power2(val.int_val))
    dmmu->pagesize = val.int_val;
  else
    CONFIG_ERROR("value of power of two expected.");
}

static void dmmu_entrysize(union param_val val, void *dat)
{
  struct dmmu *dmmu = dat;

  if (is_power2(val.int_val))
    dmmu->entrysize = val.int_val;
  else
    CONFIG_ERROR("value of power of two expected.");
}

static void dmmu_ustates(union param_val val, void *dat)
{
  struct dmmu *dmmu = dat;

  if (val.int_val >= 2 && val.int_val <= 4)
    dmmu->ustates = val.int_val;
  else
    CONFIG_ERROR("invalid USTATE.");
}

static void dmmu_missdelay(union param_val val, void *dat)
{
  struct dmmu *dmmu = dat;

  dmmu->missdelay = val.int_val;
}

static void dmmu_hitdelay(union param_val val, void *dat)
{
  struct dmmu *dmmu = dat;

  dmmu->hitdelay = val.int_val;
}

static void *dmmu_start_sec(void)
{
  struct dmmu *dmmu;

  if(!(dmmu = malloc(sizeof(struct dmmu)))) {
    fprintf(stderr, "OOM\n");
    exit(1);
  }

  dmmu->enabled = 0;
  dmmu->hitdelay = 1;
  dmmu->missdelay = 1;
  dmmu->pagesize = 8192;
  /* FIXME: Something sane */
  dmmu->entrysize = 0;

  dmmu_state = dmmu;

  return dmmu;
}

static void dmmu_end_sec(void *dat)
{
  struct dmmu *dmmu = dat;

  /* Precalculate some values for use during address translation */
  dmmu->pagesize_log2 = log2_int(dmmu->pagesize);
  dmmu->page_offset_mask = dmmu->pagesize - 1;
  dmmu->page_mask = ~dmmu->page_offset_mask;
  dmmu->vpn_mask = ~((dmmu->pagesize * dmmu->nsets) - 1);
  dmmu->set_mask = dmmu->nsets - 1;
  dmmu->lru_reload = (dmmu->set_mask << 6) & SPR_DTLBMR_LRU;

  if(dmmu->enabled) {
    PRINTF("Data MMU %dKB: %d ways, %d sets, entry size %d bytes\n",
           dmmu->nsets * dmmu->entrysize * dmmu->nways / 1024, dmmu->nways,
           dmmu->nsets, dmmu->entrysize);
    reg_sim_stat(dtlb_status, dmmu);
  }
}

void reg_dmmu_sec(void)
{
  struct config_section *sec = reg_config_sec("dmmu", dmmu_start_sec,
                                              dmmu_end_sec);

  reg_config_param(sec, "enabled", paramt_int, dmmu_enabled);
  reg_config_param(sec, "nsets", paramt_int, dmmu_nsets);
  reg_config_param(sec, "nways", paramt_int, dmmu_nways);
  reg_config_param(sec, "pagesize", paramt_int, dmmu_pagesize);
  reg_config_param(sec, "entrysize", paramt_int, dmmu_entrysize);
  reg_config_param(sec, "ustates", paramt_int, dmmu_ustates);
  reg_config_param(sec, "missdelay", paramt_int, dmmu_missdelay);
  reg_config_param(sec, "hitdelay", paramt_int, dmmu_hitdelay);
}
