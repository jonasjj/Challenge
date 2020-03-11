library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.all;
use std.textio.all;

entity debounce_tb is
end debounce_tb; 

architecture sim of debounce_tb is

  constant clk_hz : integer := 100e6; -- 100 MHz
  constant clk_period : time := 1 sec / clk_hz;

  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal button : std_logic := '0';
  signal press : std_logic;

begin

  -- ** DUT requirements **
  --
  -- Shall only produce pulse on button-down
  -- Shall ignore button-down < 1000 clock cycles after button-up
  -- Shall only produce 1 pulse per click
  -- Output pulse shall be 1 clock cycle long
  -- Output pulse shall appear the clock cycle after a button-down

  clk <= not clk after clk_period / 2;

  -- DUT : entity work.debounce(rtl)
	-- port map (
	--  clk => clk,
	--  rst => rst,
	--  button => button,
	--  press => press		 
  -- );
  
  DUT : entity work.debounce_model(beh)
  generic map (
      -- 0: No error
      -- 1: Wrong reset value
      -- 2: No output pulse
      -- 3: Pulse lasts more than 1 clock cycle
      -- 4: Accepts button-down < 1000 clock cycles after button-up
      -- 5: Timeout is slightly longer than 1000 clock cycles
      -- 6: Continuous button-down produces repeated pulses
    error_mode => 0
  )
  port map (
    clk => clk,
    rst => rst,
    button => button,
    press => press
  );

  SEQUENCER_PROC : process

    variable str : line;
    
    procedure pulse is
    begin
      button <= '1';
      wait until rising_edge(clk);
      button <= '0';
      wait until rising_edge(clk);
    end procedure;

  begin
    wait for 2 * clk_period;
    rst <= '0';

    pulse;

    -- Check the value after reset

    -- Check value after the first button press

    -- Check that the pulse lasts for 1 clock cycle

    -- Check that a button-down < 1000 clock cycles after button-up is ignored

    -- Check that a button-down > 1000 cycles after the last button-up is counted

    -- Check that there is no new pulse on continuous button-down

    wait for 10 * clk_period;
    write(str, string'("Test finished: OK"));
    writeline(output, str);
    finish;
  end process;
  
end architecture;