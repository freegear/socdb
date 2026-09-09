library verilog;
use verilog.vl_types.all;
entity AHB_interface is
    generic(
        IDLE            : integer := 1;
        R_ADDR          : integer := 2;
        W_ADDR          : integer := 4;
        W_DATA          : integer := 8;
        OPERATION       : integer := 16
    );
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HADDR           : in     vl_logic_vector(19 downto 0);
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HWRITE          : in     vl_logic;
        HSIZE           : in     vl_logic_vector(2 downto 0);
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HSEL0           : in     vl_logic;
        HSEL1           : in     vl_logic;
        HSEL2           : in     vl_logic;
        HSEL3           : in     vl_logic;
        HREADY_in       : in     vl_logic;
        HREADY_out      : out    vl_logic;
        HRESP           : out    vl_logic_vector(1 downto 0);
        HRDATA          : out    vl_logic_vector(31 downto 0);
        READY           : in     vl_logic;
        RDATA           : in     vl_logic_vector(31 downto 0);
        ADDR            : out    vl_logic_vector(19 downto 0);
        WDATA           : out    vl_logic_vector(31 downto 0);
        WRITE           : out    vl_logic;
        READ            : out    vl_logic;
        BANK_SEL        : out    vl_logic_vector(3 downto 0);
        SRAM_START      : out    vl_logic;
        TRANS_SIZE      : out    vl_logic_vector(2 downto 0)
    );
end AHB_interface;
