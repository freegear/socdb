#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

/* Need a way to have void used for ANSI, nothing for K&R. */
#ifndef _ANSI
#undef _VOID
#define _VOID
#endif

/* -------- sh.h -------- */
/*
 * shell
 */

#define	LINELIM	2100
#define	NPUSH	8	/* limit to input nesting */

#define	NOFILE	20	/* Number of open files */
#define	NUFILE	10	/* Number of user-accessible files */
#define	FDBASE	10	/* First file usable by Shell */

/*
 * values returned by wait
 */
#define	WAITSIG(s) ((s)&0177)
#define	WAITVAL(s) (((s)>>8)&0377)
#define	WAITCORE(s) (((s)&0200)!=0)

/*
 * library and system defintions
 */
#ifdef __STDC__
typedef void xint;	/* base type of jmp_buf, for not broken compilers */
#else
typedef char * xint;	/* base type of jmp_buf, for broken compilers */
#endif

/*
 * shell components
 */
/* #include "area.h" */
/* #include "word.h" */
/* #include "io.h" */
/* #include "var.h" */

#define	QUOTE	0200

#define	NOBLOCK	((struct op *)NULL)
#define	NOWORD	((char *)NULL)
#define	NOWORDS	((char **)NULL)
#define	NOPIPE	((int *)NULL)

/*
 * Description of a command or an operation on commands.
 * Might eventually use a union.
 */
struct op {
	int	type;	/* operation type, see below */
	char	**words;	/* arguments to a command */
	struct	ioword	**ioact;	/* IO actions (eg, < > >>) */
	struct op *left;
	struct op *right;
	char	*str;	/* identifier for case and for */
};

#define	TCOM	1	/* command */
#define	TPAREN	2	/* (c-list) */
#define	TPIPE	3	/* a | b */
#define	TLIST	4	/* a [&;] b */
#define	TOR	5	/* || */
#define	TAND	6	/* && */
#define	TFOR	7
#define	TDO	8
#define	TCASE	9
#define	TIF	10
#define	TWHILE	11
#define	TUNTIL	12
#define	TELIF	13
#define	TPAT	14	/* pattern in case */
#define	TBRACE	15	/* {c-list} */
#define	TASYNC	16	/* c & */

/*
 * actions determining the environment of a process
 */
#define	BIT(i)	(1<<(i))
#define	FEXEC	BIT(0)	/* execute without forking */

/*
 * flags to control evaluation of words
 */
#define	DOSUB	1	/* interpret $, `, and quotes */
#define	DOBLANK	2	/* perform blank interpretation */
#define	DOGLOB	4	/* interpret [?* */
#define	DOKEY	8	/* move words with `=' to 2nd arg. list */
#define	DOTRIM	16	/* trim resulting string */

#define	DOALL	(DOSUB|DOBLANK|DOGLOB|DOKEY|DOTRIM)

extern	char	**dolv;
extern	int	dolc;
extern	int	exstat;
extern  char	gflg;
extern  int	talking;	/* interactive (talking-type wireless) */
extern  int	execflg;
extern  int	multiline;	/* \n changed to ; */
extern  struct	op	*outtree;	/* result from parser */

extern	xint	*failpt;
extern	xint	*errpt;

struct	brkcon {
	jmp_buf	brkpt;
	struct	brkcon	*nextlev;
} ;
extern	struct brkcon	*brklist;
extern	int	isbreak;

/*
 * redirection
 */
struct ioword {
	short	io_unit;	/* unit affected */
	short	io_flag;	/* action (below) */
	char	*io_name;	/* file name */
};
#define	IOREAD	1	/* < */
#define	IOHERE	2	/* << (here file) */
#define	IOWRITE	4	/* > */
#define	IOCAT	8	/* >> */
#define	IOXHERE	16	/* ${}, ` in << */
#define	IODUP	32	/* >&digit */
#define	IOCLOSE	64	/* >&- */

#define	IODEFAULT (-1)	/* token for default IO unit */

extern	struct	wdblock	*wdlist;
extern	struct	wdblock	*iolist;

/*
 * parsing & execution environment
 */
extern struct	env {
	char	*linep;
	struct	io	*iobase;
	struct	io	*iop;
	xint	*errpt;
	int	iofd;
	struct	env	*oenv;
} e;

/*
 * flags:
 * -e: quit on error
 * -k: look for name=value everywhere on command line
 * -n: no execution
 * -t: exit after reading and executing one command
 * -v: echo as read
 * -x: trace
 * -u: unset variables net diagnostic
 */
extern	char	*flag;

extern	char	*null;	/* null value for variable */
extern	int	intr;	/* interrupt pending */

extern	char	*trap[_NSIG+1];
extern	char	ourtrap[_NSIG+1];
extern	int	trapset;	/* trap pending */

extern	int	heedint;	/* heed interrupt signals */

extern	int	yynerrs;	/* yacc */

extern	char	line[LINELIM];
extern	char	*elinep;

/*
 * other functions
 */
#ifdef __STDC__
int (*inbuilt(char *s ))(void);
#else
int (*inbuilt())();
#endif

char *rexecve (char *c , char **v, char **envp );
char *space (int n );
char *strsave (char *s, int a );
char *evalstr (char *cp, int f );
char *putn (int n );
char *itoa (unsigned u, int n );
char *unquote (char *as );
struct var *lookup (char *n );
int rlookup (char *n );
struct wdblock *glob (char *cp, struct wdblock *wb );
int my_getc( int ec);
int subgetc (int ec, int quoted );
char **makenv (void);
char **eval (char **ap, int f );
int setstatus (int s );
int waitfor (int lastpid, int canintr );

void onintr (int s ); /* SIGINT handler */

int newenv (int f );
void quitenv (void);
void err (char *s );
int anys (char *s1, char *s2 );
int any (int c, char *s );
void next (int f );
void setdash (void);
void onecommand (void);
void runtrap (int i );
void xfree (char *s );
int letter (int c );
int digit (int c );
int letnum (int c );
int gmatch (char *s, char *p );

/*
 * error handling
 */
void leave (void); /* abort shell (or fail in subshell) */
void fail (void);	 /* fail but return to process next command */
void warn (char *s );
void sig (int i );	 /* default signal handler */

/* -------- var.h -------- */

struct	var {
	char	*value;
	char	*name;
	struct	var	*next;
	char	status;
};
#define	COPYV	1	/* flag to setval, suggesting copy */
#define	RONLY	01	/* variable is read-only */
#define	EXPORT	02	/* variable is to be exported */
#define	GETCELL	04	/* name & value space was got with getcell */

extern	struct	var	*vlist;		/* dictionary */

extern	struct	var	*homedir;	/* home directory */
extern	struct	var	*prompt;	/* main prompt */
extern	struct	var	*cprompt;	/* continuation prompt */
extern	struct	var	*path;		/* search path for commands */
extern	struct	var	*shell;		/* shell to interpret command files */
extern	struct	var	*ifs;		/* field separators */

int yyparse (void);
struct var *lookup (char *n );
void setval (struct var *vp, char *val );
void nameval (struct var *vp, char *val, char *name );
void export (struct var *vp );
void ronly (struct var *vp );
int isassign (char *s );
int checkname (char *cp );
int assign (char *s, int cf );
void putvlist (int f, int out );
int eqname (char *n1, char *n2 );

int execute (struct op *t, int *pin, int *pout, int act );

/* -------- io.h -------- */
/* io buffer */
struct iobuf {
  unsigned id;				/* buffer id */
  char buf[512];			/* buffer */
  char *bufp;				/* pointer into buffer */
  char *ebufp;				/* pointer to end of buffer */
};

/* possible arguments to an IO function */
struct ioarg {
	char	*aword;
	char	**awordlist;
	int	afile;		/* file descriptor */
	unsigned afid;		/* buffer id */
	long	afpos;		/* file position */
	struct iobuf *afbuf;	/* buffer for this file */
};
extern struct ioarg ioargstack[NPUSH];
#define AFID_NOBUF	(~0)
#define AFID_ID		0

/* an input generator's state */
struct	io {
	int	(*iofn)(_VOID);
	struct	ioarg	*argp;
	int	peekc;
	char	prev;		/* previous character read by readc() */
	char	nlcount;	/* for `'s */
	char	xchar;		/* for `'s */
	char	task;		/* reason for pushed IO */
};
extern	struct	io	iostack[NPUSH];
#define	XOTHER	0	/* none of the below */
#define	XDOLL	1	/* expanding ${} */
#define	XGRAVE	2	/* expanding `'s */
#define	XIO	3	/* file IO */

/* in substitution */
#define	INSUB()	(e.iop->task == XGRAVE || e.iop->task == XDOLL)

/*
 * input generators for IO structure
 */
int nlchar (struct ioarg *ap );
int strchar (struct ioarg *ap );
int qstrchar (struct ioarg *ap );
int filechar (struct ioarg *ap );
int herechar (struct ioarg *ap );
int linechar (struct ioarg *ap );
int gravechar (struct ioarg *ap, struct io *iop );
int qgravechar (struct ioarg *ap, struct io *iop );
int dolchar (struct ioarg *ap );
int wdchar (struct ioarg *ap );
void scraphere (void);
void freehere (int area );
void gethere (void);
void markhere (char *s, struct ioword *iop );
int herein (char *hname, int xdoll );
int run (struct ioarg *argp, int (*f)(_VOID));

/*
 * IO functions
 */
int eofc (void);
int readc (void);
void unget (int c );
void ioecho (int c );
void prs (char *s );
void prn (unsigned u );
void closef (int i );
void closeall (void);

/*
 * IO control
 */
void pushio (struct ioarg *argp, int (*fn)(_VOID));
int remap (int fd );
int openpipe (int *pv );
void closepipe (int *pv );
struct io *setbase (struct io *ip );

extern	struct	ioarg	temparg;	/* temporary for PUSHIO */
#define	PUSHIO(what,arg,gen) ((temparg.what = (arg)),pushio(&temparg,(gen)))
#define	RUN(what,arg,gen) ((temparg.what = (arg)), run(&temparg,(gen)))

/* -------- word.h -------- */
#ifndef WORD_H
#define	WORD_H	1
struct	wdblock {
	short	w_bsize;
	short	w_nword;
	/* bounds are arbitrary */
	char	*w_words[1];
};

struct wdblock *addword (char *wd, struct wdblock *wb );
struct wdblock *newword (int nw );
char **getwords (struct wdblock *wb );
#endif

//#if 0
/* -------- area.h -------- */

/*
 * storage allocation
 */
char *getcell (unsigned nbytes );
void garbage (void);
void setarea (char *cp, int a );
int getarea (char *cp );
void freearea (int a );
void freecell (char *cp );

extern	int	areanum;	/* current allocation area */

#define	NEW(type) (type *)getcell(sizeof(type))
#define	DELETE(obj)	freecell((char *)obj)

//#endif
