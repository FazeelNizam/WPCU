library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity WPCU is
  port (
    CLK                                                : in  std_logic;
    RST                                                : in  std_logic; 
    leak_sensor_01, leak_sensor_02, leak_sensor_03     : in  std_logic;
	pump_control 	                                   : inout std_logic;
    high_01, high_02, high_03                          : in  std_logic;
    low_01, low_02, low_03                             : in  std_logic;
    switch_01, switch_02, switch_03                    : in  std_logic;		 
    valve_01, valve_02, valve_03 		               : out std_logic;
    filling_out                                        : out std_logic
	
  );
end WPCU;

architecture Structural of WPCU is
    -- Signals for the output of each FSM
    signal V1, V2, V3, Fo1, Fo2, Fo3, P1, P2, P3 : STD_LOGIC;
    
    -- Component declaration for FSM
    component FSM
        Port (
            clk             : in  std_logic;
            reset           : in  std_logic; 
            leak_sensor     : in  std_logic;
            pump_control 	: inout std_logic;
            high            : in  std_logic;
            low             : in  std_logic;
            switch          : in  std_logic;		 
            valve 		    : out std_logic;
            filling_out     : out std_logic
        );
    end component;
begin
    -- Instantiating FSM for Building 01
    FSM_Building_1 : FSM
        port map (
            clk => CLK,
            reset => RST,
            leak_sensor => leak_sensor_01,
            pump_control => P1,
            high => high_01,
            low => low_01,
            switch => switch_01,
            valve => V1,
            filling_out => Fo1   
        );

    -- Instantiating FSM for Building 02
    FSM_Building_2 : FSM
        port map (
            clk => CLK,
            reset => RST,
            leak_sensor => leak_sensor_02,
            pump_control => P2,
            high => high_02,
            low => low_02,
            switch => switch_02,
            valve => V2,
            filling_out => Fo2   
        );

    -- Instantiating FSM for Building 03
    FSM_Building_3 : FSM
        port map (
            clk => CLK,
            reset => RST,
            leak_sensor => leak_sensor_03,
            pump_control => P3,
            high => high_03,
            low => low_03,
            switch => switch_03,
            valve => V3,
            filling_out => Fo3   
        );

    -- Assign internal signals to output ports
	pump_control <= P1 or P2 or P3;  -- Shared pump control signal
    valve_01 <= V1;
    valve_02 <= V2;
    valve_03 <= V3;
    filling_out <= Fo1 or Fo2 or Fo3; -- Combined filling status for all buildings


end Structural;
