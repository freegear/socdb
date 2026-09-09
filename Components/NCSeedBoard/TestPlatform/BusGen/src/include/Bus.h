# ifndef BUS_H
# define BUS_H

#define MAXNAMELEN  30
#define MAXSLAVE    20
#define MAXMASTER   20
#define MAXERRORBUFF 100


#define WRCH     1 
#define RDCH     0 

struct DefWriteChPort{
    unsigned int WriteAddress;
    unsigned int WriteData;
    unsigned int WriteRes;
};

typedef struct DefWriteChPort DefWriteChPort;

struct DefReadChPort{
    unsigned int ReadAddress;
    unsigned int ReadData;
};

typedef struct DefReadChPort  DefReadChPort ;

struct DefMemoryMap{
    char name[MAXNAMELEN];
	unsigned int StartAddr;
	unsigned int AreaAddr;
	unsigned int EndAddr;
};

struct DefPortConfig{
    unsigned int IDEnable;
    unsigned int ChannelEnable;
    unsigned int LockEnable;
    unsigned int CacheEnable;
    unsigned int ProtectEnable;
    unsigned int WstrbEnable;
};

struct DefArbiter{

    char PriorityMaster[MAXMASTER][MAXNAMELEN];
    unsigned int method;
};

struct DefMain{
    char name[MAXNAMELEN];
	unsigned int BusWidth;
	unsigned int AddrWidth;
	unsigned int MasterNumber;
	unsigned int SlaveNumber;
    
    DefWriteChPort WriteChConnect;
    DefReadChPort  ReadChConnect;

    unsigned int ReMapEnable;
    struct DefMemoryMap Map0[MAXSLAVE];
    struct DefMemoryMap Map1[MAXSLAVE];
};

typedef struct DefMain DefMain;


struct DefMaster{
    char name[MAXNAMELEN];

    //ID WIDTH
    unsigned int writeidwid;
    unsigned int readidwid;

    char ConnectSlave[MAXSLAVE][MAXNAMELEN];
    //Operation condition
    unsigned int OperateMethod;
    unsigned int OperateLockEnable;
    unsigned int WriteIssuingCap;
    unsigned int ReadIssuingCap;
    //Register Slice
    unsigned int modeMtoSi;  // 0 = disable / 1=Full / 2=Forward
    unsigned int RegisterSliceMtoSi;
    unsigned int modeSitoMi;
    unsigned int RegisterSliceSitoMi;
    //Port configuration
    struct DefPortConfig WriteChPort;
    struct DefPortConfig ReadChPort;
};
typedef struct DefMaster DefMaster;

struct DefSlave{
    char name[MAXNAMELEN];
    //ID WIDTH
    unsigned int writeidwid;
    unsigned int readidwid; 
    unsigned int SelMasterWid; 
    unsigned int SelWriteWid;
    unsigned int SelReadWid;

    struct DefArbiter OperateArbiter;
    char ConnectMaster[MAXMASTER][MAXNAMELEN];
    //Operation condition
    unsigned int OperateBurstFIXEDEnable;
    unsigned int OperateBurstINCREnable;
    unsigned int OperateBurstWRAPEnable;
    unsigned int WriteIssuingCap;
    unsigned int ReadIssuingCap;
    //Register Slice
    unsigned int modeStoMi;   // 0 = disable / 1=Full / 2=Forward
    unsigned int RegisterSliceStoMi;
    unsigned int modeMitoSi;
    unsigned int RegisterSliceMitoSi;
    //Port configuration
    struct DefPortConfig WriteChPort;
    struct DefPortConfig ReadChPort;
};
typedef struct DefSlave DefSlave;

enum MAIN_DEF{

    MAIN_CROSS_BAR_BUS  = 0x0001,	/* Cross bar switch bus channel*/
    MAIN_SHARED_BUS	    = 0x0002,	/* Shared bus channel */

    ENABLE              = 0x0003,   /* Enable funciton  */
    DISABLE             = 0x0004,   /* Disable funciton */
    SIMPLE              = 0x0005,   /* simple method  */
    ADVANCED            = 0x0006,   /* advanced method */
    NORMAL              = 0x0007,   /* normal method */
};

enum error_bus{

   BUS_ERROR_NONE                       = 0x1000,
   BUS_ERROR_NONE_ENDMAIN_PARSING       = 0x1001,
   BUS_ERROR_NONE_ENDMASTER_PARSING     = 0x1002,
   BUS_ERROR_NONE_ENDSLAVE_PARSING      = 0x1003,

   /* channel connection define fault */
   BUS_ERROR_CH_CONNECT      = 0x2001,   
   /* remap choice error (enalbe or disable) */
   BUS_ERROR_REMAP_CHOICE    = 0x2002, 
   /* slave area error */
   BUS_ERROR_SLAVEAREA_OVERRAP   = 0x2003, 
   /* slave number over error */
   BUS_ERROR_SLAVENUM_OVER   = 0x2004, 
   /* master number over error */
   BUS_ERROR_MASTERNUM_OVER  = 0x2005, 
   /* invalid parameter */
   BUS_ERROR_INVALID_PARA    = 0x2006, 
   /* Exceed naming rule */
   BUS_ERROR_EXCEED_PARA     = 0x2007, 
   /* XML data parsing */
   BUS_ERROR_PARSING        = 0x2008, 
   /* DATA not Sufficient error */
   BUS_ERROR_NOT_SUFFICIENT = 0x2009, 



   /* file error open or read or write or close */
   FILE_PROCESS_ERROR        = 0x3001,

};

enum parsing_stauts{

    MAIN_PARSING        = 0x0000,
    MASTER_PARSING      = 0x0001,
    SLAVE_PARSING       = 0x0002,
    END_PARSING         = 0x0003,
};

unsigned int StackError[MAXERRORBUFF];


/* Configuration */
DefMaster ValMASTER [MAXMASTER];
DefSlave  ValSLAVE  [MAXSLAVE];
DefMain   ValMAIN;

#else

#endif
