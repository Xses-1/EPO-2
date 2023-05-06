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
--		
		count_reset		: out	std_logic;

		motor_l_reset		: out	std_logic;
		motor_l_direction	: out	std_logic;

		motor_r_reset		: out	std_logic;
		motor_r_direction	: out	std_logic
	);

end entity controller;

architecture behavioural of controller is
	
	type controller_state is 	(state_r, state_f, state_gl, state_sl, state_gr, state_sr,							-- line follower
					 state_read_data, state_send_u, state_u_1, state_u_2, state_u_3, state_u_4, state_check_u,			-- u-turn
					 state_send_s, state_s, state_check_s,										-- stop
					 state_send_l, state_gl_d, state_sl_d, state_check_l,								-- left
					 state_send_r, state_gr_d, state_sr_d, state_check_r,								-- right
					 state_send_f, state_f_2, state_check_f);										-- forward

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


	
	process (sensor_l, sensor_m, sensor_r, count_in, state, data_in, data_ready)
	begin 
		case state is

		when state_r =>		count_reset <= '1';							-- also added write_data <= '0' and read_data <= '0' in the line follower part
					motor_l_reset <= '1';
					motor_r_reset <= '1';

					motor_l_direction <= '0';
					motor_r_direction <= '0';

-- added write_data <= '0' and read_data <= '0' in the line follower part
					write_data <= '0';
					read_data <= '0';
				
				if ((sensor_l = '0') and (sensor_m = '0') and (sensor_r = '0')) then	
					new_state <= state_f;

				elsif (sensor_l = '0' and sensor_m = '0' and sensor_r = '1') then
					new_state <= state_gl;

				elsif (sensor_l = '0' and sensor_m = '1' and sensor_r = '0') then
					new_state <= state_f;

				elsif (sensor_l = '0' and sensor_m = '1' and sensor_r = '1') then
					new_state <= state_sl;

				elsif (sensor_l = '1' and sensor_m = '0' and sensor_r = '0') then
					new_state <= state_gr;

				elsif (sensor_l = '1' and sensor_m = '0' and sensor_r = '1') then
					new_state <= state_f;

				elsif (sensor_l = '1' and sensor_m = '1' and sensor_r = '0') then
					new_state <= state_sr;

				elsif (sensor_l = '1' and sensor_m = '1' and sensor_r = '1') then
					new_state <= state_f;
-- new: data_in part 		
				elsif (data_ready = '1') then
					new_state <= state_read_data;	
--				
				else 
					new_state <= state_r;
					
				end if;

		when state_f =>		count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
		
		--other signals that need to be set
		-- added write_data <= '0' and read_data <= '0' in the line follower part
					write_data <= '0';
					read_data <= '0';
				
		--define new_state
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_f;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;


		when state_gl =>	count_reset <= '0';
					motor_l_reset <= '1';
					motor_r_reset <= '0';

					motor_l_direction <= '0';
					motor_r_direction <= '0';

		--other signals that need to be set
		-- added write_data <= '0' and read_data <= '0' in the line follower part
					write_data <= '0';
					read_data <= '0';
				
		--define new_state
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gl;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;

				
				
		when state_sl =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '0';
					motor_r_direction <= '0';
		
		--other signals that need to be set
		-- added write_data <= '0' and read_data <= '0' in the line follower part
					write_data <= '0';
					read_data <= '0';
				
		--define new_state
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_sl;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;



		when state_gr =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
		
		--other signals that need to be set
		-- added write_data <= '0' and read_data <= '0' in the line follower part
					write_data <= '0';
					read_data <= '0';
				
		--define new_state
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gr;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;


		when state_sr =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '1';		
		--other signals that need to be set
		-- added write_data <= '0' and read_data <= '0' in the line follower part
					write_data <= '0';
					read_data <= '0';
				
		--define new_state
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_sr;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;

--new cases
		when state_read_data =>
			
			-- missing: signals that need to be set

			if (data_in = "00000001") then			
				new_state <= state_send_l;

			elsif (data_in = "00000010") then
				new_state <= state_send_r;

			elsif (data_in = "00000011") then
				new_state <= state_send_f;

			elsif (data_in = "00000100") then
				new_state <= state_send_u;

			elsif (data_in = "00000101") then
				new_state <= state_send_s;
			else
				new_state <= state_read_data;
-- u-turn
		when state_send_u => 

		when state_u_1 => 
		
		when state_u_2 =>

		when state_u_3 =>

		when state_u_4 =>

		when state_check_u =>

-- stop

		when state_send_s =>

		when state_s =>

		when state_check_s =>
								

-- left
		when state_send_l =>

		when state_gl_d =>

		when state_sl_d =>

		when state_check_l =>

-- right
		when state_send_r => 
	
		when state_gr_d  => 

		when state_sr_d  => 

		when state_check_r  => 			

-- forward
		when state_send_f  => 
		
		when state_f  => 
		
		when state_check_f => 


			end case;
	end process;
end architecture behavioural;

				

				
		
					
				
		












