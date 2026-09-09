library verilog;
use verilog.vl_types.all;
entity DmacChRegPOR is
    generic(
        SrcAddrAddr     : integer := 0;
        DestAddrAddr    : integer := 1;
        ControlAddr     : integer := 2;
        DescAddr        : integer := 3;
        StatusAddr      : integer := 4
    );
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(4 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        DMA_BOOT        : in     vl_logic;
        DMA_BOOT_SRC    : in     vl_logic_vector(31 downto 0);
        DMA_BOOT_DST    : in     vl_logic_vector(31 downto 0);
        DMA_BOOT_CTRL   : in     vl_logic_vector(31 downto 0);
        Active          : in     vl_logic;
        DMAReq          : in     vl_logic;
        Enabled         : out    vl_logic;
        Memory2Memory   : out    vl_logic;
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
        Interrupt       : out    vl_logic
    );
end DmacChRegPOR;
