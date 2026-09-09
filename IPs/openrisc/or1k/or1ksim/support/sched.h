/* sched.h -- Abstract entities header file handling job scheduler
   Copyright (C) 2001 Marko Mlinar, markom@opencores.org
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

#ifndef _SCHED_H_
#define _SCHED_H_

void sched_init(void);
void sched_reset(void);
void sched_next_insn(void (*func)(void *), void *dat);
void sched_find_remove(void (*job_func)(void *), void *dat, const char *func);
void sched_add(void (*job_func)(void *), void *job_param, int32_t job_time,
               const char *func);
#define SCHED_ADD(job_func, job_param, job_time) sched_add(job_func, job_param, job_time, #job_func)
#define SCHED_FIND_REMOVE(f, p) sched_find_remove(f, p, __FUNCTION__)

/* Structure for holding one job entry */
struct sched_entry {
  int32_t time;          /* Clock cycles before job starts */
  void *param;           /* Parameter to pass to the function */
  void (*func)(void *);  /* Function to call when time reaches 0 */
  struct sched_entry *next;
};

/* Heap of jobs */
struct scheduler_struct {
  struct sched_entry *free_job_queue;
  struct sched_entry *job_queue;
};

extern struct scheduler_struct scheduler;

void do_scheduler (void);

#endif /* _SCHED_H_ */
