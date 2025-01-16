library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WPCU_tb is
end WPCU_tb;

architecture test of WPCU_tb is

    -- Component Under Test
    component WPCU
        port (
            CLK                                             : in  std_logic;
            RST                                             : in  std_logic;
            leak_sensor_01, leak_sensor_02, leak_sensor_03  : in  std_logic;
            pump_control                                    : inout std_logic;
            high_01, high_02, high_03                       : in  std_logic;
            low_01, low_02, low_03                          : in  std_logic;
            switch_01, switch_02, switch_03                 : in  std_logic;		 
            valve_01, valve_02, valve_03                    : out std_logic;
            filling_out                                     : out std_logic
        );
    end component;

    -- Signals to connect to the WPCU instance
    signal CLK                                              : std_logic := '0';
    signal RST                                              : std_logic := '0';
    signal leak_sensor_01, leak_sensor_02, leak_sensor_03   : std_logic := '0';
    signal pump_control                                     : std_logic;
    signal high_01, high_02, high_03                        : std_logic := '0';
    signal low_01, low_02, low_03                           : std_logic := '0';
    signal switch_01, switch_02, switch_03                  : std_logic := '0';		 
    signal valve_01, valve_02, valve_03                     : std_logic;
    signal filling_out                                      : std_logic;

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the WPCU (DUT)
    DUT: WPCU
        port map (
            CLK            => CLK,
            RST            => RST,
            leak_sensor_01 => leak_sensor_01,
            leak_sensor_02 => leak_sensor_02,
            leak_sensor_03 => leak_sensor_03,
            pump_control   => pump_control,
            high_01        => high_01,
            high_02        => high_02,
            high_03        => high_03,
            low_01         => low_01,
            low_02         => low_02,
            low_03         => low_03,
            switch_01      => switch_01,
            switch_02      => switch_02,
            switch_03      => switch_03,
            valve_01       => valve_01,
            valve_02       => valve_02,
            valve_03       => valve_03,
            filling_out    => filling_out
        );

    -- Clock generation
    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Test process
    test_process: process
    begin
        -- Initialize signals
        RST <= '1';
        wait for 20 ns;
        RST <= '0';

        -- Test Case 1: Start filling Building 1
        switch_01 <= '1'; -- Enable filling for Building 1
        high_01 <= '0';
        low_01 <= '1';    -- Low signal active to start filling
        wait for 20 ns;
        
        -- Leakage Test 1: Simulate leak in Building 1 during filling
        leak_sensor_01 <= '1'; -- Leak detected in building 01
        wait for 10 ns;
        leak_sensor_01 <= '0';
        wait for 10 ns;
        
        -- Test Case 2: Start filling Building 2 while Building 1 is still filling
        switch_02 <= '1';
        high_02 <= '0';
        low_02 <= '1';    -- Low signal active to start filling
        wait for 20 ns;

        -- Leakage Test 2: Simulate leak in Building 2 during filling
        leak_sensor_02 <= '1'; -- Leak detected in building 02
        wait for 10 ns;
        leak_sensor_02 <= '0';
        wait for 10 ns;

        -- Test Case 3: Stop filling Building 1 and start filling Building 2
        low_01 <= '0';
        high_01 <= '1'; -- High signal to stop filling Building 1
        wait for 10 ns;

        low_02 <= '1';  -- Low signal active for Building 2
        wait for 20 ns;

        -- Test Case 4: Start filling Building 3 while Building 2 is still filling
        switch_03 <= '1';
        high_03 <= '0';
        low_03 <= '1';    -- Low signal active to start filling
        wait for 20 ns;

        -- Leakage Test 3: Simulate leak in Building 3 during filling
        leak_sensor_03 <= '1'; -- Leak detected in building 03
        wait for 10 ns;
        leak_sensor_03 <= '0';
        wait for 10 ns;

        -- Test Case 5: Stop filling Building 2 and start filling Building 3
        low_02 <= '0';
        high_02 <= '1'; -- High signal to stop filling Building 2
        wait for 10 ns;

        low_03 <= '1';   -- Low signal active to start filling
        wait for 40 ns;

        -- Test Case 6: Reset test
        RST <= '1';     -- Trigger reset
        wait for 20 ns;
        RST <= '0';
        wait for 10 ns;
        low_03 <= '0';
        high_03 <= '1'; -- High signal to stop filling Building 3

        -- End of test
        wait;
    end process;

end test;
