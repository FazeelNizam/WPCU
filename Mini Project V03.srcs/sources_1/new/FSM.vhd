library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
  port (
    clk             : in  std_logic;
    reset           : in  std_logic; 
    leak_sensor     : in  std_logic;
    pump_control    : out std_logic;
    high            : in  std_logic;
    low             : in  std_logic;
    switch          : in  std_logic;		 
    valve           : out std_logic;
    filling_out     : out std_logic
  );
end FSM;

architecture Behavioral of FSM is
    -- States for building FSM
    type state_type is (S0, S1, S2, S3); 
    signal current_state, next_state : state_type;
    signal pump_enable               : std_logic;
    signal filling_signal            : std_logic;
   
begin	   
    -- Leak detection and state transition process
    process (clk, reset, leak_sensor)
    begin
        if (reset = '1' or leak_sensor = '1') then
            current_state <= S0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
	
    -- State logic and control process
    process (current_state, high, low, switch, filling_signal)
    begin
        case current_state is
            -- State 00
            when S0 =>
                valve <= '0';
                pump_control <= '0';
                pump_enable <= '0';
                filling_out <= '0';
                
                if switch = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
        
            -- State 01      
            when S1 =>
                valve <= '0';
                pump_control <= '0';
                pump_enable <= '0';
                filling_out <= '0';
                
                if low = '1' then
                    next_state <= S2;
                else
                    next_state <= S1;
                end if;
        
            -- State 02
            when S2 =>
                valve <= '0';
                pump_control <= '1';
                pump_enable <= '1';
                filling_out <= '1';
                
                if filling_signal = '0' then
                    next_state <= S3;
                else
                    next_state <= S2;
                end if;
        
            -- State 03                
            when S3 =>
                valve <= '1';
                pump_control <= '1';
                pump_enable <= '1';
                filling_out <= '1';
                
                if high = '1' then
                    next_state <= S0;
                else
                    next_state <= S3;
                end if;
                
            when others =>
                valve <= '0';
                pump_control <= '0';
                pump_enable <= '0';
                filling_out <= '0';
                next_state <= S0;
        end case;
    end process;
end Behavioral;