/*
 * Cumana Generic NCR5380 driver defines
 *
 * Copyright 1993, Drew Eckhardt
 *	Visionary Computing
 *	(Unix and Linux consulting and custom programming)
 *	drew@colorado.edu
 *      +1 (303) 440-4894
 *
 * ALPHA RELEASE 1.
 *
 * For more information, please consult
 *
 * NCR 5380 Family
 * SCSI Protocol Controller
 * Databook
 *
 * NCR Microelectronics
 * 1635 Aeroplaza Drive
 * Colorado Springs, CO 80916
 * 1+ (719) 578-3400
 * 1+ (800) 334-5454
 */

/*
 * $Log: oak.h,v $
 * Revision 1.1.1.1  2001/09/10 07:43:54  simons
 * Initial import
 *
 * Revision 1.1.1.1  2001/07/02 17:58:40  simons
 * Initial revision
 *
 * Revision 1.1.1.1  1999/11/15 13:42:32  vadim
 * Initial import
 *
 */

#ifndef OAK_NCR5380_H
#define OAK_NCR5380_H

#define OAKSCSI_PUBLIC_RELEASE 1


#ifndef ASM
int oakscsi_abort(Scsi_Cmnd *);
int oakscsi_detect(Scsi_Host_Template *);
int oakscsi_release(struct Scsi_Host *);
const char *oakscsi_info(struct Scsi_Host *);
int oakscsi_reset(Scsi_Cmnd *, unsigned int);
int oakscsi_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
int oakscsi_proc_info (char *buffer, char **start, off_t off,
		int length, int hostno, int inout);

#ifndef NULL
#define NULL 0
#endif

#ifndef CMD_PER_LUN
#define CMD_PER_LUN 2
#endif

#ifndef CAN_QUEUE
#define CAN_QUEUE 16
#endif

#define OAK_NCR5380 {						\
	NULL,			/* ptr for modules */		\
	NULL,			/* usage count for modules */	\
	NULL,							\
	oakscsi_proc_info,					\
	"Oak 16-bit SCSI",					\
	oakscsi_detect,						\
	oakscsi_release,	/* Release */			\
	oakscsi_info,						\
	NULL,							\
	oakscsi_queue_command,					\
	oakscsi_abort, 						\
	oakscsi_reset,						\
	NULL,							\
	NULL,			/* Biosparam */			\
	CAN_QUEUE,		/* can queue */			\
	7,			/* id */			\
	SG_ALL,			/* sg_tablesize */		\
	CMD_PER_LUN,		/* cmd per lun */		\
	0,			/* number of boards */		\
	0,			/* unchecked isa dma */		\
	DISABLE_CLUSTERING					\
	}

#ifndef HOSTS_C
#define NCR5380_implementation_fields \
	int port, ctrl

#define NCR5380_local_declare() \
        struct Scsi_Host *_instance

#define NCR5380_setup(instance) \
        _instance = instance

#define NCR5380_read(reg)		oakscsi_read(_instance, reg)
#define NCR5380_write(reg, value)	oakscsi_write(_instance, reg, value)
#define NCR5380_intr			oakscsi_intr
#define NCR5380_queue_command		oakscsi_queue_command
#define NCR5380_abort			oakscsi_abort
#define NCR5380_reset			oakscsi_reset
#define NCR5380_proc_info		oakscsi_proc_info

#define BOARD_NORMAL	0
#define BOARD_NCR53C400	1

#endif /* else def HOSTS_C */
#endif /* ndef ASM */
#endif /* OAK_NCR5380_H */

