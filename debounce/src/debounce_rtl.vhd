library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
  port (
    clk : in std_logic;
    rst : in std_logic;
    button : in std_logic;
    press : out std_logic
  );
end debounce;

architecture rtl of debounce is
begin



end architecture;