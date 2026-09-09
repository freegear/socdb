/*
 * EESOX SCSI driver
 *
 * Copyright (C) 1997-1998 Russell King
 */
#ifndef EESOXSCSI_H
#define EESOXSCSI_H

extern int eesoxscsi_detect (Scsi_Host_Template *);
extern int eesoxscsi_release (struct Scsi_Host *);
extern const char *eesoxscsi_info (struct Scsi_Host *);
extern int eesoxscsi_proc_info (char *buffer, char **start, off_t offset,
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

#define EESOXSCSI {							\
	NULL,								\
	NULL,								\
	NULL,								\
	eesoxscsi_proc_info,						\
	"EESOX SCSI",						\
	eesoxscsi_detect,		/* detect		*/	\
	eesoxscsi_release,		/* release		*/	\
	eesoxscsi_info,			/* info			*/	\
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

struct control {
	unsigned int	io_port;
	unsigned int	control;
};

typedef struct {
	FAS216_Info info;

	struct control control;

	unsigned int	dmaarea;	/* Pseudo DMA area	*/
	dmasg_t		dmasg[NR_SG];	/* Scatter DMA list	*/
} EESOXScsi_Info;

#endif /* HOSTS_C */

#endif /* EESOXSCSI_H */
