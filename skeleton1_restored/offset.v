module offset(ADDR, ADDX, ADDY);
	//ADDR = 640*y + x;
	input[18:0] ADDR;
	output[18:0] ADDX,ADDY;
	assign ADDY = ADDR/(19'd640);
	assign ADDX = ADDR%(19'd640);
endmodule
