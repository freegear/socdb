-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : buswatch.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
--
-- ---------------------------------------------------------------------
-- Purpose : Buswatcher for AMBA signals. This is a simulation tool, 
--           it has no hardware function.
--
-- --=================================================================--

library ieee;
use ieee.std_logic_1164.all;

library common ;
use     common.params.all;
use     common.Defs.all;

library sys ;
use     sys.buswatch_params.all;

entity amba_buswatch is
  port(
       AGNTARM   :  in    std_ulogic;
       AREQARM   :  in    std_ulogic;
       
       BA        :  in    std_logic_vector(31 downto 0);
       BCLK      :  in    std_ulogic;
       BD        :  in    std_logic_vector(31 downto 0);
       BERROR    :  in    std_logic;
       BLAST     :  in    std_logic;
       BLOK      :  in    std_logic;
       BPROT     :  in    std_logic_vector(1 downto 0);
       BnRES     :  in    std_ulogic;
       BSIZE     :  in    std_logic_vector(1 downto 0);
       BTRAN     :  in    std_logic_vector(1 downto 0);
       BWAIT     :  in    std_logic;
       BWRITE    :  in    std_logic;

       DSELAPB   :  in    std_ulogic
       );
end amba_buswatch;

architecture only of amba_buswatch is

  type       t_edge is (FALLING, RISING);
  
  constant SuppressOnReset : boolean := TRUE;
  signal   InReset         : boolean;
  signal   B_TRAND1        : std_logic_vector(1 downto 0);

  signal write  : boolean := FALSE;
  signal waited : boolean := FALSE;
  signal atran  : boolean := TRUE;
  
  -- Long live errhandler_f !!
  procedure errhandler(message : in string; strength : 
                                                  in severity_level) is
  begin
    assert (now = 0 ns)
      report message
      severity strength;
  end errhandler;

  function IsZ(sig : std_logic) return boolean is
    variable j : boolean := TRUE;
  begin
      j := j and (sig = 'Z' or sig = 'L' or sig = 'H');
    return j;
  end IsZ;
  
  function IsZ(sig : std_logic_vector) return boolean is
    variable j : boolean := TRUE;
  begin
    for i in sig'range loop
      j := j and (sig(i) = 'Z' or sig(i) = 'L' or sig(i) = 'H');
    end loop;
    return j;
  end IsZ;
  
--  procedure setup_to_edge(edge : std_logic;
--                          edge_name : string;
--                          edge_type : t_edge;
--                          sig  : std_logic;
--                          sig_name  : string;
--                          setup_time : time) is
--  
--  begin
--    if(edge_type = FALLING) then
--      if(falling_edge(edge) and not(sig'stable(setup_time))) then
--        errhandler(sig_name & "setup to " & edge_name & "falling 
--                                                violated", error);
--      end if;
--    else
--      if(rising_edge(edge) and not(sig'stable(setup_time))) then
--        errhandler(sig_name & "setup to " & edge_name & "rising 
--                                                violated", error);
--      end if;
--    end if;
--  end setup_to_edge;
  
begin

  reset_proc : process(BnRES)
  begin
    if((BnRES = RES_POR(0)) or (BnRES = RES_INI(0))) then
      InReset <= TRUE;
    else
      InReset <= FALSE;
    end if;
  end process reset_proc;
  
------------------------------------------------------------------------
--  BA checking
------------------------------------------------------------------------
  Check_B_A : process (BCLK, BWAIT, BA, BTRAN)
  begin
    if(InReset = FALSE or SuppressOnReset = FALSE) then
      if(Is_X(BA) and falling_edge(BCLK) and not(BTRAN = TRAN_ATRAN)) 
                                                                   then
        errhandler("BA unknown", error);
      end if;
      if(falling_edge(BCLK) and not(BA'stable(tsu_ba_bclk))) then
        errhandler("BA setup to BCLK falling violated", error);
      end if;
      if(BCLK = '0' and BA'event and not(B_TRAND1 = TRAN_ATRAN)) then
        errhandler("BA changing during BCLK low", error);
      end if;
    end if;
  end process Check_B_A;

------------------------------------------------------------------------
--  BCLK checking
------------------------------------------------------------------------
    Check_B_CLK : process (BCLK)
    begin
      if(Is_X(BCLK)) then
        errhandler("BCLK unknown", error);
      end if;
    end process Check_B_CLK;

------------------------------------------------------------------------
--  BD checking
------------------------------------------------------------------------
  Check_B_D : process (BCLK)
  begin
    write <= write;
    waited <= waited;
    atran <= atran;
    if (rising_edge(BCLK)) then
      write  <= (To_X01(BWRITE) = '1');
      waited <= (To_X01(BWAIT) = '1');
    end if;
    if (falling_edge(BCLK)) then
      if (not waited) then
        atran <= (BTRAN = TRAN_ATRAN);
      end if;
    end if;
    if (falling_edge(BCLK)) then
      if (write and not atran) then-- Write operation
        if (Is_X(BD)) then
          errhandler("BD unknown on falling BCLK during write" &  
                                                    "operation",error);
        end if;
        if (not (BD'stable(tsu_b_d))) then
         errhandler ("BD setup to BCLK falling violated during write" & 
                                                    "operation", error);
        end if;
      elsif (not write and (not atran) and (not waited)) then
        if (Is_X(BD)) then
          errhandler("BD unknown on falling BCLK during read" &
                                                   "operation", error);
        end if;
        if (not (BD'stable(tsu_b_d))) then
          errhandler ("BD setup to BCLK falling violated during read" & 
                                                   "operation", error);
        end if;
      end if;
    end if;
  end process Check_B_D;
  
------------------------------------------------------------------------
--  BWAIT, BERROR, BLAST checking
------------------------------------------------------------------------
  slave_response_check : process (BCLK, BERROR, BLAST, BWAIT)
  begin
    if(rising_edge(BCLK)) then
      if(InReset = FALSE or SuppressOnReset = FALSE) then
        if(Is_X(BERROR)) then
          errhandler("BERROR unknown on rising BCLK", error);
        end if;
        if(not(BERROR'stable(tsu_slv_bclk))) then
          errhandler("BERROR setup to BCLK rising violated", error);
        end if;
        if(Is_X(BLAST)) then
          errhandler("BLAST unknown on rising BCLK", error);
        end if;
        if(not(BLAST'stable(tsu_slv_bclk))) then
          errhandler("BLAST setup to BCLK rising violated", error);
        end if;
      end if;
      if(Is_X(BWAIT)) then
        errhandler("BWAIT unknown on rising BCLK", error);
      end if;
      if(not(BWAIT'stable(tsu_slv_bclk))) then
        errhandler("BWAIT setup to BCLK rising violated", error);
      end if;      
    end if;
    if((BCLK = '1' and BERROR'event) or falling_edge(BCLK)) then
      if(not IsZ(BERROR)) then
        errhandler("BERROR driven during BCLK high", error);
      end if;
    end if;
    if((BCLK = '1' and BLAST'event) or falling_edge(BCLK)) then
      if(not IsZ(BLAST)) then
        errhandler("BLAST driven during BCLK high", error);
      end if;
    end if;
    if((BCLK = '1' and BWAIT'event) or falling_edge(BCLK)) then
      if(not IsZ(BWAIT)) then
        errhandler("BWAIT driven during BCLK high", error);
      end if;
    end if;
  end process slave_response_check;

------------------------------------------------------------------------
--  BWRITE checking
------------------------------------------------------------------------
  Check_B_WRITE : process (BCLK, BWAIT, BTRAN, BWRITE)
  begin
    if(InReset = FALSE or SuppressOnReset = FALSE) then
      if(Is_X(BWRITE) and falling_edge(BCLK) and 
                                          not(BTRAN = TRAN_ATRAN)) then
        errhandler("BWRITE unknown", error);
      end if;
      if(falling_edge(BCLK) and not(BWRITE'stable(tsu_ba_bclk))) then
        errhandler("BWRITE setup to BCLK falling violated", error);
      end if;
      if(BCLK = '0' and BWRITE'event and not(B_TRAND1 = TRAN_ATRAN)) 
                                                                   then
        errhandler("BWRITE changing during BCLK low", error);
      end if;
    end if;
  end process Check_B_WRITE;

------------------------------------------------------------------------
--  BSIZE checking
------------------------------------------------------------------------
  Check_B_SIZE : process (BCLK, BWAIT, BTRAN, BSIZE)
  begin
    if(InReset = FALSE or SuppressOnReset = FALSE) then
      if(Is_X(BSIZE) and falling_edge(BCLK) and 
                                          not(BTRAN = TRAN_ATRAN)) then
        errhandler("BSIZE unknown", error);
      end if;
      if(falling_edge(BCLK) and not(BSIZE'stable(tsu_ba_bclk))) then
        errhandler("BSIZE setup to BCLK falling violated", error);
      end if;
      if(BCLK = '0' and BSIZE'event and not(B_TRAND1 = TRAN_ATRAN)) then
        errhandler("BSIZE changing during BCLK low", error);
      end if;
    end if;
  end process Check_B_SIZE;

------------------------------------------------------------------------
--  BPROT checking
------------------------------------------------------------------------
  Check_B_PROT : process (BCLK, BWAIT, BTRAN, BPROT)
  begin
    if(InReset = FALSE or SuppressOnReset = FALSE) then
      if(Is_X(BPROT) and falling_edge(BCLK) and 
                                          not(BTRAN = TRAN_ATRAN)) then
        errhandler("BPROT unknown", error);
      end if;
      if(falling_edge(BCLK) and not(BPROT'stable(tsu_ba_bclk))) then
        errhandler("BPROT setup to BCLK falling violated", error);
      end if;
      if(BCLK = '0' and BPROT'event and not(B_TRAND1 = TRAN_ATRAN)) then
        errhandler("BPROT changing during BCLK low", error);
      end if;
    end if;
  end process Check_B_PROT;

------------------------------------------------------------------------
--  BTRAN checking
------------------------------------------------------------------------
  Check_B_TRAN : process (BCLK, BWAIT, BTRAN)
  begin
    if(InReset = FALSE or SuppressOnReset = FALSE) then
      if(falling_edge(BCLK) and Is_X(BTRAN)) then
        errhandler("BTRAN unknown on falling BCLK", error);
      end if;
      if(falling_edge(BCLK) and not(BTRAN'stable(tsu_btran_bclk))) then
        errhandler("BTRAN setup to BCLK falling violated", error);
      end if;
      if((BCLK = '0' and BTRAN'event) or rising_edge(BCLK)) then
        if(not IsZ(BTRAN)) then
          errhandler("BTRAN driven during BCLK low", error);
        end if;
      end if;
    end if;
    if falling_edge(BCLK) then
      B_TRAND1 <= BTRAN;
    end if;
  end process Check_B_TRAN;
  
end only;

-- --============================== End ==============================--
