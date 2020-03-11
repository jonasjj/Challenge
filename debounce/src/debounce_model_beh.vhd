library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce_model is
  generic (
      -- 0: No error
      -- 1: Wrong reset value
      -- 2: No output pulse
      -- 3: Pulse lasts more than 1 clock cycle
      -- 4: Accepts button-down < 1000 clock cycles after button-up
      -- 5: Timeout is slightly longer than 1000 clock cycles
      -- 6: Continuous button-down produces repeated pulses
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

  constant clk_hz : integer := 100e6; -- 100 MHz
  constant clk_period : time := 1 sec / clk_hz;
  constant timeout_time : time := 1000 * clk_period;

  -- This signal sets how long into the future the
  -- module shall be unresponsive to button presses.
  signal timeout : time := now;

begin

  assert error_mode >= 0 and error_mode <= 6
    report "error_mode " & integer'image(error_mode) & " is not supported"
    severity failure;

  -- This process controls the press output signal.
  PRESS_PROC : process
  begin

    wait until rising_edge(clk);

    if rst = '1' then
      
      if error_mode /= 1 then
        press <= '0';
      end if;

    elsif now > timeout then

      if button = '1' then

        if error_mode /= 2 then
          press <= '1';
        end if;

        wait until rising_edge(clk);

        if error_mode = 3 then
          wait until rising_edge(clk);
        end if;

        press <= '0';

      end if;

    end if;

  end process;

  -- This process controls the timeout signal.
  TIMEOUT_PROC : process
  begin
    wait until rising_edge(clk) and rst = '0';
  
    if button = '1' then
      timeout <= now + timeout_time;

      if error_mode = 4 then
        timeout <= now + timeout_time - 5 * clk_period;
      end if;

      if error_mode = 5 then
        timeout <= now + 10 ms + 5 * clk_period;
      end if;

      if error_mode = 6 then
        wait until button = '0' for timeout;
      end if;
    end if;

  end process;

end architecture;