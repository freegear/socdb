library verilog;
use verilog.vl_types.all;
entity apb2ahb is
    port(
        clk             : in     vl_logic;
        resetn          : in     vl_logic;
        paddr           : in     vl_logic_vector(11 downto 2);
        pwrite          : in     vl_logic;
        psel            : in     vl_logic;
        penable         : in     vl_logic;
        prdata          : out    vl_logic_vector(31 downto 0);
        pwdata          : in     vl_logic_vector(31 downto 0);
        pready          : out    vl_logic;
        hsel            : out    vl_logic;
        hwrite          : out    vl_logic;
        htrans          : out    vl_logic;
        haddr           : out    vl_logic_vector(11 downto 2);
        hsize           : out    vl_logic_vector(2 downto 0);
        hreadyin        : out    vl_logic;
        hwdata          : out    vl_logic_vector(31 downto 0);
        hreadyout       : in     vl_logic;
        hresp           : in     vl_logic_vector(1 downto 0);
        hrdata          : in     vl_logic_vector(31 downto 0)
    );
end apb2ahb;
