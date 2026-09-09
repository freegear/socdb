library verilog;
use verilog.vl_types.all;
entity apb_sram is
    generic(
        addr_width      : integer := 12
    );
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        penable         : in     vl_logic;
        psel            : in     vl_logic;
        pwrite          : in     vl_logic;
        paddr           : in     vl_logic_vector;
        pwdata          : in     vl_logic_vector(31 downto 0);
        prdata          : out    vl_logic_vector(31 downto 0);
        pready          : out    vl_logic
    );
end apb_sram;
