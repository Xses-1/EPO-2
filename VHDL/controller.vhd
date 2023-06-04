-- I miss understood one thing with your code (apparently that 20ms had double duty), but still there are many bugs and inconsistencies,
-- so I rewrote all the comments.
--
-- 1.) UART communication seems to not work
-- 
-- 2.) There is a bug in timebase. 
-- Debugged
--
-- 3.) 	Transition sl -> gl in the old code should also depend on the signals
--	from the sensors, because you don't have to read, or write the data if you just do a turn.
--	What you did, changed the structure of the entire state diagram drastically, if Thijs is 
--	ok with that then sure, otherwise you have to reverse to gl, sl and l states to what tey were before
--	and make them, so they are not dependable on time but as I said: transition gl -> sl is dpendable
--	on the value from the sensors and transition sl -> l depends on data_ready = '1'.
--	I think what was before was much much better solution, and changin the structure like that right now
-- 	is very stupid, however it might work as it is right now, so just leave it.
--
-- 4.)	Values of the reset signals below has to be changed, because now you only
--	use them to stop the motors if needed and reset everything at the beggining,
--	not for the periodical reset.For example, you stop motors in the stop state
--	and in the gentle stop state.
--
--      Already done? Reset signals for the motors can't be changed???? Because then you change the pwm outputs of the motorcontrols...
--	Wiktor: NO, you need to change COUNTER RESET for sure.
--
-- 6.)	U turn is now also broken, so the gentle left/right and sharp left/right 
--	has to be separated the same way as the rest of the states is, with the
--	separate read, write states.
--
--      Now you implemented a U turn here and did what Arjan told
--	but in very broken way. You are going out of U-turn based on the sensor signals, but you are going into
--	it based on the incoming data, wtf? You either do 2x sl turn and you go in and out of it based on the 
--	UART data, or you go into U-turn based on the MINE_SENSOR STATE (YOU HAVE THIS INPUT HERE, SO WHY TF
--	YOU ARE NOT USING IT IF YOU DID IMPLEMENT THE WHOLE U TURN) and go out based on sensor, like you did.
--	You just send state of the mine sensor to Thijs, so he can just send it back to you, this does nothing
--	else than intrduce delays. You either target simplicity in your design, or full autonomy.
--
-- 7.)	C code hast to also be now adjusted for the U-turn and you also need new
--	opcode naturally.
--
--     DONE. Robot will now react to data_in = "00000101" and perform U-turn (line 530). Thijs has to adjust C-code to this!!!!
--											 No he doesn't, comment above. You are
--											Just pushing work to Thijs unnecesairly.
--
-- 8.) Extra comment from Wilson and Kevin:  in order to write data you would need to pull write_data signal down after each write state,
--     so if communication still isn't working , maybe try line 669...
--
--	Wiktor: I am not sure is this supposed to be done. It must be checked with timing diagram, so this is kinda respnsibility of UART grup.
--	Your implementation in the line 669 never gonna work and I won't explain you why, you SHOULD KNOW IT if you passed the DSB exam.
--
--	Solution to that might be to use read states as refresh states, but then you have to add delays according to timing diagrams (not just 20ms
--	which was needed for motors reset). I didn't know about that, so I was trying to optimize the code for reading the UART as fast as possible.
--	Now all the trasitions to read state should be done after the minimum time needed by UART fetch to the data and then in the read state you
--	have to check if data_ready = '1' and that must be consistent for all transitions. It's not conssitent in the forward state. You should move
--	OG line follower to read state then and just go there every 20 ms.

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

		count_reset		: out	std_logic;

		motor_l_reset		: out	std_logic;
		motor_l_direction	: out	std_logic;

		motor_r_reset		: out	std_logic;
		motor_r_direction	: out	std_logic
		
	);

end entity controller;

architecture behavioural of controller is
	
	type controller_state is	(state_r, state_reset_read,
					 state_s_write, state_s_read,										
					 state_gl_d, state_gl_d_2, --state_sl_d, state_l_read,								
					 state_gr_d, state_gr_d_2, --state_sr_d, state_r_read,								
					 state_f_write, state_f_read, state_gl, state_sl, state_gr, state_sr,
					 state_u_turn, state_u_turn_2		
);											

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
					
					data_out(7)	<= '1';
					data_out(6)	<=	'1';
					data_out(5)	<=	'1';
					data_out(4)	<=	'1';
					data_out(3) <=	'1';
					data_out(2)	<=	'1';
					data_out(1)	<=	'1';
					data_out(0)	<=	'1';

					--data_out(7)		<= '0';
					--data_out(6)		<= '0';
					--data_out(5)		<= '0';
					--data_out(4)		<= sensor_l;
					--data_out(3)		<= sensor_m;
					--data_out(2)		<= sensor_r;
					--data_out(1)		<= mine_s;
					--data_out(0)		<= '1';
					
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

					
	                             	if (unsigned(count_in) < to_unsigned(1000000, 20)) then
						new_state <= state_s_write;
							
					elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then	--Is het beter om te loopen hierin (zoals
						new_state <= state_s_read;				-- in de state_f_write) of eerst naar state_s_read te gaan? en als data = 0 dan weer terug?
		
					end if;

		when state_s_read =>	count_reset		<= '1';		--state s read, als geen data dan gwn terug naar stop_s_write, 
					motor_l_reset		<= '1';		--is dit de state waar we na reset meteen heen gaan?
					motor_r_reset		<= '1';	

					motor_l_direction	<= '0';
					motor_r_direction	<= '0';

					data_out		<= "00000000";

					write_data <= '0';
					read_data <= '1';

					if (data_ready = '0') then
						new_state <= state_s_write;

					elsif (data_in = "00000001") then			
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

				

-- left branch door data van thijs, bestaande uit state_gl_d, state_gl_d_2      We need to make sure the robot turns early enough so lmr = 001 when we encounter the line again.
		
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

					-- Why did you left this here? Not deleting it just makes code harder to read.
					--if (unsigned(count_in) < to_unsigned(1000000, 20)) then
						--new_state <= state_gl_d;
							
					--elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
						--new_state <= state_sl_d;
					--end if;

					if (sensor_l = '1' and sensor_m = '1' and sensor_r = '1') then
						new_state <= state_gl_d_2;
					else 
						new_state <= state_gl_d;
					end if;
		

		when state_gl_d_2 =>	count_reset		<= '0';
					motor_l_reset		<= '1';
					motor_r_reset		<= '0';
					motor_l_direction	<= '0';
					motor_r_direction	<= '0'; 

					data_out <= "00000000";

					write_data		<= '0';
					read_data		<= '0'; 
					
					-- I am not sure wheather this is correct, but should be fine.
					if (sensor_l = '1' and sensor_m = '1' and sensor_r = '0') then
						new_state <= state_f_write;
					else 
						new_state <= state_gl_d_2;
					end if;

		


		--when state_sl_d =>	count_reset		<= '0';			-- Don't need sharp left and l_read anymore, since we go to forward state after a turn.
					--motor_l_reset		<= '0';				Wiktor: This can work, but I don't advise it, but then just delete this piece of code.
					--motor_r_reset		<= '0';					Commenting this out makes the code much harder to read.
					--motor_l_direction	<= '0';
					--motor_r_direction	<= '0';

					--data_out		<= "00000000";
					--write_data		<= '0';
					--read_data		<= '0'; 
					
					--if (unsigned(count_in) < to_unsigned(1000000, 20)) then
						--new_state <= state_sl_d;
							
					---elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
						--new_state <= state_l_read;
		
					--end if;



		--when state_l_read =>	count_reset		<= '1';		 
					--motor_l_reset		<= '1';		
					--motor_r_reset		<= '1';	

					--motor_l_direction	<= '0';
					--motor_r_direction	<= '0';

					--data_out		<= "00000000";
					--write_data 		<= '0';
					--read_data 		<= '1';

					--if (data_ready = '0') then
						--new_state <= state_gl_d;

					--elsif (data_in = "00000001") then			
						--new_state <= state_gl_d;

					--elsif (data_in = "00000010") then
						--new_state <= state_gr_d;

					--elsif (data_in = "00000011") then
						--new_state <= state_f_write;

					--elsif (data_in = "00000100") then
						--new_state <= state_s_write;
					--else
						--new_state <= state_gl_d;
					--end if;


-- right branch door data van thijs, bestaande uit state_gr_d, state_sr_d, state_r_read.      We need to make sure the robot turns early enough so lmr = 100 when we encounter the line again.
		when state_gr_d  => 
 					count_reset <= '0';
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
				
				--if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					--new_state <= state_gr_d;
					
				--elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					--new_state <= state_sr_d;

				--end if;
				
				if (sensor_l = '1' and sensor_m = '1' and sensor_r = '1') then
					new_state <= state_gr_d_2;
				else 
					new_state <= state_gr_d;
				end if;

		

		when state_gr_d_2  => 
					count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
			
					data_out <= "00000000";

					write_data <= '0';
					read_data <= '0';
				
				--if (unsigned(count_in) < to_unsigned(1000000, 20)) then		-- Just delete this.
					--new_state <= state_gr_d;
					
				--elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					--new_state <= state_sr_d;

				--end if;
				
				if (sensor_l = '1' and sensor_m = '0' and sensor_r = '0') then
					new_state <= state_f_write;
				else 
					new_state <= state_gr_d_2;
				end if;


		--when state_sr_d  => 	count_reset <= '0';				-- Don't need sharp right and r_read anymore, since we go to forward state after a turn.
					--motor_l_reset <= '0';
					--motor_r_reset <= '0';

					--motor_l_direction <= '1';
					--motor_r_direction <= '1';		

					--data_out <= "00000000";

					--write_data <= '0';
					--read_data <= '0';
					
				--if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					--new_state <= state_sr_d;
					
				--elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					--new_state <= state_r_read;
				--end if;


		--when state_r_read => 	count_reset		<= '1';		 
					--motor_l_reset		<= '1';		
					--motor_r_reset		<= '1';	

					--motor_l_direction	<= '0';
					--motor_r_direction	<= '0';

					--data_out		<= "00000000";
					--write_data <= '0';
					--read_data <= '1';
					
					--if (data_ready = '0') then
						--new_state <= state_gr_d;

					--elsif (data_in = "00000001") then			
						--new_state <= state_gl_d;

					--elsif (data_in = "00000010") then
						--new_state <= state_gr_d;

					--elsif (data_in = "00000011") then
						--new_state <= state_f_write;

					--elsif (data_in = "00000100") then
						--new_state <= state_s_write;
					--else
						--new_state <= state_gr_d;
					--end if;

-- forward branch met state_f_write, state_f_read en de line follower.
		when state_f_write  => 
					count_reset <= '0';
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

				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_f_write;
				
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f_read;
				end if;
		
		

					-- And you didn't change the reset signals values here, so it will break everything.		
		when state_f_read =>	count_reset <= '1';
					motor_l_reset <= '1';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
					
					data_out <= "00000000";
		
					write_data <= '0';
					read_data <= '1';


					if (data_ready = '1') then
						if (data_in = "00000001") then			
							new_state <= state_gl_d;

						elsif (data_in = "00000010") then
							new_state <= state_gr_d;

						elsif (data_in = "00000011") then
							new_state <= state_f_write;

						elsif (data_in = "00000100") then
							new_state <= state_s_write;
						
						elsif (data_in = "00000101") then           -- new opcode for u turn = "00000101" 
							new_state <= state_u_turn;

						end if;

					elsif (data_ready = '0') then
						if (sensor_l = '0' and sensor_m = '0' and sensor_r = '1') then
							new_state <= state_gl;

						elsif (sensor_l = '0' and sensor_m = '1' and sensor_r = '1') then
							new_state <= state_sl;

						elsif (sensor_l = '1' and sensor_m = '0' and sensor_r = '0') then
							new_state <= state_gr;

						elsif (sensor_l = '1' and sensor_m = '1' and sensor_r = '0') then
							new_state <= state_sr;

						else 
							if (unsigned(count_in) >= to_unsigned(1000000, 20)) then -- I've already added this
														 -- so write is low for more 
								new_state <= state_f_write;			 -- than 1 clock cycle
							end if;

						end if;
					else
						new_state <= state_f_read;
					end if;
										

		when state_gl =>	count_reset <= '0';
					motor_l_reset <= '1';
					motor_r_reset <= '0';

					motor_l_direction <= '0';
					motor_r_direction <= '0';

					write_data <= '0';
					read_data <= '0';
				
					data_out <= "00000000";
			
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gl;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f_read;

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
					new_state <= state_f_read;

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
					new_state <= state_f_read;

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
					new_state <= state_f_read;

				end if;



--u-turn branch implented as two sharp right states, we turn sharp right until we see lmr = 010 again, then go back to forward state.	
--we can loop in a state, because the periodical reset, resets the counter and motors.

		-- I thought that Thijs tells you HOW (ie 2x sl turn) to U turn, but whatever. 
		when state_u_turn =>	count_reset <= '0';		
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '1';		

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
					
				if (sensor_l = '1' and sensor_m = '1' and sensor_r = '1') then
					new_state <= state_u_turn_2;
				else 
					new_state <= state_u_turn;
				end if;

		
		when state_u_turn_2 =>	count_reset <= '0';		
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '1';		

					data_out <= "00000000";

					--So, you don't write the data to Thijs here?
					write_data <= '0';
					read_data <= '0';
					
				if (sensor_l = '1' and sensor_m = '0' and sensor_r = '1') then
					new_state <= state_f_write;
				else 
					new_state <= state_u_turn_2;
				end if;

		end case;
	
		-- if no data written, maybe pull write_data down to 0 after each process? see implementation below.

		-- write_data <= '0';
		-- This is retarded.
	end process;
end architecture behavioural;	

