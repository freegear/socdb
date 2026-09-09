--------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only
--  as authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised copies
--  and copies may only be made to the extent permitted by a
--  licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : tbench.vhd.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose          : Top level of the Ssp Compliance TestBench
--
--                     This file instantiates the Ssp module, the Ssp trickbox
--                     and the Read Data Mux. In this test bench, the SSPCLK
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
          PRDATA_mask            : string;
          INFILE                 : string;
          Verbosity              : integer;
          HaltOnMismatch         : integer;
          tclks                  : time;
          tclkl                  : time;
          tclkh                  : time
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

  component Ssp
port (
      PCLK           : in  std_logic;
      SSPCLK         : in  std_logic;
      
      PRESETn        : in  std_logic;
      nSSPRST        : in  std_logic;
      
      PSEL           : in  std_logic;
      PENABLE        : in  std_logic;
      PWRITE         : in  std_logic;
      
      SSPRXD         : in  std_logic;
      SSPCLKIN       : in  std_logic;
      SSPFSSIN       : in  std_logic;
      
      SCANENABLE     : in  std_logic;
      SCANINPCLK     : in  std_logic;
      SCANINSSPCLK   : in  std_logic;
      
      PADDR          : in  std_logic_vector(11 downto 2);

      PWDATA         : in  std_logic_vector(15 downto 0);       

      SSPTXDMACLR    : in  std_logic;
      SSPRXDMACLR    : in  std_logic;
     
      SSPINTR        : out std_logic;
      SSPRXINTR      : out std_logic;
      SSPTXINTR      : out std_logic;
      SSPRORINTR     : out std_logic;
      SSPRTINTR      : out std_logic;
      
      SSPFSSOUT      : out std_logic;
      SSPCLKOUT      : out std_logic;
      
      SCANOUTPCLK    : out std_logic;
      SCANOUTSSPCLK  : out std_logic;
 
      SSPTXD         : out std_logic;
      nSSPOE         : out std_logic;
      nSSPCTLOE      : out std_logic;
      
      PRDATA         : out std_logic_vector(15 downto 0);        

      SSPTXDMASREQ      : out std_logic;
      SSPTXDMABREQ      : out std_logic;
      SSPRXDMASREQ      : out std_logic;
      SSPRXDMABREQ      : out std_logic
     );
  end component;

  
  component  SspTrick
  port (
        -- APB bus signals
        PCLK         : in    std_logic;
        PRESETn      : in    std_logic;
        PENABLE      : in    std_logic;
        PSELT        : in    std_logic;
        PWRITE       : in    std_logic;
        PADDR        : in    std_logic_vector(7 downto 2);
        PWData       : in    std_logic_vector(15 downto 0);
        PRData       : out   std_logic_vector(15 downto 0);
        SCANMODE     : out   std_logic;
        SSPTXD       : out   std_logic;
        SFRMIN       : in    std_logic;
        SCLKIN       : in    std_logic;
        SSPRXD       : in    std_logic;
        SSPRXINTR    : in    std_logic;
        SSPTXINTR    : in    std_logic;
        SSPINTR      : in    std_logic;
        SSPRORINTR   : in    std_logic;
        SSPRTINTR    : in    std_logic;
        SSPTXDMASREQ : in    std_logic;
        SSPTXDMABREQ : in    std_logic;
        SSPRXDMASREQ : in    std_logic;
        SSPRXDMABREQ : in    std_logic;
        SFRMOUT      : out   std_logic;
        SCLKOUT      : out   std_logic;
        nSSPRST      : out   std_logic;
        SSPCLK       : out   std_logic;
        SSPTXDMACLR  : out   std_logic;
        SSPRXDMACLR  : out   std_logic
       );
  end  component;
  
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
  constant XonPSEL    : std_logic := '0';

  signal PCLK         : std_logic;
  signal PENABLE      : std_logic;
  signal PRESETn      : std_logic;
  signal PADDR        : std_logic_vector(31 downto 0);
  signal I_PADDR        : std_logic_vector(31 downto 0);
                                                              
  signal PWRITE       : std_logic;
  signal PSEL         : std_logic; 
  signal I_PSEL       : std_logic; 
  signal I_PWRITE     : std_logic; 
  signal PSELT        : std_logic; 
  signal I_PSELT      : std_logic; 
  signal PRDATA0      : std_logic_vector(31 downto 0);
  signal PRDATA1      : std_logic_vector(31 downto 0);
  signal PRDATA       : std_logic_vector(31 downto 0);
  signal PWDATA       : std_logic_vector(31 downto 0);

  signal SSPCLK       : std_logic; 
  signal SSPTXD       : std_logic; 
  signal SSPRXD       : std_logic; 
  signal SFRM         : std_logic; 
  signal SCLK         : std_logic; 
  signal nSSPOE       : std_logic; 
  signal SSPRXINTR    : std_logic; 
  signal SSPTXINTR    : std_logic; 
  signal SSPRORINTR   : std_logic;
  signal SSPRTINTR    : std_logic;
  signal SSPINTR      : std_logic; 

 
  signal SCANENABLE   : std_logic;
  signal SCANMODE     : std_logic;
  signal nSSPRST      : std_logic;

  signal SSPTXDMASREQ    : std_logic;
  signal SSPTXDMABREQ    : std_logic;
  signal SSPRXDMASREQ    : std_logic;
  signal SSPRXDMABREQ    : std_logic;

  signal SSPTXDMACLR  : std_logic;
  signal SSPRXDMACLR  : std_logic;

  -- Read Fill vector
  signal ReadFill     : std_logic_vector(31 downto 0);

  signal SspRdData    : std_logic_vector(15 downto 0);
  signal TrickRdData  : std_logic_vector(15 downto 0);
 
  signal SSPFSSOUT    : std_logic;
  signal SSPCLKOUT    : std_logic;

  signal SFRMTrick    : std_logic;
  signal SCLKTrick    : std_logic;

  signal nSSPCTLOE    : std_logic;
  signal SCANINPCLK   : std_logic;
  signal SCANINSSPCLK : std_logic;
  signal DUMMY        : std_logic;
   
  signal SSPTXDTrick  : std_logic;
  signal SSPTXDpad    : std_logic;
  signal SCLKpad      : std_logic;
  signal SFRMpad      : std_logic;

  signal VRG0            : std_logic_vector(31 downto 0);
  signal VRG1            : std_logic_vector(31 downto 0);
  signal VRG2            : std_logic_vector(31 downto 0);
  signal VRG3            : std_logic_vector(31 downto 0);
  signal VRG4            : std_logic_vector(31 downto 0);
  signal VRG5            : std_logic_vector(31 downto 0);
  signal VRG6            : std_logic_vector(31 downto 0);
  signal VRG7            : std_logic_vector(31 downto 0);

begin

  ReadFill <= (others => '0');
  SCANENABLE <= '0';
  SCANINPCLK <= '0';
  SCANINSSPCLK <= '0';
  DUMMY <= '0';
   
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

  SSPRXD <= SSPTXDTrick;
  SSPTXDpad <= SSPTXD when (nSSPOE = '0')
            else
               'Z';
  SFRMpad   <= SSPFSSOUT when (nSSPCTLOE = '0')
            else
               'Z';
  SCLKpad   <= SSPCLKOUT when (nSSPCTLOE = '0')
            else
               'Z';

  -- tri-state control of the SSP Master SSPTXD pad
--   process (nSSPOE, SSPTXD)
--   begin
--   if (nSSPOE = '1') then
--      SSPTXDpad <= SSPTXD;
--   else
--      SSPTXDpad <= 'Z';
--   end if;
--   end process;

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


  uut : Ssp
  port map (

      PCLK           => PCLK,
      SSPCLK         => SSPCLK,
      
      PRESETn        => PRESETN,
      nSSPRST        => nSSPRST,
      
      PSEL           => PSEL,
      PENABLE        => PENABLE,
      PWRITE         => PWRITE,
      
      SSPRXD         => SSPRXD,
      SSPCLKIN       => SCLKTrick,
      SSPFSSIN       => SFRMTrick,
      
      SCANENABLE     => SCANENABLE,
      SCANINPCLK     => SCANINPCLK,
      SCANINSSPCLK   => SCANINSSPCLK,
      
      PADDR          => PADDR(11 downto 2),

      PWDATA         => PWDATA(15 downto 0),       

      SSPTXDMACLR    => SSPTXDMACLR,
      SSPRXDMACLR    => SSPRXDMACLR,
      
      SSPINTR        => SSPINTR,
      SSPRXINTR      => SSPRXINTR,
      SSPTXINTR      => SSPTXINTR,
      SSPRORINTR     => SSPRORINTR,
      SSPRTINTR      => SSPRTINTR,
      
      SSPFSSOUT      => SSPFSSOUT,
      SSPCLKOUT      => SSPCLKOUT,
      
      SCANOUTPCLK    => DUMMY,
      SCANOUTSSPCLK  => DUMMY,
 
      SSPTXD         => SSPTXD,
      nSSPOE         => nSSPOE,
      nSSPCTLOE      => nSSPCTLOE,
      
      PRDATA         => SspRdData(15 downto 0),        

      SSPTXDMASREQ      => SSPTXDMASREQ,
      SSPTXDMABREQ      => SSPTXDMABREQ,
      SSPRXDMASREQ      => SSPRXDMASREQ,
      SSPRXDMABREQ      => SSPRXDMABREQ
    );
  
   
  u_SspTrick : SspTrick  
  port map (
            PCLK          => PCLK,
            PRESETn       => PRESETn,
            PENABLE       => PENABLE,
            PSELT         => PSELT,
            PWRITE        => PWRITE,
            PADDR         => PADDR(7 downto 2), 
            PWData        => PWDATA(15 downto 0),
            PRData        => TrickRdData,
            SCANMODE      => SCANMODE,
            SSPTXD        => SSPTXDTrick,
            SSPRXD        => SSPTXDpad,
            SFRMIN        => SFRMpad,
            SCLKIN        => SCLKpad,
            SCLKOUT       => SCLKTrick,
            SFRMOUT       => SFRMTrick,
            SSPRXINTR     => SSPRXINTR,
            SSPTXINTR     => SSPTXINTR,
            SSPINTR       => SSPINTR,
            SSPRORINTR    => SSPRORINTR,
            SSPRTINTR     => SSPRTINTR,
            nSSPRST       => nSSPRST,
            SSPCLK        => SSPCLK,
            SSPTXDMASREQ  => SSPTXDMASREQ,
            SSPTXDMABREQ  => SSPTXDMABREQ,
            SSPRXDMASREQ  => SSPRXDMASREQ,
            SSPRXDMABREQ  => SSPRXDMABREQ,
            SSPTXDMACLR   => SSPTXDMACLR,
            SSPRXDMACLR   => SSPRXDMACLR
            );
   
  PRData0 <= ReadFill(31 downto 16) & SspRdData;
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
