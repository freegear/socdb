------------------------------------------------------------------------------
-- Title      : MANIK + SDRAM + UART + OnChip Sync RAM + GPIO + Ethernet MAC
-- Project    : MANIK-II
-------------------------------------------------------------------------------
-- File       : manik_suo.vhd
-- Author     : Sandeep Dutta
-- Company    : NikTech
-- Last update: 2006-10-08
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: This is an example SOC using SDRAM, UART and OnChip Sync
-- 		RAM + GPIO + ETHERNET MAC
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Copyright (c) 2006 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2004/09/06  1.0      Sandeep	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.manikconfig.all;
use work.manikpackage.all;
use work.manikxilinx.all;
use work.manikaltera.all;
use work.manikactel.all;

entity manik_soc is
    port (      
        -- System clock 
        clk_i     : in    std_logic;
        reset_i   : in    std_logic;
        
        -- signals for SDRAM
        sdram_data : inout std_logic_vector (31 downto 0);
        sdram_addr : out   std_logic_vector (CONFIG_SDRAM_ADDR_W-1 downto 0);
        sdram_wen  : out   std_logic;
        sdram_dqm  : out   std_logic_vector (3 downto 0);
        sdram_csn  : out   std_logic_vector (0 downto 0);
        sdram_cke  : out   std_logic_vector(CONFIG_SDRAM_CKES-1 downto 0);
        sdram_rasN : out   std_logic;
        sdram_casN : out   std_logic;
        sdram_ba   : out   std_logic_vector(1 downto 0);        
        sdram_clk  : out   std_logic;
        
        -- UART pins
        txpin     : out   std_logic;
        rxpin     : in    std_logic;

        -- ETHERNET MDII (Phy) Interface
        phy_resetn : out   std_logic;
        phy_mdio   : inout std_logic;
        phy_tx_clk : in    std_logic;
        phy_rx_clk : in    std_logic;
        phy_rxd    : in    std_logic_vector(3 downto 0);
        phy_rx_dv  : in    std_logic;
        phy_rx_er  : in    std_logic;
        phy_rx_col : in    std_logic;
        phy_rx_crs : in    std_logic;
        phy_txd    : out   std_logic_vector(3 downto 0);
        phy_tx_en  : out   std_logic;
        phy_tx_er  : out   std_logic;
        phy_mdc    : out   std_logic;
              
        -- LED Outputs
        seg_led   : out   std_logic_vector (3 downto 0));

end manik_soc;

architecture Behavioral of manik_soc is
    constant USE_ETH  : boolean := false;
    
    constant WIDTH         : integer := 32;
    
    constant ZDATA : std_logic_vector(WIDTH-1 downto 0) := (others => 'Z');
    
    component manik2top
        generic (WIDTH             : integer;
                 UINST_WIDTH       : integer;
                 TIMER_WIDTH       : integer;
                 TIMER_CLK_DIV     : integer;
                 INTR_SWIVEC       : integer;
                 INTR_TMRVEC       : integer;
                 INTR_EXTVEC       : integer;
                 BASE_ROW          : integer;
                 BASE_COL          : integer;
                 USER_INST         : Boolean;
                 ICACHE_ENABLED    : Boolean;
                 DCACHE_ENABLED    : Boolean;
                 ICACHE_LINE_WORDS : integer;
                 DCACHE_LINE_WORDS : integer;
                 ICACHE_ADDR_WIDTH : integer;
                 DCACHE_ADDR_WIDTH : integer;
                 SHIFT_SWIDTH	   : integer;
                 MULT_BWIDTH	   : integer;
                 HW_WPENB	   : Boolean;
                 HW_BPENB	   : Boolean);
        port (clk     	  : in  std_logic;
              EXTRN_int   : in  std_logic_vector (NUM_INTRS-1 downto 0)  := (others => '0');
              RESET_int   : in  std_logic                                := '0';
              INTR_ack	  : out std_logic;

              -- WishBone Bus interface (Master)
              WBM_DAT_I   : in  std_logic_vector (WIDTH-1 downto 0)      := (others => '0');
              WBM_ACK_I   : in  std_logic                                := '0';
              WBM_ERR_I   : in  std_logic                                := '0';
              WBM_DAT_O   : out std_logic_vector (WIDTH-1 downto 0);
              WBM_SEL_O   : out std_logic_vector (3 downto 0);
              WBM_WE_O    : out std_logic;
              WBM_STB_O   : out std_logic;
              WBM_CYC_O   : out std_logic;
              WBM_LOCK_O  : out std_logic;
              WBM_ADR_O   : out std_logic_vector (ADDR_WIDTH-1 downto 0) := (others => '0');
              WBM_CTI_O   : out std_logic_vector (2 downto 0);
              WBM_BTE_O   : out std_logic_vector (1 downto 0);

              -- User Instruction Logic interface
              UINST_uiop  : out std_logic_vector(1 downto 0);
              UINST_uinst : out std_logic;
              UINST_Nce   : out std_logic;
              UINST_wbc   : out std_logic;
              UINST_uiopA : out std_logic_vector(UINST_WIDTH-1 downto 0);
              UINST_uiopB : out std_logic_vector(UINST_WIDTH-1 downto 0);
              UINST_uip   : in  std_logic                                := '0';
              UINST_out   : in  std_logic_vector(UINST_WIDTH-1 downto 0) := (others => '0'));
    end component;

    component serial
        generic (WIDTH         : integer;
                 BAUD_RATE     : integer;
                 CORE_FREQ_MHZ : integer);
        port (clk         :     std_logic;
              reset       :     std_logic;

              -- WishBone Bus interface (slave)
              WBS_ADR_I   : in  std_logic_vector (ADDR_WIDTH-1 downto 0);
              WBS_SEL_I   : in  std_logic_vector (3 downto 0);
              WBS_DAT_I   : in  std_logic_vector (WIDTH-1 downto 0);
              WBS_WE_I    : in  std_logic;
              WBS_STB_I   : in  std_logic;
              WBS_CYC_I   : in  std_logic;
              WBS_CTI_I   : in  std_logic_vector (2 downto 0);
              WBS_BTE_I   : in  std_logic_vector (1 downto 0);
              WBS_DAT_O   : out std_logic_vector (WIDTH-1 downto 0);
              WBS_ACK_O   : out std_logic;
              WBS_ERR_O   : out std_logic;
              
              serial_intr : out std_logic;
              txpin       : out std_logic;
              rxpin       : in  std_logic);
    end component;

    component ocsyncram
        generic (WIDTH      : integer;
                 ADDR_WIDTH : integer);
        port (clk       :     std_logic;
              reset     :     std_logic;
              WBS_ADR_I : in  std_logic_vector (ADDR_WIDTH-1 downto 0);
              WBS_SEL_I : in  std_logic_vector (3 downto 0);
              WBS_DAT_I : in  std_logic_vector (WIDTH-1 downto 0);
              WBS_WE_I  : in  std_logic;
              WBS_STB_I : in  std_logic;
              WBS_CYC_I : in  std_logic;
              WBS_CTI_I : in  std_logic_vector (2 downto 0);
              WBS_BTE_I : in  std_logic_vector (1 downto 0);
              WBS_DAT_O : out std_logic_vector (WIDTH-1 downto 0);
              WBS_ACK_O : out std_logic;
              WBS_ERR_O : out std_logic);
    end component;

    component manikremote
        generic (WIDTH      : integer;
                 ADDR_WIDTH : integer);
        port (clk       :     std_logic;
              reset     :     std_logic;
              WBS_ADR_I : in  std_logic_vector (ADDR_WIDTH-1 downto 0);
              WBS_SEL_I : in  std_logic_vector (3 downto 0);
              WBS_DAT_I : in  std_logic_vector (WIDTH-1 downto 0);
              WBS_WE_I  : in  std_logic;
              WBS_STB_I : in  std_logic;
              WBS_CYC_I : in  std_logic;
              WBS_CTI_I : in  std_logic_vector (2 downto 0);
              WBS_BTE_I : in  std_logic_vector (1 downto 0);
              WBS_DAT_O : out std_logic_vector (WIDTH-1 downto 0);
              WBS_ACK_O : out std_logic;
              WBS_ERR_O : out std_logic);
    end component;

    component gpio
        generic (WIDTH    : integer;
                 I_WIDTH  : integer;
                 O_WIDTH  : integer;                 
                 T_WIDTH  : integer;                 
                 DEBOUNCE : boolean;
                 GENIRQ   : boolean;
                 I_TRI    : boolean;                 
                 I_TYPE   : integer);
        port (clk       : in  std_logic;
              reset     : in  std_logic;
              WBS_ADR_I : in  std_logic_vector (ADDR_WIDTH-1 downto 0);
              WBS_SEL_I : in  std_logic_vector (3 downto 0);
              WBS_DAT_I : in  std_logic_vector (WIDTH-1 downto 0);
              WBS_WE_I  : in  std_logic;
              WBS_STB_I : in  std_logic;
              WBS_CYC_I : in  std_logic;
              WBS_CTI_I : in  std_logic_vector (2 downto 0);
              WBS_BTE_I : in  std_logic_vector (1 downto 0);
              WBS_DAT_O : out std_logic_vector (WIDTH-1 downto 0);
              WBS_ACK_O : out std_logic;
              WBS_ERR_O : out std_logic;
              gp_irq    : out std_logic;
              gp_inout  : inout std_logic_vector(T_WIDTH-1 downto 0);
              gp_input  : in  std_logic_vector(I_WIDTH-1 downto 0) := (others => '0');
              gp_output : out std_logic_vector(O_WIDTH-1 downto 0));
    end component;

    component sdramCntl
        generic (FREQ           : natural;
                 PIPE_EN        : boolean;
                 MAX_NOP        : natural;
                 MULTI_ACT_ROWS : boolean;
                 WIDTH          : natural;
                 CAS_LATENCY    : integer;
                 NROWS          : natural;
                 NCOLS          : natural;
                 ADDR_WIDTH     : natural;
                 RAM_ADDR_W     : natural;
                 SDRAM_CKES	: integer);
        port (clk       : in    std_logic;
              lock      : in    std_logic;
              rst       : in    std_logic;
              WBS_ADR_I : in    std_logic_vector (ADDR_WIDTH-1 downto 0);
              WBS_SEL_I : in    std_logic_vector (3 downto 0);
              WBS_DAT_I : in    std_logic_vector (WIDTH-1 downto 0);
              WBS_WE_I  : in    std_logic;
              WBS_STB_I : in    std_logic;
              WBS_CYC_I : in    std_logic;
              WBS_CTI_I : in    std_logic_vector (2 downto 0);
              WBS_BTE_I : in    std_logic_vector (1 downto 0);
              WBS_DAT_O : out   std_logic_vector (WIDTH-1 downto 0);
              WBS_ACK_O : out   std_logic;
              WBS_ERR_O : out   std_logic;
              cke       : out   std_logic_vector (SDRAM_CKES-1 downto 0);
              ce_n      : out   std_logic;
              ras_n     : out   std_logic;
              cas_n     : out   std_logic;
              we_n      : out   std_logic;
              ba        : out   std_logic_vector(1 downto 0);
              sAddr     : out   std_logic_vector(RAM_ADDR_W-1 downto 0);
              sDInOut   : inout std_logic_vector(WIDTH-1 downto 0);
              dqm       : out   std_logic_vector(3 downto 0);
              sclk      : out   std_logic);
    end component;

    component eth_mac
        generic (ETH_HALF_DUPLEX  : boolean;
                 ETH_ADDR_WIDTH   : integer;
                 ADDR_WIDTH       : integer;
                 WIDTH            : integer;
                 DEFAULT_MAC_ADDR : std_logic_vector (47 downto 0));
        port (reset      : in    std_logic;
              clk        : in    std_logic;
              WBS_ADR_I  : in    std_logic_vector (ADDR_WIDTH-1 downto 0);
              WBS_SEL_I  : in    std_logic_vector (3 downto 0);
              WBS_DAT_I  : in    std_logic_vector (WIDTH-1 downto 0);
              WBS_WE_I   : in    std_logic;
              WBS_STB_I  : in    std_logic;
              WBS_CYC_I  : in    std_logic;
              WBS_CTI_I  : in    std_logic_vector (2 downto 0);
              WBS_BTE_I  : in    std_logic_vector (1 downto 0);
              WBS_DAT_O  : out   std_logic_vector (WIDTH-1 downto 0);
              WBS_ACK_O  : out   std_logic;
              WBS_ERR_O  : out   std_logic;
              eth_intr   : out   std_logic;
              phy_resetn : out   std_logic;
              phy_mdio   : inout std_logic;
              phy_tx_clk : in    std_logic;
              phy_rx_clk : in    std_logic;
              phy_rxd    : in    std_logic_vector(3 downto 0);
              phy_rx_dv  : in    std_logic;
              phy_rx_er  : in    std_logic;
              phy_rx_col : in    std_logic;
              phy_rx_crs : in    std_logic;
              phy_txd    : out   std_logic_vector(3 downto 0);
              phy_tx_en  : out   std_logic;
              phy_tx_er  : out   std_logic;
              phy_mdc    : out   std_logic);
    end component;
    
    signal coreclk     : std_logic;
    signal EXTRN_int   : std_logic_vector(NUM_INTRS-1 downto 0) := (others => '0');
    signal INTR_ack    : std_logic;

    signal MANIK_DAT_I   : std_logic_vector (WIDTH-1 downto 0)      := (others => '0');
    signal MANIK_ACK_I   : std_logic                                := '0';
    signal MANIK_ERR_I   : std_logic                                := '0';
    signal MANIK_DAT_O   : std_logic_vector (WIDTH-1 downto 0);
    signal MANIK_SEL_O   : std_logic_vector (3 downto 0);
    signal MANIK_WE_O    : std_logic;
    signal MANIK_STB_O   : std_logic;
    signal MANIK_CYC_O   : std_logic;
    signal MANIK_LOCK_O  : std_logic;
    signal MANIK_ADR_O   : std_logic_vector (ADDR_WIDTH-1 downto 0) := (others => '0');
    signal MANIK_CTI_O   : std_logic_vector (2 downto 0);
    signal MANIK_BTE_O   : std_logic_vector (1 downto 0);
    
    signal UINST_uiop  : std_logic_vector(1 downto 0)             := "00";
    signal UINST_uinst : std_logic                                := '0';
    signal UINST_Nce   : std_logic                                := '0';
    signal UINST_wbc   : std_logic                                := '0';
    signal UINST_uiopA : std_logic_vector(CONFIG_UINST_WIDTH-1 downto 0) := (others => '0');
    signal UINST_uiopB : std_logic_vector(CONFIG_UINST_WIDTH-1 downto 0) := (others => '0');
    signal UINST_uip   : std_logic                                := '0';
    signal UINST_out   : std_logic_vector(CONFIG_UINST_WIDTH-1 downto 0) := (others => '0');

    signal OCSR_ADR_I : std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal OCSR_SEL_I : std_logic_vector (3 downto 0);
    signal OCSR_DAT_I : std_logic_vector (WIDTH-1 downto 0);
    signal OCSR_WE_I  : std_logic;
    signal OCSR_STB_I : std_logic;
    signal OCSR_CYC_I : std_logic;
    signal OCSR_CTI_I : std_logic_vector (2 downto 0);
    signal OCSR_BTE_I : std_logic_vector (1 downto 0);
    signal OCSR_DAT_O : std_logic_vector (WIDTH-1 downto 0);
    signal OCSR_ACK_O : std_logic;
    signal OCSR_ERR_O : std_logic;
    signal OCSR_en    : std_logic := '0';

    signal SDRAM_ADR_I : std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal SDRAM_SEL_I : std_logic_vector (3 downto 0);
    signal SDRAM_DAT_I : std_logic_vector (WIDTH-1 downto 0);
    signal SDRAM_WE_I  : std_logic;
    signal SDRAM_STB_I : std_logic;
    signal SDRAM_CYC_I : std_logic;
    signal SDRAM_CTI_I : std_logic_vector (2 downto 0);
    signal SDRAM_BTE_I : std_logic_vector (1 downto 0);
    signal SDRAM_DAT_O : std_logic_vector (WIDTH-1 downto 0);
    signal SDRAM_ACK_O : std_logic := '0';
    signal SDRAM_ERR_O : std_logic;
    signal SDRAM_en    : std_logic := '0';
    
    signal UART_ADR_I : std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal UART_SEL_I : std_logic_vector (3 downto 0);
    signal UART_DAT_I : std_logic_vector (WIDTH-1 downto 0);
    signal UART_WE_I  : std_logic;
    signal UART_STB_I : std_logic;
    signal UART_CYC_I : std_logic;
    signal UART_CTI_I : std_logic_vector (2 downto 0);
    signal UART_BTE_I : std_logic_vector (1 downto 0);
    signal UART_DAT_O : std_logic_vector (WIDTH-1 downto 0);
    signal UART_ACK_O : std_logic;
    signal UART_ERR_O : std_logic;
    signal UART_en    : std_logic := '0';
    signal UART_intr  : std_logic;

    signal GPIO0_ADR_I : std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal GPIO0_SEL_I : std_logic_vector (3 downto 0);
    signal GPIO0_DAT_I : std_logic_vector (WIDTH-1 downto 0);
    signal GPIO0_WE_I  : std_logic;
    signal GPIO0_STB_I : std_logic;
    signal GPIO0_CYC_I : std_logic;
    signal GPIO0_CTI_I : std_logic_vector (2 downto 0);
    signal GPIO0_BTE_I : std_logic_vector (1 downto 0);
    signal GPIO0_DAT_O : std_logic_vector (WIDTH-1 downto 0);
    signal GPIO0_ACK_O : std_logic;
    signal GPIO0_ERR_O : std_logic;
    signal GPIO0_en    : std_logic := '0';
    signal GPIO0_intr  : std_logic;

    signal EEMAC_ADR_I : std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal EEMAC_SEL_I : std_logic_vector (3 downto 0);
    signal EEMAC_DAT_I : std_logic_vector (WIDTH-1 downto 0);
    signal EEMAC_WE_I  : std_logic;
    signal EEMAC_STB_I : std_logic;
    signal EEMAC_CYC_I : std_logic;
    signal EEMAC_CTI_I : std_logic_vector (2 downto 0);
    signal EEMAC_BTE_I : std_logic_vector (1 downto 0);
    signal EEMAC_DAT_O : std_logic_vector (WIDTH-1 downto 0);
    signal EEMAC_ACK_O : std_logic;
    signal EEMAC_ERR_O : std_logic;
    signal EEMAC_en    : std_logic := '0';
    signal EEMAC_intr  : std_logic;

    signal stb_o : std_logic := '0';
    
    signal sysclk,clk : std_logic := '0';
    signal reset_in   : std_logic;
    signal io_address : std_logic := '0';
    
begin  -- Behavioral

    sysclk    <= clk_i;

    ---------------------------------------------------------------------------
    --                  SysClock generation
    ---------------------------------------------------------------------------
    xilinx_clk: if Technology = "XILINX" generate
    begin    
        xpll_n: xpll port map (iclk => sysclk, oclk => clk);
    end generate xilinx_clk;

    altera_clk: if Technology = "ALTERA" generate
    begin
        apll_ndiv: apll port map (inclk0 => sysclk, c0 => clk);
    end generate altera_clk;

    actel_clk: if Technology = "ACTEL" generate
      actpll_inst : actpll
        port map (POWERDOWN => '0',
                  CLKA      => sysclk,
                  LOCK      => open,
                  GLA       => clk);
    end generate actel_clk;
    
    reset_high: if RESET_POS = true generate
        reset_in  <= reset_i;        
    end generate reset_high;
    reset_low: if RESET_POS = false generate
        reset_in  <= not reset_i;        
    end generate reset_low;

    ---------------------------------------------------------------------------
    -- I/O address space is uncacheable data space 
    ---------------------------------------------------------------------------
    io_address <= MANIK_ADR_O(ADDR_WIDTH-1);

    manik : manik2top
        generic map (WIDTH             => WIDTH,
                     UINST_WIDTH       => CONFIG_UINST_WIDTH,
                     TIMER_WIDTH       => CONFIG_TIMER_WIDTH,
                     TIMER_CLK_DIV     => CONFIG_TIMER_CLK_DIV,
                     INTR_SWIVEC       => CONFIG_INTR_SWIVEC,
                     INTR_TMRVEC       => CONFIG_INTR_TMRVEC,
                     INTR_EXTVEC       => CONFIG_INTR_EXTVEC,
                     BASE_ROW          => CONFIG_BASE_ROW,
                     BASE_COL          => CONFIG_BASE_COL,
                     USER_INST         => CONFIG_USER_INST,
                     ICACHE_ENABLED    => CONFIG_ICACHE_ENABLED,
                     DCACHE_ENABLED    => CONFIG_DCACHE_ENABLED,
                     ICACHE_LINE_WORDS => CONFIG_ICACHE_LINE_WORDS,
                     DCACHE_LINE_WORDS => CONFIG_DCACHE_LINE_WORDS,
                     ICACHE_ADDR_WIDTH => CONFIG_ICACHE_ADDR_WIDTH,
                     DCACHE_ADDR_WIDTH => CONFIG_DCACHE_ADDR_WIDTH,
                     SHIFT_SWIDTH      => CONFIG_SHIFT_SWIDTH,
                     MULT_BWIDTH       => CONFIG_MULT_BWIDTH,
                     HW_WPENB          => CONFIG_HW_WPENB,
                     HW_BPENB	       => CONFIG_HW_BPENB)
        port map (clk         => clk,
                  EXTRN_int   => EXTRN_int,
                  RESET_int   => reset_in,
                  INTR_ack    => INTR_ack,
                  WBM_DAT_I   => MANIK_DAT_I,
                  WBM_ACK_I   => MANIK_ACK_I,
                  WBM_ERR_I   => MANIK_ERR_I,
                  WBM_DAT_O   => MANIK_DAT_O,
                  WBM_SEL_O   => MANIK_SEL_O,
                  WBM_WE_O    => MANIK_WE_O,
                  WBM_STB_O   => MANIK_STB_O,
                  WBM_CYC_O   => MANIK_CYC_O,
                  WBM_LOCK_O  => MANIK_LOCK_O,
                  WBM_ADR_O   => MANIK_ADR_O,
                  WBM_CTI_O   => MANIK_CTI_O,
                  WBM_BTE_O   => MANIK_BTE_O,
                  
                  UINST_uiop  => UINST_uiop,
                  UINST_uinst => UINST_uinst,
                  UINST_Nce   => UINST_Nce,
                  UINST_wbc   => UINST_wbc,
                  UINST_uiopA => UINST_uiopA,
                  UINST_uiopB => UINST_uiopB,
                  UINST_uip   => UINST_uip,
                  UINST_out   => UINST_out);

    MANIK_ACK_I <= OCSR_ACK_O  when OCSR_en  = '1' else
                   SDRAM_ACK_O when SDRAM_en = '1' else
                   UART_ACK_O  when UART_en  = '1' else
                   GPIO0_ACK_O when GPIO0_en = '1' else
                   EEMAC_ACK_O when EEMAC_en = '1' else '0';
    
    MANIK_DAT_I <= OCSR_DAT_O  when OCSR_en  = '1' else
                   SDRAM_DAT_O when SDRAM_en = '1' else
                   UART_DAT_O  when UART_en  = '1' else
                   GPIO0_DAT_O when GPIO0_en = '1' else
                   EEMAC_DAT_O when EEMAC_en = '1' else (others => '0');

    -- error if address is outof address range
    process (clk)
    begin        
        if rising_edge(clk) then
            if MANIK_ACK_I = '1' then
                stb_o <= '0';
            else
                stb_o <= MANIK_STB_O;             
            end if;
        end if;
    end process;
        
    MANIK_ERR_I <= stb_o and not (OCSR_en or SDRAM_en or UART_en or GPIO0_en or EEMAC_en);
    EXTRN_int(0) <= UART_intr;
    EXTRN_int(1) <= EEMAC_intr;
    
    ---------------------------------------------------------------------------
    -- 			OnChip Sync ram Address 0-0x1FFF                     --
    --			reset vector points here			     --
    ---------------------------------------------------------------------------    
    OCSR_ADR_I <= MANIK_ADR_O;
    OCSR_SEL_I <= MANIK_SEL_O;
    OCSR_DAT_I <= MANIK_DAT_O;
    OCSR_CYC_I <= OCSR_STB_I;
    OCSR_CTI_I <= MANIK_CTI_O;
    OCSR_BTE_I <= MANIK_BTE_O;
    OCSR_WE_I  <= MANIK_WE_O;
    OCSR_STB_I <= MANIK_STB_O when MANIK_ADR_O(ADDR_WIDTH-1 downto 13) = conv_std_logic_vector(0,ADDR_WIDTH-13) else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            if OCSR_ACK_O = '1' then
                OCSR_en <= '0' after 1 ns;
            else
                OCSR_en <=  OCSR_STB_I  after 1 ns;
            end if;
        end if;
    end process ;
    
    ocsyncram_1: manikremote
        generic map (WIDTH      => WIDTH,
                     ADDR_WIDTH => ADDR_WIDTH)
        port map (clk       => clk,
                  reset     => reset_in,                  
                  WBS_ADR_I => OCSR_ADR_I,
                  WBS_SEL_I => OCSR_SEL_I,
                  WBS_DAT_I => OCSR_DAT_I,
                  WBS_WE_I  => OCSR_WE_I,
                  WBS_STB_I => OCSR_STB_I,
                  WBS_CYC_I => OCSR_CYC_I,
                  WBS_CTI_I => OCSR_CTI_I,
                  WBS_BTE_I => OCSR_BTE_I,
                  WBS_DAT_O => OCSR_DAT_O,
                  WBS_ACK_O => OCSR_ACK_O,
                  WBS_ERR_O => OCSR_ERR_O);

    ---------------------------------------------------------------------------
    -- 		Off-Chip SDRAM Controller 32MB Address 0x4000000-0x5ffffff   --
    ---------------------------------------------------------------------------
    SDRAM_ADR_I <= MANIK_ADR_O;
    SDRAM_SEL_I <= MANIK_SEL_O;
    SDRAM_DAT_I <= MANIK_DAT_O;
    SDRAM_CYC_I <= SDRAM_STB_I;
    SDRAM_CTI_I <= MANIK_CTI_O;
    SDRAM_BTE_I <= MANIK_BTE_O;
    SDRAM_WE_I  <= MANIK_WE_O;
    SDRAM_STB_I <= MANIK_STB_O when MANIK_ADR_O(ADDR_WIDTH-1 downto 26) =
                   conv_std_logic_vector(1, ADDR_WIDTH-26) else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            if SDRAM_ACK_O = '1' then
                SDRAM_en <= '0' after 1 ns;
            else
                SDRAM_en <= SDRAM_STB_I after 1 ns;
            end if;
        end if;
    end process;
    
    sdram_controller : sdramCntl
        generic map (FREQ           => CORE_FREQ_MHZ*1000,
                     PIPE_EN        => false,
                     MAX_NOP        => 10000,
                     MULTI_ACT_ROWS => false,
                     WIDTH          => 32,
                     CAS_LATENCY    => 2,
                     NROWS          => 4096,
                     NCOLS          => 256,
                     ADDR_WIDTH     => ADDR_WIDTH,
                     RAM_ADDR_W     => CONFIG_SDRAM_ADDR_W,
                     SDRAM_CKES     => CONFIG_SDRAM_CKES)
        port map (clk       => clk,
                  lock      => '1',
                  rst       => reset_in,
                  WBS_ADR_I => SDRAM_ADR_I,
                  WBS_SEL_I => SDRAM_SEL_I,
                  WBS_DAT_I => SDRAM_DAT_I,
                  WBS_WE_I  => SDRAM_WE_I,
                  WBS_STB_I => SDRAM_STB_I,
                  WBS_CYC_I => SDRAM_CYC_I,
                  WBS_CTI_I => SDRAM_CTI_I,
                  WBS_BTE_I => SDRAM_BTE_I,
                  WBS_DAT_O => SDRAM_DAT_O,
                  WBS_ACK_O => SDRAM_ACK_O,
                  WBS_ERR_O => SDRAM_ERR_O,
                  cke       => sdram_cke,
                  ce_n      => sdram_csn(0),
                  ras_n     => sdram_rasN,
                  cas_n     => sdram_casN,
                  we_n      => sdram_wen,
                  ba        => sdram_ba,
                  sAddr     => sdram_addr,
                  sDInOut   => sdram_data,
                  dqm       => sdram_dqm,
                  sclk      => sdram_clk);
    
    ---------------------------------------------------------------------------
    --            UART - address 0x80000000 - 0x80000001
    ---------------------------------------------------------------------------
    UART_ADR_I <= MANIK_ADR_O;
    UART_SEL_I <= MANIK_SEL_O;
    UART_DAT_I <= MANIK_DAT_O;
    UART_CYC_I <= UART_STB_I;
    UART_CTI_I <= MANIK_CTI_O;
    UART_BTE_I <= MANIK_BTE_O;
    UART_WE_I  <= MANIK_WE_O;
    UART_STB_I <= MANIK_STB_O when io_address = '1' and
                                   MANIK_ADR_O(19 downto 16) = "0000" else '0';
                                       
    process (clk)
    begin
        if rising_edge(clk) then
            if UART_ACK_O = '1' then
                UART_en <= '0' after 1 ns;
            else
                UART_en <=  UART_STB_I after 1 ns;
            end if;
        end if;
    end process ;
    
    serial_inst: serial
        generic map (WIDTH         => WIDTH,
                     BAUD_RATE     => CONFIG_BAUD_RATE,
                     CORE_FREQ_MHZ => CORE_FREQ_MHZ)
        port map (clk         => clk,
                  reset       => reset_in,
                  WBS_ADR_I   => UART_ADR_I,
                  WBS_SEL_I   => UART_SEL_I,
                  WBS_DAT_I   => UART_DAT_I,
                  WBS_WE_I    => UART_WE_I,
                  WBS_STB_I   => UART_STB_I,
                  WBS_CYC_I   => UART_CYC_I,
                  WBS_CTI_I   => UART_CTI_I,
                  WBS_BTE_I   => UART_BTE_I,
                  WBS_DAT_O   => UART_DAT_O,
                  WBS_ACK_O   => UART_ACK_O,
                  WBS_ERR_O   => UART_ERR_O,
                  serial_intr => UART_intr,
                  txpin       => txpin,
                  rxpin       => rxpin);

    ---------------------------------------------------------------------------
    --            GPIO0 - address 0x80010000 - 0x80010003
    ---------------------------------------------------------------------------
    GPIO0_ADR_I <= MANIK_ADR_O;
    GPIO0_SEL_I <= MANIK_SEL_O;
    GPIO0_DAT_I <= MANIK_DAT_O;
    GPIO0_CYC_I <= UART_STB_I;
    GPIO0_CTI_I <= MANIK_CTI_O;
    GPIO0_BTE_I <= MANIK_BTE_O;
    GPIO0_WE_I  <= MANIK_WE_O;
    GPIO0_STB_I <= MANIK_STB_O when io_address = '1' and
                                   MANIK_ADR_O(19 downto 16) = "0001" else '0';
                                       
    process (clk)
    begin
        if rising_edge(clk) then
            if GPIO0_ACK_O = '1' then
                GPIO0_en <= '0' after 1 ns;
            else
                GPIO0_en <=  GPIO0_STB_I after 1 ns;
            end if;
        end if;
    end process ;

    segment_display : gpio
        generic map (WIDTH    => WIDTH,
                     I_WIDTH  => WIDTH,
                     O_WIDTH  => 4,
                     T_WIDTH  => WIDTH,
                     DEBOUNCE => false,                     
                     GENIRQ   => false,
                     I_TRI    => false,
                     I_TYPE   => 1)
        port map (clk       => clk,
                  reset     => reset_in,
                  WBS_ADR_I => GPIO0_ADR_I,
                  WBS_SEL_I => GPIO0_SEL_I,
                  WBS_DAT_I => GPIO0_DAT_I,
                  WBS_WE_I  => GPIO0_WE_I,
                  WBS_STB_I => GPIO0_STB_I,
                  WBS_CYC_I => GPIO0_CYC_I,
                  WBS_CTI_I => GPIO0_CTI_I,
                  WBS_BTE_I => GPIO0_BTE_I,
                  WBS_DAT_O => GPIO0_DAT_O,
                  WBS_ACK_O => GPIO0_ACK_O,
                  WBS_ERR_O => GPIO0_ERR_O,
                  gp_irq    => open,                  
                  gp_inout  => open,                  
                  gp_input  => open,                  
                  gp_output => seg_led);

    ---------------------------------------------------------------------------
    --            ETHERNET MAC - address 0x80020000 - 0x80020008
    ---------------------------------------------------------------------------
    EEMAC_ADR_I <= MANIK_ADR_O;
    EEMAC_SEL_I <= MANIK_SEL_O;
    EEMAC_DAT_I <= MANIK_DAT_O;
    EEMAC_CYC_I <= EEMAC_STB_I;
    EEMAC_CTI_I <= MANIK_CTI_O;
    EEMAC_BTE_I <= MANIK_BTE_O;
    EEMAC_WE_I  <= MANIK_WE_O;
    EEMAC_STB_I <= MANIK_STB_O when io_address = '1' and
                   MANIK_ADR_O(19 downto 16) = "0010" else '0';
    
    process (clk)
    begin
        if rising_edge(clk) then
            if EEMAC_ACK_O = '1' then
                EEMAC_en <= '0' after 1 ns;
            else
                EEMAC_en <=  EEMAC_STB_I after 1 ns;
            end if;
        end if;
    end process ;
    use_eemac: if USE_ETH_MAC = true generate
        easy_eth_mac : eth_mac
            generic map (ETH_HALF_DUPLEX  => false,
                         ETH_ADDR_WIDTH   => 11,
                         ADDR_WIDTH       => ADDR_WIDTH,
                         WIDTH            => WIDTH,
                         DEFAULT_MAC_ADDR => x"001122334455")
            port map (reset      => reset_in,
                      clk        => clk,
                      WBS_ADR_I  => EEMAC_ADR_I,
                      WBS_SEL_I  => EEMAC_SEL_I,
                      WBS_DAT_I  => EEMAC_DAT_I,
                      WBS_WE_I   => EEMAC_WE_I,
                      WBS_STB_I  => EEMAC_STB_I,
                      WBS_CYC_I  => EEMAC_CYC_I,
                      WBS_CTI_I  => EEMAC_CTI_I,
                      WBS_BTE_I  => EEMAC_BTE_I,
                      WBS_DAT_O  => EEMAC_DAT_O,
                      WBS_ACK_O  => EEMAC_ACK_O,
                      WBS_ERR_O  => EEMAC_ERR_O,
                      eth_intr   => EEMAC_intr,
                      phy_resetn => phy_resetn,
                      phy_mdio   => phy_mdio,
                      phy_tx_clk => phy_tx_clk,
                      phy_rx_clk => phy_rx_clk,
                      phy_rxd    => phy_rxd,
                      phy_rx_dv  => phy_rx_dv,
                      phy_rx_er  => phy_rx_er,
                      phy_rx_col => phy_rx_col,
                      phy_rx_crs => phy_rx_crs,
                      phy_txd    => phy_txd,
                      phy_tx_en  => phy_tx_en,
                      phy_tx_er  => phy_tx_er,
                      phy_mdc    => phy_mdc);        
    end generate use_eemac;

    no_eemac: if USE_ETH_MAC = false generate
        EEMAC_DAT_O <= (others => '0');
        EEMAC_ERR_O <= '0';
        EEMAC_ACK_O <= '0';
        EEMAC_intr  <= '0';
    end generate no_eemac;
end Behavioral;
