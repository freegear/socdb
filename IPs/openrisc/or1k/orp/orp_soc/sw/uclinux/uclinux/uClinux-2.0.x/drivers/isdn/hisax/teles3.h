/* $Id: teles3.h,v 1.1.1.1 2001/09/10 07:44:19 simons Exp $
 *
 * teles3.h   Header for Teles 16.3 PNP & compatible
 *
 * Author	Karsten Keil (keil@temic-ech.spacenet.de)
 *
 *
 * $Log: teles3.h,v $
 * Revision 1.1.1.1  2001/09/10 07:44:19  simons
 * Initial import
 *
 * Revision 1.1.1.1  2001/07/02 17:58:32  simons
 * Initial revision
 *
 * Revision 1.2  1997/01/21 22:27:14  keil
 * cleanups
 *
 * Revision 1.1  1996/10/13 20:03:49  keil
 * Initial revision
 *
 *
*/

extern	void teles3_report(struct IsdnCardState *sp);
extern  void release_io_teles3(struct IsdnCard *card);
extern	int  setup_teles3(struct IsdnCard *card);
extern  int  initteles3(struct IsdnCardState *sp);
