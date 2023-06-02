-- 1.) UART communication seems to not work
-- 2.) Timebase has to resets itself if (count >= 20ms), but it also
--	resets when the reset signals comes in, so the controller stops it.
--	It also sends a new reset signal to the motorcontrollers, every 20ms,
--	so they don't have to be reset perioidically by the controller.
-- 3.) 	Line follower needs to react to the sensors to go back to the previous
--	state - forward. See comments below.
-- 4.)	values of the reset signals below has to be changed, because now you only
--	use them to stop the motors if needed and reset everything at the beggining,
--	not for the periodical reset.For example, you stop motors in the stop state
--	and in the gentle stop state.
-- 5.)  Also check the values of the motor direction signals.
-- 6.)	U turn is now also broken, so the gentle left/right and sharp left/right 
--	has to be separated the same way as the rest of the states is, with the
--	separate read, write states.
-- 7.)	C code hast to also be now adjusted for the U-turn and you also need new
--	opcode naturally.





library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Please add necessary libraries:


entity controller is
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

		count_reset		: out 	std_logic;

		motor_l_reset		: out 	std_logic;
		motor_r_reset		: out 	std_logic;

		motor_l_direction	: out	std_logic;
		motor_r_direction	: out	std_logic
	);

end entity controller;

architecture behavioural of controller is
	
	type controller_state is	(state_r, state_reset_read,
					 state_s_write, state_s_read,										
					 state_gl_d, state_sl_d, state_l_read,								
					 state_gr_d, state_sr_d, state_r_read,								
					 state_f_write, state_f_read, state_gl, state_sl, state_gr, state_sr);											

	signal state, new_state: controller_state;


begin
	process (clk)
	begin
		if (rising_edge (clk)) then
			if (reset = '1') then
				state <= state_r;
			else
				state <= new_state;
			end if;
		end if;
	end process;

	process (sensor_l, sensor_m, sensor_r, count_in, state, data_in, data_ready, mine_s)
	begin 
		case state is

		when state_r =>		count_reset <= '1';							
					motor_l_reset <= '1';
					motor_r_reset <= '1';
					
					motor_l_direction <= '0';
					motor_r_direction <= '0';

					write_data <= '1';
					read_data <= '0';

					data_out(7)		<= '0';
					data_out(6)		<= '0';
					data_out(5)		<= '0';
					data_out(4)		<= sensor_l;
					data_out(3)		<= sensor_m;
					data_out(2)		<= sensor_r;
					data_out(1)		<= mine_s;
					data_out(0)		<= '1';
					
				if (data_ready = '1') then
					new_state <= state_reset_read;
				else 
					new_state <= state_r;
				end if;



		when state_reset_read=>		count_reset <= '1';							
						motor_l_reset <= '1';
						motor_r_reset <= '1';

						motor_l_direction <= '0';
						motor_r_direction <= '0';

						write_data <= '0';
						read_data <= '1';
	
						data_out <= "00000000";

					if (data_in = "00000001") then			
						new_state <= state_gl_d;

					elsif (data_in = "00000010") then
						new_state <= state_gr_d;

					elsif (data_in = "00000011") then
						new_state <= state_f_write;

					elsif (data_in = "00000100") then
						new_state <= state_s_write;
					else
						new_state <= state_r;
					end if;


--new cases


-- stop branch, bestaande uit state_s_write en state_s_read.

		when state_s_write =>		count_reset		<= '1';
						motor_l_reset		<= '1';
						motor_r_reset		<= '1';
						
						motor_l_direction	<= '0';
						motor_r_direction	<= '0';

						data_out(7)		<= '0';
						data_out(6)		<= '0';
						data_out(5)		<= '0';
						data_out(4)		<= sensor_l;
						data_out(3)		<= sensor_m;
						data_out(2)		<= sensor_r;
						data_out(1)		<= mine_s;
						data_out(0)		<= '1';

						write_data		<= '1';
						read_data		<= '0';

	                             	if (data_ready = '0') then
						new_state <= state_s_write;
							
					else
						new_state <= state_s_read;
		
					end if;

		when state_s_read =>	count_reset		<= '1';
					motor_l_reset		<= '1';
					motor_r_reset		<= '1';

					motor_l_direction	<= '0';
					motor_r_direction	<= '0';

					data_out		<= "00000000";

					write_data <= '0';
					read_data <= '1';


					if (data_in = "00000001") then			
						new_state <= state_gl_d;

					elsif (data_in = "00000010") then
						new_state <= state_gr_d;

					elsif (data_in = "00000011") then
						new_state <= state_f_write;

					elsif (data_in = "00000100") then
						new_state <= state_s_write;
					else
						new_state <= state_s_write;
					end if;

				

-- left branch door data van thijs, bestaande uit state_gl_d, state_sl_d en state_l_read.
		
		when state_gl_d =>	count_reset		<= '0';
					motor_l_reset		<= '1';
					motor_r_reset		<= '0';

					motor_l_direction	<= '0';
					motor_r_direction	<= '0'; 

					data_out(7)		<= '1';
					data_out(6)		<= '0';
					data_out(5)		<= '1';
					data_out(4)		<= sensor_l;
					data_out(3)		<= sensor_m;
					data_out(2)		<= sensor_r;
					data_out(1)		<= mine_s;
					data_out(0)		<= '1';

					write_data		<= '1';
					read_data		<= '0'; 

					-- This has to be changed so the robot goes to the sharp turn
					-- when sensors are detecting the line again
					if (unsigned(count_in) < to_unsigned(1000000, 20)) then
						new_state <= state_gl_d;
							
					elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
						new_state <= state_sl_d;
					end if;


		when state_sl_d =>	count_reset		<= '0';
					motor_l_reset		<= '0';
					motor_r_reset		<= '0';

					motor_l_direction	<= '0';
					motor_r_direction	<= '0';

					data_out		<= "00000000";
					write_data		<= '0';
					read_data		<= '0'; 
					
					if (data_ready = '0') then
						new_state <= state_sl_d;
							
					else
						new_state <= state_l_read;
		
					end if;

		when state_l_read =>	count_reset		<= '1';		 
					motor_l_reset		<= '1';		
					motor_r_reset		<= '1';	
					
					motor_l_direction	<= '0';
					motor_r_direction	<= '0';

					data_out		<= "00000000";
					write_data 		<= '0';
					read_data 		<= '1';

					if (data_in = "00000001") then			
						new_state <= state_gl_d;

					elsif (data_in = "00000010") then
						new_state <= state_gr_d;

					elsif (data_in = "00000011") then
						new_state <= state_f_write;

					elsif (data_in = "00000100") then
						new_state <= state_s_write;
					else
						new_state <= state_gl_d;
					end if;


-- right branch door data van thijs, bestaande uit state_gr_d, state_sr_d, state_r_read.
		when state_gr_d  => 	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
			
					data_out(7) <= '0';
					data_out(6) <= '1';
					data_out(5) <= '1';
					data_out(4) <= sensor_l;
					data_out(3) <= sensor_m;
					data_out(2) <= sensor_r;
					data_out(1) <= mine_s;
					data_out(0) <= '1';

					write_data <= '1';
					read_data <= '0';
				
				-- This has to be changed so the robot goes to the sharp turn
				-- when sensors are detecting the line again
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gr_d;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_sr_d;

				end if;


		when state_sr_d  => 	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '1';		

					data_out <= "00000000";

					write_data <= '0';
					read_data <= '0';
					
				if (data_ready = '0') then
					new_state <= state_sr_d;
					
				else
					new_state <= state_r_read;
				end if;


		when state_r_read => 	count_reset		<= '1';		 
					motor_l_reset		<= '1';		
					motor_r_reset		<= '1';	

					motor_l_direction	<= '0';
					motor_r_direction	<= '0';

					data_out		<= "00000000";
					write_data <= '0';
					read_data <= '1';
					
					if (data_in = "00000001") then			
						new_state <= state_gl_d;

					elsif (data_in = "00000010") then
						new_state <= state_gr_d;

					elsif (data_in = "00000011") then
						new_state <= state_f_write;

					elsif (data_in = "00000100") then
						new_state <= state_s_write;
					else
						new_state <= state_gr_d;
					end if;

-- forward branch met state_f_write, state_f_read en de line follower.
		when state_f_write  => 	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '0';

					write_data <= '1';
					read_data <= '0';
					
					data_out(7) <= '0';
					data_out(6) <= '0';
					data_out(5) <= '1';
					data_out(4) <= sensor_l;
					data_out(3) <= sensor_m;
					data_out(2) <= sensor_r;
					data_out(1) <= mine_s;
					data_out(0) <= '1';
										
			--define new_state or correct when offset from path
					if (data_ready = '1') then
						new_state	<= state_f_read;

					elsif (sensor_l = '0' and sensor_m = '0' and sensor_r = '1') then
						new_state <= state_gl;

					elsif (sensor_l = '0' and sensor_m = '1' and sensor_r = '1') then
						new_state <= state_sl;

					elsif (sensor_l = '1' and sensor_m = '0' and sensor_r = '0') then
						new_state <= state_gr;

					elsif (sensor_l = '1' and sensor_m = '1' and sensor_r = '0') then
						new_state <= state_sr;

					else 
						new_state <= state_f_write;

					end if;
		

		when state_f_read =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
					
					data_out <= "00000000";
		
					write_data <= '0';
					read_data <= '1';

					if (data_in = "00000001") then			
						new_state <= state_gl_d;

					elsif (data_in = "00000010") then
						new_state <= state_gr_d;

					elsif (data_in = "00000011") then
						new_state <= state_f_write;

					elsif (data_in = "00000100") then
						new_state <= state_s_write;
					else
						new_state <= state_f_write;
					end if;
										

		when state_gl =>	count_reset <= '0';
					motor_l_reset <= '1';
					motor_r_reset <= '0';

					motor_l_direction <= '0';
					motor_r_direction <= '0';

					write_data <= '0';
					read_data <= '0';
				
					data_out <= "00000000";
			
					-- This also has to be changed to react on the signals
					-- form the sensors
					-- 
					-- Same for the ones below 
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gl;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f_write;

				end if;
				
		when state_sl =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '0';
					motor_r_direction <= '0';
		
					write_data <= '0';
					read_data <= '0';

					data_out <= "00000000";				
			
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_sl;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f_write;

				end if;


		when state_gr =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '0';

					write_data <= '0';
					read_data <= '0';

					data_out <= "00000000";		
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gr;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f_write;

				end if;


		when state_sr =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '1';		

					write_data <= '0';
					read_data <= '0';

					data_out <= "00000000";		
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_sr;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f_write;

				end if;

		end case;
	end process;
end architecture behavioural;	
