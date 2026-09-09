library verilog;
use verilog.vl_types.all;
entity mailboxblk is
    port(
        rst             : in     vl_logic;
        clkrd           : in     vl_logic;
        clkwr           : in     vl_logic;
        rd              : in     vl_logic;
        we              : in     vl_logic;
        wr64            : in     vl_logic;
        rdaddr          : in     vl_logic_vector(2 downto 0);
        wraddr          : in     vl_logic_vector(2 downto 0);
        ben             : in     vl_logic_vector(7 downto 0);
        din             : in     vl_logic_vector(63 downto 0);
        dout            : out    vl_logic_vector(63 downto 0);
        full            : out    vl_logic_vector(3 downto 0)
    );
end mailboxblk;
