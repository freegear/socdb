/***************************************************************************
** Copyright © ARM Limited 1998.  All rights reserved.
*****************************************************************************
** 
** Flash Library required macros to enable\disable flash writes
**
*/

#define INTEL_FL_WRITE_EN  Integrator_Flash_Write_Enable()
#define INTEL_FL_WRITE_DIS Integrator_Flash_Write_Disable()

#define ATMEL_FL_WRITE_EN  Integrator_Boot_Flash_Write_Enable()
#define ATMEL_FL_WRITE_DIS Integrator_Boot_Flash_Write_Disable()

__inline void Integrator_Flash_Write_Enable (void)
{
	*(volatile unsigned int *)INTEGRATOR_EBI_CSR1 |= INTEGRATOR_EBI_WRITE_ENABLE;

	if (!(*(volatile unsigned int *)INTEGRATOR_EBI_CSR1 & INTEGRATOR_EBI_WRITE_ENABLE))
	{
		*(volatile unsigned int *)INTEGRATOR_EBI_LOCK = 0xA05F;
		*(volatile unsigned int *)INTEGRATOR_EBI_CSR1 |= INTEGRATOR_EBI_WRITE_ENABLE;
		*(volatile unsigned int *)INTEGRATOR_EBI_LOCK = 0;
	}

	*(volatile unsigned int *)INTEGRATOR_SC_CTRLS = INTEGRATOR_SC_CTRL_nFLVPPEN | INTEGRATOR_SC_CTRL_nFLWP;
}

__inline void Integrator_Flash_Write_Disable (void)
{
	*(volatile unsigned int *)INTEGRATOR_EBI_CSR1 &= ~INTEGRATOR_EBI_WRITE_ENABLE;

	if (*(volatile unsigned int *)INTEGRATOR_EBI_CSR1 & INTEGRATOR_EBI_WRITE_ENABLE)
	{
		*(volatile unsigned int *)INTEGRATOR_EBI_LOCK = 0xA05F;
		*(volatile unsigned int *)INTEGRATOR_EBI_CSR1 &= ~INTEGRATOR_EBI_WRITE_ENABLE;
		*(volatile unsigned int *)INTEGRATOR_EBI_LOCK = 0;
	}

	*(volatile unsigned int *)INTEGRATOR_SC_CTRLS = INTEGRATOR_SC_CTRL_nFLVPPEN | INTEGRATOR_SC_CTRL_nFLWP;
}

__inline void Integrator_Boot_Flash_Write_Enable (void)
{
	*(volatile unsigned int *)INTEGRATOR_EBI_CSR0 |= INTEGRATOR_EBI_WRITE_ENABLE;

	if (!(*(volatile unsigned int *)INTEGRATOR_EBI_CSR0 & INTEGRATOR_EBI_WRITE_ENABLE))
	{
		*(volatile unsigned int *)INTEGRATOR_EBI_LOCK = 0xA05F;
		*(volatile unsigned int *)INTEGRATOR_EBI_CSR0 |= INTEGRATOR_EBI_WRITE_ENABLE;
		*(volatile unsigned int *)INTEGRATOR_EBI_LOCK = 0;
	}

	*(volatile unsigned int *)INTEGRATOR_SC_CTRLS = INTEGRATOR_SC_CTRL_nFLVPPEN | INTEGRATOR_SC_CTRL_nFLWP;
}

__inline void Integrator_Boot_Flash_Write_Disable (void)
{
	*(volatile unsigned int *)INTEGRATOR_EBI_CSR0 &= ~INTEGRATOR_EBI_WRITE_ENABLE;

	if (*(volatile unsigned int *)INTEGRATOR_EBI_CSR0 & INTEGRATOR_EBI_WRITE_ENABLE)
	{
		*(volatile unsigned int *)INTEGRATOR_EBI_LOCK = 0xA05F;
		*(volatile unsigned int *)INTEGRATOR_EBI_CSR0 &= ~INTEGRATOR_EBI_WRITE_ENABLE;
		*(volatile unsigned int *)INTEGRATOR_EBI_LOCK = 0;
	}

	*(volatile unsigned int *)INTEGRATOR_SC_CTRLS = INTEGRATOR_SC_CTRL_nFLVPPEN | INTEGRATOR_SC_CTRL_nFLWP;
}
