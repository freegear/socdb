--------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : defs.vhd,v
--  File Revision          : 1.1.1.1
--  
--  Release Information    : PL050-REL1v1
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose          : Standard definitions for AMBA
--
--------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

package Defs is
  -----------------------------------------------------------------------------
  -- constant definitions for B_TRAN : transaction type
  -----------------------------------------------------------------------------
  -- address transfer
  constant TRAN_ATRAN   : std_logic_vector( 1 downto 0 ) := "00" ;
  -- internal transfer
  constant TRAN_ITRAN   : std_logic_vector( 1 downto 0 ) := "01" ;
  -- non-sequential transfer
  constant TRAN_NTRAN   : std_logic_vector( 1 downto 0 ) := "10" ;
  -- sequential transfer
  constant TRAN_STRAN   : std_logic_vector( 1 downto 0 ) := "11" ;
  -- high impedance
  constant TRAN_HIZ    : std_logic_vector( 1 downto 0 ) := "ZZ" ;
  -- undefined
  constant TRAN_X      : std_logic_vector( 1 downto 0 ) := "XX" ;

  type TRAN_S is ( ATRAN, ITRAN, NTRAN, STRAN, XXXX ) ;

  function To_TRAN_S( Transfer : std_logic_vector( 1 downto 0 ) )
    return TRAN_S ;
  
  -----------------------------------------------------------------------------
  --  constant definitions for B_SIZE : Bus Transfer size
  -----------------------------------------------------------------------------
  constant SIZE_BYTE  : std_logic_vector( 1 downto 0 ) := "00" ;
  constant SIZE_HALF  : std_logic_vector( 1 downto 0 ) := "01" ;
  constant SIZE_WORD  : std_logic_vector( 1 downto 0 ) := "10" ;
  constant SIZE_HIZ   : std_logic_vector( 1 downto 0 ) := "ZZ" ;
  constant SIZE_X     : std_logic_vector( 1 downto 0 ) := "XX" ;

  type SIZE_S is ( BYTE, HALF, WORD, XXXX ) ;

  function To_SIZE_S ( Size : std_logic_vector( 1 downto 0 ) )
    return SIZE_S ;

  -----------------------------------------------------------------------------
  --  B_MODE Definitions
  -----------------------------------------------------------------------------
  constant RES_POR       : std_ulogic_vector( 1 downto 0 ) := "00" ;
  constant RES_INI       : std_ulogic_vector( 1 downto 0 ) := "10" ;
  constant RES_RUN       : std_ulogic_vector( 1 downto 0 ) := "11" ;
  constant RES_X         : std_ulogic_vector( 1 downto 0 ) := "XX" ;

  type RES_S is ( POR, INI, RUN, XX ) ;

  function To_RES_S ( Resetin : std_ulogic_vector( 1 downto 0 ))
    return RES_S ;
  

  -----------------------------------------------------------------------------
  --  APBIF Definitions
  -----------------------------------------------------------------------------

  -- APB Address Bus Width
  constant APB_AddressWidth   : Positive := 16;

  -- APBIF states
  type APBIF_S is (S_IDLE, S_WAIT, S_STROBE, S_ERROR);

end Defs ;

package body Defs is

  function To_TRAN_S( Transfer : std_logic_vector( 1 downto 0 ) )
    return TRAN_S is
  begin
    case Transfer is
      when TRAN_ATRAN => return ATRAN ;
      when TRAN_ITRAN => return ITRAN ;
      when TRAN_NTRAN => return NTRAN ;
      when TRAN_STRAN => return STRAN ;
      when others     => return XXXX ;
    end case ;
  end To_TRAN_S ;

  function To_SIZE_S ( Size : std_logic_vector( 1 downto 0 ) )
    return SIZE_S is
  begin
    case Size is
      when SIZE_BYTE    => return ( BYTE ) ;
      when SIZE_HALF    => return ( HALF ) ;
      when SIZE_WORD    => return ( WORD ) ;
      when others       => return ( XXXX ) ;
    end case ;
  end To_SIZE_S ;

  function To_RES_S ( Resetin : std_ulogic_vector( 1 downto 0 ))
    return RES_S is
  begin
    case Resetin is
      when RES_POR     => return ( POR ) ;
      when RES_INI     => return ( INI ) ;
      when RES_RUN     => return ( RUN ) ;
      when others      => return ( XX ) ;
    end case ;
  end To_RES_S ;

end Defs ;
