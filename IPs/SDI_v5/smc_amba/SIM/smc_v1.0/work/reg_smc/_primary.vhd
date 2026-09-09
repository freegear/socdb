library verilog;
use verilog.vl_types.all;
entity reg_smc is
    port(
        apb_clk         : in     vl_logic;
        apb_rstb        : in     vl_logic;
        apb_enable      : in     vl_logic;
        apb_sel         : in     vl_logic;
        apb_addr        : in     vl_logic_vector(3 downto 2);
        apb_write       : in     vl_logic;
        apb_wdata       : in     vl_logic_vector(31 downto 0);
        apb_rdata       : out    vl_logic_vector(31 downto 0);
        ahb_write       : in     vl_logic;
        ahb_bsel        : in     vl_logic_vector(3 downto 0);
        dbus_width      : out    vl_logic;
        adr_sft         : out    vl_logic;
        adr_setup       : out    vl_logic_vector(1 downto 0);
        cs_setup        : out    vl_logic_vector(1 downto 0);
        acc_cycle       : out    vl_logic_vector(3 downto 0);
        cs_hold         : out    vl_logic_vector(1 downto 0);
        adr_hold        : out    vl_logic_vector(1 downto 0)
    );
end reg_smc;
