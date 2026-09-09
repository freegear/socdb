library verilog;
use verilog.vl_types.all;
entity pci_barreg is
    generic(
        present         : integer := 0;
        dwidth          : integer := 0;
        barmap          : integer := 0;
        c_0x0000        : integer := 0
    );
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        we              : in     vl_logic;
        acc_space       : in     vl_logic;
        first_cyc       : in     vl_logic;
        din             : in     vl_logic_vector(31 downto 0);
        busadr          : in     vl_logic_vector(31 downto 0);
        ben             : in     vl_logic_vector(3 downto 0);
        hit             : out    vl_logic;
        limit           : out    vl_logic;
        dout            : out    vl_logic_vector(31 downto 0)
    );
end pci_barreg;
