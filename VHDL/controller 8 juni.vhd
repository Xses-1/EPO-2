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
	
	type controller_state is	(state_r,
					 state_s,										
					 state_gl_d, state_sl_d_2,							
					 state_gr_d, state_sr_d_2, 							
					 state_f, state_gl, state_sl, state_gr, state_sr,
					 state_u_turn, state_u_turn_2   --state_u_turn_final, weggehaald zie explanation helemaal onder.		
);											
	
	type crossing_state is		(state_ptc, --state patch to crossing
					 state_crossing, --state when on crossing
					 state_ctp,  --state crossing to patch	
					 state_patch	--state when on patch

);

	type communication_state is	(state_com_r, 
					 state_com_write,
					 state_com_wait, state_com_wait_2,
					 state_com_read
);


	signal state, new_state: controller_state;
	signal state_p, new_state_p: crossing_state;
	signal state_com, new_state_com: communication_state;
	signal crossing: std_logic;
	signal left_signal, right_signal, stop_signal, forward_signal, u_turn_signal: std_logic;
	signal count_turn, new_count_turn : unsigned (27 downto 0);

begin
	process (clk)
	begin
		if (rising_edge (clk)) then
			if (reset = '1') then
				state	<= state_r;
				state_p <= state_ptc;
				state_com <= state_com_r;
				
			else
				state 	<= new_state;
				state_p	<= new_state_p;
				state_com <= new_state_com;
			end if;
		end if;
	end process;


	
--Counter (hoeft niet gebruikt te worden)
 	process ( clk )
 	begin
 		if ( clk'event and clk ='1' ) then
			if (reset = '1') then
 				count_turn <= ( others => '0');
 			else
 				count_turn <= new_count_turn;
 			end if;
 		end if;
 	end process;

 	process ( count_turn )
 	begin

		new_count_turn <= count_turn + 1;

 	end process;
--Eind counters
	



--FSM voor cross counting
	process (sensor_l, sensor_m, sensor_r, state_p)  --deleted crossing signal from sensitivity list
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



--Process for communication
	process (state_com, mine_s, crossing, sensor_l, sensor_m, sensor_r, data_ready, data_in, count_turn)
	begin		
		left_signal <= '0';
		right_signal <= '0';
		stop_signal <= '0';
		u_turn_signal <= '0';
		forward_signal<= '0';
		
		case state_com is

			when state_com_r =>	
						read_data <= '0';
						data_out <= "00000000";
						write_data <= '0';
					
					if (mine_s = '1') then
						new_state_com <= state_com_write;
				
					elsif (crossing = '1') then
						new_state_com <= state_com_write;
					
					elsif ((sensor_l = '1' and sensor_m = '1' and sensor_r = '1')) then
						new_state_com <= state_com_write;
					
					else
						new_state_com <= state_com_r;
					end if;
			

			when state_com_write =>		
							read_data <= '0';
							write_data <= '1';
							new_state_com <= state_com_wait;
							
						if (mine_s = '1') then
							data_out <= "00000100";  --Mine detected
						elsif (crossing = '1') then
							data_out <= "00000010";  -- at crossing
						elsif (sensor_l = '0' and sensor_m = '0' and sensor_r = '0') then
							data_out <= "00000011"; -- at dead end
						else
							data_out <= "00000000";
						end if;
						
			when state_com_wait	=>
							write_data <= '0';
							read_data <= '0';

							data_out <= "00000000";
											
						if (data_ready = '0') then
							new_state_com <= state_com_wait_2;
						else
							new_state_com <= state_com_wait;
						end if;
				
			when state_com_wait_2	=>
							write_data <= '0';
							read_data <= '0';

							data_out <= "00000000";

						if ((data_ready = '1')) then 				
							new_state_com <= state_com_read;
						else
							new_state_com <= state_com_wait_2;
						end if;

			when state_com_read	=>
							write_data <= '0';
							data_out <= "00000000";
							read_data<= '1';
							
						if (data_in = "00000001") then
							left_signal <= '1';			
							
						elsif (data_in = "00000010") then
							right_signal <= '1';
		
						elsif (data_in = "00000011") then
							forward_signal<= '1';
	
							
						elsif (data_in = "00000100") then
							stop_signal <= '1';
					
							
						elsif (data_in = "00000101") then
							u_turn_signal <= '1';
			
						else						
							left_signal <= '0';
							right_signal <= '0';
							stop_signal <= '0';
							u_turn_signal <= '0';
							forward_signal<= '0';
						end if;
						
						if (mine_s = '0' or crossing = '0' or (sensor_l = '1' and sensor_m = '0' and sensor_r = '1')) then
							new_state_com <= state_com_r;
						else
							new_state_com <= state_com_read;
						end if;
			
		end case;
	end process;			
																
--End process for communication


--Process for motors
	process (sensor_l, sensor_m, sensor_r, count_in, state, mine_s, --data_in, data_ready,      --I don't think these two should be here (Not read anywhere in this process)
		left_signal, right_signal, stop_signal, forward_signal, u_turn_signal, count_turn) -- added the left, right, stop forward, uturn signals.
	begin 
		case state is

		when state_r =>		count_reset <= '1';							
					motor_l_reset <= '1';
					motor_r_reset <= '1';

					motor_l_direction <= '0';
					motor_r_direction <= '0';

				if (sensor_l = '1' and sensor_m = '0' and sensor_r = '1') then    -- this part makes the robot start working without initializing signal coming in from uart.
					new_state <= state_f;
					
				else
					new_state <= state_r;
				end if;

	
		when state_f => 
					count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
						
				if (left_signal = '1') then
					new_state <= state_gl_d;

				elsif (right_signal = '1') then
					new_state <= state_gr_d;

				elsif (stop_signal = '1') then
					new_state <= state_s;
			
				elsif (forward_signal = '1') then
					new_state <= state_f;

				elsif (u_turn_signal = '1' or mine_s = '1') then
					new_state <= state_u_turn;

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

				else 
					new_state <= state_f;
				
				end if;
		
		
		when state_gl =>	count_reset <= '0';
					motor_l_reset <= '1';
					motor_r_reset <= '0';

					motor_l_direction <= '0';
					motor_r_direction <= '0';
			
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gl;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f;
				end if;
		

		when state_sl =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '0';
					motor_r_direction <= '0';				
			
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_sl;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f;

				end if;
		

		when state_gr =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '0';	
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gr;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f;

				end if;


		when state_sr =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '1';				
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_sr;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_f;

				end if;


-- stop branch, bestaande uit state_s_write en state_s_read.

		when state_s	 =>		count_reset		<= '1';
						motor_l_reset		<= '1';
						motor_r_reset		<= '1';

						motor_l_direction	<= '0';
						motor_r_direction	<= '0';

	               new_state <= state_s;        -- end state, you never leave this, because if you come here you are finished with challenge.
							
				

-- left branch door data van thijs, bestaande uit state_gl_d, state_gl_d_2      We need to make sure the robot turns early enough so lmr = 110 when we encounter the line again.
		
		when state_gl_d =>	count_reset		<= '0';
					motor_l_reset		<= '1';
					motor_r_reset		<= '0';

					motor_l_direction	<= '0';
					motor_r_direction	<= '0'; 

				if ((sensor_l = '1' and sensor_m = '1' and sensor_r = '1')) then
					new_state <= state_sl_d_2;
				else 
					new_state <= state_gl_d;
				end if;
		

		when state_sl_d_2 =>	count_reset		<= '0';
					motor_l_reset		<= '0';
					motor_r_reset		<= '0';
					motor_l_direction	<= '0';
					motor_r_direction	<= '0'; 
					
				if (sensor_l = '1' and sensor_m = '0' and sensor_r = '1') then   -- go back when we see the line again 
					new_state <= state_f;					
				else 
					new_state <= state_sl_d_2;
				end if;


-- right branch door data van thijs, bestaande uit state_gr_d, state_gr_d_2
		when state_gr_d  => 
 					count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
				
				if ((sensor_l = '1' and sensor_m = '1' and sensor_r = '1')) then
					new_state <= state_sr_d_2;
				else 
					new_state <= state_gr_d;
				end if;


		when state_sr_d_2  => 
					count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '1';
				
				if (sensor_l = '1' and sensor_m = '0' and sensor_r = '1') then  -- same comment as state_gl_d_2.
					new_state <= state_f;
				else 
					new_state <= state_sr_d_2;
				end if;
	

--u-turn branch implented as two sharp right states, we turn sharp right until we see lmr = 101 again. 

		when state_u_turn =>	count_reset <= '0';		
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '1';		
					
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
					
				if ((sensor_l = '1' and sensor_m = '0' and sensor_r = '1') or (sensor_l = '0' and sensor_m = '0' and sensor_r = '0') ) then
					new_state <= state_f;
				else 
					new_state <= state_u_turn_2;
				end if;

		end case;
	end process;
end architecture behavioural;
