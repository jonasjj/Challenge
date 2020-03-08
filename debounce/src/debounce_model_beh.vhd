library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce_model is
  generic (
      error_mode : integer := 0
    );
  port (
    clk : in std_logic;
    rst : in std_logic;
    button : in std_logic;
    press : out std_logic
  );
end debounce_model;

architecture beh of debounce_model is
begin



end architecture;