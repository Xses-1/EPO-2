library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Please add necessary libraries:


entity flipflop is
	port (	clk		: in	std_logic;

		sensor_l_in	: in	std_logic;
		sensor_m_in	: in	std_logic;
		sensor_r_in	: in	std_logic;

		sensor_l_out	: out	std_logic;
		sensor_m_out	: out	std_logic;
		sensor_r_out	: out	std_logic
	);
end entity flipflop;


architecture behavioral of flipflop is 

begin
	process (clk)
	begin 
		if rising_edge(clk) then
			sensor_l_out <= sensor_l_in;
			sensor_m_out <= sensor_m_in;
			sensor_r_out <= sensor_r_in;

		end if;
	end process;

end behavioral;
