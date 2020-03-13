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

  signal timeout : integer range 0 to 999;
  signal button_p1 : std_logic;

begin
  
  DEBOUNCE_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        timeout <= 0;
        press <= '0';
        button_p1 <= '0';
        
      else
        press <= '0';
        button_p1 <= button;

        if timeout = 0 then

          if button = '1' and button_p1 = '0' then
            press <= '1';
          end if;

        else
          timeout <= timeout - 1;
        end if;

        if button = '0' and button_p1 = '1' then
          timeout <= 999;
        end if;

      end if;
    end if;
  end process;

end architecture;