
# ifndef APINTCFG_H
# define APINTCFG_H

 COMMENT //
 COMMENT // Copyright: 
 COMMENT // ----------------------------------------------------------------
 COMMENT // This confidential and proprietary software may be used only as
 COMMENT // authorised by a licensing agreement from ARM Limited
 COMMENT //   (C) COPYRIGHT 2001,2002 ARM Limited
 COMMENT //       ALL RIGHTS RESERVED
 COMMENT // The entire notice above must be reproduced on all authorised
 COMMENT // copies and copies may only be made to the extent permitted
 COMMENT // by a licensing agreement from ARM Limited.
 COMMENT // ----------------------------------------------------------------
 COMMENT // File:     apintcfg.h,v
 COMMENT // Revision: 1.23
 COMMENT // ----------------------------------------------------------------
 COMMENT // 
 COMMENT //  ----------------------------------------
 COMMENT //  Version and Release Control Information:
 COMMENT // 
 COMMENT //  File Name              : apintcfg.h.rca
 COMMENT //  File Revision          : 1.9
 COMMENT // 
 COMMENT //  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 COMMENT //  ----------------------------------------
 COMMENT //
 COMMENT /* This file contains configuration data mainly relating    */
 COMMENT /* to the interrupt controller.                             */
 COMMENT /* The file is written in a format so that C and assembler  */
 COMMENT /* files can include it. Specifically put spaces in front of */
 COMMENT /* the comment macro, a space after each #, and put each     */
 COMMENT /* of the # in the first column.                             */

 COMMENT /* These are the defined platforms supported.  Interrupt     */
 COMMENT /* controller will differ between these platforms            */

 COMMENT /* Integrator platform - this assumes an RPS controller in the */
 COMMENT /* Integrator AP, with an optional logic module.  If present,  */
 COMMENT /* the logic module includes an RPS controller                 */
# define apVERSION_INTEGRATOR       0x1

 COMMENT /* ARMulator model, assuming a single RPS controller           */
# define apVERSION_ARMULATOR        0x2

 COMMENT /* A single vectored interrupt controller PL190                */
# define apVERSION_VECTORED         0x4

 COMMENT /* Integrator platform - this assumes an RPS controller in the */
 COMMENT /* Integrator AP, with an optional logic module.  If present,  */
 COMMENT /* the logic module includes a vectored PL190 controller       */
# define apVERSION_VIC_ON_LM        0x5

 COMMENT /* Integrator platform - this assumes an RPS controller in the */
 COMMENT /* Integrator AP, with an optional logic module.  If present,  */
 COMMENT /* the logic module includes no interrupt controller           */
# define apVERSION_NONE_ON_LM       0x9

 COMMENT /* Integrator platform - this assumes an RPS controller in the */
 COMMENT /* Integrator AP, with an optional logic module.  If present,  */
 COMMENT /* the logic module includes a vectored PL190 controller.      */
 COMMENT /* nVICFIQ is connected to ARM FIQ, nVICIRQ is unconnected.    */
# define apVERSION_VIC_ON_LM_FIQ    0x15

 COMMENT /* A single vectored interrupt controller PL192                */
# define apVERSION_VECTORED_PL192   0x24

 COMMENT /* Integrator platform - this assumes an RPS controller in the */
 COMMENT /* Integrator AP, with an optional logic module.  If present,  */
 COMMENT /* the logic module includes a vectored PL192 controller.      */
 COMMENT /* nVICFIQ is connected to ARM FIQ, nVICIRQ to nVICIRQ         */
# define apVERSION_VIC_PL192_ON_LM  0x25

 COMMENT /* These are where the actual version to be used is set. */
 COMMENT /* This should be one of the options above.*/
# define apINT_VERSION    apVERSION_INTEGRATOR

 COMMENT /* Don't alter, these constant options used by next paragraph  */
# define apCONFIG_ARM_ONLY      0
# define apCONFIG_ARM_AND_THUMB 1
# define apCONFIG_THUMB_ONLY    2

 COMMENT /* Set to apCONFIG_ARM_AND_THUMB if the processor architecture */
 COMMENT /* supports Thumb state, or apCONFIG_ARM_ONLY otherwise*/
# define apCONFIG_CORE_SUPPORTS  apCONFIG_ARM_AND_THUMB

 COMMENT /* The Micropack (INT) interrupt handler is not re-entrant and   */
 COMMENT /* will ignore this parameter                                    */
 COMMENT /* The Vectored Interrupt Controller can be configured as        */
 COMMENT /* re-entrant by setting this parameter to '1'.                  */
# define apOS_CONFIG_INT_REENTRANT 0

 COMMENT /* Set this to one of the options above to control whether       */
 COMMENT /* Thumb veneers and BX instructions are used in the interrupt   */
 COMMENT /* dispatch routines                                             */
 COMMENT /*     apCONFIG_ARM_ONLY if ISRs are in ARM code                 */
 COMMENT /*     apCONFIG_THUMB_ONLY if ISRs are in Thumb code             */
# define apOS_CONFIG_INT_ISR_ISA apCONFIG_ARM_ONLY

 COMMENT /* Set these to 1 if extra code should be called either before   */
 COMMENT /* the interrupt dispatcher is called or after (correspondingly) */
 COMMENT /* Set to 0 to just save/restore state either side (quicker but  */
 COMMENT /* means harder to hook into process switching operating systems.*/
# define apOS_CONFIG_INT_USE_PREDISPATCH_CODE  0
# define apOS_CONFIG_INT_USE_POSTDISPATCH_CODE 0

# define apOS_CONFIG_VIC_USE_PREDISPATCH_CODE  0
# define apOS_CONFIG_VIC_USE_POSTDISPATCH_CODE 0

 COMMENT /* Although each interrupt controller may control 32 interrupt   */
 COMMENT /* sources, you may optionally define apOS_INT_CONFIG_SOURCES_USED */
 COMMENT /* to specify the total number of sources in use across all      */
 COMMENT /* (RPS) interrupt controllers.  This will reduce the storage    */
 COMMENT /* space used by the interrupt controller.*/
# define apOS_INT_CONFIG_SOURCES_USED 16

 COMMENT /* In a real system, a Vectored Interrupt Controller (if present)*/
 COMMENT /* should be placed at 0xFFFFF000 in the memory map.  This will  */
 COMMENT /* mean that a dispatcher need not be called for interrupts, so  */
 COMMENT /* saving a number of cycles.  See the PL190 documentation.      */
# define apOS_CONFIG_VIC_AT_0xFFFFF000 0

 COMMENT /* Allows to use the only active registered FIQ interrupt source */
# define  apOS_CONFIG_VIC_SINGLE_FIQ 0 

 COMMENT /* Allows master VIC #0 to be solely responsible for blocking    */  
 COMMENT /* low level interrupts from the daisy chained VICs.             */
# define  apOS_CONFIG_VIC_0_BLOCKING_MODE 0         


 COMMENT /* This defines number of PL192 VICs in the system               */  
# define  apOS_CONFIG_VIC_NUMBER 2

 END
 
# endif
