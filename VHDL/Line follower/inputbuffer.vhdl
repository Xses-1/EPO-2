library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Please add necessary libraries:


entity inputbuffer is
	port (	clk		: in	std_logic;

		sensor_l_in	: in	std_logic;
		sensor_m_in	: in	std_logic;
		sensor_r_in	: in	std_logic;

		sensor_l_out	: out	std_logic;
		sensor_m_out	: out	std_logic;
		sensor_r_out	: out	std_logic
	);
end entity inputbuffer;




architecture structural of inputbuffer is

component flipflop is 

	port(clk, sensor_l_in, sensor_m_in, sensor_r_in: in std_logic;  sensor_l_out, sensor_m_out, sensor_r_out: out std_logic);
end component;

signal s1, s2, s3: std_logic;

begin 

FF1: flipflop port map(	clk => clk, 

			sensor_l_in => sensor_l_in, 
			sensor_m_in => sensor_m_in,  
			sensor_r_in => sensor_r_in, 

			sensor_l_out => s1,
			sensor_m_out => s2,
			sensor_r_out => s3);

FF2: flipflop port map(	clk => clk, 

			sensor_l_in => s1,
			sensor_m_in => s2,
			sensor_r_in => s3,

			sensor_l_out => sensor_l_out,
			sensor_m_out => sensor_m_out,
			sensor_r_out => sensor_r_out);

end structural;

			

