/***************************************************************************
 * Copyright © ARM Limited 1998.  All rights reserved.
 ***************************************************************************/
/*****************************************************************************

        This file contains Integrator specfic C code.

******************************************************************************/

#include	"uhal.h"
#include	"errno.h"
#include	"uart.h"
#include	"mmu_h.h"
/*
 * ** Externals.
 */
extern U32 uHALiv_MemorySize;
extern void uHALir_PCIInit(void);

/* Initialise the LED(s) to given value - usually 0 */
void uHALir_SetLEDs(U32 value)
{
    volatile U32 *LedBank = (U32 *) LED_BANK;

    /*
     * ** Poll the scan in progress bit
     * **
     * ** If the H/W is in the process of writing to the LED's then writing
     * ** to the control register will screw things up
     */

    while (*(volatile U32 *)INTEGRATOR_DBG_ALPHA & 1) ;

    *LedBank = value;
}

/* Set the state of the specified LED */
S32 uHALr_WriteLED(U32 number, U32 state)
{
    U32 mask;
    volatile U32 *LedBank = (U32 *) LED_BANK;

    mask = 1 << (number - 1);

    /*
     * ** Poll the scan in progress bit
     * **
     * ** If the H/W is in the process of writing to the LED's then writing
     * ** to the control register will screw things up
     */

    while (*(volatile U32 *)INTEGRATOR_DBG_ALPHA & 1) ;

    /* Want to turn LED on, determine which way we need to flip the bit */

    if (state)
        *LedBank |= mask;       /* Set the bit */
    else
        *LedBank &= ~mask;      /* Reset the bit */

    return (OK);
}

/*
 * Update the register on the target which masks the irq passed to the CPU.
 * This routine is target-specific.  Turn the interrupt source off.
 */
void uHALir_MaskIrq(U32 irq)
{
    int header_number;
    volatile unsigned int *IRQBase;

    if (irq < INTEGRATOR_CM_INT0)
    {
        header_number = *((volatile unsigned int *)INTEGRATOR_HDR_STAT) & 3;
        IRQBase = (unsigned int *)(INTEGRATOR_IC_BASE + (header_number << 6));
    }
    else
    {
        IRQBase = (unsigned int *)INTEGRATOR_HDR_IC;
        irq -= INTEGRATOR_CM_INT0;
    }

    IRQBase[(IRQ_ENABLE_CLEAR / sizeof(unsigned int))] = (1 << irq);
}

/*
 * Update the register on the target which masks the irq passed to the CPU.
 * This routine is target-specific.  Turn the interrupt source on.
 */
void uHALir_UnmaskIrq(U32 irq)
{
    int header_number;
    volatile unsigned int *IRQBase;

    if (irq < INTEGRATOR_CM_INT0)
    {
        header_number = *((volatile unsigned int *)INTEGRATOR_HDR_STAT) & 3;
        IRQBase = (unsigned int *)(INTEGRATOR_IC_BASE + (header_number << 6));
    }
    else
    {
        IRQBase = (unsigned int *)INTEGRATOR_HDR_IC;
        irq -= INTEGRATOR_CM_INT0;
    }

    IRQBase[(IRQ_ENABLE_SET / sizeof(unsigned int))] = (1 << irq);
}

unsigned int uHALir_ReadCPUIdFromBoard(void)
{
    unsigned int *headerP = (unsigned int *)INTEGRATOR_HDR_PROC;

    return (*headerP);
}

/*============================================================================
 *
 *  routine:     getPlatformId()
 *
 *  parameters:  void
 *
 *  description: this routine will return the current platform ID
 *
 *  calls:       none
 *
 *  returns:     platform ID 
 *
 */
void uHALr_GetPlatformInfo(pInfoType p)
{
    uHALr_memset((char *)p, 0, sizeof(infoType));

    p->memType = 0;
    p->memSize = uHALiv_MemorySize;
    p->cpuId = uHALir_CpuIdRead();
    p->platformId = PLATFORM_ID;

    return;
}

/*============================================================================
 *
 * routine:	uHALr_PCIHost()
 *
 * parameters:	void
 *
 * description:	This routine determines if the target is PCI Host.
 *
 * calls:	none
 *
 * returns:	FALSE if not PCI Host
 *
 */
U32 uHALr_PCIHost(void)
{
#if uHAL_PCI != 0
    return (TRUE);
#else
    return (FALSE);
#endif
}

#if uHAL_PCI != 0

/*
 * 
 * The V3 PCI interface chip in Integrator provides several windows from
 * local bus memory into the PCI memory areas.   Unfortunately, there
 * are not really enough windows for our usage, therefore we reuse 
 * one of the windows for access to PCI configuration space.  The
 * memory map is as follows:
 * 
 * Local Bus Memory         Usage
 * 
 * 80000000 - 8FFFFFFF      PCI memory.  256M non-prefetchable
 * 90000000 - 9FFFFFFF      PCI memory.  256M prefetchable
 * B0000000 - B0FFFFFF      PCI IO.  16M
 * B8000000 - B8FFFFFF      PCI Configuration. 16M
 * 
 * There are three V3 windows, each described by a pair of V3 registers.
 * These are LB_BASE0/LB_MAP0, LB_BASE1/LB_MAP1 and LB_BASE2/LB_MAP2.
 * Base0 and Base1 can be used for any type of PCI memory access.   Base2
 * can be used either for PCI I/O or for I20 accesses.  By default, uHAL
 * uses this only for PCI IO space.
 * 
 * PCI Memory is mapped so that assigned addresses in PCI Memory match
 * local bus memory addresses.  In other words, if a PCI device is assigned
 * address 80200000 then that address is a valid local bus address as well
 * as a valid PCI Memory address.  PCI IO addresses are mapped to start
 * at zero.  This means that local bus address B0000000 maps to PCI IO address
 * 00000000 and so on.   Device driver writers need to be aware of this 
 * distinction.
 * 
 * Normally these spaces are mapped using the following base registers:
 * 
 * Usage Local Bus Memory         Base/Map registers used
 * 
 * Mem   80000000 - 8FFFFFFF      LB_BASE0/LB_MAP0
 * Mem   90000000 - 9FFFFFFF      LB_BASE1/LB_MAP1
 * A0000000 - AFFFFFFF      
 * IO    B0000000 - B0FFFFFF      LB_BASE2/LB_MAP2
 * Cfg   B8000000 - B8FFFFFF      
 * 
 * This means that I20 and PCI configuration space accesses will fail.
 * When PCI configuration accesses are needed (via the uHAL PCI 
 * configuration space primitives) we must remap the spaces as follows:
 * 
 * Usage Local Bus Memory         Base/Map registers used
 * 
 * Mem   80000000 - 8FFFFFFF      LB_BASE0/LB_MAP0
 * Mem   90000000 - 9FFFFFFF      LB_BASE0/LB_MAP0
 * A0000000 - AFFFFFFF      
 * IO    B0000000 - B0FFFFFF      LB_BASE2/LB_MAP2
 * Cfg   B8000000 - B8FFFFFF      LB_BASE1/LB_MAP1
 * 
 * To make this work, the code depends on overlapping windows working.
 * The V3 chip translates an address by checking its range within 
 * each of the BASE/MAP pairs in turn (in ascending register number
 * order).  It will use the first matching pair.   So, for example,
 * if the same address is mapped by both LB_BASE0/LB_MAP0 and
 * LB_BASE1/LB_MAP1, the V3 will use the translation from 
 * LB_BASE0/LB_MAP0.
 * 
 * To allow PCI Configuration space access, the code enlarges the
 * window mapped by LB_BASE0/LB_MAP0 from 256M to 512M.  This occludes
 * the windows currently mapped by LB_BASE1/LB_MAP1 so that it can
 * be remapped for use by configuration cycles.
 * 
 * At the end of the PCI Configuration space accesses, 
 * LB_BASE1/LB_MAP1 is reset to map PCI Memory.  Finally the window
 * mapped by LB_BASE0/LB_MAP0 is reduced in size from 512M to 256M to
 * reveal the now restored LB_BASE1/LB_MAP1 window.
 * 
 * NOTE: We do not set up I20 mapping.  I suspect that this is only
 * for an intelligent (target) device.  Using I2O disables most of
 * the mappings into PCI memory.
 */

// V3 access routines
#define _V3Write16(o,v) (*(volatile U16 *)(PCI_V3_BASE + (U32)(o)) = (U16)(v))
#define _V3Read16(o)    (*(volatile U16 *)(PCI_V3_BASE + (U32)(o)))

#define _V3Write32(o,v) (*(volatile U32 *)(PCI_V3_BASE + (U32)(o)) = (U32)(v))
#define _V3Read32(o)    (*(volatile U32 *)(PCI_V3_BASE + (U32)(o)))

void _V3OpenConfigWindow(void)
{
    // Set up base0 to see all 512Mbytes of memory space (not prefetchable), this
    //   frees up base1 for re-use by configuration memory
    _V3Write32(V3_LB_BASE0, ((PCI_MEM_BASE & 0xFFF00000) | 0x90 | V3_LB_BASE_M_ENABLE));
    // Set up base1 to point into configuration space, note that MAP1 register is
    //   set up by uHALir_PCIMakeConfigAddress().
    _V3Write32(V3_LB_BASE1, ((PCI_CONFIG_BASE & 0xFFF00000) | 0x40 | V3_LB_BASE_M_ENABLE));
}

void _V3CloseConfigWindow(void)
{
    // Reassign base1 for use by prefetchable PCI memory 
    _V3Write32(V3_LB_BASE1, (((PCI_MEM_BASE + SZ_256M) & 0xFFF00000) | 0x84 | V3_LB_BASE_M_ENABLE));
    _V3Write16(V3_LB_MAP1, (((PCI_MEM_BASE + SZ_256M) & 0xFFF00000) >> 16) | 0x0006);
    // And shrink base0 back to a 256M window (NOTE: MAP0 already correct)
    _V3Write32(V3_LB_BASE0, ((PCI_MEM_BASE & 0xFFF00000) | 0x80 | V3_LB_BASE_M_ENABLE));
}

/*============================================================================
 *
 * routine:	uHALir_PCIMapInterrupt()
 *
 * parameters:	bus = which pin (A=1, B=2, C=3, D=4)
 *              slot = which slot (IDSEL = slot + 11)
 *
 * description:	this routine returns the interrupt # that this slot/pin 
 *              combination will use.
 *
 * calls:	none
 *
 * returns:	Board specific interrupt #
 *
 */
U8 uHALir_PCIMapInterrupt(U8 pin, U8 slot)
{
#define INTA IRQ_PCIINT0
#define INTB IRQ_PCIINT1
#define INTC IRQ_PCIINT2
#define INTD IRQ_PCIINT3

    // DANGER! For now this is the SDM interrupt table...
    char irq_tab[12][4] =
    {
    // INTA  INTB  INTC  INTD
        {INTA, INTB, INTC, INTD},  // idsel 20, slot  9
         {INTB, INTC, INTD, INTA},  // idsel 21, slot 10
         {INTC, INTD, INTA, INTB},  // idsel 22, slot 11
         {INTD, INTA, INTB, INTC},  // idsel 23, slot 12
         {INTA, INTB, INTC, INTD},  // idsel 24, slot 13
         {INTB, INTC, INTD, INTA},  // idsel 25, slot 14
         {INTC, INTD, INTA, INTB},  // idsel 26, slot 15
         {INTD, INTA, INTB, INTC},  // idsel 27, slot 16
         {INTA, INTB, INTC, INTD},  // idsel 28, slot 17
         {INTB, INTC, INTD, INTA},  // idsel 29, slot 18
         {INTC, INTD, INTA, INTB},  // idsel 30, slot 19
         {INTD, INTA, INTB, INTC}  // idsel 31, slot 20
    };

    // if PIN = 0, default to A
    if (pin == 0)
        pin = 1;

    // return the magic number
    return irq_tab[slot - 9][pin - 1];
}

/*============================================================================
 *
 * routine:	uHALir_PCIMakeConfigAddress()
 *
 * parameters:	bus = which bus
 *              device = which device
 *              function = which function
 *		offset = configuration space register we are interested in
 *
 * description:	this routine will generate a platform dependant config
 *		address.
 *
 * calls:	none
 *
 * returns:	configuration address to play on the PCI bus
 *
 * To generate the appropriate PCI configuration cycles in the PCI 
 * configuration address space, you present the V3 with the following pattern 
 * (which is very nearly a type 1 (except that the lower two bits are 00 and
 * not 01).   In order for this mapping to work you need to set up one of
 * the local to PCI aperatures to 16Mbytes in length translating to
 * PCI configuration space starting at 0x0000.0000.
 *
 * PCI configuration cycles look like this:
 *
 * Type 0:
 *
 *  3 3|3 3 2 2|2 2 2 2|2 2 2 2|1 1 1 1|1 1 1 1|1 1 
 *  3 2|1 0 9 8|7 6 5 4|3 2 1 0|9 8 7 6|5 4 3 2|1 0 9 8|7 6 5 4|3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * | | |D|D|D|D|D|D|D|D|D|D|D|D|D|D|D|D|D|D|D|D|D|F|F|F|R|R|R|R|R|R|0|0|
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *
 *	31:11	Device select bit.
 * 	10:8	Function number
 * 	 7:2	Register number
 *
 * Type 1:
 *
 *  3 3|3 3 2 2|2 2 2 2|2 2 2 2|1 1 1 1|1 1 1 1|1 1 
 *  3 2|1 0 9 8|7 6 5 4|3 2 1 0|9 8 7 6|5 4 3 2|1 0 9 8|7 6 5 4|3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * | | | | | | | | | | |B|B|B|B|B|B|B|B|D|D|D|D|D|F|F|F|R|R|R|R|R|R|0|1|
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *
 *	31:24	reserved
 *	23:16	bus number (8 bits = 128 possible buses)
 *	15:11	Device number (5 bits)
 *	10:8	function number
 *	 7:2	register number
 *  
 */

U32 uHALir_PCIMakeConfigAddress(U32 bus, U32 device, U32 function, U32 offset)
{
    U32 address, devicebit;
    U16 mapaddress;

    if (bus == 0)
    {
        /* local bus segment so need a type 0 config cycle */
        /* build the PCI configuration "address" with one-hot in A31-A11 */
        address = PCI_CONFIG_BASE;
        address |= ((function & 0x07) << 8);
        address |= offset & 0xFF;
        mapaddress = 0x000A;    /* 101=>config cycle, 0=>A1=A0=0 */
        devicebit = (1 << (device + 11));
        if ((devicebit & 0xFF000000) != 0)
        {
            /* high order bits are handled by the MAP register */
            mapaddress |= (devicebit >> 16);
        }
        else
        {
            /* low order bits handled directly in the address */
            address |= devicebit;
        }
    }
    else
    {                           /* bus !=0 */
        /* not the local bus segment so need a type 1 config cycle */
        /* A31-A24 are don't care (so clear to 0) */
        mapaddress = 0x000B;    /* 101=>config cycle, 1=>A1&A0 from PCI_CFG */
        address = PCI_CONFIG_BASE;
        address |= ((bus & 0xFF) << 16);  /* bits 23..16 = bus number      */
        address |= ((device & 0x1F) << 11);  /* bits 15..11 = device number   */
        address |= ((function & 0x07) << 8);  /* bits 10..8  = function number */
        address |= offset & 0xFF;  /* bits  7..0  = register number */
    }
    _V3Write16(V3_LB_MAP1, mapaddress);

    return address;
}

/*============================================================================
 *
 * routine:	uHALr_PciCfgRead8()
 * 		uHALr_PciCfgRead16()
 * 		uHALr_PciCfgRead32()
 *
 * parameters:	bus = bus #
 *              device = device #
 *              function = function #
 *		offset = offset into PCI config space for current BAR
 *		data    = value to be written
 *
 * description:	These routines read a byte, short or long value from the given
 *		PCI config register.
 *
 * calls:	uHALir_PciMakeConfigAddress()
 *
 * returns:	data - value read.
 */

U8 uHALr_PCICfgRead8(U32 bus, U32 device, U32 function, U32 offset)
{
    PU8 pAddress;
    U8 data;

    // open the (closed) configuration window from local bus memory 
    _V3OpenConfigWindow();

    /* generate the address of correct configuration space */
    pAddress = (PU8) (uHALir_PCIMakeConfigAddress(bus, device,
                                                  function, offset));

    /* now that we have valid params, go read the config space data */
    data = *pAddress;

    // close the window
    _V3CloseConfigWindow();

    return (data);
}

U16 uHALr_PCICfgRead16(U32 bus, U32 device, U32 function, U32 offset)
{
    PU16 pAddress;
    U16 data;

    // open the (closed) configuration window from local bus memory 
    _V3OpenConfigWindow();

    /* generate the address of correct configuration space */
    pAddress = (PU16) (uHALir_PCIMakeConfigAddress(bus, device,
                                                   function, offset));

    /* now that we have valid params, go read the config space data */
    data = *pAddress;

    // close the window
    _V3CloseConfigWindow();

    return (data);
}

U32 uHALr_PCICfgRead32(U32 bus, U32 device, U32 function, U32 offset)
{
    PU32 pAddress;
    U32 data;

    // open the (closed) configuration window from local bus memory 
    _V3OpenConfigWindow();

    /* generate the address of correct configuration space */
    pAddress = (PU32) (uHALir_PCIMakeConfigAddress(bus, device,
                                                   function, offset));

    /* now that we have valid params, go read the config space data */
    data = *pAddress;

    // close the window
    _V3CloseConfigWindow();

    return (data);
}

/*============================================================================
 *
 * routine:	uHALr_PCICfgWrite8()
 * 		uHALr_PCICfgWrite16()
 * 		uHALr_PCICfgWrite32()
 *
 * parameters:	bus = bus #
 *              device = device #
 *              function = function #
 *		offset = offset into PCI config space for current BAR
 *		data    = value to be written
 *		pStatus = SUCCESS/FAIL flag
 *
 * description:	These routines write a byte, short or long value to the given
 *		PCI config register.
 *
 * calls:	uHALir_PCIMakeConfigAddress()
 *
 * returns:	none
 */

void uHALr_PCICfgWrite8(U32 bus, U32 device, U32 function, U32 offset, U32 data)
{
    volatile PU8 pAddress;

    // open the (closed) configuration window from local bus memory 
    _V3OpenConfigWindow();

    /* V3 workaround */
    if (bus != 0) {
      pAddress = (PU8)PCI_CONFIG_BASE ;
      *pAddress = (U8)data ;
    }

    /* generate the address of correct configuration space */
    pAddress = (PU8) (uHALir_PCIMakeConfigAddress(bus, device,
                                                  function, offset));

    /* now that we have valid params, go write the config space data */
    *pAddress = (U8) data;

    // close the window
    _V3CloseConfigWindow();

    return;
}

void uHALr_PCICfgWrite16(U32 bus, U32 device, U32 function, U32 offset, U32 data)
{
    volatile PU16 pAddress;

    // open the (closed) configuration window from local bus memory
    _V3OpenConfigWindow();

    /* V3 workaround */
    if (bus != 0) {
      pAddress = (PU16)PCI_CONFIG_BASE ;
      *pAddress = (U16)data ;
    }

    /* generate the address of correct configuration space */
    pAddress = (PU16) (uHALir_PCIMakeConfigAddress(bus, device,
                                                   function, offset));

    /* now that we have valid params, go write the config space data */
    *pAddress = (U16) data;

    // close the window
    _V3CloseConfigWindow();

    return;
}

void uHALr_PCICfgWrite32(U32 bus, U32 device, U32 function, U32 offset, U32 data)
{
    volatile PU32 pAddress;

    // open the (closed) configuration window from local bus memory 
    _V3OpenConfigWindow();

    /* V3 workaround */
    if (bus != 0) {
      pAddress = (PU32)PCI_CONFIG_BASE ;
      *pAddress = (U32)data ;
    }

    /* generate the address of correct configuration space */
    pAddress = (PU32) (uHALir_PCIMakeConfigAddress(bus, device,
                                                   function, offset));

    /* now that we have valid params, go write the config space data */
    *pAddress = (U32) data;

    // close the window
    _V3CloseConfigWindow();

    return;
}

#endif

/*============================================================================
 *
 *  routine:     uHALir_PlatformInit()
 *
 *  parameters:  void
 *
 *  description: this routine does platform specific system initialization.
 *
 *  calls:       none
 *
 *  returns:     void
 *
 */
void uHALir_PlatformInit(void)
{
#ifdef DEBUG
    /* Debug - write to LEDs */
    uHALir_SetLEDs(RED_LED + GREEN_LED);
#endif

#ifndef SEMIHOSTED
    /* Turn on MMU & caches by default */
    uHALr_InitMMU(EnableMMU | IC_ON | DC_ON | WB_ON);
#endif

    /* reset the COM port that we can use */
    uHALr_ResetPort();

    /* PCIInit already done in boot-up, but if a different configuration
     * were required, it could go here INSTEAD.
     * uHALir_PCIInit() ;
     */

#if uHAL_HEAP != 0
	uHALr_LibraryInit();
#endif

#if uHAL_PCI
    uHALir_PCIInit();
#endif

#ifdef DEBUG
    uHALir_SetLEDs(YELLOW_LED + GREEN_LED);
#endif
}

/*
 * Integrator Timer register definitions.
 *
 * Integrator has 2 fixed rate timers.
 */

typedef struct TimerStruct
{
    unsigned long TimerLoad;
    unsigned long TimerValue;
    unsigned long TimerControl;
    unsigned long TimerClear;
}
TimerStruct_t;

TimerStruct_t *TimerBase[] =
{0, (TimerStruct_t *) INTEGRATOR_TIMER1_BASE,
 (TimerStruct_t *) INTEGRATOR_TIMER2_BASE};

extern struct uHALis_Timer uHALiv_TimerStatus[MAX_TIMER + 1];

void uHALir_PlatformClearTimerInterrupt(U32 timer)
{
    volatile TimerStruct_t *Timer = TimerBase[timer];

    /* clear the interrupt (if any) */
    Timer->TimerClear = 1;
}

/* This routine stops the specified timer hardware. */
void uHALir_PlatformDisableTimer(U32 timer)
{
    volatile TimerStruct_t *Timer = TimerBase[timer];

    /* clear the interrupt (if any) */
    Timer->TimerClear = 1;

    Timer->TimerControl = 0;    /* Clear control register with will disable timer */
}

/* This routine starts the specified timer hardware. */
void uHALir_PlatformEnableTimer(U32 timer)
{
    struct uHALis_Timer *action = &uHALiv_TimerStatus[timer];
    volatile TimerStruct_t *Timer = TimerBase[timer];
    U32 ticks;
    U32 control;

    action->ClearInterruptRtn = &uHALir_PlatformClearTimerInterrupt;

    /* clear the interrupt (if any) */
    Timer->TimerClear = 1;

    /*
     * ** Period is in usec.
     * ** Calculate the number of ticks required.
     */
    ticks = action->period * TICKS_PER_uSEC;

    if (ticks >= 0x100000)
    {
        ticks >>= 8;            /* Divide by 256 */
        control = 0x88;         /* Enable, Clock divided by 256 */
    }
    else if (ticks >= 0x10000)
    {
        ticks >>= 4;            /* Divide by 16 */
        control = 0x84;         /* Enable, Clock divided by 16 */
    }
    else
    {
        control = 0x80;         /* Enable */
    }

    /* set its count */
    Timer->TimerLoad = ticks;

    if (action->state == T_INTERVAL)
    {
        action->hw_interval = 1;  /* H/W supports interval timer operation */
        control |= 0x40;        /* Periodic */
    }

    Timer->TimerControl = control;
}

/* Initialise the serial port
 * NOTE: HOST_COMPORT and OS_COMPORT must be defined (see platform.[sh])
 *
 * uHALr_ResetPort() is aliased to be 
 * uHALir_InitSerial(OS_COMPORT, DEFAULT_OS_BAUD)
 */
void uHALir_InitSerial(unsigned int port, unsigned int baudRate)
{
#ifdef SEMIHOSTED

    /* If running under a debugger, don't re-initialise its comport. */
    if (HOST_COMPORT != port)

#endif

    {
        /* first, disable everything */
        IO_WRITE(port + AMBA_UARTCR, 0x0);

        /* Set baud rate */
        IO_WRITE(port + AMBA_UARTLCR_M, ((baudRate & 0xf00) >> 8));
        IO_WRITE(port + AMBA_UARTLCR_L, (baudRate & 0xff));

        /* ----------v----------v----------v----------v---------- */
        /* NOTE: MUST BE WRITTEN LAST (AFTER UARTLCR_M & UARTLCR_L) */
        /* ----------^----------^----------^----------^---------- */
        /* set the UART to be 8 bits, 1 stop bit, no parity, fifo enabled */
        IO_WRITE(port + AMBA_UARTLCR_H, (AMBA_UARTLCR_H_WLEN_8 | AMBA_UARTLCR_H_FEN));

        /* finally, enable the uart */
        IO_WRITE(port + AMBA_UARTCR, AMBA_UARTCR_UARTEN);
    }
}
