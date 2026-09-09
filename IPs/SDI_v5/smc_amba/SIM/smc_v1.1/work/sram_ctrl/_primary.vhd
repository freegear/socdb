library verilog;
use verilog.vl_types.all;
entity sram_ctrl is
    generic(
        s0              : integer := 1;
        s1              : integer := 2;
        s2              : integer := 4;
        s3              : integer := 8;
        s4              : integer := 16;
        s5              : integer := 32;
        s6              : integer := 64;
        s7              : integer := 128;
        s8              : integer := 256
    );
    port(
        resetx          : in     vl_logic;
        clk             : in     vl_logic;
        sram            : in     vl_logic;
        mesb_adr26_0    : in     vl_logic_vector(26 downto 0);
        esb_bex         : in     vl_logic_vector(3 downto 0);
        esb_rdx         : in     vl_logic;
        esb_wrx         : in     vl_logic;
        esb_burst       : in     vl_logic;
        adr_setup       : in     vl_logic_vector(1 downto 0);
        cs_setup        : in     vl_logic_vector(1 downto 0);
        acc_cycle       : in     vl_logic_vector(3 downto 0);
        cs_hold         : in     vl_logic_vector(1 downto 0);
        adr_hold        : in     vl_logic_vector(1 downto 0);
        use_bex         : in     vl_logic;
        wait_enable     : in     vl_logic;
        dbus_width      : in     vl_logic;
        adr_sft         : in     vl_logic;
        burst_src       : in     vl_logic_vector(6 downto 0);
        waitx           : in     vl_logic;
        sram_csx        : out    vl_logic;
        sram_adr        : out    vl_logic_vector(26 downto 0);
        sram_bex        : out    vl_logic_vector(3 downto 0);
        sram_wex        : out    vl_logic;
        sram_rdx        : out    vl_logic;
        sram_ibex       : out    vl_logic_vector(3 downto 0);
        sram_latch      : out    vl_logic;
        sram_rdyx       : out    vl_logic;
        sram_wenx       : out    vl_logic;
        sram_idle       : out    vl_logic;
        burst_end       : out    vl_logic
    );
end sram_ctrl;
