library verilog;
use verilog.vl_types.all;
entity dp_ram is
    port(
        clk             : in     vl_logic;
        write           : in     vl_logic;
        wr_address      : in     vl_logic_vector(5 downto 0);
        wr_data         : in     vl_logic_vector(7 downto 0);
        read            : in     vl_logic;
        rd_address      : in     vl_logic_vector(5 downto 0);
        rd_data         : out    vl_logic_vector(7 downto 0)
    );
end dp_ram;
