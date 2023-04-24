library IEEE;
use IEEE.std_logic_1164.all;

entity robot is
	port (  clk             : in    std_logic;
		reset           : in    std_logic;

		sensor_l_in     : in    std_logic;
		sensor_m_in     : in    std_logic;
		sensor_r_in     : in    std_logic;

		motor_l_pwm     : out   std_logic;
		motor_r_pwm     : out   std_logic
	);
end entity robot;

architecture structural of robot is

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


component timebase is
	port (  clk             : in std_logic;
        	reset           : in std_logic;
        	count_out       : out std_logic_vector (19 downto 0)
 	) ;
 end component timebase ;


component motorcontrol is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;
		direction	: in	std_logic;
		count_in	: in	std_logic_vector (19 downto 0);  -- Please enter upper bound

		pwm		: out	std_logic
	);
end component motorcontrol;



signal sensor_l, sensor_m, sensor_r, count_rs, motor_l_rs, motor_l_d, motor_r_rs, motor_r_d: std_logic;
signal count: std_logic_vector(19 downto 0); 

begin
LB1: inputbuffer port map(	clk		=>	clk,

				sensor_l_in	=>	sensor_l_in,
				sensor_m_in	=>	sensor_m_in,
				sensor_r_in	=>	sensor_r_in,

				sensor_l_out	=>	sensor_l,
				sensor_m_out	=>	sensor_m,
				sensor_r_out	=>	sensor_r);



LB2: controller port map(	clk			=>	clk,
				reset			=>	reset,

				sensor_l		=>	sensor_l,
				sensor_m		=>	sensor_m,
				sensor_r		=>	sensor_r,

				count_in		=>	count,

				count_reset		=>	count_rs,

				motor_l_reset		=>	motor_l_rs,
				motor_l_direction	=>	motor_l_d,

				motor_r_reset		=>	motor_r_rs,
				motor_r_direction	=>	motor_r_d);


LB3: timebase port map(		clk		=>	clk,
				reset		=>	count_rs,
				count_out	=>	count);




MCL: motorcontrol port map(	clk		=>	clk,
				reset		=>	motor_l_rs,
				direction	=>	motor_l_d,
				count_in	=>	count,

				pwm		=>	motor_l_pwm);



MCR: motorcontrol port map(	clk		=>	clk,
				reset		=>	motor_r_rs,
				direction	=>	motor_r_d,
				count_in	=>	count,

				pwm		=>	motor_r_pwm);


end architecture structural;




