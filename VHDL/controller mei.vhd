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
	
	type controller_state is 	(state_r, state_f, state_gl, state_sl, state_gr, state_sr,					-- line follower
					 state_eind_u1, state_eind_u2, state_eind_s,																-- als je aan het einde van je lijn zit, thus if www (000)
					 state_u_1, state_u_2,																	-- u-turn
					 state_bbb1,																			-- if bbb, thus 111
					 state_s,																				-- stop
					 state_gl_d, state_sl_d,																-- left bbb
					 state_gr_d, state_sr_d, 																-- right bbb
					 state_f_d,																				-- forward bbb
					 state_s_d);																			-- stop bbb

	signal state, new_state, prev_state: controller_state;
	signal crossing, crosscounter: std_logic := '0';


begin
	process (sensor_l, sensor_m, sensor_r, crosscounter)
	begin
	-- zodat bij oneven bbb wordt gedetect als kruising
		if (sensor_l = '1' and sensor_m = '1' and sensor_r = '1') then
			if (crosscounter = '0') then
				crosscounter <= '1';
				crossing <= '1';
			elsif (crosscounter = '1') then
				crosscounter <= '0';
				crossing <= '0';
			end if;
		end if;
	end process;

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

			-- added write_data <= '0' and read_data <= '0' and data_out <= "00000000" in the line follower part
					write_data <= '0';
					read_data <= '0';
					data_out <= "00000000";

					if ((sensor_l = '0') and (sensor_m = '0') and (sensor_r = '0')) then	
					new_state <= state_bbb1;              

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
					new_state <= state_eind_u1;

	--nieuw toegevoegd
					elsif (mine_s = '1') then
					new_state <= state_u_1;
					else 
					new_state <= state_r;
					end if;


		when state_f =>		count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
		
			-- added write_data <= '0' and read_data <= '0' and data_out <= "00000000" in the line follower part
					write_data <= '0';
					read_data <= '0';
					
					data_out <= "00000000";
										
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

			-- added write_data <= '0' and read_data <= '0' and data_out <= "00000000" in the line follower part
					write_data <= '0';
					read_data <= '0';
				
					data_out <= "00000000";
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
		
			-- added write_data <= '0' and read_data <= '0' and data_out <= "00000000" in the line follower part
					write_data <= '0';
					read_data <= '0';

					data_out <= "00000000";				
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
		
			-- added write_data <= '0' and read_data <= '0' and data_out <= "00000000" in the line follower part
					write_data <= '0';
					read_data <= '0';

					data_out <= "00000000";				
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

			-- added write_data <= '0' and read_data <= '0' and data_out <= "00000000" in the line follower part
					write_data <= '0';
					read_data <= '0';

					data_out <= "00000000";				
			--define new_state
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_sr;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;

--new cases

--u-turn
		when state_u_1 =>
				count_reset <= '0';
				motor_l_reset <= '0';
				motor_r_reset <= '0';
		
				motor_l_direction <= '1';
				motor_r_direction <= '1';

				write_data <= '0';
				read_data <= '0';
				data_out <= "00000000";

				new_state <= state_u_2;

		when state_u_2 =>
				count_reset <= '0';
				motor_l_reset <= '0';
				motor_r_reset <= '0';

				motor_l_direction <= '1';
				motor_r_direction <= '1';
				data_out <= "00000000";

				write_data <= '0';
				read_data <= '0';

		-- 
		if ((sensor_l = '1') and (sensor_m = '0') and (sensor_r = '1')) then
			new_state <= state_r ;
		else
			new_state <= state_u_2;
		end if;

-- eind van lijn
-- state_eind_u1 en state_eind_u2 zijn copies van state_u_1 and state_u_2
		when state_eind_u1 =>
		count_reset <= '0';
		motor_l_reset <= '0';
		motor_r_reset <= '0';

		motor_l_direction <= '1';
		motor_r_direction <= '1';

		write_data <= '0';
		read_data <= '0';
		data_out <= "00000000";

		new_state <= state_eind_u2;

		when state_eind_u2 =>
		count_reset <= '0';
		motor_l_reset <= '0';
		motor_r_reset <= '0';

		motor_l_direction <= '1';
		motor_r_direction <= '1';
		data_out <= "00000000";

		write_data <= '0';
		read_data <= '0';

		
		if ((sensor_l = '1') and (sensor_m = '0') and (sensor_r = '1')) then
			new_state <= state_eind_s ;
		else
			new_state <= state_u_2;
		end if;

		-- state_eind_s is copy of state_s
		when state_eind_s =>
		count_reset		<= '1';
		motor_l_reset		<= '1';
		motor_r_reset		<= '1';

		motor_l_direction	<= '0';
		motor_r_direction	<= '0';

		write_data		<= '1';
		read_data		<= '0';
		data_out <= "00000000";

		if (unsigned(count_in) < to_unsigned(1000000, 20)) then
			new_state <= state_eind_s;
		elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
			new_state <= state_r;
		end if;	

		
-- stop state
		when state_s =>		
					count_reset		<= '1';
					motor_l_reset		<= '1';
					motor_r_reset		<= '1';

					motor_l_direction	<= '0';
					motor_r_direction	<= '0';

					write_data		<= '1';
					read_data		<= '0';
					data_out <= "00000000";

					if (unsigned(count_in) < to_unsigned(1000000, 20)) then
						new_state <= state_s;
					elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
						new_state <= state_r;
					end if;

-- vanaf hier moeten we weer code terugsturen naar C, welke data moeten we terugzenden?
-- bbb state
		when state_bbb1 =>
			count_reset <= '0';
			motor_l_reset <= '0';
			motor_r_reset <= '0';

			motor_l_direction <= '1';
			motor_r_direction <= '0';

			write_data <= '1';  -- we moeten hiermee nog iets doen
			read_data <= '0';


	-- welke code moeten we terugsturen naar Thijs?
			data_out 		<= "00000000";


			if (data_ready = '1') then
				if 		(data_in = "00000101") then
					new_state <= state_s_d;
				elsif 	(data_in = "00000001") then
					new_state <= state_gl_d;
				elsif 	(data_in = "00000010") then
					new_state <= state_gr_d;
				elsif 	(data_in = "00000011") then
					new_state <= state_f_d;
				else
						new_state <= state_bbb1;
				end if;
			end if;

		
-- bbb left
		
		when state_gl_d =>	
					count_reset		<= '0';
					motor_l_reset		<= '1';
					motor_r_reset		<= '0';
					motor_l_direction	<= '0';
					motor_r_direction	<= '0'; 

					write_data		<= '1';
					read_data		<= '0'; 

	-- welke code moeten we terugsturen naar Thijs?
					data_out 		<= "00000000";

					if (unsigned(count_in) < to_unsigned(1000000, 20)) then
						new_state <= state_gl_d;
							
					elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
						new_state <= state_sl_d;
		
					end if;

		when state_sl_d =>	
					count_reset		<= '0';
					motor_l_reset		<= '0';
					motor_r_reset		<= '0';
					motor_l_direction	<= '0';
					motor_r_direction	<= '0';

					write_data		<= '0';
					read_data		<= '0'; 


	-- welke code moeten we terugsturen naar Thijs?
					data_out 		<= "00000000";
					
					if (unsigned(count_in) < to_unsigned(1000000, 20)) then
						new_state <= state_sl_d;
							
					elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
						new_state <= state_r;
		
					end if;

-- bbb right
		when state_gr_d  => 
					count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '0';

					write_data <= '1';
					read_data <= '0';
	
	-- welke code moeten we terugsturen naar Thijs?
					data_out 		<= "00000000";


				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gr_d;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_sr_d;

				end if;

		when state_sr_d  => 

					count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '1';		

					write_data <= '0';
					read_data <= '0';

	-- welke code moeten we terugsturen naar Thijs?
					data_out 		<= "00000000";

				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_sr_d;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;

-- bbb forward
		when state_f_d  => 
					count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '0';

					write_data <= '1';
					read_data <= '0';
	-- welke code moeten we terugsturen naar Thijs?
					data_out 		<= "00000000";


					if (unsigned(count_in) < to_unsigned(1000000, 20)) then
						new_state <= state_f_d;
					elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
						new_state <= state_r;
					end if;
					
--- bbb stop
		when state_s_d =>
		count_reset		<= '1';
		motor_l_reset		<= '1';
		motor_r_reset		<= '1';

		motor_l_direction	<= '0';
		motor_r_direction	<= '0';

		write_data		<= '1';
		read_data		<= '0';

-- welke code moeten we terugsturen naar Thijs?
		data_out 		<= "00000000";

		if (unsigned(count_in) < to_unsigned(1000000, 20)) then
			new_state <= state_s_d;
		elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
			new_state <= state_r;
		end if;
			

		end case;
	end process;
end architecture behavioural;
