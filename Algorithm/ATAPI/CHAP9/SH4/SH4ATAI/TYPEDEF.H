/********************************
	typedef 定義
*********************************/

#ifndef _TYPEDEF_
#define _TYPEDEF_

#ifdef IDE1
	/* x86系CPU MS-DOS(16ビット)環境 */
	typedef unsigned long		UDWORD;
	typedef unsigned int		UWORD;
	typedef unsigned char		UBYTE;
#endif
#ifdef IDE2
	/* x86系CPU MS-DOS(16ビット)環境 */
	typedef unsigned long		UDWORD;
	typedef unsigned int		UWORD;
	typedef unsigned char		UBYTE;
#endif
#ifdef PCI
	/* x86系CPU MS-DOS(16ビット)環境 */
	typedef unsigned long		UDWORD;
	typedef unsigned int		UWORD;
	typedef unsigned char		UBYTE;
#endif
#ifdef SH4B
	/* SH-4 ビッグエンディアン */
	#ifndef _KMCLIB_H
	typedef unsigned int		UDWORD;
	typedef unsigned short int	UWORD;
	typedef unsigned char		UBYTE;
	#endif
	typedef volatile unsigned int *		pUDWORD;
	typedef volatile unsigned short *	pUWORD;
	typedef volatile unsigned char *	pUBYTE;
#endif
#ifdef SH4L
	/* SH-4 リトルエンディアン */
	#ifndef _KMCLIB_H
	typedef unsigned int		UDWORD;
	typedef unsigned short int	UWORD;
	typedef unsigned char		UBYTE;
	#endif
	typedef volatile unsigned int *		pUDWORD;
	typedef volatile unsigned short *	pUWORD;
	typedef volatile unsigned char *	pUBYTE;
#endif
#ifdef SH3B
	/* SH-3 ビッグエンディアン */
	typedef unsigned int		UDWORD;
	typedef unsigned short int	UWORD;
	typedef unsigned char		UBYTE;
	typedef volatile unsigned int *		pUDWORD;
	typedef volatile unsigned short *	pUWORD;
	typedef volatile unsigned char *	pUBYTE;
#endif
#ifdef SH3L
	/* SH-3 リトルエンディアン */
	typedef unsigned int		UDWORD;
	typedef unsigned short int	UWORD;
	typedef unsigned char		UBYTE;
	typedef volatile unsigned int *		pUDWORD;
	typedef volatile unsigned short *	pUWORD;
	typedef volatile unsigned char *	pUBYTE;
#endif

#endif
