library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity controller_tb is
end entity controller_tb;


architecture structural of controller_tb is

	component timebase is
		port (	clk			: in	std_logic;
			reset			: in	std_logic;

			count_out		: out	std_logic_vector (19 downto 0)
		);
	end component timebase;

	

	component motorcontrol is
		port (	clk			: in	std_logic;
			reset			: in	std_logic;
			direction		: in	std_logic;
			count_in		: in	std_logic_vector (19 downto 0);

			pwm			: out	std_logic
		);
	end component motorcontrol;

	

	component controller is 
		port (	clk			: in	std_logic;
			reset			: in	std_logic;

			sensor_l		: in	std_logic;
			sensor_m		: in	std_logic;
			sensor_r		: in	std_logic;

			count_in		: in	std_logic_vector (19 downto 0);  -- Please enter upper bound
			count_reset		: out	std_logic;

			motor_l_reset		: out	std_logic;
			motor_l_direction	: out	std_logic;

			motor_r_reset		: out	std_logic;
			motor_r_direction	: out	std_logic
		);	
	end component controller;


signal clk, reset, sensor_l_in, sensor_m_in, sensor_r_in: std_logic;
signal count : std_logic_vector(19 downto 0);
signal sensors : std_logic_vector(2 downto 0);
signal motor_RD, motor_LD, motor_RR, motor_LR, count_RS : std_logic;



begin
LB1: controller port map(	clk 			=> clk,
				reset 			=> reset,
				sensor_l 		=> sensor_l_in,
				sensor_m 		=> sensor_m_in,
				sensor_r 		=> sensor_r_in,
				count_in 		=> count,
				count_reset 		=> count_RS,
				motor_l_direction 	=> motor_LD,
				motor_r_direction	=> motor_RD,
				motor_l_reset 		=> motor_LR,
				motor_r_reset 		=> motor_RR);


LB2: timebase port map ( clk => clk , reset => count_RS , count_out => count);
				
				

	clk			<=	'0' after 0 ns,
					'1' after 10 ns when clk /= '1' else '0' after 10 ns;

	reset			<=	'1' after 0 ns,
					'0' after 20 ns,
					'1' after 20000000 ns,
					'0' after 20000020 ns,
					'1' after 40000000 ns,
					'0' after 40000020 ns;

	sensors			<=	"000" after 0 ms,
					"001" after 70 ms,
					"010" after 110 ms,
					"011" after 150 ms,
					"100" after 190 ms,
					"101" after 230 ms,
					"110" after 280 ms,
					"111" after 330 ms;				

	sensor_l_in		<=	sensors(2);
	sensor_m_in		<=	sensors(1);
	sensor_r_in		<=	sensors(0);



end architecture structural;






