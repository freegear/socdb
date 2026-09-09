library verilog;
use verilog.vl_types.all;
entity SmiCore is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HADDR           : in     vl_logic_vector(28 downto 0);
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HWRITE          : in     vl_logic;
        HSIZE           : in     vl_logic_vector(2 downto 0);
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HSELSMC         : in     vl_logic;
        HREADYIN        : in     vl_logic;
        HRDATA          : out    vl_logic_vector(31 downto 0);
        HREADYOUT       : out    vl_logic;
        HRESP           : out    vl_logic_vector(1 downto 0);
        REMAP           : in     vl_logic;
        SMDATAIN        : in     vl_logic_vector(31 downto 0);
        SMDATAOUT       : out    vl_logic_vector(31 downto 0);
        nSMDATAEN       : out    vl_logic_vector(3 downto 0);
        SMADDR          : out    vl_logic_vector(25 downto 0);
        SMCS            : out    vl_logic_vector(7 downto 0);
        nSMBLS          : out    vl_logic_vector(3 downto 0);
        nSMOEN          : out    vl_logic
    );
end SmiCore;
