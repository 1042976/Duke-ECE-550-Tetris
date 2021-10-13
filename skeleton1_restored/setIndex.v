module setIndex(count, ADDX, ADDY, index, left, right, up, down, x, y, index_new);
	input[13:0] count;
	input[7:0] index;
	input left, right, up, down;
	input[9:0] ADDX, ADDY;
	output reg[9:0] x, y;
	output reg [7:0] index_new;
	
	always@(count) begin
		if(count == 0) begin
			if(left == 1 && right == 0) 
				x = x - 1;
			else if(left == 0 && right == 1)
				x = x + 1;
			if(up == 1 && down == 0)
				y = y - 1;
			else if(up == 0 && down == 1)
				y = y + 1;
		end
		
		if(ADDX >= x && ADDX < x+40 && ADDY >= y && ADDY < y+40)
			index_new = 10;
		else
			index_new = index;
	end
endmodule
