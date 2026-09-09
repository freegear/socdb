library verilog;
use verilog.vl_types.all;
entity smc_reg is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        paddr           : in     vl_logic_vector(3 downto 2);
        psel            : in     vl_logic;
        penable         : in     vl_logic;
        pwrite          : in     vl_logic;
        pwdata          : in     vl_logic_vector(31 downto 0);
        prdata          : out    vl_logic_vector(31 downto 0);
        sram_start      : in     vl_logic;
        bank_sel        : in     vl_logic_vector(3 downto 0);
        addr_setup      : out    vl_logic_vector(2 downto 0);
        addr_hold       : out    vl_logic_vector(2 downto 0);
        cs_setup        : out    vl_logic_vector(2 downto 0);
        cs_hold         : out    vl_logic_vector(2 downto 0);
        acc_cycle       : out    vl_logic_vector(3 downto 0);
        bus_width       : out    vl_logic_vector(1 downto 0);
        addr_shift      : out    vl_logic_vector(1 downto 0)
    );
end smc_reg;
