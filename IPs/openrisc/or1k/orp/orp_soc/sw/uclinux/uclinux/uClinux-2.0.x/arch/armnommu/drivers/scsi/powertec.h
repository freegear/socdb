/*
 * PowerTec SCSI driver
 *
 * Copyright (C) 1997-1998 Russell King
 */
#ifndef POWERTECSCSI_H
#define POWERTECSCSI_H

extern int powertecscsi_detect (Scsi_Host_Template *);
extern int powertecscsi_release (struct Scsi_Host *);
extern const char *powertecscsi_info (struct Scsi_Host *);
extern int powertecscsi_proc_info (char *buffer, char **start, off_t offset,
					int length, int hostno, int inout);

#ifndef NULL
#define NULL ((void *)0)
#endif

#ifndef CAN_QUEUE
/*
 * Default queue size
 */
#define CAN_QUEUE	1
#endif

#ifndef CMD_PER_LUN
#define CMD_PER_LUN	1
#endif

#ifndef SCSI_ID
/*
 * Default SCSI host ID
 */
#define SCSI_ID		7
#endif

#include <scsi/scsicam.h>

#include "fas216.h"

#define POWERTECSCSI {							\
	NULL,								\
	NULL,								\
	NULL,								\
	powertecscsi_proc_info,						\
	"PowerTec SCSI",						\
	powertecscsi_detect,		/* detect		*/	\
	powertecscsi_release,		/* release		*/	\
	powertecscsi_info,		/* info			*/	\
	fas216_command,			/* command		*/	\
	fas216_queue_command,		/* queuecommand		*/	\
	fas216_abort,			/* abort		*/	\
	fas216_reset,			/* reset		*/	\
	NULL,								\
	scsicam_bios_param,		/* biosparam		*/	\
	CAN_QUEUE,			/* can queue		*/	\
	SCSI_ID,			/* scsi host id		*/	\
	SG_ALL,				/* sg_tablesize		*/	\
	CMD_PER_LUN,			/* cmd per lun		*/	\
	0,				/* number of boards	*/	\
	0,				/* unchecked isa dma	*/	\
	DISABLE_CLUSTERING						\
	}

#ifndef HOSTS_C

#include <asm/dma.h>

#define NR_SG	256

typedef struct {
	FAS216_Info info;

	struct {
		unsigned int term_port;
		unsigned int terms;
	} control;

	/* other info... */
	dmasg_t		dmasg[NR_SG];	/* Scatter DMA list	*/
} PowerTecScsi_Info;

#endif /* HOSTS_C */

#endif /* POWERTECSCSI_H */
