--------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only
--  as authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised copies
--  and copies may only be made to the extent permitted by a
--  licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : tbench.vhd.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose          : Top level of the Sci Compliance TestBench
--
--                     This file instantiates the Sci module, the Sci trickbox
--                     and the Read Data Mux. In this test bench, the SCICLK
--                     frequency may be set different from the PCLK frequency.
--                     Free-running tests should be run on this testbench.
--------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

library tbench;
use     tbench.timing.all;

library uut;

library trickbox;

entity tbench is
end tbench;

architecture structural of tbench is

  component apbslave_tb
  generic
         (
          PRDATA_mask      : string;
          INFILE           : string;
          Verbosity        : integer;
          HaltOnMismatch   : integer;
          tclks            : time;
          tclkl            : time;
          tclkh            : time
          );
  port(
       PRESETn     : out std_logic;
       PCLK        : out std_logic;
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


  component Sci
   port (
      PCLK                : in   std_logic;
      SCICLK              : in   std_logic;
      PRESETn             : in   std_logic;
      nSCIRST             : in   std_logic;
      PSEL                : in   std_logic;
      PENABLE             : in   std_logic;
      PWRITE              : in   std_logic;
      PADDR               : in   std_logic_vector(11 downto 2);
      PWDATA              : in   std_logic_vector(15 downto 0);
      SCIDATAIN           : in   std_logic;
      SCICLKIN            : in   std_logic;
      SCIDETECT           : in   std_logic;
      SCIDEACREQ	  : in   std_logic;
      SCITXDMACLR	  : in   std_logic;
      SCIRXDMACLR	  : in   std_logic;
      SCANENABLE	  : in   std_logic;
      SCANINPCLK	  : in   std_logic;
      SCANINSCICLK	  : in   std_logic;
      
      nSCIDATAOUTEN	  : out  std_logic;
      nSCIDATAEN	  : out  std_logic;
      SCICLKOUT           : out  std_logic;
      nSCICLKOUTEN	  : out  std_logic;
      nSCICLKEN           : out  std_logic;
      nSCICARDRST	  : out  std_logic;
      SCIFCB              : out  std_logic;
      SCIVCCEN            : out  std_logic;
      SCIDEACACK	  : out  std_logic;
      PRDATA              : out  std_logic_vector(15 downto 0);
      SCICARDININTR	  : out  std_logic;
      SCICARDOUTINTR	  : out  std_logic;
      SCICARDUPINTR	  : out  std_logic;
      SCICARDDNINTR	  : out  std_logic;
      SCITXERRINTR	  : out  std_logic;
      SCIATRSTOUTINTR	  : out  std_logic;
      SCIATRDTOUTINTR	  : out  std_logic;
      SCIBLKTOUTINTR	  : out  std_logic;
      SCICHTOUTINTR	  : out  std_logic;
      SCIRTOUTINTR	  : out  std_logic;
      SCIRORINTR	  : out  std_logic;
      SCICLKSTPINTR	  : out  std_logic;
      SCICLKACTINTR	  : out  std_logic;
      SCITXTIDEINTR	  : out  std_logic;
      SCIRXTIDEINTR	  : out  std_logic;
      SCIINTR             : out  std_logic;
      SCITXDMASREQ	  : out  std_logic;
      SCITXDMABREQ	  : out  std_logic;
      SCIRXDMASREQ	  : out  std_logic;
      SCIRXDMABREQ	  : out  std_logic;
      SCANOUTPCLK	  : out  std_logic;
      SCANOUTSCICLK	  : out  std_logic 
   );
  end component;

  component SciTrick
  port (
        PCLK            : in   std_logic;
        PRESETn         : in   std_logic;
        PENABLE         : in   std_logic;
        PSELT           : in   std_logic;
        PWRITE          : in   std_logic;
        PADDR           : in   std_logic_vector(7 downto 2);
        PWData          : in   std_logic_vector(15 downto 0);
        PRData          : out  std_logic_vector(15 downto 0);
        SCICLK          : out  std_logic;
        nSCIRST         : out  std_logic;
        SCIDETECT       : out  std_logic;
        SCIVCCEN        : in   std_logic;
        nSCICARDRST     : in   std_logic;
        SCIFCB          : in   std_logic;
        SCICLKOUT       : out  std_logic;            
        SCICLKIN        : in   std_logic;
        SCIDATAOUT      : out  std_logic; 
        SCIDATAIN       : in   std_logic; 
        SCICARDININTR   : in   std_logic;
        SCICARDOUTINTR  : in   std_logic;
        SCICARDUPINTR   : in   std_logic;
        SCICARDDNINTR   : in   std_logic;
        SCITXERRINTR    : in   std_logic;
        SCIATRSTOUTINTR : in   std_logic;
        SCIATRDTOUTINTR : in   std_logic;
        SCIBLKTOUTINTR  : in   std_logic;
        SCICHTOUTINTR   : in   std_logic;
        SCITXTIDEINTR   : in   std_logic;
        SCIRXTIDEINTR   : in   std_logic;
        SCIRTOUTINTR    : in   std_logic;
        SCIRORINTR      : in   std_logic;
        SCICLKSTPINTR   : in   std_logic;
        SCICLKACTINTR   : in   std_logic;
        SCIINTR         : in   std_logic;
        SCIDEACACK      : in   std_logic; 
        SCIDEACREQ      : out  std_logic;
        SCITXDMASREQ    : in   std_logic;
        SCITXDMABREQ    : in   std_logic;
        SCIRXDMASREQ    : in   std_logic;
        SCIRXDMABREQ    : in   std_logic;
        SCITXDMACLR     : out  std_logic;
        SCIRXDMACLR     : out  std_logic
       );
  end component;

  component  apbmux
  port (
        PCLK       : in     std_logic;
        PRESETn    : in     std_logic;
        PSEL       : in     std_logic;
        PSELT      : in     std_logic;
        PRData0    : in     std_logic_vector(31 downto 0);
        PRData1    : in     std_logic_vector(31 downto 0);
        PRData     : out    std_logic_vector(31 downto 0)
       );
  end  component;

  -----------------------------------------------------------------------------
  -- If the XonPSEL constant is set to '0' (default), an 'X' appearing
  -- on the PSEL line will be converted to '0'. If this constant is set
  -- to '1', the PSEL generated internally by the testbench is passed on
  -- unmodified.
  -----------------------------------------------------------------------------
  constant XonPSEL       : std_logic := '0';

  signal PCLK            : std_logic;
  signal PENABLE         : std_logic;
  signal PRESETn         : std_logic;
  signal PADDR           : std_logic_vector(31 downto 0);
  signal I_PADDR         : std_logic_vector(31 downto 0);
                                                              
  signal PWRITE          : std_logic;
  signal PSEL            : std_logic; 
  signal I_PSEL          : std_logic; 
  signal I_PWRITE        : std_logic; 
  signal PSELT           : std_logic; 
  signal I_PSELT         : std_logic; 
  signal PRDATA0         : std_logic_vector(31 downto 0);
  signal PRDATA1         : std_logic_vector(31 downto 0);
  signal PRDATA          : std_logic_vector(31 downto 0);
  signal PWDATA          : std_logic_vector(31 downto 0);
  signal nSCIRST         : std_logic;

  signal SCICLK          : std_logic; 
  signal SCIDATAIN       : std_logic; 
  signal SCICLKIN        : std_logic; 
  signal SCIDETECT       : std_logic; 
  signal SCIDEACREQ      : std_logic; 
  signal nSCIDATAOUTEN   : std_logic; 
  signal nSCIDATAEN      : std_logic;	
  signal nSCIDATAIN      : std_logic; 
  signal SCICLKOUT       : std_logic; 
  signal nSCICLKOUTEN    : std_logic;
  signal nSCICLKEN       : std_logic;
  signal nSCICARDRST     : std_logic;
  signal SCIFCB          : std_logic;
 
  signal SCIVCCEN        : std_logic;
  signal SCICARDININTR   : std_logic;

  signal SCICARDOUTINTR  : std_logic;
  signal SCICARDUPINTR   : std_logic;
  signal SCICARDDNINTR   : std_logic;
  signal SCITXERRINTR    : std_logic;

  signal SCIATRSTOUTINTR : std_logic;
  signal SCIATRDTOUTINTR : std_logic;
  signal SCIBLKTOUTINTR  : std_logic;
  signal SCICHTOUTINTR   : std_logic;
  signal SCITXTIDEINTR   : std_logic;
  signal SCIRXTIDEINTR   : std_logic;
  signal SCIRTOUTINTR    : std_logic;
  signal SCIRORINTR      : std_logic;
  signal SCICLKSTPINTR   : std_logic;
  signal SCICLKACTINTR   : std_logic;
  signal SCIINTR         : std_logic;
  signal SCIDEACACK      : std_logic;
  signal SCITXDMASREQ    : std_logic;
  signal SCITXDMABREQ    : std_logic;
  signal SCIRXDMASREQ    : std_logic;
  signal SCIRXDMABREQ    : std_logic;
  signal SCITXDMACLR     : std_logic;
  signal SCIRXDMACLR     : std_logic;
  signal SCANOUTPCLK     : std_logic;
  signal SCANOUTSCICLK   : std_logic;

  signal SCANENABLE      : std_logic;
  signal SCANINPCLK      : std_logic;
  signal SCANINSCICLK    : std_logic;


  -- Read Fill vector
  signal ReadFill        : std_logic_vector(31 downto 0);

  signal VRG0            : std_logic_vector(31 downto 0);
  signal VRG1            : std_logic_vector(31 downto 0);
  signal VRG2            : std_logic_vector(31 downto 0);
  signal VRG3            : std_logic_vector(31 downto 0);
  signal VRG4            : std_logic_vector(31 downto 0);
  signal VRG5            : std_logic_vector(31 downto 0);
  signal VRG6            : std_logic_vector(31 downto 0);
  signal VRG7            : std_logic_vector(31 downto 0);

  signal SciRdData       : std_logic_vector(15 downto 0);
  signal TrickRdData     : std_logic_vector(15 downto 0);

  signal TSCICLKout      : std_logic;

  signal SCIDATA         : std_logic;
  signal TSCIDATAout     : std_logic;

  signal IntSciClkout    : std_logic; 

  signal ClockContention : std_logic; 
  signal DataContention  : std_logic;

  signal DelayednSCIRST  : std_logic;

begin

  SCANINSCICLK <= '0';
  SCANINPCLK   <= '0';
  SCANENABLE   <= '0';

  ReadFill     <= (others => '0');

  PSEL  <= '0' when (XonPSEL = '0' and I_PSEL = 'X')
        else
           I_PSEL;
 
  PSELT <= '0' when (XonPSEL = '0' and I_PSELT = 'X')
        else
           I_PSELT;
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
 
  --  All the unconnected Virtual Register inputs should be set to zero:
  VRG0 (31 downto 0) <= (others => '0');
  VRG1 (31 downto 0) <= (others => '0');
  VRG2 (31 downto 0) <= (others => '0');
  VRG3 (31 downto 0) <= (others => '0');
  VRG4 (31 downto 0) <= (others => '0');
  VRG5 (31 downto 0) <= (others => '0');
  VRG6 (31 downto 0) <= (others => '0');
  VRG7 (31 downto 0) <= (others => '0');

  SCICLKIN  <= IntSciClkout  when (nSCICLKEN = '0') 
          else 
             TSCICLKout; 

  SCIDATAIN <= nSCIDATAOUTEN when (nSCIDATAEN = '0')
          else 
             TSCIDATAout; 

  DataContention  <= (not nSCIDATAEN) and (not TSCIDATAout);
  ClockContention <= (not nSCICLKEN) and (not TSCICLKout);

  p_Contention : process (DataContention, ClockContention)  
  begin
    if (DataContention = '1') then
      assert false
        report "Contention on SCIDATA line"
        severity error;
      end if;

    if (ClockContention = '1') then
      assert false
        report "Contention on SCICLOCK line"
        severity error;
      end if;
  end process p_Contention;

  IntSciClkout <= nSCICLKOUTEN xor SCICLKOUT; 

-- -----------------------------------------------------------------------------
-- Delay nSCIRST from rising edge of SCICLK
-- -----------------------------------------------------------------------------

DelayednSCIRST <= nSCIRST after 1 ns;

  u_apbslv_tb : apbslave_tb 
    generic map (
                 PRDATA_mask => "FFFFFFFF",
                 INFILE => "../../bustest/invec/infile.bif",
                 Verbosity => 0,
                 HaltOnMismatch => 0,
                 tclks => tclks,
                 tclkl => Tclkl,
                 tclkh => Tclkh
                )
  port map ( 
            PRESETn       => PRESETn,
            PCLK          => PCLK,
            PADDR         => I_PADDR,
            PWRITE        => I_PWRITE,
            PENABLE       => PENABLE,
            PSEL          => I_PSEL,
            PSELT         => I_PSELT,
            PRDATA        => PRDATA,
            PWDATA        => PWDATA,
            VRG0          => VRG0,
            VRG1          => VRG1,
            VRG2          => VRG2,
            VRG3          => VRG3,
            VRG4          => VRG4,
            VRG5          => VRG5,
            VRG6          => VRG6,
            VRG7          => VRG7
           );


  uut : Sci
  port map (

      PCLK                => PCLK,
      SCICLK              => SCICLK,
      PRESETn             => PRESETn,
      nSCIRST             => DelayednSCIRST,
      PSEL                => PSEL,
      PENABLE             => PENABLE,
      PWRITE              => PWRITE,
      PADDR               => PADDR(11 downto 2),
      PWDATA              => PWDATA(15 downto 0),
      SCIDATAIN           => SCIDATAIN,
      SCICLKIN            => SCICLKIN,
      SCIDETECT           => SCIDETECT,
      SCIDEACREQ	  => SCIDEACREQ,
      SCITXDMACLR	  => SCITXDMACLR,
      SCIRXDMACLR	  => SCIRXDMACLR,
      SCANENABLE	  => SCANENABLE,
      SCANINPCLK	  => SCANINPCLK,
      SCANINSCICLK	  => SCANINSCICLK,
      
      nSCIDATAOUTEN	  => nSCIDATAOUTEN,
      nSCIDATAEN	  => nSCIDATAEN,
      SCICLKOUT           => SCICLKOUT,
      nSCICLKOUTEN	  => nSCICLKOUTEN,
      nSCICLKEN           => nSCICLKEN,
      nSCICARDRST	  => nSCICARDRST,
      SCIFCB              => SCIFCB,
      SCIVCCEN            => SCIVCCEN,
      SCIDEACACK	  => SCIDEACACK,
      PRDATA              => SciRdData,
      SCICARDININTR	  => SCICARDININTR,
      SCICARDOUTINTR	  => SCICARDOUTINTR,
      SCICARDUPINTR	  => SCICARDUPINTR,
      SCICARDDNINTR	  => SCICARDDNINTR,
      SCITXERRINTR	  => SCITXERRINTR,
      SCIATRSTOUTINTR	  => SCIATRSTOUTINTR,
      SCIATRDTOUTINTR	  => SCIATRDTOUTINTR,
      SCIBLKTOUTINTR	  => SCIBLKTOUTINTR,
      SCICHTOUTINTR	  => SCICHTOUTINTR,
      SCIRTOUTINTR	  => SCIRTOUTINTR,
      SCIRORINTR	  => SCIRORINTR,
      SCICLKSTPINTR	  => SCICLKSTPINTR,
      SCICLKACTINTR	  => SCICLKACTINTR,
      SCITXTIDEINTR	  => SCITXTIDEINTR,
      SCIRXTIDEINTR	  => SCIRXTIDEINTR,
      SCIINTR             => SCIINTR,
      SCITXDMASREQ	  => SCITXDMASREQ,
      SCITXDMABREQ	  => SCITXDMABREQ,
      SCIRXDMASREQ	  => SCIRXDMASREQ,
      SCIRXDMABREQ	  => SCIRXDMABREQ,
      SCANOUTPCLK	  => SCANOUTPCLK,
      SCANOUTSCICLK	  => SCANOUTSCICLK
    );
  
   
  uSciTrick : SciTrick
  port map (

        PCLK            => PCLK,
        PRESETn         => PRESETn,
        PENABLE         => PENABLE,
        PSELT           => PSELT,
        PWRITE          => PWRITE,
        PADDR           => PADDR(7 downto 2),
        PWData          => PWData(15 downto 0),
        PRData          => TrickRdData,
        SCICLK          => SCICLK,
        nSCIRST         => nSCIRST,
        SCIDETECT       => SCIDETECT,
        SCIVCCEN        => SCIVCCEN,
        nSCICARDRST     => nSCICARDRST,
        SCIFCB          => SCIFCB,
        SCICLKOUT       => TSCICLKout,            
        SCICLKIN        => SCICLKIN,
        SCIDATAOUT      => TSCIDATAout, 
        SCIDATAIN       => SCIDATAIN, 
        SCICARDININTR   => SCICARDININTR,
        SCICARDOUTINTR  => SCICARDOUTINTR,
        SCICARDUPINTR   => SCICARDUPINTR,
        SCICARDDNINTR   => SCICARDDNINTR,
        SCITXERRINTR    => SCITXERRINTR,
        SCIATRSTOUTINTR => SCIATRSTOUTINTR,
        SCIATRDTOUTINTR => SCIATRDTOUTINTR,
        SCIBLKTOUTINTR  => SCIBLKTOUTINTR,
        SCICHTOUTINTR   => SCICHTOUTINTR,
        SCITXTIDEINTR   => SCITXTIDEINTR,
        SCIRXTIDEINTR   => SCIRXTIDEINTR,
        SCIRTOUTINTR    => SCIRTOUTINTR,
        SCIRORINTR      => SCIRORINTR,
        SCICLKSTPINTR   => SCICLKSTPINTR,
        SCICLKACTINTR   => SCICLKACTINTR,
        SCIINTR         => SCIINTR,
        SCIDEACACK      => SCIDEACACK, 
        SCIDEACREQ      => SCIDEACREQ,
        SCITXDMASREQ    => SCITXDMASREQ,
        SCITXDMABREQ    => SCITXDMABREQ,
        SCIRXDMASREQ    => SCIRXDMASREQ,
        SCIRXDMABREQ    => SCIRXDMABREQ,
        SCITXDMACLR     => SCITXDMACLR,
        SCIRXDMACLR     => SCIRXDMACLR
    );
    
  PRData0 <= ReadFill(31 downto 16) & SciRdData;
  PRData1 <= ReadFill(31 downto 16) & TrickRdData;

  u_apbmux : apbmux
  port map (
            PCLK          => PCLK,
            PRESETn       => PRESETn,
            PSEL          => PSEL,
            PSELT         => PSELT,
            PRData0       => PRDATA0,
            PRData1       => PRDATA1,
            PRData        => PRDATA
           );

end structural;
