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
	
	type controller_state is	(state_r, --state_reset_read,
					 state_s_write,										
					 state_gl_d, state_gl_d_2,							
					 state_gr_d, state_gr_d_2, 							
					 state_f_write, state_f_read, state_gl, state_sl, state_gr, state_sr,
					 state_u_turn, state_u_turn_2, state_u_turn_final,
					 
					 state_pause_com_mine, state_pause_com_crossing, state_pause_com_www

				
);											
	
	type crossing_state is		(state_ptc, --state patch to crossing
					 state_crossing, --state when on crossing
					 state_ctp,  --state crossing to patch	
					 state_patch --state when on patch
);


	signal state, new_state: controller_state;
	signal state_p, new_state_p: crossing_state;
	signal crossing: std_logic;


begin
	process (clk)
	begin
		if (rising_edge (clk)) then
			if (reset = '1') then
				state	<= state_r;
				state_p <= state_ptc;
			else
				state 	<= new_state;
				state_p	<= new_state_p;
			end if;
		end if;
	end process;
	
	
--FSM voor cross counting
	process (sensor_l, sensor_m, sensor_r, crossing, state_p)  --nieuwe element in sensitivity list (state_p)
	begin
		case state_p is
			
			when state_ptc => 	crossing <= '0';
					
					if (sensor_l = '0' and sensor_m = '0' and sensor_r = '0') then
						new_state_p 	<=	state_crossing;
					else

						new_state_p 	<=	state_ptc;
					end if;		

			when state_crossing => 	crossing <= '0';
					
					if (sensor_l = '0' and sensor_m = '0' and sensor_r = '0') then
						new_state_p 	<=	state_crossing;
					else

						new_state_p 	<=	state_ctp;
					end if;		

			when state_ctp => 	crossing <= '0';
					
					if (sensor_l = '0' and sensor_m = '0' and sensor_r = '0') then
						new_state_p 	<=	state_patch;
					else

						new_state_p 	<=	state_ctp;
					end if;
			
			when state_patch => 	crossing <= '1';
					
					if (sensor_l = '0' and sensor_m = '0' and sensor_r = '0') then
						new_state_p 	<=	state_patch;
					else

						new_state_p 	<=	state_ptc;
					end if;	
		end case;
	end process;
--Eind FSM crosscounting


	process (sensor_l, sensor_m, sensor_r, count_in, state, data_in, data_ready, mine_s)
	begin 
		case state is

		when state_r =>		count_reset <= '1';							
					motor_l_reset <= '1';
					motor_r_reset <= '1';

					motor_l_direction <= '0';
					motor_r_direction <= '0';

					write_data <= '0';
					read_data <= '0';

					data_out <= "00000000";
					
				--if (data_ready = '1') then
				--	new_state <= state_reset_read;
				--else 
				--	new_state <= state_r;
				--end if;
				
				
				
				if (sensor_l = '1' and sensor_m = '0' and sensor_r = '1') then
					new_state <= state_f_read;
					
				else
					new_state <= state_r;
				end if;
					
					

	--	when state_reset_read=>		count_reset <= '1';							
					--	motor_l_reset <= '1';
					--	motor_r_reset <= '1';
	
					--	motor_l_direction <= '0';
						--motor_r_direction <= '0';

						--write_data <= '0';
					--	read_data <= '1';
	
						--data_out <= "00000000";

				--if (data_in = "00000001") then			
						--new_state <= state_gl_d;

					--elsif (data_in = "00000010") then
					--	new_state <= state_gr_d;

					--elsif (data_in = "00000011") then
					--	new_state <= state_f_write;

					--elsif (data_in = "00000100") then
						--new_state <= state_s_write;


					-- No need for extra statement to go to u turn here, and probably no need for stop but leave it!!
					-- since you never abruptly go to u-turn from reset.
					
					--elsif (data_in = "00000101") then
						--new_state <= state_u_turn;
						
					--else
					--	new_state <= state_r;
					--end if;


--new cases


-- stop branch, bestaande uit state_s_write en state_s_read.

		when state_s_write =>		count_reset		<= '1';
						motor_l_reset		<= '1';
						motor_r_reset		<= '1';

						motor_l_direction	<= '0';
						motor_r_direction	<= '0';

						data_out  		<= "00000000";
						write_data		<= '0';
						read_data		<= '0';

					
	               new_state <= state_s_write;        -- end state, you never leave this, because ifyou come here you are finished with challenge.
							
				

	

-- left branch door data van thijs, bestaande uit state_gl_d, state_gl_d_2      We need to make sure the robot turns early enough so lmr = 110 when we encounter the line again.
		
		when state_gl_d =>	count_reset		<= '0';
					motor_l_reset		<= '1';
					motor_r_reset		<= '0';

					motor_l_direction	<= '0';
					motor_r_direction	<= '0'; 

					data_out  		<= "00000000";

					write_data		<= '0';
					read_data		<= '0'; 

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

					data_out 		<= "00000000";

					write_data		<= '0';
					read_data		<= '0'; 
					
					
					if (sensor_l = '0' and sensor_m = '1' and sensor_r = '1') then
						new_state <= state_f_write;
					else 
						new_state <= state_gl_d_2;
					end if;

		-- when turning no data is needed to be send to thijs so data_out is all 0


-- left branch door data van thijs, bestaande uit state_gr_d, state_gr_d_2
				when state_gr_d  => 
 					count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
					
					data_out 		<= "00000000";

					write_data <= '0';
					read_data <= '0';
				
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
				
				if (sensor_l = '1' and sensor_m = '1' and sensor_r = '0') then
					new_state <= state_f_write;
				else 
					new_state <= state_gr_d_2;
				end if;


-- forward central state where linefollower is residing in this state

		when state_f_write  => 
					count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '0';

					write_data <= '1';
					read_data <= '0';
					
			--oude stuk
				--	if (mine_s = '1') then
					--	data_out 		<= "00000100";
				--	elsif (crossing = '1') then
					--	data_out		<= "00000010";
				--	elsif (sensor_l = '1' and sensor_m = '1' and sensor_r = '1') then
					--	data_out		<= "00000011";
				--	else 
					--	data_out		<= "00000000";
				--	end if;
								

				--if (unsigned(count_in) < to_unsigned(1000000, 20)) then
				--	new_state <= state_f_write;
				
				--elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					--new_state <= state_f_read;
				--end if;
			--eind oude stuk
		
		
			--Nieuw stukje om 80 keer communicatie te solven	
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_f_write;
					data_out <= "00000000";
				
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					if (mine_s = '1') then
						data_out 		<= "00000100";
						new_state		<= state_pause_com_mine;
					elsif (crossing = '1') then
						data_out		<= "00000010";
						new_state		<= state_pause_com_crossing;
					elsif (sensor_l = '1' and sensor_m = '1' and sensor_r = '1') then
						data_out		<= "00000011";
						new_state		<= state_pause_com_www;
					else 
						data_out		<= "00000000";
						new_state	<= state_f_read;
					end if;
				end if;
		
		when state_pause_com_mine =>	count_reset <= '1';							
												motor_l_reset <= '1';
												motor_r_reset <= '1';

												motor_l_direction <= '0';
												motor_r_direction <= '0';

												write_data <= '0';
												read_data <= '0';

												data_out <= "00000000";
						
											new_state <= state_u_turn;
											
					
		when state_pause_com_crossing => count_reset <= '0';
													motor_l_reset <= '0';
													motor_r_reset <= '0';

													motor_l_direction <= '1';
													motor_r_direction <= '0';

													write_data <= '0';
													read_data <= '1';

													data_out <= "00000000";
												
												if (data_ready = '1') then
													if (data_in = "00000001") then			
														new_state <= state_gl_d;

													elsif (data_in = "00000010") then
														new_state <= state_gr_d;

													elsif (data_in = "00000011") then
														new_state <= state_f_read;
													end if;
												else
													new_state <= state_f_read;
												end if;
													
	
		when state_pause_com_www	=> 	count_reset <= '1';							
													motor_l_reset <= '1';
													motor_r_reset <= '1';

													motor_l_direction <= '0';
													motor_r_direction <= '0';

													write_data <= '0';
													read_data <= '1';

													data_out <= "00000000";
												
												if (data_ready = '1') then	
													if (data_in = "00000100") then
														new_state <= state_s_write;
													elsif (data_in = "00000101") then           
														new_state <= state_u_turn;
													end if;
												else
													new_state <= state_f_read;
												end if;
																									
		-- eind nieuw stukje

		when state_f_read =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
					
					data_out <= "00000000";
		
					write_data <= '0';
					read_data <= '1';

				if (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					--if (mine_s = '1') then
						--new_state <= state_u_turn;

					--elsif (data_ready = '1') then
						--if (data_in = "00000001") then			
					--		new_state <= state_gl_d;

					--	elsif (data_in = "00000010") then
						--	new_state <= state_gr_d;

						--elsif (data_in = "00000011") then
							--new_state <= state_f_write;

						--elsif (data_in = "00000100") then
							--new_state <= state_s_write;
						
						--elsif (data_in = "00000101" or mine_s = '1') then           
							--new_state <= state_u_turn;

						--end if;
						
						if (data_ready = '0') then
							if (sensor_l = '0' and sensor_m = '0' and sensor_r = '1') then
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



--u-turn branch implented as two sharp right states, we turn sharp right until we see lmr = 010 again, then go to u_turn_final to let Thijs know. 

		when state_u_turn =>	count_reset <= '0';		
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '1';		

					data_out	  <= "00000000";

					write_data <= '0';
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

					write_data <= '0';
					read_data <= '0';
					
				if ((sensor_l = '1' and sensor_m = '0' and sensor_r = '1') or (sensor_l = '0' and sensor_m = '0' and sensor_r = '0') ) then
					new_state <= state_u_turn_final;
				else 
					new_state <= state_u_turn_2;
				end if;
		
	when state_u_turn_final =>	count_reset <= '0';		
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '0';		

					data_out <= "00000101";

					write_data <= '1';
					read_data <= '0';
					
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_u_turn_final;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f_read;

				end if;

		end case;
	end process;
end architecture behavioural;
