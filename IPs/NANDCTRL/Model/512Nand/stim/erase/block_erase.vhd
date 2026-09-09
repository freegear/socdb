--        ____________________________________ 
--       /                                    |
--      |                                     |
--      |      __________________   __________|
--      |     |                 |   |
--       \     \                |   |   _______________________________________________________
--        \     \               |   |
--         \     \              |   |                                                
--          \     \             |   |                                                NAND512W3A   
--           \     \            |   |      
--            \     \           |   |                                               512Gbit (x8)       
--             \     \          |   |                    528 Byte Page, 3V, NAND Flash Memories
--              \     \         |   |       
--               \     \        |   |                                     VHDL Behavioral Model
--                |     \       |   |                                               Version 1.0
--                |     |       |   |                                               
--  ______________|     |       |   |                     Copyright (c) 2005 STMicroelectronics
-- |                    |       |   |  
-- |                    |       |   |  _________________________________________________________
-- |___________________/        |___|
-- 
-- 
-- ********************************************************************************************* 
-- 
-- 
-------------------------------------------------------------------------
--	> Commands:                                                    --
--      >            block erase command code                          -- 
--      >            address insertion x8 devices                      --
--      >            read                                              --
-------------------------------------------------------------------------

LIBRARY IEEE;
Use  IEEE.std_logic_1164.all;
LIBRARY work;
Use work.def.all;
Use work.data.all;
Use work.TimingData.all;
Use work.UserData.all;



Entity Stimuli is
port 
     (
      I_O : inout IObus_type;
      E_N, R_N, W_N, WP_N: out std_logic;
      AL, CL: out std_logic;
      Vss, Vdd: out real
     );
End Stimuli;


Architecture behavior of Stimuli is
-- Add control signals 
  signal START_LOOP: natural := 0;

signal CK      : std_logic := '0';
signal read_cycle       : boolean := false;


Signal A0: Std_Logic_vector (7 downto 0) ;
Signal A1: Std_Logic_vector (7 downto 0) ;
Signal A2: Std_Logic_vector (7 downto 0) ;
Signal A3: Std_Logic_vector (7 downto 0) ;




constant PERIOD: time:= 60 ns;   -- t_RLRL min 60 ns

begin

clock1_process: process(CK) 
begin

     R_N <= not CK after PERIOD/2;
  
end process;

clock2_process: process(CK, read_cycle) 
begin

   if read_cycle then CK <= not CK after PERIOD/2;
   else CK <= '0';
   end if;
  
end process;


--  Logic sequence generator
Main : process
        
----- Begin procedure: 

--||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- READ OPERATION
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||

procedure four_Address_cycles (A: in std_logic_vector(31 downto 0)) is
begin
      
        I_O <= (others => 'Z');
	wait for 5 ns;  
	E_N<='0';
	CL <='0';                       --t_CLLWL=0
	AL <='1';                       --t_AHWL=0
	wait for 5 ns;  
        A0 <= A (7 downto 0);
        A1 <= A (16 downto 9);
        A2 <= A (24 downto 17);
	wait for 25 ns;  
	W_N<='1';                         --t_WLWH>25
        if not mode16bit then 
                A3 <="000000" & A (26 downto 25);
        else 
                A3 <="000000" & A (26 downto 25);
        end if;
        wait for 10 ns;                   --
	W_N<='0';                         --t_WLWH>25
        I_O <= A0  ;
        wait for 25 ns;                   --
	W_N<='1';                         --t_WLWH>25
        wait for 20 ns;
        I_O <= (Others => 'Z');   
        wait for 20 ns;                   --
        W_N <= '0';
        wait for 20 ns;
        I_O <= A1  ;
        wait for 20 ns;                   --
	W_N<='1';                         --t_WLWH>25
        wait for 20 ns;                   --
        I_O <= (Others => 'Z');   
        wait for 20 ns;                   --
        W_N <= '0';
        wait for 20 ns;
        I_O <= A2  ;
        wait for 20 ns;                   --
	W_N<='1';                         --t_WLWH>25
        wait for 20 ns;                   --
        I_O <= (Others => 'Z');   
        wait for 20 ns;     
        W_N <= '0';      --
        wait for 20 ns;
        I_O <= A3  ;
        wait for 20 ns;                   --
	W_N<='1';                         --t_WLWH>25
        wait for 20 ns;                   --
        I_O <= (Others => 'Z');   
        wait for 20 ns;
	AL<='0'; 
        wait for 10 ns;
end;

procedure block_Address_cycles (A: in std_logic_vector(31 downto 0)) is
begin
      
        I_O <= (others => 'Z');
	wait for 5 ns;  
	E_N<='0';
	CL <='0';                       --t_CLLWL=0
	AL <='1';                       --t_AHWL=0
	wait for 5 ns;  
        A0 <= A (7 downto 0);
        A1 <= A (16 downto 9);
        A2 <= A (24 downto 17);
	wait for 25 ns;  
	W_N<='1';                         --t_WLWH>25
        if not mode16bit then 
                A3 <="000000" & A (26 downto 25);
        else 
                A3 <="000000" & A (26 downto 25);
        end if;
        wait for 10 ns;                   --
	W_N<='0';                         --t_WLWH>25
        wait for 20 ns;
        I_O <= A1  ;
        wait for 20 ns;                   --
	W_N<='1';                         --t_WLWH>25
        wait for 20 ns;                   --
        I_O <= (Others => 'Z');   
        wait for 20 ns;                   --
        W_N <= '0';
        wait for 20 ns;
        I_O <= A2  ;
        wait for 20 ns;                   --
	W_N<='1';                         --t_WLWH>25
        wait for 20 ns;                   --
        I_O <= (Others => 'Z');   
        wait for 20 ns;     
        W_N <= '0';      --
        wait for 20 ns;
        I_O <= A3  ;
        wait for 20 ns;                   --
	W_N<='1';                         --t_WLWH>25
        wait for 20 ns;                   --
        I_O <= (Others => 'Z');   
        wait for 20 ns;
	AL<='0'; 
        wait for 10 ns;
end;



procedure BusRead_op  is
begin
        
        CL <='0';
        E_N <= '1';
        wait for 1000 ns;
        E_N <= '0';
        wait for 50 ns;
        read_cycle  <= true;      
        wait for 300 ns;             -- read cycle
        read_cycle <= false;
        wait for 50 ns;
        E_N <='1';

end;


procedure Command_Code (A: in IObus_type) is
begin
        I_O <= (others => 'Z');
	E_N<='0';
	CL<='1';                        --t_CLHWL=0 
	W_N<='0';                         --t_ELWL=0
        I_O <= A ;        --t_DVWH>20
        wait for 30 ns;                   --t_ELTV
	W_N<='1';                         --t_WLWH>25
        wait for 15 ns;                   --t_ELWl
	CL<='0';                        --t_WHCLL>10
        wait for 5 ns;
        wait for 5 ns;
        I_O <= (others => 'Z');
        wait for 5 ns;
        wait for 5 ns;
end;

procedure Read_Code  is
begin
        I_O <= (others => 'Z');
	E_N<='0';
	CL<='1';                        --t_CLHWL=0 
	W_N<='0';                         --t_ELWL=0
        I_O <=  "00000000" ;        --t_DVWH>20
        wait for 30 ns;                   --t_ELTV
	W_N<='1';                         --t_WLWH>25
        wait for 15 ns;                   --t_ELWl
	CL<='0';                        --t_WHCLL>10
        wait for 5 ns;
        wait for 5 ns;
        I_O <= (others => 'Z');
        wait for 5 ns;
        wait for 5 ns;
end;

procedure Read_Code_A  is
begin
        I_O <= (others => 'Z');
	E_N<='0';
	CL<='1';                        --t_CLHWL=0 
	W_N<='0';                         --t_ELWL=0
        I_O <=  "00000000" ;        --t_DVWH>20
        wait for 30 ns;                   --t_ELTV
	W_N<='1';                         --t_WLWH>25
        wait for 15 ns;                   --t_ELWl
	CL<='0';                        --t_WHCLL>10
        wait for 5 ns;
        wait for 5 ns;
        I_O <= (others => 'Z');
        wait for 5 ns;
        wait for 5 ns;
end;

procedure Read_Code_B  is
begin
        I_O <= (others => 'Z');
	E_N<='0';
	CL<='1';                        --t_CLHWL=0 
	W_N<='0';                         --t_ELWL=0
        I_O <=  "00000001" ;        --t_DVWH>20
        wait for 30 ns;                   --t_ELTV
	W_N<='1';                         --t_WLWH>25
        wait for 15 ns;                   --t_ELWl
	CL<='0';                        --t_WHCLL>10
        wait for 5 ns;
        wait for 5 ns;
        I_O <= (others => 'Z');
        wait for 5 ns;
        wait for 5 ns;
end;

procedure Read_Code_C  is
begin
        I_O <= (others => 'Z');
	E_N<='0';
	CL<='1';                        --t_CLHWL=0 
	W_N<='0';                         --t_ELWL=0
        I_O <=  "01010000" ;        --t_DVWH>20
        wait for 30 ns;                   --t_ELTV
	W_N<='1';                         --t_WLWH>25
        wait for 15 ns;                   --t_ELWl
	CL<='0';                        --t_WHCLL>10
        wait for 5 ns;
        wait for 5 ns;
        I_O <= (others => 'Z');
        wait for 5 ns;
        wait for 5 ns;
end;



procedure Confirm_Code  is
begin
        I_O <= (others => 'Z');
	E_N<='0';
	CL<='1';                        --t_CLHWL=0 
	W_N<='0';                         --t_ELWL=0
        I_O <=  "00110000" ;        --t_DVWH>20
        wait for 30 ns;                   --t_ELTV
	W_N<='1';                         --t_WLWH>25
        wait for 15 ns;                   --t_ELWl
	CL<='0';                        --t_WHCLL>10
        wait for 5 ns;
        wait for 5 ns;
        I_O <= (others => 'Z');
        wait for 5 ns;
        wait for 5 ns;
end;

procedure Read_Confirm_Code  is
begin
        I_O <= (others => 'Z');
	E_N<='0';
	CL<='1';                        --t_CLHWL=0 
	W_N<='0';                         --t_ELWL=0
        I_O <=  "00110000" ;        --t_DVWH>20
        wait for 30 ns;                   --t_ELTV
	W_N<='1';                         --t_WLWH>25
        wait for 15 ns;                   --t_ELWl
	CL<='0';                        --t_WHCLL>10
        wait for 5 ns;
        wait for 5 ns;
        I_O <= (others => 'Z');
        wait for 5 ns;
        wait for 5 ns;
end;


procedure Block_Erase_Code  is
begin
        I_O <= (others => 'Z');
	E_N<='0';
	CL<='1';                        --t_CLHWL=0 
	W_N<='0';                         --t_ELWL=0
        I_O <=  "01100000" ;        --t_DVWH>20
        wait for 30 ns;                   --t_ELTV
	W_N<='1';                         --t_WLWH>25
        wait for 15 ns;                   --t_ELWl
	CL<='0';                        --t_WHCLL>10
        wait for 5 ns;
        wait for 5 ns;
        I_O <= (others => 'Z');
        wait for 5 ns;
        wait for 5 ns;
end;

procedure Erase_Confirm_Code  is
begin
        I_O <= (others => 'Z');
	E_N<='0';
	CL<='1';                        --t_CLHWL=0 
	W_N<='0';                         --t_ELWL=0
        I_O <=  "11010000" ;            --t_DVWH>20
        wait for 30 ns;                   --t_ELTV
	W_N<='1';                         --t_WLWH>25
        wait for 15 ns;                   --t_ELWl
	CL<='0';                        --t_WHCLL>10
        wait for 5 ns;
        wait for 5 ns;
        I_O <= (others => 'Z');
        wait for 5 ns;
        wait for 5 ns;
end;



procedure Data_Cycle (D: in IObus_type) is
begin
        I_O <= (others => 'Z');
	wait for 5 ns;  
	E_N<='0';
	CL<='0';                       --t_CLLWL=0
	W_N<='0';                        --t_ELWL=0
        I_O <=D ;
        wait for 25 ns;                   --
	W_N<='1'; 
        wait for 10 ns;                   --
        I_O <= (others => 'Z');
	wait for 15 ns;  
        wait for 5 ns;
        wait for 5 ns;
end;



--  ********** End Procedure ************************** 

begin
 
	E_N <= '1';
	W_N <= '1'; 
	AL <='0'; 
	CL <='0'; 
	WP_N <='0';
        wait for 100 ns;
        
	I_O<="ZZZZZZZZ";  
        Vdd<=3.0; 
        wait for 5001 ns;

       
--------------------------------------------------------------------        
         
       WP_N <='1';
        
       
---   ERASE  ---

      Block_Erase_Code;                            -- 60h
      wait for 100 ns;
       
      four_Address_cycles(X"00000000");   
       
      Erase_Confirm_Code;                          -- D0h

      wait for ERASE_time;

       
---    READ   ----

      Read_Code_A;                                           -- 00h

      block_Address_cycles(X"00000000");   
 
       CL <='0'; 
       
     wait for 100 ns;
       
       wait for READ_BUSY_time;

       BusRead_op;

       wait for 1000 ns;

     Read_Code_B;                                           -- 00h

      four_Address_cycles(X"00000000");   
 
       CL <='0'; 
       
     wait for 100 ns;
       
       wait for READ_BUSY_time;

       BusRead_op;

       wait for 1000 ns;


      
--***************************************************************************************

        E_N<='1';
        wait for 1000 ns;
        assert (false) report "End Of Stimuli";

end process;
end behavior;


