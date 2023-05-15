library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mine_counter is
	port (  clk             : in std_logic;
		mine_out 	: in std_logic;
        	reset           : out std_logic
 	) ;
 end entity mine_counter ;

 architecture behavioural of mine_counter is

 	signal count, new_count : unsigned (19 downto 0);

 begin
 	process ( clk )
 	begin
 		if ( clk'event and clk = '1' ) then
			if ( mine_out = '0' ) then
 				
				count <= ( others => '0');
				reset <= '0';

			elsif ( count = 4000 ) then
				
				count <= count;
				reset <= '1';

			else
 				count <= new_count;

 			end if;
 		end if;
 	end process;


 	process ( count )
 	begin

		new_count <= count + 1;

 	end process;
 end architecture behavioural;
