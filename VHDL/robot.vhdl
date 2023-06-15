library IEEE;
use IEEE.std_logic_1164.all;

entity robot is
	port ( 
	
		clk             : in    std_logic;
		reset           : in    std_logic;
		
		sensor_l_in     : in    std_logic;
		sensor_m_in     : in    std_logic;
		sensor_r_in     : in    std_logic;
		
		sensor_mine_in	: in	std_logic;
		
		rx		: in	std_logic;
		tx		: out 	std_logic;
		buffer_empty	: out	std_logic;

		motor_l_pwm     : out   std_logic;
		motor_r_pwm     : out   std_logic;
		
		--led_7 : out std_logic;
		--led_6 : out std_logic;
		--led_5 : out std_logic;
		--led_4 : out std_logic;
		--led_3 : out std_logic;
		--led_2 : out std_logic;
		--led_1 : out std_logic;
		led_0 : out std_logic
	
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

		count_in		: in	std_logic_vector (19 downto 0);  

--new inputs
		data_in			: in 	std_logic_vector (7 downto 0);	
		data_ready		: in	std_logic;
		mine_s			: in	std_logic;


--new outputs
		data_out		: out	std_logic_vector (7 downto 0);	
		write_data		: out	std_logic;
		read_data		: out	std_logic;
--		
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
	
		reset_out	: out std_logic;					-- New port for periodic reset.	

        	count_out       : out std_logic_vector (19 downto 0)
 	) ;
 end component timebase ;


component motorcontrol is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;
		direction	: in	std_logic;
		count_in	: in	std_logic_vector (19 downto 0);  -- Please enter upper bound

		reset_in	: in std_logic;					-- New port for periodic reset.	
	
		pwm		: out	std_logic
	);
end component motorcontrol;

component uart is
	port (
        clk             : in  std_logic;
        reset           : in  std_logic;

        rx              : in  std_logic;
        tx              : out std_logic;

        data_in         : in  std_logic_vector (7 downto 0);
        buffer_empty    : out std_logic;
        write           : in  std_logic;

        data_out        : out std_logic_vector (7 downto 0);
        data_ready      : out std_logic;
        read            : in  std_logic
    );
end component uart;

component mine_sensor_top is
	port (	clk		: in std_logic;
		mine_sensor_in	: in std_logic;
		mine_out	: out std_logic;
		led_0 		: out std_logic
	);
end component mine_sensor_top;

signal sensor_l, sensor_m, sensor_r, count_rs, reset_periodical, motor_l_rs, motor_l_d, motor_r_rs, motor_r_d: std_logic;
signal count: std_logic_vector(19 downto 0); 


-- new signals
signal data_uico: std_logic_vector (7 downto 0);  --uart in controller out
signal data_uoci: std_logic_vector (7 downto 0); -- uart out controller in
signal write_sig, read_sig, data_ready_sig: std_logic; 
signal mine_signal: std_logic;
signal mine_out_signal: std_logic;


begin
LB1: inputbuffer port map(	clk		=>	clk,

				sensor_l_in	=>	sensor_l_in,
				sensor_m_in	=>	sensor_m_in,
				sensor_r_in	=>	sensor_r_in,

				sensor_l_out	=>	sensor_l,
				sensor_m_out	=>	sensor_m,
				sensor_r_out	=>	sensor_r);


M1: mine_sensor_top port map (	clk		=>	clk,
				mine_sensor_in	=> 	sensor_mine_in,
				mine_out 	=> 	mine_out_signal,
				led_0				=> led_0);


U1:	uart port map(
					clk  => 		clk,
					reset => 		reset,

					rx => 			rx,	
					tx => 			tx,

					data_in => 		data_uico,     
					buffer_empty => 	buffer_empty,
					write => 		write_sig,     
					
					data_out => 		data_uoci,
					data_ready => 		data_ready_sig,  
					read => 		read_sig
					
);

LB2: controller port map(	
				clk			=>	clk,
				reset			=>	reset,

				sensor_l		=>	sensor_l,
				sensor_m		=>	sensor_m,
				sensor_r		=>	sensor_r,

				count_in		=>  	count,

--new inputs

				--data_in(7)	=>	led_7,
				--data_in(6)	=>	led_6,
				--data_in(5)	=>	led_5,
				--data_in(4)	=>	led_4,
				--data_in(3)	=>	led_3,
				--data_in(2)	=>	led_2,
				--data_in(1)	=>	led_1,
				--data_in(0)	=>	led_0,
				
				data_in		=> data_uoci,
			
				data_ready		=> 	data_ready_sig, 
				
				mine_s			=> 	mine_out_signal,


--new outputs

				--data_out(7)	=>	led_7,
				--data_out(6)	=>	led_6,
				--data_out(5)	=>	led_5,
				--data_out(4)	=>	led_4,
				--data_out(3)	=>	led_3,
				--data_out(2)	=>	led_2,
				--data_out(1)	=>	led_1,
				--data_out(0)	=>	led_0,
				
				data_out		=> 	data_uico,
				write_data		=> 	write_sig,
				read_data		=> 	read_sig,
--

				count_reset		=>	count_rs,

				motor_l_reset		=>	motor_l_rs,
				motor_l_direction	=>	motor_l_d,

				motor_r_reset		=>	motor_r_rs,
				motor_r_direction	=>	motor_r_d
				);


T1: timebase port map(		clk		=>	clk,
				reset		=>	count_rs,
				count_out	=>	count,
				reset_out	=>	reset_periodical       			-- added reset periodical (new ports)
);

MCL: motorcontrol port map(	clk		=>	clk,
				reset		=>	motor_l_rs,
				direction	=>	motor_l_d,
				count_in	=>	count,
				
				reset_in	=>	reset_periodical,			-- added reset periodical (new ports)

				pwm		=>	motor_l_pwm
			);



MCR: motorcontrol port map(	clk		=>	clk,
				reset		=>	motor_r_rs,
				direction	=>	motor_r_d,
				count_in	=>	count,

				reset_in	=>	reset_periodical,			-- added reset periodical (new ports)
				
				pwm		=>	motor_r_pwm
		);


end architecture structural;
