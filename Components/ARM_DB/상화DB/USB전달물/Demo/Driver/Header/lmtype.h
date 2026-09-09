///////////////////////////////////////////////////////////////////////
// This file contains LM board specific data structure & definitions
///////////////////////////////////////////////////////////////////////
#include	"types.h"

typedef struct HPI_REG_TAG {
	USHORT	hpi_ctrl_reg;
	USHORT	hpi_d0_reg;
	USHORT	hpi_d1_reg;
	USHORT	hpi_d2_reg;
	USHORT	hpi_d3_reg;
	USHORT	hpi_d4_reg;
	USHORT	hpi_d5_reg;
	USHORT	hpi_d6_reg;
	USHORT	hpi_d7_reg;
}HPI_REG;
