library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity inputbuffer_tb is
end entity inputbuffer_tb;


architecture structural of inputbuffer_tb is

	component inputbuffer is
		port (	clk		: in	std_logic;

			sensor_l_in	: in	std_logic;
			sensor_m_in	: in	std_logic;
			sensor_r_in	: in	std_logic;

			sensor_l_out	: out	std_logic;
			sensor_m_out	: out	std_logic;
			sensor_r_out	: out	std_logic
		);
	end component inputbuffer;


	signal clk, sensor_l_in, sensor_m_in, sensor_r_in, sensor_l_out, sensor_m_out, sensor_r_out: std_logic;


begin
	lb10: inputbuffer port map(	clk			=> clk,
					sensor_l_in		=> sensor_l_in,
					sensor_m_in		=> sensor_m_in,
					sensor_r_in		=> sensor_r_in,
					sensor_l_out		=> sensor_l_out,
					sensor_m_out		=> sensor_m_out,
					sensor_r_out		=> sensor_r_out
				);


	
	
	clk			<=	'0' after 0 ns,
					'1' after 10 ns when clk /= '1' else '0' after 10 ns;

	

	sensor_l_in		<=	'0' after 0 ns,
					'1' after 5 ns, 
					'0' after 35 ns;

	sensor_m_in		<=	'0' after 0 ns,
					'1' after 15 ns;

	sensor_r_in		<=	'0' after 0 ns,
					'1' after 20 ns;



end architecture structural;
