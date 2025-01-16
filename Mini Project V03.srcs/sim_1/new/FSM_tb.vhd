library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_tb is
end FSM_tb;

architecture tb of FSM_tb is
    signal clk, reset, leak_sensor : std_logic := '0';
    signal high, low, switch : std_logic := '0';
    signal pump_control, valve : std_logic;
    signal filling_out         :  std_logic;

    constant clk_period : time := 10 ns;
begin
    -- Instantiate FSM
    uut: entity work.FSM
        port map (
            clk => clk,
            reset => reset,
            leak_sensor => leak_sensor,
            pump_control => pump_control,
            high => high,
            low => low,
            switch => switch,
            valve => valve,
            filling_out => filling_out
        );

    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Test process
    test_process : process
    begin
        
        -- Initial state
        reset <= '1';
        leak_sensor <= '0';
        switch <= '0';
        low <= '0';
        high <= '0';
        
        -- Reset the system
        wait for 20 ns;
        reset <= '0';
        
        -- Test Case 1: Switch pressed, no leak
        switch <= '1';
        wait for 20 ns;
        
        -- Test Case 2: Low signal active, pump should on
        low <= '1';
        wait for 20 ns;
        
        -- Test Case 3: Leak detected, pump should be off
        leak_sensor <= '1';
        wait for 20 ns;
        
        -- Test Case 4: Leak cleared, pump should start again
        leak_sensor <= '0';
        wait for 20 ns;
        
        -- Test Case 5: High signal active, pump should be off
        low <= '0';
        wait for 20 ns;
        high <= '1';  -- Simulate high signal being active
        wait for 20 ns;

        -- Test Case 6: Switch off and wait for transition to S0
        switch <= '0';
        wait for 40 ns;
        
        
        wait;
    end process;

end tb;
