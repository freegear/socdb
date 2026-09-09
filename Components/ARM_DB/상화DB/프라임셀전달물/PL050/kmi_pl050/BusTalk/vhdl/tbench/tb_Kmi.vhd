--------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only
--  as authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised copies
--  and copies may only be made to the extent permitted by a
--  licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : tb_Kmi.vhd,v
--  File Revision          : 1.3
--
--  Release Information    : PL050-REL1v1
--
--------------------------------------------------------------------------------
 
--------------------------------------------------------------------------------
--  Purpose          : Top level of the Kmi Compliance TestBench 
--
--                     This file instantiates the APB Slave model and the Kmi 
--                     module. In this test bench, the KMIREFCLK is fed from  
--                     the PCLK source. All clock-enabled tests should be run
--                     on this testbench.
--------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

library tbench;

library uut;

entity tb_Kmi is
end tb_Kmi;

architecture test of tb_Kmi is

  component apbslave_tb
  generic
         (
          PRDATA_mask            : string;
          INFILE                 : string;
          Verbosity              : integer;
          HaltOnMismatch         : integer;
          tclkl                  : integer;
          tclkh                  : integer
          );
  port(
       BnRES       : out std_logic;
       BCLK        : out std_logic;
       PADDR       : out std_logic_vector(31 downto 0);
       PWRITE      : out std_logic;
       PENABLE     : out std_logic;
       PSEL        : out std_logic; 
       PSELT       : out std_logic; 
       PWDATA      : out std_logic_vector(31 downto 0);
       PRDATA      : in  std_logic_vector(31 downto 0);
       VRG0        : inout std_logic_vector(31 downto 0);
       VRG1        : inout std_logic_vector(31 downto 0);
       VRG2        : inout std_logic_vector(31 downto 0);
       VRG3        : inout std_logic_vector(31 downto 0);
       VRG4        : inout std_logic_vector(31 downto 0);
       VRG5        : inout std_logic_vector(31 downto 0);
       VRG6        : inout std_logic_vector(31 downto 0);
       VRG7        : inout std_logic_vector(31 downto 0)
       );
  end  component;

   component Kmi
   port (
        PCLK         : in    std_logic;
        KMIREFCLK    : in    std_logic;
        BnRES        : in    std_logic;
        nKMIRST      : in    std_logic;
        PSEL         : in    std_logic;
        PENABLE      : in    std_logic;
        PWRITE       : in    std_logic;
        PADDRH       : in    std_logic_vector(7 downto 6);
        PADDRL       : in    std_logic_vector(4 downto 2);
        PWDATA       : in    std_logic_vector(7 downto 0);
        PRDATA       : out   std_logic_vector(7 downto 0);
        SCANMODE     : in    std_logic;
        KMICLKIN     : in    std_logic;
        KMIDATAIN    : in    std_logic;
        nKMICLKEN    : out   std_logic;
        nKMIDATAEN   : out   std_logic;
        KMITXINTR    : out   std_logic;
        KMIRXINTR    : out   std_logic;
        KMIINTR      : out   std_logic
        );
   end component;

  -----------------------------------------------------------------------------
  -- If the XonPSEL constant is set to '0' (default), an 'X' appearing
  -- on the PSEL line will be converted to '0'. If this constant is set
  -- to '1', the PSEL generated internally by the testbench is passed on
  -- unmodified.
  -----------------------------------------------------------------------------
  constant XonPSEL    : std_logic := '0';

  signal BCLK         : std_logic;
  signal PENABLE      : std_logic;
  signal BnRES        : std_logic;
  signal nKMIRST      : std_logic;
  signal PADDR        : std_logic_vector(31 downto 0);
  signal I_PADDR      : std_logic_vector(31 downto 0);
  signal SCANMODE     : std_logic; 

  signal PWRITE       : std_logic;
  signal I_PWRITE     : std_logic;
  signal PSEL         : std_logic; 
  signal I_PSEL       : std_logic; 
  signal PSELT        : std_logic; 
  signal PRDATA       : std_logic_vector(31 downto 0);
  signal PWDATA       : std_logic_vector(31 downto 0);

  signal KMICLKIN     : std_logic;
  signal KMIDATAIN    : std_logic;
  signal nKMICLKEN    : std_logic;
  signal nKMIDATAEN   : std_logic;
  signal KMITXINTR    : std_logic;
  signal KMIRXINTR    : std_logic;
  signal KMIINTR      : std_logic;
  signal nKMIRSTInt   : std_logic;
  signal KmiRdData    : std_logic_vector(7 downto 0);
  
  signal VRG0         : std_logic_vector(31 downto 0);
  signal VRG1         : std_logic_vector(31 downto 0);
  signal VRG2         : std_logic_vector(31 downto 0);
  signal VRG3         : std_logic_vector(31 downto 0);
  signal VRG4         : std_logic_vector(31 downto 0);
  signal VRG5         : std_logic_vector(31 downto 0);
  signal VRG6         : std_logic_vector(31 downto 0);
  signal VRG7         : std_logic_vector(31 downto 0);

  -- Read Fill vector
  signal ReadFill     : std_logic_vector(31 downto 0);
  
  begin

  ReadFill <= (others => '0');
  
  PSEL <= '0' when (XonPSEL = '0' and I_PSEL = 'X')
       else
          I_PSEL ;

  PWRITE <= '0' when (XonPSEL = '0' and I_PWRITE = 'X')
       else
          I_PWRITE ;

  p_PADDR : process (I_PADDR)
  begin
    for i in 0 to 31 loop
      if ((XonPSEL = '0') and (I_PADDR(i) = 'X')) then  
          PADDR(i) <= '0';
      else
        PADDR(i) <= I_PADDR(i);
      end if;
    end loop;
  end process p_PADDR;
       
  -- select functional mode
  SCANMODE  <= '0'; 
  KMICLKIN  <= '1';
  KMIDATAIN <= '1';
  
  -- All the unconnected Virtual Register inputs should be set to zero:
  VRG0 (31 downto 0) <= (others => '0');
  VRG1 (31 downto 0) <= (others => '0');
  VRG2 (31 downto 0) <= (others => '0');
  VRG3 (31 downto 0) <= (others => '0');
  VRG4 (31 downto 0) <= (others => '0');
  VRG5 (31 downto 0) <= (others => '0');
  VRG6 (31 downto 0) <= (others => '0');
  VRG7 (31 downto 0) <= (others => '0');

  -- create nKMIRST by synchronizing BnRES
  process (BCLK, BnRES)
  begin
    if (BnRES = '0') then
      nKMIRSTInt <= '0';
      nKMIRST    <= '0';
    elsif (BCLK'event and BCLK = '1') then
      nKMIRSTInt <= BnRES;
      nKMIRST    <= nKMIRSTInt;
    end if;
  end process;

  u_apbslv_tb : apbslave_tb 
    generic map (PRDATA_mask => "FFFFFFFF",
                 INFILE => "infile.bif",
                 Verbosity => 0,
                 HaltOnMismatch => 0,
                 tclkl => 10,
                 tclkh => 10
                )
  port map ( 
            BnRES       => BnRES,
            BCLK        => BCLK,
            PADDR       => I_PADDR,
            PWRITE      => I_PWRITE,
            PENABLE     => PENABLE,
            PSEL        => I_PSEL,
            PSELT       => PSELT,
            PRDATA      => PRDATA,
            PWDATA      => PWDATA,
            VRG0        => VRG0,
            VRG1        => VRG1,
            VRG2        => VRG2,
            VRG3        => VRG3,
            VRG4        => VRG4,
            VRG5        => VRG5,
            VRG6        => VRG6,
            VRG7        => VRG7
           );


-- Note : KMIREFCLK and PCLK need to be fed from the APB bus clock during
--        production testing.
u_Kmi : Kmi
port map (
         PCLK         => BCLK,
         KMIREFCLK    => BCLK,
         BnRES        => BnRES,
         nKMIRST      => nKMIRST,
         PSEL         => PSEL,
         PENABLE      => PENABLE,
         PWRITE       => PWRITE,
         PADDRH       => PADDR(7 downto 6),
         PADDRL       => PADDR(4 downto 2),
         PWDATA       => PWDATA(7 downto 0),
         PRDATA       => KmiRdData,
         SCANMODE     => SCANMODE,
         KMICLKIN     => KMICLKIN,
         KMIDATAIN    => KMIDATAIN,
         nKMICLKEN    => nKMICLKEN,
         nKMIDATAEN   => nKMIDATAEN,
         KMITXINTR    => KMITXINTR,
         KMIRXINTR    => KMIRXINTR,
         KMIINTR      => KMIINTR
         );
 
--Zero fill unused upper bits
PRDATA <= ReadFill(31 downto 8) & KmiRdData;

end test;
