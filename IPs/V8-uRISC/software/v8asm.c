/****************************************************************************
 *
 *	Name: v8asm.c - VAutomation V8 RISC Assembler
 *	Author: Gig Kirk
 *
 *	Operating Environment: MS DOS EXE, Requires 386 or greater
 *	Linkage Requirements:	ANSI C Runtime
 *		Compiles and runs with Microsoft C/C++ 1.52 and Gcc
 *
 *	Description: This EXE loads the language syntax file v8asm.syn
 *				 which describes the assembler operation codes,
 *				 mnemonics, and operands required and then assembles
 *				 a source file passed as a parameter in the invocation.
 *
 *				 For a description of the syntax and operand format
 *				 descriptions, please refer to the format file
 *				 v8asm.syn.
 *
 *	Usage:	v8asm {-dSymbol=Value} {-l} {-pnn} {-s} {-tnn} progfile
 *
 *			where:
 *				-p is an optional page size parm (in lines) which defaults to 22222 if not provided.
 *
 *				-dSymbol=Value pretends first line of file is '.equ Symbol Value'
 *
 *				-l no lint
 *
 *				-s dump symbol usage
 *
 *				-t is an optional tab stop (default 0)
 *
 *				progfile - is the file name to assemble, if the name
 *					does not have a suffix, it is automatically suffixed
 *					with '.asm'.
 *
 *			examples. v8asm myprog - to assemble myprog.asm.
 *					v8asm -p60 myprog.a - to assemble file myprog.a
 *										with 60 lines per listing page.
 *					v8asm - to display program usage.
 *
 *	Inputs: v8asm.syn - syntax file which must be in the same directory
 *						 as the exe file v8asm.exe.
 *			progfile - the assembler source file specified as a parm.
 *
 *	Outputs: progfile.lst - The assembler listing file containing the
 *							source file, locations, and object code.
 *			 progfile.ihx - The object file in Intel Hex format.
 *
 * Copyright 1996-1998 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
 * This software is provided under license and contains proprietary and
 * confidential material which is the property of VAutomation Inc.
 *
 * $Log: v8asm.c,v $
 * Revision 1.33  1999/09/17 21:01:40  russell
 * complain if label name is same as an opcode
 *
 * Revision 1.7	1998/04/05 21:48:10	russell
 * display number of errors.
 * set exit value to non-zero if error.
 * beep if error occurs.
 * add -tnn switch to set tab stop size.
 * fix nested .ifs
 * add comment to .else and .endif showing original .if value.
 * add mov instruction.
 *
 * Revision 1.3	1997/10/07 21:15:06	eric
 * Added NULL escapes for the end of strings.
 *
 * Revision 1.1	1996/12/23	16:41:29	eric
 * Initial revision
 *
 ***************************************************************************/
#define VERSION	 "1.4"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <time.h>

#if defined(WIN32)
void figureOutSynName(char *szSynFile);
#endif

/****************************************************************************
 *	#defines																*
 ***************************************************************************/
#define MAX_PROG_SIZE	65536
#define MAX_ERRORS		5		/* Maximum number of errors which will be
									reported on a single line of code */
#define MAX_LABEL_SIZE	128		/* Maximum size of a label */
#define MAX_LINE_SIZE	512		/* Maximum size of a Line */
#define MAX_STRING_SIZE 256		/* Maximum size of a string lit */
#if MAX_LINE_SIZE < ((MAX_LABEL_SIZE * 2) + 2)
	FORCES COMPILE ERROR-MAX_LINE_SIZE MUST BE GREATER THAN 2 TIMES
	THE MAX LABEL SIZE PLUS 2 BYTES!!
#endif

#define usLoc_PLUS(c)	((unsigned int)((usLoc + c) & 0xffff))

/****************************************************************************
 *	constants																*
 ***************************************************************************/
char hextable[] = "0123456789ABCDEF";
char *ErrorMsgs[] =
	{
#define ERR_INV_MNEMONIC				1
	"Instruction mnemonic expected\n",
#define ERR_OPERAND_EXPECTED			2
	"Operand Expected\n",
#define ERR_2ND_OPERAND_EXPECTED		3
	"2nd Operand Expected\n",
#define ERR_1ST_OPER_NOT_REG			4
	"1st Operand not in format r0-r7\n",
#define ERR_1ST_OPER_NOT_NUM			5
	"1st Operand not in format 0-7\n",
#define ERR_BRANCH_LABEL_GT_8_BITS		6
	"Branch Label exceeds 8-bit offset\n",
#define ERR_INV_8_BIT_HEX_VALUE			7
	"Invalid 8-bit hex value\n",
#define ERR_INV_16_BIT_HEX_VALUE		8
	"Invalid 16-bit hex value\n",
#define ERR_INV_8_BIT_DEC_VALUE			9
	"Invalid 8-bit decimal value\n",
#define ERR_INV_16_BIT_DEC_VALUE		10
	"Invalid 16-bit decimal value\n",
#define ERR_INV_8_BIT_OCT_VALUE			11
	"Invalid 8-bit octal value\n",
#define ERR_INV_16_BIT_OCT_VALUE		12
	"Invalid 16-bit octal value\n",
#define ERR_INV_8_BIT_BIN_VALUE			13
	"Invalid 8-bit binary value\n",
#define ERR_INV_16_BIT_BIN_VALUE		14
	"Invalid 16-bit binary value\n",
#define ERR_INV_CHAR_LITERAL			15
	"Invalid character literal\n",
#define ERR_INV_8_BIT_STRING_LITERAL	16
	"Invalid 8-bit string literal\n",
#define ERR_INV_16_BIT_STRING_LITERAL	17
	"Invalid 16-bit string literal\n",
#define ERR_UNREC_8_BIT_OPER			18
	"Unrecognized 8-bit operand\n",
#define ERR_UNREC_16_BIT_OPER			19
	"Unrecognized 16-bit operand\n",
#define ERR_INV_DIRECTIVE				20
	"Invalid assembler directive\n",
#define ERR_EQU_REQ_2_OPERANDS			21
	".equ directive requires 2 operands\n",
#define ERR_INV_INCLUDE_FILE			22
	"unable to open include file\n",
#define ERR_DUP_LABEL					23
	"duplicate label\n",
#define ERR_INVALID_EXPRESSION			24
	"invalid expression\n",
#define ERR_MEM_LOC_EXCEEDED			25
	"Maximum memory location exceeded\n",
#define ERR_CYCLICAL_EQUATES			26
	"Endless loop in equating operand\n",
#define ERR_EQU_REDEFINED				27
	"Equate value redefined\n",
#define ERR_EQU_IS_LABEL				28
	"Equate value is a label\n",
#define ERR_INV_STRING_LITERAL			29
	"Invalid string literal\n",
#define ERR_UNEXPECTED_OPERAND			30
	"Unexpected operand\n",
#define ERR_MEMORY_OVERLAY				31
	"This location has already been used\n",
#define ERR_UNENDED_IF					32
	".ENDIF expected\n",
#define ERR_LABEL_IS_OPCODE				33
	"label name is the same as an opcode\n",

#define LINT_FIRST						34
#define LINT_STX_R0						34
	"writing low byte of address to self\n",
#define LINT_REG_ODD					35
	"register must be even\n",
#define LINT_CLP_C_ROL_R0				36
	"'add r0' would ignore carry\n",
#define LINT_CMP_R0						37
	"wanna bet it's equal?\n",
#define LINT_AND_OR_R0					38
	"do you really mean r0?\n",
#define LINT_LDA_STA_TOO_SMALL			39
	"address is less than 0x0100\n"
	};

/****************************************************************************
 *  Structures used by this program. Each structure is a linked list		*
 *  which is malloc'ed as needed and linked as a new first element in  		*
 *  the linked list.														*
 ***************************************************************************/
/****************************************************************************
 *  SYNTAX structure - contains the mnemonic, opcode and format				*
 *  information loaded from the file v8asm.syn.								*
 ***************************************************************************/
typedef struct tagSyntax tSYNTAX;
struct tagSyntax
{
unsigned char opcode;
char		  mnemonic[5];
unsigned char format;
unsigned char size;
tSYNTAX *	 pnext;
};
typedef tSYNTAX * pSYNTAX;

/****************************************************************************
 *  LABEL structure - contains LABEL names and their location. These		*
 *  objects are created in Pass 1 of the Assembler.							*
 ***************************************************************************/
typedef struct tagLabel tLABEL;
struct tagLabel
{
char   * pvalue;
unsigned short loc;
unsigned short line;
tLABEL * pnext;
int				iRefs;	// number of times referenced
};
typedef tLABEL * pLABEL;

/****************************************************************************
 *  ORG structure - created to manage the .org directive. This object  		*
 *  keeps track of where code blocks are in memory and how large they  		*
 *  are.																	*
 ***************************************************************************/
typedef struct tagOrg tORG;
struct tagOrg
{
unsigned short loc;
unsigned short line;
unsigned short lth;
unsigned short segment;	/* 0=rom, 1=ram, 2=other */
tORG   * pnext;
};
typedef tORG * pORG;

/****************************************************************************
 *  EQUATE structure - created each time an .equ directive is found 		*
 *  in Pass 1 of the assembler.												*
 ***************************************************************************/
typedef struct tagEquate tEQUATE;
struct tagEquate
{
char	* pvalue1;
char	* pvalue2;
tEQUATE * pnext;
};
typedef tEQUATE * pEQUATE;

/****************************************************************************
 *  FILE structure - keeps track of .include directives.					*
 ***************************************************************************/

typedef struct
	{
	FILE	*pfile;
	char	name[256];
	int		lines;
	} INPUTFILE;

#define MAX_FILES	64
INPUTFILE	inputfiles[MAX_FILES];
int			inputfile = -1;	/* current file opened */

/****************************************************************************
 *  Local function prototypes												*
 ***************************************************************************/

int fnAssembleFile(void);

int fnReadLine(FILE * fpFile, char * szLine);
int fnReadSource(char *szLine);

int fnGetLineToken(unsigned char * szLine, int * nStart,
				int * lpnPos, int nMinLth, int nMaxLth,
				unsigned char * szToken);

int fnOverlayCheck(unsigned short usLoc, unsigned short usLth);

void fnAddError(int nError);

int fnWriteErrors(void);

int fnWriteHeader(void);

int fnIHex(unsigned char * szToken, int nOutBytes, unsigned short * usResult);

void fnOHex(unsigned short usVal, int nBytes, char * szHexOut);

int fnExtractExpression(char * szToken);

void fnEvaluateExpression(unsigned short * pusValue,
					  unsigned char *  pchOper,
					  char * szExpression);

unsigned short fnProcessExpression(unsigned short usValue1,
					 unsigned char  chOper,
					 unsigned short usValue2);

int fnProcessOperand(unsigned char * szToken, unsigned short usLoc,
				  unsigned short usSize,
				  unsigned char uchFmt, 
				  int nOperand,
				  int nReverseWord);

int fnEquateToken(unsigned char * szToken);

pLABEL fnOperandIsLabel(unsigned char * szToken);

int fnOperandIsHex(unsigned char * szToken, int nSize, unsigned short * pusVal);

int fnOperandIsDec(unsigned char * szToken, int nSize, unsigned short * pusVal);

int fnOperandIsOct(unsigned char * szToken, int nSize, unsigned short * pusVal);

int fnOperandIsBin(unsigned char * szToken, int nSize, unsigned short * pusVal);

int fnOperandIsChr(unsigned char * szToken, int nSize, unsigned short * pusVal);

int fnOperandIsStr(unsigned char * szToken, int nSize, unsigned short * pusVal);

int fnOperandIsHexDecOctBinChrStr(unsigned char * szToken, int nSize, unsigned short * pusVal);

int fnConvertString(unsigned char * szToken, unsigned char * szReturnString);

int fnReadSyntax(void);

int fnWriteHexFile(FILE * fpHex);

int fnCleanup();

int fnInitialize(int argc, char **argv);

int allocateOriginIfNeeded(unsigned short usLoc, unsigned short usLine);
int datePass1(unsigned char *szToken, unsigned char *szString, 
			  unsigned short *pusLoc, unsigned short *pusLine, unsigned short usSize);
int datePass2(unsigned char *szToken, unsigned char *szString, 
			  unsigned short usSize, unsigned short *pusLoc, unsigned short *pusSize, unsigned char *pDateTime);

int directive1(char *szLine, char *szToken, int *pnStart, int *pnPos, unsigned short *pusLine, unsigned short *pusLoc, unsigned short *pusSize);
int directive2(char *szLine, char *szToken, int *pnStart, int *pnPos, unsigned short *pusLine, unsigned short *pusLoc, unsigned short *pusSize);
int iffy(char *szLine, char *szToken, int *pnStart, int *pnPos, unsigned short *pusLine, unsigned short *pusLoc, unsigned short *pusSize);

unsigned short org(char *szLine, char *szToken, int *pnStart, int *pnPos, unsigned short *pusLine, unsigned short *pusLoc, unsigned short *pusSize);

void tabbedOutput(char *szLst);

int smoothMov(char *szLine);
char *stepOverLabel(char *szLine);
int fnReadNextLine(char *szLine, int iMax, FILE *pfile);

typedef struct _macro
	{
	struct _macro *pNext;
	char		*name;
	char		*arg[9];
	int			args;
	char		*line[64];
	int			lines;
	int			currentLine;
	int			instance;		// for local scope labels
	} MACRO, *PMACRO;

PMACRO	pMacroList = NULL;		// linked list of macros
PMACRO	pCurrentMacro = NULL;

unsigned short stamp = 0xdead;

int macro(char *szLine);
int macroBody(void);
PMACRO findMacro(char *name);
void reinitMacro(void);
int strcmpi(const char *s1, const char *s2);
int strcmpni(const char *s1, const char *s2, int n);


/****************************************************************************
 *   Globals																*
 ***************************************************************************/
pSYNTAX			pFirstSyn;				/* First SYNTAX object */
pORG			pFirstOrg;				/* First ORG object */
unsigned short org1=0, org2=0;			/* number of orgs in each pass */
pLABEL			pFirstLbl;				/* First LABEL object */
pEQUATE			pFirstEqu;				/* First EQUATE object */
unsigned char * pObjCode;				/* 65500 bytes mem for obj code */
unsigned char * pObjUsed;				/* 65500 bytes mem for obj used */
int				nErrors[MAX_ERRORS];	/* Error stack for each line */
int				bErrors = 0;
int				bWarnings = 0;
int				nErrorCnt = 0;
int				nWarningCnt = 0;
int				nPage;					/* Listing page variables */
int				nPageSize, nPagePos;	/* Listing page variables */
int				nTabStops = 0;			/* tab size if not 0 */
FILE *			fpSyn;					/* .syn source file pointer */
FILE *			fpLst;					/* .lst output file pointer */
char			szAsmFile[ 128 ];		/* .asm file name */
char			szSynFile[ 128 ];		/* .syn file name */
char			szLstFile[ 128 ];		/* .lst file name */
char			szHexFile[ 128 ];		/* .ihx file name */
char			szDateTime[16];
int				pass = 1;
int				bLint = 1;
int				bSymbols = 0;

#define IF_LIMIT	64
typedef struct
	{
	int		value;
	char	string[MAX_LINE_SIZE];
	} IFS;

IFS ifs[IF_LIMIT] = {0};
int	ifCount = 0;

int bInMacro = 0;

int bList = 1;		/* set/cleared by .list/.nolist */

/***************************************************************************
 *  main - program entry point											*
 ***************************************************************************/

main(int argc, char **argv)
{
int   nWk;
int		iRetVal;

	/* pop out our banner and version */
	printf("VAutomation RISC Assembler\n");
	printf("Version %s, %s\n", VERSION, __DATE__);
	printf("Copyright 1996-1998 VAutomation Inc. Nashua NH USA.\n");

	/* Do initialization */
	if ((nWk = fnInitialize(argc, argv)) != 0)
		return nWk;

	/* Open the v8asm.syn file */
	if ((fpSyn=fopen(szSynFile, "r")) == NULL)
		if ((fpSyn=fopen("v8asm.syn", "r")) == NULL)
			{
			printf("\nUnable to open syntax file %s\n", szSynFile);
			fprintf(stderr, "\a");
			return 8;
			}

	/* Read in the syntax file */
	if (fnReadSyntax())
		{
		fnCleanup();
		fclose (fpSyn);
		return 8;
		}
	fclose (fpSyn);

	if ((inputfiles[0].pfile=fopen(szAsmFile, "r")) == NULL)
		{
		fnCleanup();
		printf("\nUnable to open asm file %s\n", szAsmFile);
		fprintf(stderr, "\a");
		return 8;
		}
	inputfile = 0;
	strcpy(inputfiles[inputfile].name, szAsmFile);
	inputfiles[inputfile].lines = 0;

	if ((fpLst=fopen(szLstFile, "w")) == NULL)
		{
		fclose (inputfiles[0].pfile);
		fnCleanup();
		printf("\nUnable to open listing file %s\n", szLstFile);
		fprintf(stderr, "\a");
		return 8;
		}
	/* Assemble the .asm file */
	iRetVal = fnAssembleFile();
	fclose (inputfiles[0].pfile);

	if (bSymbols && !iRetVal)
		{
		pLABEL pLbl;

		tabbedOutput("\n");
		tabbedOutput("- Occurances Label\n");
		for (pLbl = pFirstLbl; pLbl; pLbl = pLbl->pnext)
			{
			char	buff[1024];
			sprintf(buff, "-  %9i %04x %s\n", pLbl->iRefs, pLbl->loc, pLbl->pvalue);
			tabbedOutput(buff);
			}
		}
	
	fclose (fpLst);
	fnCleanup();
	return iRetVal;

}


/***************************************************************************
 *  Function:    fnAssembleFile                                        	*
 *                                                                     	*
 *  Description: This is the main function in the program. It makes two	*
 *               passes of the .asm file. The first pass resolves the  	*
 *               locations and size of all instructions and assembler  	*
 *               directives. In this pass, all errors are ignored.     	*
 *                                                                     	*
 *               The second pass builds the memory map of the program, 	*
 *               produces a listing of the program and its object      	*
 *               code, and checks for errors.                          	*
 *                                                                     	*
 *               If the program assembles without errors, the ORG      	*
 *               objects are passed to produce the Intel hex file      	*
 *               of the program. ORG objects keep track of the locations   *
 *               and length of where object code was generated during the  *
 *               assembly process.                                     	*
 ***************************************************************************/

#define NULL_TOKEN	(!szToken[0] || szToken[0] == ';')

int
fnAssembleFile(void)
{
unsigned char szLine[ MAX_LINE_SIZE ];
unsigned char szLst[ MAX_LINE_SIZE * 2 ];
unsigned char szToken[ MAX_LINE_SIZE ];
int nStart, nPos, nLabel, nDirective, nRead, nToken;
unsigned short  usLine;
unsigned short  usLoc;
unsigned short  usSize;
FILE  *fpHex;
time_t timer;
struct tm * ptm;
int		iRetCode;

	/* Get the current time for any of the date/time directives */
	time(&timer);
	ptm = localtime(&timer);
	/* Now get the ascii form of the date time in a string as */
	/* 'yyyymmddhhmmss'                                   	*/
	sprintf(szDateTime, "%04d%02d%02d%02d%02d%02d",
			(int) ptm->tm_year + 1900,
			(int) ptm->tm_mon+1,
			(int) ptm->tm_mday,
			(int) ptm->tm_hour,
			(int) ptm->tm_min,
			(int) ptm->tm_sec);

	stamp = ((ptm->tm_year - 90) << 9) | 
			((ptm->tm_mon + 1) << 5) |
			((ptm->tm_mday));

	/*
	* Assembly Pass 1, Resolve branch labels and their location,
	* and .equ, .org, .byte, .word, and .rword directives.
	*/
	usLine = 0;
	usLoc = 0;

	bList = 1;
	for (; ;)
		{
		nRead = fnReadSource(szLine);
		if (!nRead)
			break;
		usLine++;
		nStart = 0;
		nToken = 0;

		for (; ;)
			{
			fnGetLineToken(szLine, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, szToken);
			nToken++;

			/* go to the next line if no token found or the token is a comment */
			if (NULL_TOKEN)
				break;

			 /* branch Label */
			if (szToken[ strlen(szToken) - 1 ] == ':')
				{
				if (!ifCount || ifs[ifCount].value)
					{
					/* Clear the ':' at the end of the label */
					szToken[ strlen(szToken) - 1 ] = '\0';
					szToken[ MAX_LABEL_SIZE ] = '\0'; /* trunc if too long */
					if (nToken == 1)
						{
						pLABEL pLbl;

						if (!allocateOriginIfNeeded(usLoc, usLine))
							return 8;

						pLbl = (pLABEL)malloc(sizeof(tLABEL));
						if (!pLbl)
							{
							printf ("\nmalloc failed for label object\n");
							return 8;
							}
						pLbl->pvalue = malloc(strlen(szToken) + 1);
						if (!pLbl->pvalue)
							{
							printf ("\nmalloc failed for label object\n");
							return 8;
							}
						strcpy(pLbl->pvalue, szToken);
						pLbl->loc = usLoc;
						pLbl->line = usLine;
						pLbl->pnext = pFirstLbl;
						pLbl->iRefs = 0;
						pFirstLbl = pLbl;
						fnGetLineToken(szLine, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, szToken);
						if (NULL_TOKEN)
							break;
						}
					}
				}
			if (szToken[ 0 ] == '.')	/* Assembler directive */
				{
				iRetCode = directive1(szLine, szToken, &nStart, &nPos, &usLine, &usLoc, &usSize);
				if (iRetCode)
					return iRetCode;
				break;
				}
			 else if (!ifCount || ifs[ifCount].value)
				{
				pSYNTAX pSyn;
				/*
				 * Here we expect an instruction mneumonic.
				 */
				pSyn = pFirstSyn;
				while (pSyn)
					{
					if (strcmpi(szToken, pSyn->mnemonic) == 0)
						break;
					pSyn = pSyn->pnext;
					}
				/*
				 * update the location counter based on the format
				 * of the instruction.
				 */
				if (pSyn)
					{
					unsigned char uchWk;

					if (!allocateOriginIfNeeded(usLoc, usLine))
						return 8;

					uchWk = pSyn->format;
					uchWk /= 10;
					switch (uchWk)
						{
						case 3:    /*  8 bit operand, add 1 */
						case 4:
							usLoc++;
							pFirstOrg->lth++;
							break;
						case 5:    /* 16 bit operand, add 2 */
							usLoc += 2;
							pFirstOrg->lth += 2;
							break;
						}
					uchWk = pSyn->format;
					uchWk %= 10;
					switch (uchWk)
						{
						case 3:    /*  8 bit operand, add 1 */
						case 4:
							usLoc++;
							pFirstOrg->lth++;
							break;
					   case 5:    /* 16 bit operand, add 2 */
							usLoc += 2;
							pFirstOrg->lth += 2;
							break;
						}
				   /*
					* Add 1 for the opcode itself
					*/
					usLoc++;
					pFirstOrg->lth++;
					}
				}
			}
		}

	if (ifCount)
		ifCount = 0;

   /*******************************************************************
	* Assembly Pass 2                                             	*
	*******************************************************************/
	pass = 2;
	reinitMacro();
	fseek(inputfiles[0].pfile, 0, 0);	/* reset file pointer in main file */
	inputfiles[0].lines = 0;				/* reset line count in main file */
   /*
	* Assembly Pass 2, Produce the object code
	*/
	usLine = 0;
	usLoc = 0;
	bList = 1;
	nErrorCnt = 0;
	nWarningCnt = 0;
	nPage = 0;
	nPagePos = nPageSize + 1;
	ifCount = 0;

	for (; ;)
		{
		int i;
		memset(szToken, '\0', sizeof(szToken));
		nRead = fnReadSource(szLine);
		if (!nRead) 
			break;
		usLine++;
		nStart = 0;
		usSize = 0;
		nLabel = 0;
		nDirective = 0;
		nToken = 0;
		for (i = 0 ; i < MAX_ERRORS ; i++)
			nErrors[i] = 0;
		bErrors = bWarnings = 0;

		for (; ;)
			{
			fnGetLineToken(szLine, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, szToken);
			nToken++;
		 /*
		  * go to the next line if no token found or
		  * the token is a comment
		  */
			if (NULL_TOKEN || szToken[MAX_LABEL_SIZE + 1] == ';')
				break;

		 /*
		 * branch Label
		 */
			if (szToken[ strlen(szToken) - 1 ] == ':')
				{
				pSYNTAX pSyn;

				// Clear the ':' at the end of the label
				szToken[ strlen(szToken) - 1 ] = '\0';

				// see if label is also a mnemonic
				pSyn = pFirstSyn;
				while (pSyn)
					{
					if (strcmpi(szToken, pSyn->mnemonic) == 0)
						{
						fnAddError(ERR_LABEL_IS_OPCODE);
						break;
						}
					pSyn = pSyn->pnext;
					}

				if (!ifCount || ifs[ifCount].value)
					{
					pLABEL pLbl;
				

					if (nToken == 1)
						{
						nLabel = 1;

				   /*
				   * Make sure this label is not a duplicate
				   */
						pLbl = pFirstLbl;
						while (pLbl)
							{
							if (strcmpi(szToken, pLbl->pvalue) == 0 && usLine != pLbl->line)
								{
								fnAddError(ERR_DUP_LABEL);
								break;
								}
							pLbl = pLbl->pnext;
							}
						fnGetLineToken(szLine, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, szToken);
						if (NULL_TOKEN)  
							break;
						}
					}
				}

		 /*
		 * Assembler directives
		 */
			if (szToken[ 0 ] == '.')
				{
				nDirective = 1;
				iRetCode = directive2(szLine, szToken, &nStart, &nPos, &usLine, &usLoc, &usSize);
				if (iRetCode)
					return iRetCode;

				/* force going to next line */
				break;
				}
			else if (!ifCount || ifs[ifCount].value)
				{
				pSYNTAX pSyn;
				/* Here we expect an instruction mneumonic. */
				pSyn = pFirstSyn;
				while (pSyn)
					{
					if (strcmpi(szToken, pSyn->mnemonic) == 0)
						break;
					pSyn = pSyn->pnext;
					}

				/* pSyn is set if the instruction was found */
				if (pSyn && (usLoc + pSyn->size) > MAX_PROG_SIZE)
					{
					fnAddError(ERR_MEM_LOC_EXCEEDED);
					/* force going to next line */
					break;
					}
				else if (pSyn)
					{
					unsigned char uchWk;

			   /*
				* Check that instruction is not overlaying
				* previously generated object code.
				*/
					fnOverlayCheck(usLoc, (unsigned short) pSyn->size);
			   /*
				* put the operation code in the memory map
				*/
					pObjCode[ usLoc ] = pSyn->opcode;
					pObjUsed[ usLoc ] = 0xff;

			  /*
			   * determine the size of the operation code based
			   * on its operand(s).
			   */
					usSize = 1;
					uchWk = pSyn->format;
					uchWk /= 10;
					switch (uchWk)
						{
						case 3:    /*  8 bit operand, add 1 */
						case 4:
							usSize++;
							break;
						case 5:    /* 16 bit operand, add 2 */
							usSize += 2;
							break;
						}
					uchWk = pSyn->format;
					uchWk %= 10;
					switch (uchWk)
						{
						case 3:    /*  8 bit operand, add 1 */
						case 4:
							usSize++;
							break;
						case 5:    /* 16 bit operand, add 2 */
							usSize += 2;
							break;
						}

			   /* Process the instruction Operands */
					uchWk = pSyn->format;
					uchWk /= 10;
					if (uchWk)
						{
						fnGetLineToken(szLine, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, szToken);
						if (NULL_TOKEN)
							{
							/* Operand expected error */
							fnAddError(ERR_OPERAND_EXPECTED);
							}
						else
							{
							if (fnExtractExpression(szToken) == 0 && !(pSyn->format % 10))
								{
								fnGetLineToken(szLine, &nStart, &nPos,	1, MAX_LINE_SIZE - 1, 
									szToken + MAX_LABEL_SIZE + 1);
								}
							fnProcessOperand(szToken, usLoc, usSize, uchWk, 1, 1);
							}
						}

					uchWk = pSyn->format;
					uchWk %= 10;
					if (uchWk)
						{
						fnGetLineToken(szLine, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, szToken);
						if (NULL_TOKEN)
							{
							fnAddError(ERR_2ND_OPERAND_EXPECTED);
							}
						else
							{
							if (fnExtractExpression(szToken) == 0)
								{
								fnGetLineToken(szLine, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, 
									szToken + MAX_LABEL_SIZE + 1);
								}
							fnProcessOperand(szToken, usLoc, usSize, uchWk, 2, 1);
							}
						}

					if (bLint)
						{
						if ((pObjCode[ usLoc ] & 0xd8) == 0xc8)	// lda/sta
							{
							if (!pObjCode[ usLoc+2 ])			// lda rn,0x00nn ; too small
								{
								fnAddError(LINT_LDA_STA_TOO_SMALL);
								}
							}

						if (pObjCode[ usLoc ] == 0xd0)	// stx r0
							{
							fnAddError(LINT_STX_R0);
							}
						
						if ((pObjCode[ usLoc ] & 0xd1) == 0xd1)	// ldx/stx r1/3/5/7
							{
							fnAddError(LINT_REG_ODD);
							}

#if 0	// too picky
						if (pObjCode[ usLoc ] == 0x30)	// rol r0
							{
							if (pObjCode[ usLoc-1 ] == 0x69)	// clp PSR_C
								{
								fnAddError(LINT_CLP_C_ROL_R0);
								}
							}
#endif

						if ((pObjCode[ usLoc ] & 0xf9) == 0xc1)	// upp r1/3/5/7
							{
							fnAddError(LINT_REG_ODD);
							}

						if (pObjCode[ usLoc ] == 0x78)	// cmp r0
							{
							fnAddError(LINT_CMP_R0);
							}

						if (pObjCode[ usLoc ] == 0x18 || pObjCode[ usLoc ] == 0x20)	// or/and r0
							{
							fnAddError(LINT_AND_OR_R0);
							}
						}
					

					/* update the location counter based on the format of the instruction. */
					usLoc += usSize;

					}
				else
					{
					fnAddError(ERR_INV_MNEMONIC);
					/* force going to next line */
					break;
					}
				}
			}

	  /*
	   * Now write out the source line to the listing
	   * file.
	   */
		sprintf(szLst, "                %6d", 
			inputfiles[inputfile].lines==0 && inputfile ? inputfiles[inputfile-1].lines : inputfiles[inputfile].lines);
		if (usSize || nLabel)
			{
			/* Put out the location in hex */
			fnOHex((unsigned short)(usLoc - usSize), 4, szLst + 1);
#if 0
			if (nErrors[0] == 0)
#else
			if (!bErrors)
#endif
				{
				if (nDirective)
					{
					if (usLoc <= MAX_PROG_SIZE)
						{
						if (usSize )
							{
							fnOHex((unsigned short)pObjCode[(usLoc - usSize)], 2, szLst + 9);
							}
						if (usSize > 1)
							{
							fnOHex((unsigned short)pObjCode[(usLoc - usSize) + 1], 2, szLst + 11);
							}
						if (usSize > 2)
							{
							fnOHex((unsigned short)pObjCode[(usLoc - usSize) + 2], 2, szLst + 13);
							}
						if (usSize > 3)
							{
							fnOHex((unsigned short)pObjCode[(usLoc - usSize) + 3], 2, szLst + 15);
							}
						}
					}
				else if (usSize)
					{
					if (usLoc <= MAX_PROG_SIZE)
						{
						fnOHex((unsigned short)pObjCode[usLoc - usSize], 2, szLst + 9);
						if (usSize == 2)
							{
							fnOHex((unsigned short) pObjCode[usLoc - 1], 2, szLst + 12);
							}
						else if (usSize > 2)
							{
							fnOHex((unsigned short)pObjCode[(usLoc - usSize) + 1], 2, szLst + 12);
							fnOHex((unsigned short)pObjCode[(usLoc - usSize) + 2], 2, szLst + 14);
							}
						}
					}
				}
			}

		if (ifCount)
			{
			if (ifs[ifCount].value)
				strcat(szLst, "+");
			else
				strcat(szLst, "-");
			}
		else
			{
			if (!nTabStops)
				strcat(szLst, " ");
			}

		if (nTabStops)
			strcat(szLst, "\t");
		else
			strcat(szLst, " ");
		strcat(szLst, szLine);
		strcat(szLst, "\n");
		tabbedOutput(szLst); //fwrite(szLst, strlen(szLst), 1, fpLst);
		if (bErrors || bWarnings)
			fputs(szLst, stdout);
		nErrorCnt += fnWriteErrors();
		}

	if (ifCount)
		{
		fnAddError(ERR_UNENDED_IF);
		nErrorCnt += fnWriteErrors();
		}
		
	if (nErrorCnt)
		{
		printf("\n Assembly ended with %u errors and %u warnings\n", nErrorCnt, nWarningCnt);

		fprintf(stderr, "\a");
		return 1;
		}
	else
		{
		if (nWarningCnt)
			{
			printf("\n Assembly ended with %u warnings\n", nWarningCnt);
			fprintf(stderr, "\a");
			}

		if ((fpHex=fopen(szHexFile, "w")) == NULL)
			{
			printf("\nUnable to open hex file %s\n", szHexFile);
			fprintf(stderr, "\a");
			return 8;
			}
		fnWriteHexFile(fpHex);
		printf("\nAssembly successful @%s\n", szDateTime);
		}

	return 0;
}

char	*pOperators = "+-*/><=";


/***************************************************************************
 *  Function:    fnExtractExpression                                   	*
 *                                                                     	*
 *  Description: This function extracts an arithmetic expression from  	*
 *               an operand token and places it at offset              	*
 *               MAX_LABEL_SIZE + 1 from the beginning of the token    	*
 *               For example, if an operand is coded as                	*
 *               'label1+4' the '+4' will be separated from the token  	*
 *               and placed at MAX_LABEL_SIZE + 1 off the token for later  *
 *               evaluation after 'label1' is resolved.                	*
 *                                                                     	*
 *               Expressions are determined by the existence of one    	*
 *               of the following characters in a position other than  	*
 *               the first position of the token. Arithmetic operands  	*
 *               are '+','-','*','/','>','<'. The shift operands '>' and   *
 *               '>' must be doubled up (ex. >>8, <<2)                	*
 *                                                                     	*
 ***************************************************************************/
int
fnExtractExpression(char * szToken)
{
int i;
int j;
int nEscape;
char chQuote;
char szWk[ MAX_LABEL_SIZE + 4 ];  /* +4 For safety's sake */

	j = strlen(szToken);
	nEscape = 0;
	chQuote = '\0';
	for (i = 0; szToken[i] ; i++)
		{
		if (nEscape)
			nEscape = 0;
		else if (chQuote)
			{
			if (szToken[i] == '\\')
				nEscape = 1;
			else if (szToken[i] == chQuote)
				chQuote = '\0';
			}
		else if (szToken[i] == '\"' || szToken[i] == '\'')
			chQuote = szToken[i];
		else if (i > 0 && strchr(pOperators, szToken[i]))
			{
			if (j - i > (MAX_LABEL_SIZE + 1))
				szToken[ i + MAX_LABEL_SIZE + 1 ] = '\0';
			strcpy(szWk, &szToken[i]);
			szToken[i] = '\0';                 /* Truncate at operand */
			szToken[ MAX_LABEL_SIZE ] = '\0';  /* For safety's sake   */
			strcpy(&szToken[MAX_LABEL_SIZE + 1], szWk);
			return 1;
			}
		}
	szToken[ MAX_LABEL_SIZE ] = '\0';
	return 0;
}


/****************************************************************************
 *  Function:    fnEvaluateExpression                                  		*
 *                                                                     		*
 *  Description: This function takes an arithmetic expression, determines	*
 *               its type and evaluates its value as a 16 bit operand. 		*
 *                                                                     		*
 *               Types are:   1 - addition '+'                         		*
 *                            2 - subtraction '-'                      		*
 *                            3 - multiplication '*'                   		*
 *                            4 - division '/'                         		*
 *                            5 - shift right '>>'                     		*
 *                            6 - shift left '<<'                      		*
 *							  7 - compare '='								*
 *							  8 - greater than								*
 *							  9 - less than									*
 *                                                                     		*
 *               The value is determined exactly as any other 16       		*
 *               bit value is. That is, it can be a label, decimal,    		*
 *               hex, binary, octal, character, or 2 byte string.      		*
 *                                                                     		*
 ***************************************************************************/
void
fnEvaluateExpression(unsigned short * pusValue,
					  unsigned char *  pchOper,
					  char * szExpression)
{
	int i;
	pLABEL pLbl;
	char	*p;

   *pchOper = 0;
   *pusValue = 0;
   i = 1;
   p = strchr(pOperators, szExpression[0]);

	if (!p)
		fnAddError(ERR_INVALID_EXPRESSION);
	else
	   {
		*pchOper = p - pOperators + 1;

		if (*pchOper == 5 || *pchOper == 6)			// less than or greater than sign
			{
			if (szExpression[0] != szExpression[1])	// if not doubled
				{
#if 0
				fnAddError(ERR_INVALID_EXPRESSION);
#else
				*pchOper += 3;						// it's not a shift, it's a compare
#endif
				}
			else
				i = 2;								// it's a shift, skip 2 chars
			}
		else
			i = 1;
		}

   /*
	* Validate expression as 16 bit format Operand
	*/
   fnEquateToken(&szExpression[i]);
   if (pLbl = fnOperandIsLabel(&szExpression[i]))
   {
	  *pusValue = pLbl->loc;
   }
   else if (fnOperandIsHexDecOctBinChrStr(&szExpression[i], 2, pusValue))
   {
	  ;
   }
   else
   {
	  *pchOper = 0;
	  fnAddError(ERR_INVALID_EXPRESSION);
   }
}


/***************************************************************************
 *  Function:    fnProcessExpression                                   	*
 *                                                                     	*
 *  Description: This function takes an evaluated arithmetic expression	*
 *               and applies it to the evaluated operand passed in     	*
 *               usValue1.                                             	*
 *                                                                     	*
 ***************************************************************************/
unsigned short
fnProcessExpression(unsigned short usValue1,
					 unsigned char  chOper,
					 unsigned short usValue2)
{
   switch (chOper)
   {
	  case 1:
		 usValue1 += usValue2;
		 break;
	  case 2:
		 usValue1 -= usValue2;
		 break;
	  case 3:
		 usValue1 *= usValue2;
		 break;
	  case 4:
		 if (usValue2)
			usValue1 /= usValue2;
		 break;
	  case 5:
		 usValue1 >>= usValue2;
		 break;
	  case 6:
		 usValue1 <<= usValue2;
		 break;
	  case 7:
		  usValue1 = usValue1 == usValue2;
		 break;
	  case 8:
		  usValue1 = usValue1 > usValue2;
		 break;
	  case 9:
		  usValue1 = usValue1 < usValue2;
		 break;
   }
   return usValue1;
}

/***************************************************************************
 *  Function:    fnProcessOperand                                      	*
 *                                                                     	*
 *  Description: This function takes in an operand and the expected    	*
 *               operand type, determines its value, and sets the      	*
 *               value in the memory image of the object code.         	*
 *                                                                     	*
 ***************************************************************************/

int
fnProcessOperand(unsigned char * szToken, unsigned short usLoc,
				  unsigned short usSize,
				  unsigned char uchFmt, 
				  int nOperand,
				  int nReverseWord)
{
unsigned short usWk;
unsigned short usWk2;
unsigned char  uchOper = 0;	//rf - is not set always

   /*
	* if there is an arithmetic expression, evaluate its value
	* and get the operand for the expression
	*/
   usWk2 = 0;
   if (szToken[MAX_LABEL_SIZE + 1] && szToken[MAX_LABEL_SIZE + 1] != ';')
   {
	  fnEvaluateExpression(&usWk2, &uchOper, 
							&szToken[MAX_LABEL_SIZE + 1]);
   }
   fnEquateToken(szToken);
   if (uchFmt < 3)
   {
	  unsigned char uchWk;
	  if (uchFmt == 1 && (strlen(szToken) != 2 ||
		   (szToken[0] != 'r' && szToken[0] != 'R') ||
		   szToken[1] < '0' || szToken[1] > '7'))
	  {
		 fnAddError(ERR_1ST_OPER_NOT_REG);
		 return 0;
	  }
	  if (uchFmt == 2 && (strlen(szToken) != 1 ||
		   szToken[0] < '0' || szToken[0] > '7'))
	  {
		 fnAddError(ERR_1ST_OPER_NOT_NUM);
		 return 0;
	  }
	  if (uchFmt == 1)
		 uchWk = (szToken[1] - '0');
	  else
		 uchWk = (szToken[0] - '0');
	  uchWk = (unsigned char)
		 fnProcessExpression((unsigned short) uchWk,
							  uchOper, usWk2);
	  pObjCode[ usLoc ] += uchWk;
	  pObjUsed[ usLoc ] = 0xff;
   }
   else if (uchFmt < 5)
   {
	  pLABEL pLbl;
	  short  sWk;
	  /*
	   * Validate 8 bit format Operand
	   */
	  if (pLbl = fnOperandIsLabel(szToken))
	  {
		 if (uchFmt == 3)
		 {
			sWk = (short) pLbl->loc;
			sWk -= usLoc_PLUS(usSize);
			if (sWk > 127 || sWk < -128)
			   fnAddError(ERR_BRANCH_LABEL_GT_8_BITS);
			else
			   usWk = (unsigned short) sWk;
		 }
		 else
			usWk = pLbl->loc;
	  }
	  else if (fnOperandIsHexDecOctBinChrStr(szToken, 1, &usWk))
	  {
		 ;
	  }
	  else
	  {
		 fnAddError(ERR_UNREC_8_BIT_OPER);
	  }
	  usWk = fnProcessExpression(usWk, uchOper, usWk2);
	  pObjCode[ usLoc_PLUS(1) ] = (unsigned char) usWk;
	  pObjUsed[ usLoc_PLUS(1) ] = 0xff;
   }
   else
   {
	  pLABEL pLbl;
	  unsigned short usWk;
	  /*
	   * Validate 16 bit format Operand
	   */
	  usWk = 0;
	  if (pLbl = fnOperandIsLabel(szToken))
	  {
		 usWk = pLbl->loc;
	  }
	  else if (fnOperandIsHexDecOctBinChrStr(szToken, 2, &usWk))
	  {
		 ;
	  }
	  else
	  {
		 fnAddError(ERR_UNREC_16_BIT_OPER);
	  }
	  /*
	   * now process the expression on the reversed address
	   */
	  usWk = fnProcessExpression(usWk, uchOper, usWk2);

	  if (nReverseWord == 1)
	  {
		 pObjCode[ usLoc_PLUS(1) ] = (unsigned char) usWk;
		 pObjUsed[ usLoc_PLUS(1) ] = 0xff;
		 usWk >>= 8;
		 pObjCode[ usLoc_PLUS(2) ] = (unsigned char) usWk;
		 pObjUsed[ usLoc_PLUS(2) ] = 0xff;
	  }
	  else
	  {
		 pObjCode[ usLoc_PLUS(2) ] = (unsigned char) usWk;
		 pObjUsed[ usLoc_PLUS(2) ] = 0xff;
		 usWk >>= 8;
		 pObjCode[ usLoc_PLUS(1) ] = (unsigned char) usWk;
		 pObjUsed[ usLoc_PLUS(1) ] = 0xff;
	  }
   }
   return 0;
}

/***************************************************************************
 *  Function:    fnEquateToken                                         	*
 *                                                                     	*
 *  Description: This function takes a token and re-equates the value  	*
 *               based on the .equ directives until the value received 	*
 *               is not a source value in the equate table.            	*
 *                                                                     	*
 ***************************************************************************/

int
fnEquateToken(unsigned char * szToken)
{
pEQUATE pEqu;
int nEquates;
int nPasses;

   nPasses = 0;
   nEquates = 0;
   while (nPasses < 100)
   {
	  pEqu = pFirstEqu;
	  while (pEqu)
	  {
		 if (strcmpi(pEqu->pvalue1, szToken) == 0)
		 {
			strcpy(szToken, pEqu->pvalue2);
			nEquates++;
			break;
		 }
		 pEqu = pEqu->pnext;
	  }
	  nPasses++;
	  if (nEquates < nPasses)
		 break;
   }
   if (nEquates == nPasses)
	  fnAddError(ERR_CYCLICAL_EQUATES);
   return nEquates;
}


/***************************************************************************
 *  Function:    fnOperandIsLabel                                      	*
 *                                                                     	*
 *  Description: This function takes in a token and looks it up        	*
 *               to see if the token is a label. If so, it returns     	*
 *               the pointer to the label structure associated with    	*
 *               the token. Otherwise, it returns 0.                   	*
 *                                                                     	*
 ***************************************************************************/

pLABEL
fnOperandIsLabel(unsigned char * szToken)
{
pLABEL pLbl;


	if (szToken[ strlen(szToken) - 1 ] == ':')
		{
		/* Clear the ':' at the end of the label */
		szToken[ strlen(szToken) - 1 ] = '\0';
		}
	pLbl = pFirstLbl;
	while (pLbl)
		{
		if (strcmpi(pLbl->pvalue, szToken) == 0)
			{
			pLbl->iRefs++;
			return pLbl;
			}
		pLbl = pLbl->pnext;
		}
   return 0;
}

int fnOperandIsHexDecOctBinChrStr(unsigned char * szToken, int nSize, unsigned short * pusVal)
{

	return	fnOperandIsHex(szToken, nSize, pusVal) ||
			fnOperandIsDec(szToken, nSize, pusVal) ||
			fnOperandIsOct(szToken, nSize, pusVal) ||
			fnOperandIsBin(szToken, nSize, pusVal) ||
			fnOperandIsChr(szToken, nSize, pusVal) ||
			fnOperandIsStr(szToken, nSize, pusVal) ;

}


/***************************************************************************
 *  Function:    fnOperandIsHex                                        	*
 *                                                                     	*
 *  Description: This function takes in a token and determines if it   	*
 *               is a hex value (denoted by the token starting with    	*
 *               either the characters '0x' or the characters 'h''.    	*
 *               If the operand is hex, it then validates the hex      	*
 *               characters and returns the hex value as an            	*
 *               unsigned short.                                       	*
 *                                                                     	*
 ***************************************************************************/

int
fnOperandIsHex(unsigned char * szToken,
				int nSize,
				unsigned short * pusVal)
{
   (*pusVal) = 0;
   if (strcmpni(szToken, "0x", 2) == 0 ||
		strcmpni(szToken, "h'", 2) == 0)
   {
	  if (fnIHex(&szToken[2], nSize, pusVal))
	  {
		 if (nSize == 1)
			fnAddError(ERR_INV_8_BIT_HEX_VALUE);
		 else
			fnAddError(ERR_INV_16_BIT_HEX_VALUE);
	  }
	  return 1;
   }
   return 0;
}


/***************************************************************************
 *  Function:    fnOperandIsDec                                        	*
 *                                                                     	*
 *  Description: This function takes in a token and determines if it   	*
 *               is a decimal value (denoted as the first character    	*
 *               either being a '-' or a digit).                       	*
 *               If the operand is decimal, it then validates the      	*
 *               characters and returns the decimal value as an        	*
 *               unsigned short.                                       	*
 *                                                                     	*
 ***************************************************************************/

int
fnOperandIsDec(unsigned char * szToken,
				int nSize,
				unsigned short * pusVal)
{
unsigned int i;
long lWk;

   (*pusVal) = 0;
   for (i = 0 ; i < strlen(szToken) ; i++)
   {
	  if (!isdigit(szToken[i]) &&
		   (i > 0 || szToken[i] != '-' || nSize == 2))
	  {
		 return 0;
	  }
   }
   lWk = atol(szToken);
   if (nSize == 1 && (lWk > 255 || lWk < -128))
	  fnAddError(ERR_INV_8_BIT_DEC_VALUE);
   else if (nSize == 2 && lWk > 65535)
	  fnAddError(ERR_INV_16_BIT_DEC_VALUE);
   else
	  (*pusVal) = (unsigned short) lWk;
   return 1;
}


/***************************************************************************
 *  Function:    fnOperandIsOct                                        	*
 *                                                                     	*
 *  Description: This function takes in a token and determines if it   	*
 *               is an octal value (denoted as the first two characters	*
 *               being 'o'').                                          	*
 *               If the operand is octal, it then validates the        	*
 *               characters and returns the octal value as an          	*
 *               unsigned short.                                       	*
 *                                                                     	*
 ***************************************************************************/

int
fnOperandIsOct(unsigned char * szToken,
				int nSize,
				unsigned short * pusVal)
{
int i, j;
int nShift;
int nErr;
unsigned short usWk;

   (*pusVal) = 0;
   if (strcmpni(szToken, "o'", 2) == 0)
   {
	  szToken += 2;
	  i = strlen(szToken);
	  nErr = 0;
	  for (j = 0 ; j < i ; j++)
	  {
		 if (szToken[j] < '0' || szToken[j] > '7')
		 {
			nErr = 1;
			break;
		 }
	  }
	  if (nSize == 1)
	  {
		 if (i > 3 || nErr ||
			  (i == 3 && szToken[2] > '6'))
		 {
			fnAddError(ERR_INV_8_BIT_OCT_VALUE);
			return 1;
		 }
		 if (i == 3)
			nShift = 5;
		 else
			nShift = (3 * (i - 1));
	  }
	  else
	  {
		 if (i > 6 || nErr ||
			  (i == 6 && szToken[5] > '4'))
		 {
			fnAddError(ERR_INV_16_BIT_OCT_VALUE);
			return 1;
		 }
		 if (i == 6)
			nShift = 13;
		 else
			nShift = (3 * (i - 1));
	  }
	  for (j = 0; j < i ; j++)
	  {
		 usWk = szToken[j];
		 usWk -= '0';
		 if (nShift < 0)
		 {
			if (nSize == 1)
			   usWk >>= 1;
			else
			   usWk >>= 2;
		 }
		 else
			usWk <<= nShift;
		 (*pusVal) += usWk;
		 nShift -= 3;
	  }
	  return 1;
   }
   return 0;
}


/***************************************************************************
 *  Function:    fnOperandIsBin                                        	*
 *                                                                     	*
 *  Description: This function takes in a token and determines if it   	*
 *               is a binary value (denoted as the first two characters	*
 *               being 'b'').                                          	*
 *               If the operand is binary, it then validates the       	*
 *               characters and returns the binary value as an         	*
 *               unsigned short.                                       	*
 *                                                                     	*
 ***************************************************************************/

int
fnOperandIsBin(unsigned char * szToken,
				int nSize,
				unsigned short * pusVal)
{
int i, j;
int nShift;
int nErr;
unsigned short usWk;

   (*pusVal) = 0;
   if (strcmpni(szToken, "b'", 2) == 0)
   {
	  szToken += 2;
	  i = strlen(szToken);
	  nErr = 0;
	  for (j = 0 ; j < i ; j++)
	  {
		 if (szToken[j] < '0' || szToken[j] > '1')
		 {
			nErr = 1;
			break;
		 }
	  }
	  if (nSize == 1)
	  {
		 if (i > 8 || nErr)
		 {
			fnAddError(ERR_INV_8_BIT_BIN_VALUE);
			return 1;
		 }
	  }
	  else
	  {
		 if (i > 16 || nErr)
		 {
			fnAddError(ERR_INV_16_BIT_BIN_VALUE);
			return 1;
		 }
	  }
	  nShift = (i - 1);
	  for (j = 0; j < i ; j++)
	  {
		 usWk = szToken[j];
		 usWk -= '0';
		 usWk <<= nShift;
		 (*pusVal) += usWk;
		 nShift--;
	  }
	  return 1;
   }
   return 0;
}


/***************************************************************************
 *  Function:    fnOperandIsChr                                        	*
 *                                                                     	*
 *  Description: This function takes in a token and determines if it   	*
 *               is a character value (denoted as the first character  	*
 *               being ''').                                           	*
 *               If the operand is character, it then validates the    	*
 *               format of the character expression and returns the    	*
 *               character as an unsigned short.                       	*
 *                                                                     	*
 ***************************************************************************/

int
fnOperandIsChr(unsigned char * szToken,
				int nSize,
				unsigned short * pusVal)
{
int i;

   (*pusVal) = 0;
   if (szToken[0] == '\'')
   {
	  i = strlen(szToken);
	  if (szToken[i-1] != '\'')
		 fnAddError(ERR_INV_CHAR_LITERAL);
	  else
	  {
		 /* Get real length of string by calling fnConvertString */
		 /* to account for any escape sequences.             	*/
		 i = fnConvertString(szToken, szToken);
		 if (i != 1)
			fnAddError(ERR_INV_CHAR_LITERAL);
		 else
			(*pusVal) = (unsigned short) szToken[0];
	  }
	  return 1;
   }
   return 0;
}


/***************************************************************************
 *  Function:    fnOperandIsStr                                        	*
 *                                                                     	*
 *  Description: This function takes in a token and determines if it   	*
 *               is a string value (denoted as the first character     	*
 *               being '"').                                           	*
 *               If the operand is string, it then validates the       	*
 *               format of the string expression and returns the       	*
 *               string as an unsigned short.                          	*
 *                                                                     	*
 *                                                                     	*
 ***************************************************************************/

int
fnOperandIsStr(unsigned char * szToken,
				int nSize,
				unsigned short * pusVal)
{
int i;

   (*pusVal) = 0;
   if (szToken[0] == '"')
   {
	  i = strlen(szToken);
	  if (szToken[ i - 1 ] != '"')
	  {
		 fnAddError(ERR_INV_STRING_LITERAL);
		 return 1;
	  }
	  /* Get real length of string by calling fnConvertString */
	  /* to account for any escape sequences.             	*/
	  i = fnConvertString(szToken, 0);
	  if (i == 0)
		 return 1;
	  if (nSize == 1)
	  {
		 fnConvertString(szToken, szToken + 10);
		 if (i > 1)
			fnAddError(ERR_INV_8_BIT_STRING_LITERAL);
		 else
			(*pusVal) = (unsigned short) szToken[10];
	  }
	  else
	  {
		 if (i > nSize)
			fnAddError(ERR_INV_16_BIT_STRING_LITERAL);
		 else
		 {
			if (nSize == 2)
			{
			   fnConvertString(szToken, szToken + 10);
			   (*pusVal) = (unsigned char) szToken[10];
			   if (i > 1)
			   {
				  (*pusVal) <<= 8;
				  (*pusVal) += szToken[11];
			   }
			}
			else
			   (*pusVal) = 0;
		 }
	  }
	  return 1;
   }
   return 0;
}


/***************************************************************************
 *  Function:    fnConvertString                                       	*
 *                                                                     	*
 *  Description: This function takes in a string literal surrounded by 	*
 *               quotes or a character literal surrounded by apostrophe's  *
 *               and converts out any escape sequences in the string.  	*
 *               The return value is the length of the string.         	*
 *                                                                     	*
 *               The return string parameter is optional so this function  *
 *               can be used to simply calculate the length of the string. *
 *                                                                     	*
 ***************************************************************************/
int
fnConvertString(unsigned char * szToken,
				 unsigned char * szReturnString)
{
int nLth, nReturnLth, nEscape, nWk;

   nLth = strlen(szToken) - 2;
   nReturnLth = 0;
   nEscape = 0;
   for (nWk = 1; nWk <= nLth; nWk++)
   {
	  if (nEscape)
	  {
		 if (szReturnString)
		 {
			switch (szToken[nWk])
			{
			   case 'a':
				  szReturnString[nReturnLth++] = '\a';
				  break;
			   case 'b':
				  szReturnString[nReturnLth++] = '\b';
				  break;
			   case 'f':
				  szReturnString[nReturnLth++] = '\f';
				  break;
			   case 'n':
				  szReturnString[nReturnLth++] = '\n';
				  break;
			   case 'r':
				  szReturnString[nReturnLth++] = '\r';
				  break;
			   case 't':
				  szReturnString[nReturnLth++] = '\t';
				  break;
			   case 'v':
				  szReturnString[nReturnLth++] = '\v';
				  break;
			   case '0':
				  szReturnString[nReturnLth++] = '\0';
				  break;
			   default:
				  szReturnString[nReturnLth++] = szToken[nWk];
				  break;
			}
		 }
		 else
			nReturnLth++;
		 nEscape = 0;
	  }
	  else if (szToken[ nWk ] == '\\')
		 nEscape = 1;
	  else
	  {
		 if (szReturnString)
			szReturnString[ nReturnLth++ ] = szToken[ nWk ];
		 else
			nReturnLth++;
	  }
   }
   return nReturnLth;
}

/***************************************************************************
 *  Function:    fnReadLine                                            	*
 *                                                                     	*
 *  Description:  This function reads a line from the passed file      	*
 *                handle and returns the line in the string passed     	*
 *                as well as the length of the line returned in        	*
 *                the return code. If the file contains blank lines,   	*
 *                they are skipped and never seen by the caller!       	*
 *                                                                     	*
 *                A zero length line means the end of the file was     	*
 *                reached.                                             	*
 *                                                                     	*
 ***************************************************************************/

int fnReadLine(FILE * fpFile, char * szLine)
{
	int i, j;

	j = 0;
	i = getc(fpFile);
	while (!feof(fpFile) && (i == '\n' || i == '\r' || i == '\x1a'))
		{
		i = getc(fpFile);
		}
	
	while (!feof(fpFile))
		{
		if (i == '\n' || i == '\r' || i == '\x1a' || i == -1)
			break;

		*szLine++ = (char) i;
		j++;
		i = getc(fpFile);
		}

	*szLine = '\0';
	
	return j;
}

int fnReadSource(char *szLine)
{
	int		i;

	if (inputfile < 0)
		return 0;

	if (bInMacro)
		macroBody();

	i = fnReadNextLine(szLine, MAX_LINE_SIZE, inputfiles[inputfile].pfile);

	if (!i)	/* end of file */
		{
		if (!inputfile)
			return 0;

		fclose(inputfiles[inputfile].pfile);	/* close current file */
		sprintf(szLine, ";.resume \"%s\"", inputfiles[inputfile-1].name);
		inputfile--;							/* use previous file */
#if 0
		return fnReadSource(szLine);
#else
		return strlen(szLine);
#endif
		}

	if (!pCurrentMacro)
		inputfiles[inputfile].lines++;

	i = strlen(szLine);
	if (i < 2)
		return fnReadSource(szLine);		/* read next line */

	i--;
	szLine[i] = '\0';

	return i;
	
}

/***************************************************************************
 *  Function:    fnGetLineToken                                        	*
 *                                                                     	*
 *  Description: This function extracts a token from a line read by    	*
 *               fnReadLine. Tokens are delimited by spaces, tabs,     	*
 *               and commas. If a string is found enclosed in either   	*
 *               apostrophes or quotes, all delimiter characters are   	*
 *               ignored within the string.                            	*
 *                                                                     	*
 ***************************************************************************/

int
fnGetLineToken(unsigned char * szLine, int * lpnStart,
				int * lpnPos, int nMinLth, int nMaxLth,
				unsigned char * szToken)
{
	int nPos;
	char chQuote;

	szToken[0] = 0;
	nPos = 0;
	chQuote = '\0';
	if (*lpnStart > (int) strlen(szLine))
		return 0;
	if (nMinLth > nMaxLth)
		nMinLth = nMaxLth;
	szLine += *lpnStart;
	while (szLine[0] && (szLine[0] == ' ' || szLine[0] == '\t'))
		{
		szLine++;
		(*lpnStart)++;
		}
	(*lpnPos) = 0;
	while (szLine[0] && ((szLine[0] != ' ' && szLine[0] != '\t' &&
		szLine[0] != ',' &&
		(szLine[0] != ';' || nPos == 0)) || chQuote))
		{
		if (nPos < nMaxLth)
			{
			szToken[nPos++] = szLine[0];
			szToken[nPos] = 0;
			if (*lpnPos == 0)
				*lpnPos = *lpnStart;
			if (!chQuote)
				{
				if (nPos == 1 && (szLine[0] == '\'' || szLine[0] == '"'))
					{
					chQuote = szLine[0];
					}
				}
			else
				{
				if (szLine[0] == chQuote)
					chQuote = '\0';
				}
			}
		szLine++;
		(*lpnStart)++;
		}
	while (szLine[0] == ' ' || szLine[0] == '\t')
		{
		szLine++;
		(*lpnStart)++;
		}
	if (szLine[0] == ',')
		{
		if (nPos == 0)
			if (strlen(szToken) == 0)		/* comma shouldn't be first thing on line */
				{
				strcpy(szToken, "comma");	/* this will generate an "Instruction mnemonic expected" error */
				}
		szLine++;
		(*lpnStart)++;
		}
	if (nPos == 0)
		return 0;
	while (strlen(szToken) < (unsigned int) nMinLth)
		strcat(szToken, " ");
	return 1;
}


/***************************************************************************
 *  Function:    fnOverlayCheck                                        	*
 *                                                                     	*
 *  Description: This function validates that the object code location 	*
 *               about to be written has not already been written by   	*
 *               some previous assembly code.                          	*
 *                                                                     	*
 ***************************************************************************/
int
fnOverlayCheck(unsigned short usLoc, unsigned short usLth)
{
unsigned usWk;

//if (usLoc == 0x50f2)
//	usWk = 1;

   for (usWk = usLoc ; usWk < ((unsigned)usLoc + usLth) ; usWk++)
   {
	  if (pObjUsed[usWk])
	  {
		 fnAddError(ERR_MEMORY_OVERLAY);
		 return 1;
	  }
   }
   return 0;
}

/***************************************************************************
 *  Function:    fnAddError                                            	*
 *                                                                     	*
 *  Description: This function adds an error to the integer error      	*
 *               array for printing out errors encountered in Pass 2   	*
 *               of the assembler after printing out the line in       	*
 *               error itself.                                         	*
 *                                                                     	*
 ***************************************************************************/

void
fnAddError(int nError)
{
	int i;


	if ( nError < LINT_FIRST)
		bErrors = 1;
	else
		bWarnings = 1;
	for (i = 0 ; i < MAX_ERRORS ; i++)
		{
		if (nErrors[i] == 0)
			{
			nErrors[i] = nError;
			break;
			}
		}
	return;
}


/***************************************************************************
 *  Function:    fnWriteErrors                                         	*
 *                                                                     	*
 *  Description:  This function writes errors detected in processing   	*
 *                an assembler line in Pass 2 to the listing file.     	*
 *                                                                     	*
 ***************************************************************************/

int
fnWriteErrors(void)
{
	int i, j;

	j = 0;
	for (i = 0 ; i < MAX_ERRORS ; i++)
		{
		if (nErrors[i])
			{
			
			if ( nErrors[i] < LINT_FIRST)
				tabbedOutput("              *** ERROR - ");
			else
				tabbedOutput("              *** LINT  - ");

			tabbedOutput(inputfiles[inputfile].name);
			tabbedOutput(" - ");
			tabbedOutput(ErrorMsgs[nErrors[i]-1]);

			if ( nErrors[i] < LINT_FIRST)
				fprintf(stdout, "%s(%u) : error a%04i: ", inputfiles[inputfile].name, inputfiles[inputfile].lines, nErrors[i]);
			else
				fprintf(stdout, "%s(%u) : warning a%04i: ", inputfiles[inputfile].name, inputfiles[inputfile].lines, nErrors[i]);
			fputs(ErrorMsgs[nErrors[i]-1], stdout);
			if (nErrors[i] < LINT_FIRST)
				j++;
			else
				nWarningCnt++;
			}
		else
			return j;
		}
}


/***************************************************************************
 *  Function:    fnIHex                                                	*
 *                                                                     	*
 *  Description:  This function takes a hex string and converts it to  	*
 *                either a 1 byte or two byte short. It also validates 	*
 *                that the string contains only valid hex characters   	*
 *                and is not two large for the 1 or two byte integer.  	*
 *                                                                     	*
 ***************************************************************************/

int
fnIHex(unsigned char * szToken, int nOutBytes,
		unsigned short * usResult)
{
int i;
int j;
unsigned int usWk;
int nShift;

   (*usResult) = 0;
   i = strlen(szToken);
   if ((nOutBytes == 1 && i > 2) ||
		(nOutBytes == 2 && i > 4))
   {
	  return 1;
   }

   nShift = (i - 1) * 4;
   for (j = 0 ; j < i ; j++)
   {
	  usWk = szToken[j];
	  if (usWk >= 'a')
	  {
		 if (usWk > 'f')
			return 2;
		 usWk -= ('a' - 10);
	  }
	  else if (usWk >= 'A')
	  {
		 if (usWk > 'F')
			return 2;
		 usWk -= ('A' - 10);
	  }
	  else
	  {
		 if (usWk < '0' || usWk > '9')
			return 2;
		 usWk -= '0';
	  }
	  usWk <<= nShift;
	  nShift -= 4;
	  (*usResult) += usWk;
   }

   return 0;
}


/***************************************************************************
 *  Function:    fnOHex                                                	*
 *                                                                     	*
 *  Description:  This function takes in an unsigned short and converts	*
 *                it to either a 2 byte or 4 byte hex string.          	*
 *                                                                     	*
 ***************************************************************************/

void
fnOHex(unsigned short usVal, int nBytes, char * szHexOut)
{
unsigned short usWk;
unsigned short usShift;

   usShift = 12;
   while (nBytes)
   {
	  usWk = usVal;
	  usWk <<= usShift;
	  usWk >>= 12;
	  usShift -= 4;
	  nBytes--;
	  szHexOut[ nBytes ] = hextable[ usWk ];
   }
}

/***************************************************************************
 *  Function:    fnReadSyntax                                          	*
 *                                                                     	*
 *  Description:  This function reads in the syntax file v8asm.syn  	*
 *                and creates a SYNTAX object for each operation code  	*
 *                defined in the file. See the file v8asm.syn for   	*
 *                a description of its format.                         	*
 *                                                                     	*
 ***************************************************************************/

int
fnReadSyntax(void)
{
int nStart, nPos;
unsigned char szLine[ 128 ];
unsigned char szToken[ 12 ];
unsigned char szMnemonic[ 5 ];
pSYNTAX pNewSyn;
unsigned short usLine;
int nErr;
unsigned short usOpCode;
unsigned char uchSize;

	usLine = 0;
	while (fnReadLine(fpSyn, szLine))
		{
		usLine++;
		nStart = 0;
		uchSize = 1;
		fnGetLineToken(szLine, &nStart, &nPos, 1, 10, szToken);
		if (!szToken[0] )
			goto error1;
		if (szToken[0] != ';')
			{
			nErr = fnIHex(szToken, 1, &usOpCode);
			if (nErr)
				goto error2;
			fnGetLineToken(szLine, &nStart, &nPos,
						 1, 10, szToken);
			if (NULL_TOKEN)
				goto error3;
			if (strlen(szToken) > 4 )
				goto error4;
			strcpy(szMnemonic, szToken);
			fnGetLineToken(szLine, &nStart, &nPos,
						 1, 10, szToken);
			if (NULL_TOKEN)
				goto error5;
			if (strlen(szToken) != 2 ||
				szToken[0] < '0' || szToken[0] > '5' ||
				szToken[1] < '0' || szToken[1] > '5' ||
				(szToken[0] == '0' && szToken[1] != '0'))
				{
				goto error6;
				}
			if (szToken[0] > '4')
				uchSize += 2;
			else if (szToken[0] > '2')
				uchSize++;
			else if (szToken[1] > '4')
				uchSize += 2;
			else if (szToken[1] > '2')
				uchSize++;
			/*
			* The syntax line is valid, create a new Syntax element
			*/
			pNewSyn = malloc(sizeof(tSYNTAX));
			if (!pNewSyn)
				goto error7;
			pNewSyn->opcode = (unsigned char) usOpCode;
			strcpy(pNewSyn->mnemonic, szMnemonic);
			pNewSyn->format = (unsigned char) atoi(szToken);
			pNewSyn->size = uchSize;
			pNewSyn->pnext = pFirstSyn;
			pFirstSyn = pNewSyn;
			}
		}

   /*
	* We've read the syntax and loaded it successfully
	*/
   return 0;

error1:
   printf("\nOpcode token missing in v8asm.syn\n");
   goto errorexit;
error2:
   printf("\nOpcode token invalid in v8asm.syn\n");
   goto errorexit;
error3:
   printf("\nMnemonic token missing in v8asm.syn\n");
   goto errorexit;
error4:
   printf("\nMnemonic exceeds 4 bytes in v8asm.syn\n");
   goto errorexit;
error5:
   printf("\nFormat token missing in v8asm.syn\n");
   goto errorexit;
error6:
   printf("\nFormat token invalid in v8asm.syn\n");
   goto errorexit;
error7:
   printf("\nError allocating memory for syntax\n");
   goto errorexit;

errorexit:
   printf("on line %d, line is '%s'\n", usLine, szLine);
   fprintf(stderr, "\a");
   return 8;
}


/***************************************************************************
 *  Function:    fnWriteHexFile                                        	*
 *                                                                     	*
 *  Description:  This function goes through the ORG objects and       	*
 *                produces the Intel hex output of the assembly.       	*
 *                Since ORG objects are stacked last-in first-out,     	*
 *                this function processes them by taking the last ORG  	*
 *                object in the linked list so the hex file reflects   	*
 *                the object code generated in the listing.            	*
 *                                                                     	*
 *                All ORG objects contain the location in the pObjCode 	*
 *                memory where object code was generated and the length	*
 *                of the code. A new ORG object is created in the      	*
 *                assembly process each time an .org directive is      	*
 *                found in the source.                                 	*
 *                                                                     	*
 ***************************************************************************/

int
fnWriteHexFile(FILE * fpHex)
{
pORG pOrg;
pORG pPrevOrg;
unsigned short usLth, usLoc, usWrite;
unsigned long  ulWk;
unsigned short usWk;
unsigned char uchLine[ 60 ];
unsigned char * puch;

   pPrevOrg = 0;
   fwrite(":020000020000FC\n", 16, 1, fpHex);
   for (; ;)
   {
	  if (pPrevOrg == pFirstOrg)
		 break;
	  pOrg = pFirstOrg;
	  while (pOrg->pnext != pPrevOrg)
		 pOrg = pOrg->pnext;

	  usLth = pOrg->lth;
	  usLoc = pOrg->loc;
	  while (usLth)
	  {
		 if (usLth > 16)
			usWrite = 16;
		 else
			usWrite = usLth;
		 memset(uchLine, '\0', sizeof(uchLine));
		 strcpy(uchLine, ":");
		 fnOHex(usWrite, 2, uchLine+1);
		 fnOHex(usLoc, 4, uchLine+3);
		 strcat(uchLine, "00");
		 puch = uchLine + 9;
		 ulWk = usWrite;
		 usWk = usLoc;
		 usWk >>= 8;
		 ulWk += usWk;
		 usWk = usLoc;
		 usWk <<= 8;
		 usWk >>= 8;
		 ulWk += usWk;
		 for (usWk = 0 ; usWk < usWrite ; usWk++)
		 {
			fnOHex((unsigned short) pObjCode[ usLoc ], 2, puch);
			puch+=2;
			ulWk += pObjCode[ usLoc ];
			usLoc++;
		 }
		 usLth -= usWrite;

		 /*
		  * calculate the checksum field
		  */
		 ulWk <<= 24;
		 ulWk >>= 24;
		 ulWk = 255 - ulWk;
		 ulWk++;
		 fnOHex((unsigned short) ulWk, 2, puch);
		 strcat(puch, "\n");
		 fwrite(uchLine, strlen(uchLine), 1, fpHex);
	  }

	  pPrevOrg = pOrg;
   }
   fwrite(":00000001FF\n", 12, 1, fpHex);
   return 0;
}

/***************************************************************************
 *  Function:    fnInitialize                                          	*
 *                                                                     	*
 *  Description:  This function initializes the program global variables,  *
 *                processes the incoming parameter(s), and builds the  	*
 *                file names to be used in the assembly process.       	*
 *                                                                     	*
 ***************************************************************************/

int
fnInitialize(int argc, char **argv)
{
char  * pchWk;
int		i, usage = 0;

   pFirstSyn = 0;
   pFirstOrg = 0;
   pFirstLbl = 0;
   pFirstEqu = 0;

   pObjCode = malloc((size_t) MAX_PROG_SIZE);
   if (!pObjCode)
   {
	  printf ("\nmalloc failed for memory copy of object code\n");
	  return 8;
   }
   memset(pObjCode, '\0', (size_t) MAX_PROG_SIZE);
   pObjUsed = malloc((size_t) MAX_PROG_SIZE);
   if (!pObjUsed)
   {
	  printf ("\nmalloc failed for memory copy of object code\n");
	  return 8;
   }
   memset(pObjUsed, '\0', (size_t) MAX_PROG_SIZE);

   /* first off, make sure a file name came in in argv */
	szAsmFile[0] = '\0';
	nPageSize = 22222;

	for (i=1; i<argc; i++)
		{
		if (argv[i][0] == '-' || argv[i][0] == '/')
			{
			switch (tolower(argv[i][1]))
				{
				case 'l':	// no lint
					bLint = 0;
					break;

				case 's':	// dump symbol usage
					bSymbols = 1;
					break;

				case 'p':	// set page size
					nPageSize = atoi(&argv[i][2]);
					if (nPageSize < 10)
						nPageSize = 66;
					break;

				case 't':	// set tab stops
					nTabStops = atoi(&argv[i][2]);
					if (nTabStops < 0)
						nTabStops = 0;
					if (nTabStops > 16)
						nTabStops = 16;
					break;

				case 'd':	// define value
					{
					char *pSym, *pVal;

					pEQUATE pEqu;
					/* equ directive */
					pEqu = (pEQUATE)malloc(sizeof(tEQUATE));
//					if (!pEqu)
//						{
//						printf ("\nmalloc failed for equ object\n");
//						return 8;
//						}
					memset(pEqu, '\0', sizeof(tEQUATE));

					pSym = &argv[i][2];
					pVal = strchr(pSym, '=');

					if (!pVal)
						{
						usage = 1;
						break;
						}

					*pVal++ = '\0';
					pEqu->pvalue1 = malloc(strlen(pSym) + 1);
//					if (!pEqu->pvalue1)
//						{
//						printf ("\nmalloc failed for equ object\n");
//						return 8;
//						}
					strcpy(pEqu->pvalue1, pSym);
					pEqu->pvalue2 = malloc(strlen(pVal) + 1);
//					if (!pEqu->pvalue2)
//						{
//						printf ("\nmalloc failed for equ object\n");
//						return 8;
//						}
					strcpy(pEqu->pvalue2, pVal);
					pEqu->pnext = pFirstEqu;
					pFirstEqu = pEqu;
					}
					break;

				default:
					usage = 1;
					break;
				}

			}
		else
			{
			if (szAsmFile[0])
				usage = 1;
			strcpy(szAsmFile, argv[i]);
			}
		}

	if (!szAsmFile[0])
		usage = 1;

   if (usage)
   {
	  printf("\nCommand format v8asm -dSymbol=Value -l -pnn -s -tnn filename\n\n");
	  printf("  where:\n");
	  printf("    -dSymbol=Value pretends first line of file is '.equ Symbol Value'\n");
	  printf("    -l no lint\n");
	  printf("    -p=listing page size in lines (default 22222)\n");
	  printf("    -s show symbol usage\n");
	  printf("    -t=tab stops (default 0)\n");
	  printf("    filename=.asm file to assemble\n\n");
	  printf("    ex. v8asm myprog (assembles myprog.asm)\n");
	  printf("        v8asm -p60 myprog.asm\n\n");
	  return 4;
   }

   /* Get file name of assembler file */
   if (!strchr(szAsmFile, '.'))
	  strcat(szAsmFile, ".asm");

   strcpy(szHexFile, szAsmFile);
   pchWk = szHexFile;
   while (pchWk[0] != '.')
	   pchWk++;
   strcpy(pchWk, ".ihx");

   strcpy(szLstFile, szAsmFile);
   pchWk = szLstFile;
   while (pchWk[0] != '.')
	   pchWk++;
   strcpy(pchWk, ".lst");

   /*
	* Get the v8asm.syn file name, extract the path of where the
	* assembler is and look for the syn file in that directory
	*/
#if defined(WIN32)
   figureOutSynName(szSynFile);
#else
   strcpy(szSynFile, *(argv));
   pchWk = szSynFile + strlen(szSynFile);
   while (pchWk > szSynFile && pchWk[0] != '\\')
	   pchWk--;
   if (pchWk > szSynFile)
	   pchWk++;
   strcpy(pchWk, "v8asm.syn");
#endif

   return 0;
}


/***************************************************************************
 *  Function:    fnCleanup                                             	*
 *                                                                     	*
 *  Description: This function cleans up all memory allocated in the   	*
 *               assembly process.                                     	*
 *                                                                     	*
 ***************************************************************************/

int
fnCleanup()
{
pSYNTAX pSyn;
pORG    pOrg;
pLABEL  pLbl;
pEQUATE pEqu;

	if (pObjCode)
		free (pObjCode);
	if (pObjUsed)
		free (pObjUsed);

	pSyn = pFirstSyn;
	while (pSyn)
		{
		pFirstSyn = pSyn->pnext;
		free (pSyn);
		pSyn = pFirstSyn;
		}
	pOrg = pFirstOrg;
	while (pOrg)
		{
		pFirstOrg = pOrg->pnext;
		free (pOrg);
		pOrg = pFirstOrg;
		}
	pLbl = pFirstLbl;
	while (pLbl)
		{
		pFirstLbl = pLbl->pnext;
		if (pLbl->pvalue)
		free (pLbl->pvalue);
		free (pLbl);
		pLbl = pFirstLbl;
		}
	pEqu = pFirstEqu;
	while (pEqu)
		{
		pFirstEqu = pEqu->pnext;
		if (pEqu->pvalue1)
			free (pEqu->pvalue1);
		if (pEqu->pvalue2)
			free (pEqu->pvalue2);
		free (pEqu);
		pEqu = pFirstEqu;
		}

	return 0;
}


int allocateOriginIfNeeded(unsigned short usLoc, unsigned short usLine)
{

/* allocate an origin if we don't have one */
	if (!pFirstOrg)
		{
		pFirstOrg = malloc(sizeof(tORG));
		if (!pFirstOrg)
			{
			printf ("\nmalloc failed for org object\n");
			return 0;
			}
		pFirstOrg->loc = usLoc;
		pFirstOrg->line = usLine;
		pFirstOrg->lth  = 0;
		pFirstOrg->pnext = 0;
		}

	return 1;
}

int datePass1(unsigned char *szToken, unsigned char *szString, 
			  unsigned short *pusLoc, unsigned short *pusLine, unsigned short usSize)
{
	if (strcmpi(szToken, szString) == 0)
		{
		if (!allocateOriginIfNeeded(*pusLoc, *pusLine))
			return 0;	/* error */
		*pusLoc += usSize;
		pFirstOrg->lth += usSize;
		}

	return 1;	/* happy */
}

int datePass2(unsigned char *szToken, unsigned char *szString, 
			  unsigned short usSize, unsigned short *pusLoc, 
			  unsigned short *pusSize, unsigned char *pDateTime)
{

	if (strcmpi(szToken, szString) == 0)
		{
		*pusSize = usSize;
		if (((long) (*pusLoc) + usSize) > MAX_PROG_SIZE)
			fnAddError(ERR_MEM_LOC_EXCEEDED);
		else
			{
			fnOverlayCheck(*pusLoc, usSize);
			memcpy(pObjCode + *pusLoc, pDateTime, (int) usSize);
			memset(pObjUsed + *pusLoc, 0xff, (int) usSize);
			*pusLoc += usSize;
			}
		return 1;	// it's us
		}
	return 0;	// not us
}

int directive1(char *szLine, char *szToken, int *pnStart, int *pnPos, 
	unsigned short *pusLine, unsigned short *pusLoc, unsigned short *pusSize)
{
	int i;
	unsigned short  usWk;

	for (i = 0 ; i < MAX_ERRORS ; i++)
		nErrors[i] = 0;
	bErrors = bWarnings = 0;

	if (iffy(szLine, szToken, pnStart, pnPos, pusLine, pusLoc, pusSize))
		return 0;

	if (ifCount && !ifs[ifCount].value)
		return 0;	// code has been .if'd out

	if (strcmpi(szToken, ".list") == 0)
		{
		bList = 1;
		return 0;
		}

	if (strcmpi(szToken, ".nolist") == 0)
		{
		bList = 0;
		return 0;
		}

	if (strcmpi(szToken, ".equ") == 0)
		{
		pEQUATE pEqu;
		/* equ directive */
		pEqu = (pEQUATE)malloc(sizeof(tEQUATE));
		if (!pEqu)
			{
			printf ("\nmalloc failed for equ object\n");
			return 8;
			}
		memset(pEqu, '\0', sizeof(tEQUATE));
		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		if (!NULL_TOKEN)
			{
			szToken[ MAX_LABEL_SIZE ] = '\0';
			pEqu->pvalue1 = malloc(strlen(szToken) + 1);
			if (!pEqu->pvalue1)
				{
				printf ("\nmalloc failed for equ object\n");
				return 8;
				}
			strcpy(pEqu->pvalue1, szToken);
			fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
			if (!NULL_TOKEN)
				{
				szToken[ MAX_LABEL_SIZE ] = '\0';
				pEqu->pvalue2 = malloc(strlen(szToken) + 1);
				if (!pEqu->pvalue2)
					{
					printf ("\nmalloc failed for equ object\n");
					return 8;
					}
				strcpy(pEqu->pvalue2, szToken);
				}
			}
		if (!pEqu->pvalue1 || !pEqu->pvalue2)
			{
			if (pEqu->pvalue1)
				free (pEqu->pvalue1);
			if (pEqu->pvalue2)
				free (pEqu->pvalue2);
			free (pEqu);
			}
		else
			{
			pEqu->pnext = pFirstEqu;
			pFirstEqu = pEqu;
			}
		return 0;
		}

	if (strcmpi(szToken, ".org") == 0 ||
		strcmpi(szToken, ".rom") == 0 ||
		strcmpi(szToken, ".ram") == 0)
		{
		unsigned short	segment = 0;

		if (strcmpi(szToken, ".ram") == 0)
			segment = 1;
		if (strcmpi(szToken, ".org") == 0)
			segment = 2;

		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);

		if (NULL_TOKEN)
			{	// no arg, lookup last value in org list
			pORG pOrg;

			usWk = 2;
			for (pOrg = pFirstOrg; pOrg; pOrg = pOrg->pnext)
				{
				if (pOrg->segment == segment)
					{
					usWk = pOrg->loc + pOrg->lth;
					break;
					}
				}

			}
		else
			usWk = org(szLine, szToken, pnStart, pnPos, pusLine, pusLoc, pusSize);

		/*
		* if the .org token is a valid value and it
		* is not the current location pointer, create
		* a new org object.
		*/
		if (nErrors[0] == 0 /*&& usWk != *pusLoc*/)
			{
			pORG pOrg;

			org1++;
			pOrg = (pORG)malloc(sizeof(tORG));
			if (!pOrg)
				{
				printf ("\nmalloc failed for org object\n");
				return 8;
				}
			pOrg->loc = usWk;
			pOrg->line = *pusLine;
			pOrg->lth  = 0;
			pOrg->segment = segment;
			pOrg->pnext = pFirstOrg;
			pFirstOrg = pOrg;
			*pusLoc = usWk;
			/*
			* If the current label is on this line,
			* update its location to the .org location
			*/
			if (pFirstLbl && pFirstLbl->line == pFirstOrg->line)
				{
				pFirstLbl->loc = pFirstOrg->loc;
				}
			}
		return 0;
		}

	if (strcmpi(szToken, ".byte") == 0 ||
		strcmpi(szToken, ".word") == 0 ||
		strcmpi(szToken, ".rword") == 0)
		{
		if (!allocateOriginIfNeeded(*pusLoc, *pusLine))
			return 8;
		if (strcmpi(szToken, ".byte") == 0)
			*pusSize = 1;
		else
			*pusSize = 2;
		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		while (!NULL_TOKEN)
			{
			*pusLoc += *pusSize;
			pFirstOrg->lth += *pusSize;
			fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
			}
		return 0;
		}

	if (strcmpi(szToken, ".datestamp") == 0)
		{
		if (!allocateOriginIfNeeded(*pusLoc, *pusLine))
			return 8;
		*pusSize = 2;
		*pusLoc += 2;
		pFirstOrg->lth += *pusSize;

		return 0;
		}

	if (strcmpi(szToken, ".string") == 0)
		{
		if (!allocateOriginIfNeeded(*pusLoc, *pusLine))
			return 8;
		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		while (!NULL_TOKEN)
			{
			*pusSize = (unsigned short)fnConvertString(szToken, 0);
			*pusLoc += *pusSize;
			pFirstOrg->lth += *pusSize;
			fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
			}
		return 0;
		}

	if (strcmpi(szToken, ".unicode") == 0)
		{
		if (!allocateOriginIfNeeded(*pusLoc, *pusLine))
			return 8;
		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		while (!NULL_TOKEN)
			{
			*pusSize = (unsigned short)fnConvertString(szToken, 0) * 2;
			*pusLoc += *pusSize;
			pFirstOrg->lth += *pusSize;
			fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
			}
		return 0;
		}

	if (strcmpi(szToken, ".include") == 0)
		{
		FILE * fpNewFile;

		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		if (!NULL_TOKEN)
			{
			if (szToken[0] == '"')
				{
				strcpy(szToken, &szToken[1]);
				szToken[ strlen(szToken) - 1 ] = '\0';
				}
			if ((fpNewFile=fopen(szToken, "r")) != NULL)
				{
				inputfile++;
				if (inputfile == MAX_FILES)
					{
					printf("\nError: too many nested .includes\n");
					fclose (fpNewFile);
					return 8;
					}
				inputfiles[inputfile].pfile = fpNewFile;
				strcpy(inputfiles[inputfile].name, szToken);
				inputfiles[inputfile].lines = 0;
				}
			}
		return 0;
		}

	if (!datePass1(szToken, "..datetime", pusLoc, pusLine, 14) ||
		!datePass1(szToken, "..date", pusLoc, pusLine, 8) ||
		!datePass1(szToken, "..time", pusLoc, pusLine, 6) ||
		!datePass1(szToken, "..year", pusLoc, pusLine, 4) ||
		!datePass1(szToken, "..month", pusLoc, pusLine, 2) ||
		!datePass1(szToken, "..day", pusLoc, pusLine, 2) ||
		!datePass1(szToken, "..hour", pusLoc, pusLine, 2) ||
		!datePass1(szToken, "..minute", pusLoc, pusLine, 2) ||
		!datePass1(szToken, "..second", pusLoc, pusLine, 2))
		return 8;

	if (strcmpi(szToken, ".macro") == 0)
		{
		return macro(szLine);
		}

	return 0;
}


int directive2(char *szLine, char *szToken, int *pnStart, int *pnPos, 
	unsigned short *pusLine, unsigned short *pusLoc, unsigned short *pusSize)
{
	unsigned short  usWk;

	if (iffy(szLine, szToken, pnStart, pnPos, pusLine, pusLoc, pusSize))
		return 0;

	if (ifCount && !ifs[ifCount].value)
		return 0;	// code has been .if'd out

	if (strcmpi(szToken, ".list") == 0)
		{
		bList = 1;
		return 0;
		}

	if (strcmpi(szToken, ".nolist") == 0)
		{
		bList = 0;
		return 0;
		}

	if (strcmpi(szToken, ".equ") == 0)
		{
		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LABEL_SIZE, szToken);
		if (!NULL_TOKEN)
			{
			fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LABEL_SIZE, 
				szToken + MAX_LABEL_SIZE + 1);
			if (!NULL_TOKEN)
				{
				pEQUATE pEqu;
				pLABEL  pLbl;

				 /* Make sure this equate has not already been */
				 /* defined. We'll allow redefinitions to the  */
				 /* same value so copied assembler routines	*/
				 /* can contain the same equates.          	*/
				pEqu = pFirstEqu;
				while (pEqu)
					{
					if (strcmpi(pEqu->pvalue1, szToken) == 0)
						{
						if (strcmpi(pEqu->pvalue2, szToken + MAX_LABEL_SIZE + 1) != 0)
							{
							fnAddError(ERR_EQU_REDEFINED);
							break;
							}
						}
					pEqu = pEqu->pnext;
					}

				 /* Make sure this equate has not already been */
				 /* defined as a lebel.                    	*/
				pLbl = pFirstLbl;
				while (pLbl)
					{
					if (strcmpi(pLbl->pvalue, szToken) == 0)
						{
						fnAddError(ERR_EQU_IS_LABEL);
						break;
						}
					pLbl = pLbl->pnext;
					}
				}
			else
				{
				fnAddError(ERR_EQU_REQ_2_OPERANDS);
				}
			}
		else
			{
			fnAddError(ERR_EQU_REQ_2_OPERANDS);
			}
		return 0;
		}

	if (strcmpi(szToken, ".org") == 0 ||
		strcmpi(szToken, ".rom") == 0 ||
		strcmpi(szToken, ".ram") == 0)
		{
		unsigned short	segment = 0;

		if (strcmpi(szToken, ".ram") == 0)
			segment = 1;
		if (strcmpi(szToken, ".org") == 0)
			segment = 2;

		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		
		if (NULL_TOKEN)
			{	// no arg, lookup last value in org list
			pORG pOrg;
			unsigned short org;

			usWk = 2;
			org = org2+1;
			for (pOrg = pFirstOrg; pOrg; pOrg = pOrg->pnext)
				{
				if (org == org1)
					{
					usWk = pOrg->loc;
					break;
					}
				org++;
				}
			}
		else
			usWk = org(szLine, szToken, pnStart, pnPos, pusLine, pusLoc, pusSize);

		org2++;

		  /*
		   * if the .org token valid, update the location
		   * pointer.
		   */
		if (nErrors[0] == 0)
			{
			*pusLoc = usWk;
			}
		return 0;
		}

	if (strcmpi(szToken, ".byte") == 0 ||
		 strcmpi(szToken, ".word") == 0 ||
		 strcmpi(szToken, ".rword") == 0)
		{
		unsigned short usLth;
		int nRWord;

		nRWord = 0;
		if (strcmpi(szToken, ".byte") == 0)
			usLth = 1;
		else
			{
			usLth = 2;
			if (strcmpi(szToken, ".rword") == 0)
				nRWord = 1;
			}
		*pusSize = 0;
		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		if (NULL_TOKEN)
			{
			fnAddError(ERR_OPERAND_EXPECTED);
			return 0;
			}

		while (!NULL_TOKEN)
			{
			szToken[MAX_LABEL_SIZE+1] = 0;	/* clear previous stuff */
			fnExtractExpression(szToken);

			 /* Call the Process Operand function with the */
			 /* location value - 1 since there is no   	*/
			 /* preceding op-code on .byte and .word   	*/
			 /* directives. If the directive is byte, have */
			 /* fnProcessOperand treat it as a format 4	*/
			 /* 8-bit operand, otherwise, treat it as a	*/
			 /* format 5 16-bit operand.               	*/
			if (((long) *pusLoc + usLth) > MAX_PROG_SIZE)
				fnAddError(ERR_MEM_LOC_EXCEEDED);
			else
				{
				fnOverlayCheck(*pusLoc, usLth);
				if (usLth == 1)
					fnProcessOperand(szToken, (unsigned short)(*pusLoc-1), 0, 4, 0, 0);
				else
					fnProcessOperand(szToken, (unsigned short)(*pusLoc-1), 0, 5, 0, nRWord);
				*pusLoc += usLth;
				*pusSize += usLth;
				}
			fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
			}
		return 0;
		}

	if (strcmpi(szToken, ".datestamp") == 0)
		{
		unsigned short usLth;

		usLth = 2;

		pObjCode[ *pusLoc + 0 ] = stamp>>8;
		pObjUsed[ *pusLoc + 0 ] = 0xff;

		pObjCode[ *pusLoc + 1 ] = stamp & 0xff;
		pObjUsed[ *pusLoc + 1 ] = 0xff;
		
		*pusSize = usLth;
		*pusLoc += usLth;
		return 0;
		}

	if (strcmpi(szToken, ".string") == 0)
		{
		unsigned short usLth;

		*pusSize = 0;
		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		while (!NULL_TOKEN)
			{
			usLth = 0;
			if (fnOperandIsStr(szToken, MAX_STRING_SIZE, &usWk))
				{
				if (strlen(szToken) > 2)
					{
					usLth = (unsigned short)fnConvertString(szToken, szToken);
					if (((long) *pusLoc + usLth) > MAX_PROG_SIZE)
						fnAddError(ERR_MEM_LOC_EXCEEDED);
					else
						{
						fnOverlayCheck(*pusLoc, usLth);
						memcpy(pObjCode + *pusLoc, szToken, usLth);
						memset(pObjUsed + *pusLoc, 0xff, usLth);
						}
					}
				}
			else
				{
				fnAddError(ERR_INV_STRING_LITERAL);
				}
			*pusLoc += usLth;
			*pusSize += usLth;
			fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
			}
		return 0;
		}

	if (strcmpi(szToken, ".unicode") == 0)
		{
		unsigned short usLth;

		*pusSize = 0;
		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		while (!NULL_TOKEN)
			{
			usLth = 0;
			if (fnOperandIsStr(szToken, MAX_STRING_SIZE, &usWk))
				{
				if (strlen(szToken) > 2)
					{
					usLth = (unsigned short) fnConvertString(szToken, szToken) * 2;
					if (((long) *pusLoc + usLth) > MAX_PROG_SIZE)
						fnAddError(ERR_MEM_LOC_EXCEEDED);
					else
						{
						int	i, j;
						fnOverlayCheck(*pusLoc, usLth);
						for (i=0, j=0; j<usLth; i++, j+=2)
							{
							pObjCode[*pusLoc + j] = szToken[i];
							pObjUsed[*pusLoc + j] = 0xff;
							pObjCode[*pusLoc + j + 1] = 0;
							pObjUsed[*pusLoc + j + 1] = 0xff;
							}
						}
					}
				}
			else
				{
				fnAddError(ERR_INV_STRING_LITERAL);
				}
			*pusLoc += usLth;
			*pusSize += usLth;
			fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
			}
		return 0;
		}

	if (strcmpi(szToken, ".include") == 0)
		{
		FILE * fpNewFile;

		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		if (!NULL_TOKEN)
			{
			if (szToken[0] == '"')
				{
				strcpy(szToken, &szToken[1]);
				szToken[ strlen(szToken) - 1 ] = '\0';
				}
			if ((fpNewFile=fopen(szToken, "r")) != NULL)
				{
				inputfile++;
				if (inputfile == MAX_FILES)
					{
					printf("\nError: too many nested .includes\n");
					fclose (fpNewFile);
					return 8;
					}
				inputfiles[inputfile].pfile = fpNewFile;
				strcpy(inputfiles[inputfile].name, szToken);
				inputfiles[inputfile].lines = 0;
				}
			else
				{
				fnAddError(ERR_INV_INCLUDE_FILE);
				}
			}
		return 0;
		}

	if (datePass2(szToken, "..datetime", 14, pusLoc, pusSize, szDateTime) ||
		datePass2(szToken, "..date", 8, pusLoc, pusSize, szDateTime) ||
		datePass2(szToken, "..time", 6, pusLoc, pusSize, szDateTime+8) ||
		datePass2(szToken, "..year", 4, pusLoc, pusSize, szDateTime) ||
		datePass2(szToken, "..month", 2, pusLoc, pusSize, szDateTime+4) ||
		datePass2(szToken, "..day", 2, pusLoc, pusSize, szDateTime+6) ||
		datePass2(szToken, "..hour", 2, pusLoc, pusSize, szDateTime+8) ||
		datePass2(szToken, "..minute", 2, pusLoc, pusSize, szDateTime+10) ||
		datePass2(szToken, "..second", 2, pusLoc, pusSize, szDateTime+12)
		)
		{
		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
		if (!NULL_TOKEN)
			fnAddError(ERR_UNEXPECTED_OPERAND);
		return 0;
		}

	if (strcmpi(szToken, ".macro") == 0)
		{
		return macro(szLine);
		}


	fnAddError(ERR_INV_DIRECTIVE);

	return 0;
}

unsigned short org(char *szLine, char *szToken, int *pnStart, int *pnPos, unsigned short *pusLine, unsigned short *pusLoc, unsigned short *pusSize)
{
	unsigned short usWk = 0;
	unsigned short usWk2;
	unsigned char uchOper;
	pLABEL pLbl;

	if (fnExtractExpression(szToken) == 0)
		{
		fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, 
			szToken + MAX_LABEL_SIZE + 1);
		}
	/*
	Re-equate the org. NOTE, this re-equate only
	works on equates defined prior to this .org
	in the assembler file.
	*/
	fnEquateToken(szToken);

	/*
	* Validate 16 bit format Operand
	*/
	if (strcmp(szToken, "*") == 0)
		usWk = *pusLoc;
	else if (pLbl = fnOperandIsLabel(szToken))
		usWk = pLbl->loc;
	else if (fnOperandIsHexDecOctBinChrStr(szToken, 2, &usWk))
		;
	else
		fnAddError(ERR_UNREC_16_BIT_OPER);

	/*
	* if there is an expression with the .org,
	* evaluate it.
	*/
	if (szToken[MAX_LABEL_SIZE + 1] && szToken[MAX_LABEL_SIZE + 1] != ';')
		{
		fnEvaluateExpression(&usWk2, &uchOper, &szToken[MAX_LABEL_SIZE + 1]);
		usWk = fnProcessExpression(usWk, uchOper, usWk2);
		}

	return usWk;
}

#define _IF		0
#define _IFN	1
#define _IFDEF	2
#define _IFNDEF	3
#define _ELSE	4
#define _ENDIF	5
#define _BOGUS	6

/*                    0      1       2          3           4    	  5 */
char *ifTypes[_BOGUS] = {".if", ".ifn", ".ifdef",  ".ifndef",  ".else",  ".endif"};

int iffy(char *szLine, char *szToken, int *pnStart, int *pnPos, 
		 unsigned short *pusLine, unsigned short *pusLoc, unsigned short *pusSize)
{
	int type;
	int	bToken;

	for (type=0; type<_BOGUS; type++)
		if (strcmpi(szToken, ifTypes[type]) == 0)
			break;

	if (type == _BOGUS)
		return 0;

	fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, szToken);
	bToken = (!NULL_TOKEN);

	if (type == _ELSE)
		{
		if (pass == 2)
			{
			if (bToken)
				fnAddError(ERR_UNEXPECTED_OPERAND);
			
			if (nTabStops)
				strcat(szLine, "\t;;;; NOT ");
			else
				strcat(szLine, " ;;;; NOT ");
			strcat(szLine, ifs[ifCount].string);
			}

		if (ifCount > 1 && !ifs[ifCount-1].value)	// inside of commented out code
			{
			ifs[ifCount].value = 0;
			return 1;
			}
		
		ifs[ifCount].value = !ifs[ifCount].value;
		return 1;
		}

	if (type == _ENDIF)
		{
		if (pass == 2)
			{
			if (bToken)
				fnAddError(ERR_UNEXPECTED_OPERAND);
			
			if (nTabStops)
				strcat(szLine, "\t;;;; ");
			else
				strcat(szLine, " ;;;; ");
			strcat(szLine, ifs[ifCount].string);
			}
		if (ifCount)
			ifCount--;
		return 1;
		}

	if (bToken)
		{
		ifCount++;

		if (type == _IF)
			strcpy(ifs[ifCount].string, szToken);
		else if (type == _IFN)
			sprintf(ifs[ifCount].string, "NOT (%s)", szToken);
		else if (type == _IFDEF)
			sprintf(ifs[ifCount].string, "defined(%s)", szToken);
		else /* if (type == _IFNDEF)*/
			sprintf(ifs[ifCount].string, "NOT defined(%s)", szToken);

		if (ifCount > 1 && !ifs[ifCount-1].value)	// inside of commented out code
			{
			ifs[ifCount].value = 0;
			return 1;
			}

		if (type == _IF)
			{
			ifs[ifCount].value = org(szLine, szToken, pnStart, pnPos, pusLine, pusLoc, pusSize);
			}
		else if (type == _IFN)
			{
			ifs[ifCount].value = !org(szLine, szToken, pnStart, pnPos, pusLine, pusLoc, pusSize);
			}
		else if (type == _IFDEF)
			{
			if (fnExtractExpression(szToken) == 0)
				{
				fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, 
					szToken + MAX_LABEL_SIZE + 1);
				}
			ifs[ifCount].value = fnEquateToken(szToken);
			}
		else /* if (type == _IFNDEF)*/
			{
			if (fnExtractExpression(szToken) == 0)
				{
				fnGetLineToken(szLine, pnStart, pnPos, 1, MAX_LINE_SIZE - 1, 
					szToken + MAX_LABEL_SIZE + 1);
				}
			ifs[ifCount].value = !fnEquateToken(szToken);
			}

		}
	else if (pass == 2)
		fnAddError(ERR_OPERAND_EXPECTED);

	return 1;
}

/***************************************************************************
 *  Function:    fnWriteHeader                                         	*
 *                                                                     	*
 *  Description: This function writes out a page header to the listing 	*
 *               file of the assembler output.                         	*
 *                                                                     	*
 ***************************************************************************/

int
fnWriteHeader(void)
{
unsigned char szLst[ 320 ];
/*unsigned char szPage[ 5 ];*/

	nPage++;
	nPagePos = 0;

	/*itoa(nPage+1000, szPage, 10);*/
	/*strcpy(szPage, szPage+1);*/

	tabbedOutput("\n");
	sprintf(szLst, "                 VAutomation V8 RISC Assembler                  Page %d\n", nPage);
	tabbedOutput(szLst);
	sprintf(szLst, "                   Version %s, %s\n", VERSION, __DATE__);
	tabbedOutput(szLst);
	tabbedOutput("\n");
	strcpy(szLst, " Loc     Code     Stmt  Source Code\n");
	tabbedOutput(szLst);
	strcpy(szLst, "                       |....+....1....+....2....+....3....+....4....+....5....+....6\n");
	tabbedOutput(szLst);
	return 0;
}


int smoothMov(char *szLine)
{
	char	buff[MAX_LINE_SIZE];
	char	op1[MAX_LINE_SIZE];
	char	op2[MAX_LINE_SIZE];
	char	*p, *ps, *pd;
	int		operand;

	if (strcmpni(szLine, "mov", 3) != 0)
		return 0;

/*
	1	mov r0,rn		->	tx0 rn
	2	mov rn,r0		->	t0x rn
	3	mov rn,#12		->	ldi rn,12
	4	mov rn,1234		->	lda rn,1234
	5	mov 1234,rn		->	sta rn,1234
	6	mov r0,@rn		->	ldx rn
	7	mov @rn,r0		->	stx rn
	8	mov r0,rn[12]	->	ldo rn,12
	9	mov rn[12],r0	->	sto rn,12
	10	mov rn,rm		->	psh rm pop rn
*/

	ps = szLine + 3;

	operand = 1;
	pd = op1;

	for (; *ps && (*ps != ';') && (operand <= 2); ps++)
		{
		if (*ps == ' ' || *ps == '\t' || *ps == '\r' || *ps == '\n')
			continue;

		if (*ps == ',')
			{
			*pd = '\0';
			operand++;
			if (operand == 2)
				pd = op2;
			continue;
			}

		*pd++ = *ps;
		}
	
	if (operand != 2)
		return -1;

	*pd = '\0';

// op[0], op[1]

#define IS_REG(p)			(((p[0] | 0x20) == 'r')	 && (p[1] >= '0' && p[1] <= '7') && !p[2])
#define IS_REG0(p)			(((p[0] | 0x20) == 'r')	 && p[1] == '0' && !p[2])
#define IS_REG_INDEX(p)		(((p[0] | 0x20) == 'r')	 && (p[1] >= '0' && p[1] <= '7') && (p[2] == '['))
//#define IS_REG_INDIRECT(p)	((p[0] == '@') && IS_REG((p+1)))

	if (op2[0] == '#')	// 3	mov r7,#12		->	ldi r7,12
		{
		if (!IS_REG(op1))
			return -1;
		sprintf(buff, "ldi %s,%s ;;;; %s", op1, &op2[1], szLine);
		strcpy(szLine, buff);
		return 0;
		}

	if (IS_REG0(op1))	// 1,6,8
		{
		if (op2[0] == '@')		// 6	mov r0,@r6		->	ldx r6
			{
			sprintf(buff, "ldx %s ;;;; %s", &op2[1], szLine);
			strcpy(szLine, buff);
			return 0;
			}

		if (IS_REG_INDEX(op2))	// 8	mov r0,r6[12]	->	ldo r6,12
			{
			for (p=op2; *p; p++)
				if (*p == '[')
					*p = ',';
				else if (*p == ']')
					*p = '\0';

			sprintf(buff, "ldo %s ;;;; %s", op2, szLine);
			strcpy(szLine, buff);
			return 0;
			}

		if (IS_REG(op2))		// 1	mov r0,r1		->	tx0 r1
			{
			sprintf(buff, "tx0 %s ;;;; %s", op2, szLine);
			strcpy(szLine, buff);
			return 0;
			}

		return -1;
		}

	if (IS_REG0(op2))	// 2,7,9
		{
		if (op1[0] == '@')		// 7	mov @r6,r0		->	stx r6
			{
			sprintf(buff, "stx %s ;;;; %s", &op1[1], szLine);
			strcpy(szLine, buff);
			return 0;
			}
		
		if (IS_REG_INDEX(op1))	// 9	mov r6[12],r0	->	sto r6,12
			{
			for (p=op1; *p; p++)
				if (*p == '[')
					*p = ',';
				else if (*p == ']')
					*p = '\0';

			sprintf(buff, "sto %s ;;;; %s", op1, szLine);
			strcpy(szLine, buff);
			return 0;
			}

		if (IS_REG(op1))		// 2	mov r1,r0		->	t0x r1
			{
			sprintf(buff, "t0x %s ;;;; %s", op1, szLine);
			strcpy(szLine, buff);
			return 0;
			}

		return -1;
		}

	if (IS_REG(op1) && IS_REG(op2))	// 10	mov r6,r7		->	psh r7 pop r6
		{
		sprintf(buff, ".byte 0x%2x,0x%2x ; push r%c pop r%c ;;;; %s", 0x80 + (op2[1] & 0x07), 0x88 + (op1[1] & 0x07), '0' + (op2[1] & 0x07), '0' + (op1[1] & 0x07), szLine);
		strcpy(szLine, buff);
		return 0;
		}

	if (IS_REG(op1))	// 4	mov r7,1234		->	lda r7,1234
		{
		sprintf(buff, "lda %s,%s ;;;; %s", op1, op2, szLine);
		strcpy(szLine, buff);
		return 0;
		}

	if (IS_REG(op2))	// 5	mov 1234,r7		->	sta r7,1234
		{
		sprintf(buff, "sta %s,%s ;;;; %s", op2, op1, szLine);
		strcpy(szLine, buff);
		return 0;
		}

	return -1;
}

char *stepOverLabel(char *szLine)
{
	char	*p;

	while (*szLine == ' ' || *szLine == '\t')	/* find first non-whitespace on line */
		szLine++;

	for (p=szLine; *p; p++)
		if (*p == ' ' || *p == '\t')
			if (p[-1] == ':')	/* current token is a label */
				return stepOverLabel(p);
	
	return szLine;
}

int macro(char *szLine)
{
	unsigned char	szToken[MAX_LINE_SIZE];
	int				i, nStart=0, nPos=0;

	if (bInMacro)
		{
		printf ("\nnested macros\n");
		return 1;
		}

	bInMacro = 1;

	fnGetLineToken(szLine, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, szToken);
	if (NULL_TOKEN)
		{
		printf ("\nmacro error\n");
		return 1;
		}

	fnGetLineToken(szLine, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, szToken);
	if (NULL_TOKEN)
		{
		printf ("\n.macro must have a name\n");
		return 1;
		}

	if (pass == 1)
		{
		PMACRO	pCur = findMacro(szToken);
		PMACRO pNew;

		if (pCur)
			{
			printf ("\n.macro %s - already defined\n", szToken);
			return 1;
			}

		pNew = (PMACRO)malloc(sizeof(MACRO));
		if (!pNew)
			{
			printf ("\nout of memory\n");
			return 8;
			}

		pNew->pNext = pMacroList;
		i = strlen(szToken) + 1;
		pNew->name = (char *)malloc(i);
		if (!pNew->name)
			{
			printf ("\nout of memory\n");
			return 8;
			}
		strcpy(pNew->name, szToken);
		pNew->lines = 0;
		pNew->instance = 0;

		pMacroList = pNew;
		}


	return 0;
}

int macroBody()
{
	char	szMacro[MAX_LINE_SIZE];
	unsigned char szLst[ MAX_LINE_SIZE * 2 ];
	char	*p;
	int		i, j;

	for (;;)
		{
		i = fnReadNextLine(szMacro, MAX_LINE_SIZE, inputfiles[inputfile].pfile);

		if (!i)
			return 1;

		if (!pCurrentMacro)
			inputfiles[inputfile].lines++;

		if (pass == 2)
			{
			sprintf(szLst, "                %6d  %s", inputfiles[inputfile].lines, szMacro);
			tabbedOutput(szLst);
			}
		
		p = szMacro;
		while (*p == ' ' || *p == '\t')
			p++;

		if (strcmpni(p, ".endmacro", 9) == 0)
			break;

		if (pass == 1)
			{
			if (pMacroList->lines == 64)
				{
				printf ("\nmacros can't exceed 64 lines\n");
				return 8;
				}

			i = strlen(szMacro) + 1;
			j = pMacroList->lines++;
			pMacroList->line[j] = (char *)malloc(i);
			strcpy(pMacroList->line[j], szMacro);
			}
		}

	bInMacro = 0;
	return 0;
}


PMACRO findMacro(char *name)
{
	PMACRO	pCur = pMacroList;
	char	buff[MAX_LINE_SIZE];
	char	*ps, *pd;

	for (ps=name, pd=buff; *ps > ' '; ps++, pd++)
		*pd = *ps;
	*pd = '\0';

	while (pCur)
		{
		if (strcmpi(buff, pCur->name) == 0)
			return pCur;

		pCur = pCur->pNext;
		}

	return NULL;
}

void reinitMacro()
{
	PMACRO	pCur = pMacroList;

	while (pCur)
		{
		pCur->instance = 0;
		pCur = pCur->pNext;
		}

	return;
}

int fnReadNextLine(char *szLine, int iMax, FILE *pfile)
{
	char			*p, *pd, *ps;
	unsigned char	szToken[MAX_LINE_SIZE];
	int				i, nStart=0, nPos=0;
	PMACRO			pCur;

	if (pCurrentMacro)
		{
		if (pCurrentMacro->currentLine < pCurrentMacro->lines)
			{
			p = pCurrentMacro->line[pCurrentMacro->currentLine++];
			pd = szLine;

			for (; *p; p++)	/* look for %'s */
				{
				if (*p == '%')
					{
					p++;
					if (*p >= '1' && *p <= '9')		// replacement
						{
						for (ps = pCurrentMacro->arg[*p - '1']; *ps; ps++)
							*pd++ = *ps;
						continue;
						}
					}
				if (*p == '~')
					{
					char	buff[MAX_LINE_SIZE];

					if (p[1] == '~')
						{
						buff[0] = '~';
						buff[1] = '\0';
						p++;
						}
					else
						{
						sprintf(buff, "%s_%i_", pCurrentMacro->name, pCurrentMacro->instance);
						}

					for (ps = buff; *ps; ps++)
						*pd++ = *ps;

					p++;
					}

				*pd++ = *p;
				}

			*pd = '\0';

			return 1;
			}

		pCurrentMacro = NULL;
		}

	p = fgets(szLine, iMax, pfile);
	if (p)
		{
		i = strlen(p);
		while (i && p[i-1] <= ' ')
			i--;
		p[i++] = '\n';
		p[i++] = '\0';

		p = stepOverLabel(p);
		smoothMov(p);

		fnGetLineToken(p, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, szToken);
		if (!NULL_TOKEN)
			if (pCur = findMacro(szToken))
				{
				pCurrentMacro = pCur;
				pCurrentMacro->currentLine = 0;
				pCurrentMacro->instance++;

				inputfiles[inputfile].lines++;
				
				for (pCurrentMacro->args = 0;
					fnGetLineToken(p, &nStart, &nPos, 1, MAX_LINE_SIZE - 1, szToken) && pCurrentMacro->args<9;
					pCurrentMacro->args++)
					{
					pCurrentMacro->arg[pCurrentMacro->args] = ps = strdup(szToken);
					if (!ps)
						return 0;	/* out of memory */

					while (*ps)
						{
						if (*ps == '\r' || *ps == '\n')
							*ps = '\0';
						ps++;
						}
					}

				strcpy(szToken, p);
				*p++ = ';';
				strcpy(p, szToken);
				}
		}

	return p != NULL;
}


void tabbedOutput(char *szLst)
{
	int		i;

	if (!bList)		// output is turned off via .nolist
		return;

	if (nTabStops)	// expand tabstops
		{
		for (i=0; szLst[i]; i++)
			if (szLst[i] != ' ')
				break;

		while (nTabStops <= i)
			{
			fwrite("\t", 1, 1, fpLst);
			szLst += nTabStops;
			i -= nTabStops;
			}
		}
	else
		i = strlen(szLst);

	if (!i)		// no one expects a null string
		return;

	// if line won't fit, goto new page
	if ((nPagePos + 1) > nPageSize)
		fnWriteHeader();

	nPagePos += (szLst[i-1] == '\n');

	fwrite(szLst, i, 1, fpLst);
	return;
}

#if defined(WIN32)
#include <windows.h>

void figureOutSynName(char *szSynFile)
{
	int i;

	i = GetModuleFileName(0, szSynFile, 256);
	if (i)
		strcpy(&szSynFile[i - 3], "syn");
	else
		strcpy(szSynFile, "v8asm.syn");
	return;
}
#endif

int strcmpi(const char *s1, const char *s2)
{

	while (*s1 && (tolower(*s1) == tolower(*s2)))
		{
		s1++;
		s2++;
		}

	return *s1 - *s2;
}

int strcmpni(const char *s1, const char *s2, int n)
{

	while (n-- && *s1 && (tolower(*s1) == tolower(*s2)))
		{
		s1++;
		s2++;
		}

	if (n == -1)
		return 0;

	return *s1 - *s2;
}
