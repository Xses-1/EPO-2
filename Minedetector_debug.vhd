library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mine_sensor is 

	port (	clk		: in  std_logic;
		reset		: in  std_logic;
		sensor		: in  std_logic;
		mine_out	: out std_logic;
		led_1		: out std_logic;
		led_2		: out std_logic;	
		led_3		: out std_logic;
		led_4		: out std_logic;
		led_5		: out std_logic;
		led_6		: out std_logic;	
		led_7		: out std_logic;
		led_8		: out std_logic
	);
end entity mine_sensor;

architecture behavioural of mine_sensor is

type sensor_states is (reset_state, count_state, compare_state, detected_state);

signal count, new_count: unsigned (11 downto 0) := to_unsigned(0,12);
constant treshhold : unsigned(11 downto 0 ) :=  to_unsigned(1760, 12);
signal state, next_state : sensor_states;
signal count_bit: std_logic_vector(11 downto 0);
begin
	process(clk)
		begin
			if (rising_edge(clk)) then
				if (reset = '1') then
					state <= reset_state;
					count <= (others => '0');
				else
					state <= next_state;
					count <= new_count;
				end if;
			end if;
		end process;
	
	process(state, count, sensor)
		begin	
		case state is
			when reset_state =>
				mine_out <= '0';
				new_count <= (others => '0');

				if (sensor = '1') then
					next_state <= reset_state;
				else
					next_state <= count_state;
				end if;

			when count_state =>
				mine_out <= '0';
				if (sensor = '0') then
					new_count <= count + 1;
					next_state <= count_state;
				else
					new_count <= count;
					next_state <= compare_state;
				end if;

			when compare_state =>
				mine_out <= '0';
				new_count <= count;
				if (count > treshhold) then
					next_state <= detected_state;
				else
					next_state <= reset_state;
				end if;

			when detected_state =>
				mine_out <= '1';
				new_count <= count;
				next_state <= detected_state;	

			when others =>

			end case;
		end process;

count_bit <= std_logic_vector(count);
led_1 <= count_bit(11);
led_2 <= count_bit(10);
led_3 <= count_bit(9);
led_4 <= count_bit(8);
led_5 <= count_bit(7);
led_6 <= count_bit(6);
led_7 <= count_bit(5);
led_8 <= count_bit(4);
end architecture behavioural;
