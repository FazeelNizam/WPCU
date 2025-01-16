library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
  port (
    clk             : in  std_logic;
    reset           : in  std_logic; 
    leak_sensor     : in  std_logic;
	pump_control 	: out std_logic;
    high            : in  std_logic;
    low             : in  std_logic;
    switch          : in  std_logic;		 
    valve 		    : out std_logic;
--    filling_in      : in std_logic;
    filling_out     : out std_logic
	
  );
end FSM;

architecture Behavioral of FSM is

	-- States for building FSM
    type state_type is (S0, S1, S2, S3); 
    signal current_state, next_state : state_type;
    signal pump_enable               : std_logic;
    signal filling_signal            : std_logic;
    signal reset_new                 : std_logic;
   
begin	   
	
	
	-- Leak detection logic: Reset if any leak detected
--    process (leak_sensor)
--    begin
--    	if (leak_sensor = '1') then	
--            pump_enable <= '0'; -- Disable pump if any leak detected
--        else						
--            pump_enable <= '1'; -- Enable pump if no leaks detected
--        end if;
--    end process; 	
    
    pump_enable <= not leak_sensor;
    pump_control <= pump_enable;
    reset_new <= reset or leak_sensor;
	
    -- Motor control logic: Motor is enabled if motor_enable is '1'	
--	process (pump_enable)  
--	begin
--		if (pump_enable = '1')	then
--			pump_control <= '1';
--		else
--			pump_control <= '0';
--		end if;
--	end process;

	-- Signal assignments
    filling_signal <= pump_enable;
	filling_out <= filling_signal;
	
	
    -- FSM ------------------------------------------------ 
	
	--Clock & Reset 
    process (clk, reset_new)
    begin
        if (reset_new = '1') then
            current_state <= S0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
	
	--State transitions
    process (current_state, high, low, switch, filling_signal)
    begin
        case current_state is
        
        -- State 00
            when S0 =>
                valve <= '0';
		        pump_enable <= '0';
                if switch = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
        
        -- State 01      
            when S1 =>
                valve <= '0';
                pump_enable <= '0';
                if low = '1' then
                    next_state <= S2;
                else
                    next_state <= S1;
                end if;
        
        -- State 02
            when S2 =>
                next_state <= S3;
                valve <= '0';
                pump_enable <= '0';
                if filling_signal = '0' then
                    next_state <= S3;
                else
                    next_state <= S2;
                end if;
        
        -- State 03                
            when S3 =>
                next_state <= S0;
                valve <= '1';
                pump_enable <= '1';
                if high = '1' then
                    -- Transition back to S0
                    next_state <= S0;
                else
                    next_state <= S3;
                end if;
                
            when others =>
                next_state <= S0;
        end case;
    end process;

end Behavioral;