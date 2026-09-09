library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bid_buff is
  port (
	sda_out : in std_logic;
	ack_enb : in std_logic;
	sda_in  : out std_logic;
        sda     : inout std_logic
  );
end bid_buff;

architecture func of bid_buff is
begin

  sda_in <= sda;

  sda <= sda_out when ack_enb = '0' else 'Z';

end func;
