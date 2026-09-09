/*
 * Cumana Generic NCR5380 driver defines
 *
 * Copyright 1995, Russell King
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
 * $Log: ecoscsi.h,v $
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

#ifndef ECOSCSI_NCR5380_H
#define ECOSCSI_NCR5380_H

#define ECOSCSI_PUBLIC_RELEASE 1


#ifndef ASM
int ecoscsi_abort (Scsi_Cmnd *);
int ecoscsi_detect (Scsi_Host_Template *);
int ecoscsi_release (struct Scsi_Host *);
const char *ecoscsi_info (struct Scsi_Host *);
int ecoscsi_reset(Scsi_Cmnd *, unsigned int);
int ecoscsi_queue_command (Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
int ecoscsi_proc_info (char *buffer, char **start, off_t offset,
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

#define ECOSCSI_NCR5380 {					\
	NULL,							\
	NULL,							\
	NULL,							\
	NULL,							\
	"Serial Port EcoSCSI NCR5380",				\
	ecoscsi_detect,						\
	ecoscsi_release,					\
	ecoscsi_info,						\
	NULL,						 	\
	ecoscsi_queue_command,					\
	ecoscsi_abort, 						\
	ecoscsi_reset,						\
	NULL, 							\
	NULL,							\
	CAN_QUEUE,			/* can queue */		\
	7,				/* id */		\
	SG_ALL,							\
	CMD_PER_LUN,			/* cmd per lun */	\
	0,							\
	0,							\
	DISABLE_CLUSTERING					\
	}

#ifndef HOSTS_C
#define NCR5380_implementation_fields \
    int port, ctrl

#define NCR5380_local_declare() \
        struct Scsi_Host *_instance

#define NCR5380_setup(instance) \
        _instance = instance

#define NCR5380_read(reg) ecoscsi_read(_instance, reg)
#define NCR5380_write(reg, value) ecoscsi_write(_instance, reg, value)

#define NCR5380_intr ecoscsi_intr
#define NCR5380_queue_command ecoscsi_queue_command
#define NCR5380_abort ecoscsi_abort
#define NCR5380_reset ecoscsi_reset
#define NCR5380_proc_info ecoscsi_proc_info

#define BOARD_NORMAL	0
#define BOARD_NCR53C400	1

#endif /* ndef HOSTS_C */
#endif /* ndef ASM */
#endif /* ECOSCSI_NCR5380_H */

