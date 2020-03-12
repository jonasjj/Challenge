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

  DUT : entity work.debounce(rtl)
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

    -- Check the value after reset
    assert press = '0'
      report "should be '0' after reset"
      severity failure;

    -- Check value after the first button press
    pulse;
    assert press = '1'
      report "press should be '1' after first button-down"
      severity failure;

    -- Check that the pulse lasts for 1 clock cycle
    wait until rising_edge(clk);
    assert press = '0'
      report "pulse should last for 1 clock cycle"
      severity failure;
    
    -- Check that a button-down < 1000 clock cycles after button-up is ignored
    wait for 996 * clk_period;
    pulse;
    assert press = '0'
      report "button-down < 1000 cycles after button-up should be ignored"
      severity failure;
    wait for 1 * clk_period;

    -- Check that a button-down > 1000 cycles after the last button-up is counted
    wait for 1000 * clk_period;
    pulse;
    assert press = '1'
      report "button-down 1000 cycles after button-up should be counted"
      severity failure;
    
    -- Check that there is no new pulse on continuous button-down
    button <= '1'; -- hold down the button
    wait for 3 * 1000 * clk_period;
    assert press = '0' report "should be '0' after long button-down";
    assert press'stable(3 * 1000 * clk_period)
      report "should remain '0' during long button-down"
      severity failure;

    wait for 10 * clk_period;
    write(str, string'("Test finished: OK"));
    writeline(output, str);
    finish;
  end process;
  
end architecture;