library verilog;
use verilog.vl_types.all;
entity mem_ctrl is
    port(
        clk             : in     vl_logic;
        resetx          : in     vl_logic;
        apb_enable      : in     vl_logic;
        apb_sel         : in     vl_logic;
        apb_addr        : in     vl_logic_vector(3 downto 2);
        apb_write       : in     vl_logic;
        apb_wdata       : in     vl_logic_vector(31 downto 0);
        apb_rdata       : out    vl_logic_vector(31 downto 0);
        ahb_sel0        : in     vl_logic;
        ahb_sel1        : in     vl_logic;
        ahb_sel2        : in     vl_logic;
        ahb_sel3        : in     vl_logic;
        ahb_readyin     : in     vl_logic;
        ahb_htrans      : in     vl_logic_vector(1 downto 0);
        ahb_addr        : in     vl_logic_vector(19 downto 0);
        ahb_write       : in     vl_logic;
        ahb_size        : in     vl_logic_vector(2 downto 0);
        ahb_wdata       : in     vl_logic_vector(31 downto 0);
        ahb_rdata       : out    vl_logic_vector(31 downto 0);
        ahb_ready       : out    vl_logic;
        ahb_resp        : out    vl_logic_vector(1 downto 0);
        ext_csb         : out    vl_logic_vector(3 downto 0);
        ext_adr         : out    vl_logic_vector(19 downto 0);
        ext_beb         : out    vl_logic_vector(1 downto 0);
        ext_wbeb        : out    vl_logic_vector(1 downto 0);
        ext_web         : out    vl_logic;
        ext_oeb         : out    vl_logic;
        ext_wdata       : out    vl_logic_vector(15 downto 0);
        ext_rdata       : in     vl_logic_vector(15 downto 0);
        ext_bidoe       : out    vl_logic
    );
end mem_ctrl;
