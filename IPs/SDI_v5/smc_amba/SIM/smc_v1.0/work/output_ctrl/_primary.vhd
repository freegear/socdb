library verilog;
use verilog.vl_types.all;
entity output_ctrl is
    port(
        resetx          : in     vl_logic;
        clk             : in     vl_logic;
        sram            : in     vl_logic;
        reg_rdata       : in     vl_logic_vector(17 downto 0);
        reg_rdyx        : in     vl_logic;
        m2b_data        : in     vl_logic_vector(31 downto 0);
        esb_adr26_2     : in     vl_logic_vector(26 downto 2);
        esb_dout        : in     vl_logic_vector(31 downto 0);
        sram_adr        : in     vl_logic_vector(26 downto 0);
        sram_ibex       : in     vl_logic_vector(3 downto 0);
        sram_latch      : in     vl_logic;
        sram_rdyx       : in     vl_logic;
        sram_wenx       : in     vl_logic;
        mem_adr         : out    vl_logic_vector(26 downto 0);
        mem_rdyx        : out    vl_logic;
        mem_wenx        : out    vl_logic;
        b2m_data        : out    vl_logic_vector(31 downto 0);
        mem_rdata       : out    vl_logic_vector(31 downto 0)
    );
end output_ctrl;
