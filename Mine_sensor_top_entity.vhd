library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mine_sensor_top is
	port (	clk		: in std_logic;
		mine_sensor_in	: in std_logic;
		mine_out	: out std_logic;
		led_0		: out std_logic
	);
end entity mine_sensor_top;

architecture structural of mine_sensor_top is
	component mine_sensor is
		port (	clk	: in std_logic;
			reset 	: in std_logic;
			sensor	: in std_logic;
			mine_out: out std_logic;
			led_0	: out std_logic
		);
	end component mine_sensor;

	component mine_counter is
		port (  clk             : in std_logic;
			mine_out 	: in std_logic;
        		reset           : out std_logic
 		) ;
	end component mine_counter;

signal mine_reset_signal, mine_out_signal: std_logic;


begin
	mine_detector	: mine_sensor port map (	clk		=>	clk,
							reset		=>	mine_reset_signal,
							sensor		=>	mine_sensor_in,
							mine_out	=>	mine_out_signal,
							led_0		=> 	led_0
						);

	count		: mine_counter port map	(	clk		=>	clk,
							mine_out	=>	mine_out_signal,
							reset		=>	mine_reset_signal
						);
	mine_out <= mine_out_signal;
end architecture structural;
