library verilog;
use verilog.vl_types.all;
entity SEG_SLAVE is
    port(
        HSEL            : in     vl_logic;
        HWRITE          : in     vl_logic;
        HRESETn         : in     vl_logic;
        HCLOCK          : in     vl_logic;
        HADDRESS        : in     vl_logic_vector(31 downto 0);
        HBURST          : in     vl_logic_vector(2 downto 0);
        HSIZE           : in     vl_logic_vector(1 downto 0);
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HREADY          : out    vl_logic;
        lcd_en          : out    vl_logic;
        phase           : out    vl_logic;
        cnt3            : out    vl_logic_vector(1 downto 0);
        data_out        : out    vl_logic_vector(7 downto 0);
        HRESP           : out    vl_logic_vector(1 downto 0);
        mode            : out    vl_logic_vector(1 downto 0);
        rd_address      : out    vl_logic_vector(4 downto 0);
        read_reg        : out    vl_logic_vector(31 downto 0);
        seg_data        : out    vl_logic_vector(31 downto 0);
        seg_gnd1        : out    vl_logic_vector(2 downto 0);
        seg_gnd2        : out    vl_logic_vector(2 downto 0);
        seg_out1        : out    vl_logic_vector(7 downto 0);
        seg_out2        : out    vl_logic_vector(7 downto 0)
    );
end SEG_SLAVE;
