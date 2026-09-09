// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SiliconGear
// ALL RIGHTS RESERVED SiliconGear 
// -----------------------------------------------------------------
// Version and Release information: S-AXI bus generator Ver 0.1 
// File Name           : genDef.h 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : header file 
//  ----------------------------------------------------------------

# ifndef GenDef_H
# define GenDef_H

//  =================================================================
//  Variable declaraion
//  ----------------------------------------------------------------

#define MAX_PARAMETER  28
#ifdef _EXTERN
char PARA[29][2][80] = {
    /*0*/{{"parameter BUS_WID ="},{"0"}},     //__
    /*1*/{{"parameter ADDR_WID="},{"0"}},     //__
    /*2*/{{"parameter MASTERID_WID="},{"0"}},  //__
    /*3*/{{"parameter SLAVEID_WID="},{"0"}},  //__
    /*4*/{{"parameter AWLEN_WID="},{"4"}},
    /*5*/{{"parameter AWSIZE_WID="},{"3"}},
    /*6*/{{"parameter AWBURST_WID="},{"2"}},
    /*7*/{{"parameter AWLOCK_WID="},{"2"}},
    /*8*/{{"parameter AWCACHE_WID="},{"4"}},
    /*9*/{{"parameter AWPROT_WID="},{"3"}},
    /*10*/{{"parameter WSTRB_WID="},{"4"}},
    /*11*/{{"parameter BRESP_WID="},{"2"}},
    /*12*/{{"parameter RRESP_WID="},{"2"}},
    /*13*/{{"parameter ARLEN_WID="},{"4"}},
    /*14*/{{"parameter ARBURST_WID="},{"2"}},
    /*15*/{{"parameter ARLOCK_WID="},{"2"}},
    /*16*/{{"parameter ARCACHE_WID="},{"4"}},
    /*17*/{{"parameter ARPROT_WID="},{"3"}},
    /*18*/{{"parameter MASTER_WID="},{"0"}},//__
    /*19*/{{"parameter SLAVE_WID="},{"0"}}, //__
    /*20*/{{"parameter SLAVE_NUM="},{"0"}}, //__
    /*21*/{{"parameter MASTER_NUM="},{"0"}},    //__
    /*22*/{{"parameter SELMASTER_WID="},{"0"}}, //__
    /*23*/{{"parameter Wr_REQDEPTH_WID="},{"0"}}, //__
    /*24*/{{"parameter Rd_REQDEPTH_WID="},{"0"}}, //__
    /*25*/{{"parameter WrPermit_SLAVECNTWID="},{"0"}},  //__
    /*26*/{{"parameter RdPermit_SLAVECNTWID="},{"0"}},   //__
    /*27*/{{"parameter ARSIZE_WID="},{"3"}},
    /*28*/{{"parameter SELMASTER_RID="},{"0"}}
};
#else
extern char PARA[MAX_PARAMETER+1][2][80];
#endif

//  =================================================================
//  Function declaration
//  ----------------------------------------------------------------
unsigned int getMaxID(DefSlave *);
unsigned int genDef(DefMain *, DefMaster *, DefSlave *, int ReadWrite);
unsigned int getDefaultID(DefSlave *VAL_SLAVE);
unsigned int genPARA(void);
unsigned int DefBit(unsigned int In);

# else

# endif
