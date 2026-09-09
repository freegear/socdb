library verilog;
use verilog.vl_types.all;
entity DmacRegFile4Ch is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(6 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        Active          : in     vl_logic_vector(3 downto 0);
        DMAReq          : in     vl_logic_vector(3 downto 0);
        Enabled         : out    vl_logic_vector(3 downto 0);
        Memory2Memory   : out    vl_logic_vector(3 downto 0);
        Control         : out    vl_logic_vector(31 downto 0);
        SrcAddr         : out    vl_logic_vector(31 downto 0);
        DestAddr        : out    vl_logic_vector(31 downto 0);
        Descriptor      : out    vl_logic_vector(31 downto 0);
        ControlWE       : in     vl_logic;
        SrcAddrWE       : in     vl_logic;
        DestAddrWE      : in     vl_logic;
        DescriptorWE    : in     vl_logic;
        ControlWData    : in     vl_logic_vector(31 downto 0);
        SrcAddrWData    : in     vl_logic_vector(31 downto 0);
        DestAddrWData   : in     vl_logic_vector(31 downto 0);
        DescriptorWData : in     vl_logic_vector(31 downto 0);
        StartInterruptIn: in     vl_logic;
        EndInterruptIn  : in     vl_logic;
        ErrorInterruptIn: in     vl_logic;
        StopInterruptIn : in     vl_logic;
        Interrupt       : out    vl_logic_vector(3 downto 0)
    );
end DmacRegFile4Ch;
