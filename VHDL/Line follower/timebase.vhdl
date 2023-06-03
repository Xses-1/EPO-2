library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timebase is
	port (  clk             : in std_logic;
        	reset           : in std_logic;
        	count_out       : out std_logic_vector (19 downto 0)
		-- add a new reset out here
 	) ;
 end entity timebase ;

 architecture behavioural of timebase is

 	signal count, new_count : unsigned (19 downto 0);

 begin
 	process ( clk )
 	begin
 		if ( clk'event and clk ='1' ) then
			if ( reset = '1' OR count >= 20ms ) then
 				count <= ( others => '0');
				-- new reset out is 1 here 
 			else
 				count <= new_count;
				-- new reset out is 0 here

 			end if;
 		end if;
 	end process;


 	process ( count )
 	begin

		new_count <= count + 1;

 	end process;

 	count_out <= std_logic_vector ( count );
 end architecture behavioural;
