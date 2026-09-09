#ifndef _DMAC_INTERNAL_H
#define _DMAC_INTERNAL_H
// DMASAdr
#define SourceAddr	(0xffffffff)<<0
// DMADAdr
#define DestinationAddr	(0xffffffff)<<0

// DMACCon
#define StartIntEn	(0x01Ul)<<31
#define EndIntEn	(0x01Ul)<<30
#define M2M		(0x01Ul)<<29
#define SrcIncr		(0x01Ul)<<26
#define SrcWidth	(0x03Ul)<<24
#define DstIncr		(0x01Ul)<<22
#define DstWidth	(0x03Ul)<<20
#define Size		(0x07Ul)<<16
#define TransferLength	(0xffffUl)<<0

// DMACDescrp
#define DescrAddr	(0xffffffffUl)<<2
#define DescrEnd	(0x1Ul)<<0

// DMACSta
#define	Enable		(0x1Ul)<<31
#define	Active		(0x1Ul)<<27
#define	StopIntEn	(0x1Ul)<<4
#define	StopInt		(0x1Ul)<<3
#define	StartInt	(0x1Ul)<<2
#define	EndInt		(0x1Ul)<<1
#define	ErrorInt	(0x1Ul)<<0

#endif
