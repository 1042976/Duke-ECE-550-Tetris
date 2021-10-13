module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 left,
							 right,
							 space,
							 down,
							 ifkeypressed);

input left,right,space,down;
input iRST_n;
input iVGA_CLK;
input ifkeypressed;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
wire [18:0] ADDX, ADDY;
reg [18:0] ADDX_r, ADDY_r;
reg [18:0] x0,x1,x2,x3,y0,y1,y2,y3;
reg [14:0] score_img0, score_img1;
reg [18:0] y_0, y_1, y_2, y_3;
reg [18:0] mx0,mx1,mx2,mx3,my_0,my_1,my_2,my_3;
reg [18:0] count;
reg [23:0] bgr_data;
reg [4:0] blockType;
reg [383:0] staticBlock;
reg moveEnable;
wire VGA_CLK_n;
wire [7:0] index;
reg [18:0] score;
reg [18:0] wx0,wx1,wx2,wx3;
reg[7:0] index_new;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
wire [18:0] lBorder, rborder, width;
wire [18:0] xbegin, xend, xlen;
wire [18:0] score0, score1;
assign lBorder = 160;
assign rborder = 480;
assign width = 320;
assign xbegin = 8;
assign xend = 23;
assign xlen = 16;
//initial square  length = 40
integer i, j, k;
wire wi;
initial begin
	x0 <= 13;
	x1 <= 14;
	x2 <= 15;
	x3 <= 16;
	y0 <= 0;
	y1 <= 0;
	y2 <= 0;
	y3 <= 0;
	y_0 <= 0;
	y_1 <= 0;
	y_2 <= 0;
	y_3 <= 0;
	mx0 <= 13;
	mx1 <= 14;
	mx2 <= 15;
	mx3 <= 16;
	my_0 <= 0;
	my_1 <= 0;
	my_2 <= 0;
	my_3 <= 0;
	count <= 0;
	moveEnable <= 1'b0;
	blockType <= 0;
	staticBlock <= 0;
	score <= 0;
	score_img0 <= 15'b111101101101111;
	score_img1 <= 15'b111101101101111;
end

assign score0 = score%10;
assign score1 = score/10;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
									
				
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//Get ADDX, ADDY.
offset(.ADDR(ADDR),.ADDX(ADDX),.ADDY(ADDY));
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
always@(posedge iVGA_CLK) begin
	if(count == 599999) begin
		count = 0;
	end
	else begin 
		if(ifkeypressed) begin 
			moveEnable = 1'b1;
		end
	   if(count == 0) begin
			mx0 = x0;
			mx1 = x1;
			mx2 = x2;
			mx3 = x3;
			my_0 = y_0;
			my_1 = y_1;
			my_2 = y_2;
			my_3 = y_3;
			if(moveEnable)begin
				if(x0 >= xbegin+1 && x1 >= xbegin+1 && x2>= xbegin+1&& x3 >= xbegin+1&&left == 1 && right == 0 && space ==0) begin
					mx0 = x0 - 1;
					mx1 = x1 - 1;
					mx2 = x2 - 1;
					mx3 = x3 - 1;
				end
				else if(x0 < xend && x1<xend&& x2 < xend && x3 < xend && left == 0 && right == 1 && space == 0)begin
					mx0 = x0 + 1;
					mx1 = x1 + 1;
					mx2 = x2 + 1;
					mx3 = x3 + 1;
				end
				//rotation
				else if(left == 0 && right == 0 && space == 1)begin
					if(blockType == 0)begin
						mx0 = x1;
						mx2 = x1;
						mx3 = x1;
						my_0 = y_1-1*20;
						my_2 = y_1+1*20;
						my_3 = y_1+2*20;
						blockType = 1;
					end
					else if(blockType == 1)begin
						mx0 = x1-1;
						mx2 = x1+1;
						mx3 = x1+2;
						my_0 = y_1;
						my_2 = y_1;
						my_3 = y_1;
						blockType = 0;
					end
					else if(blockType == 3)begin
						mx0 = x2-1;
						mx1 = x2;
						mx3 = x2;
						my_0 = y_2+1*20;
						my_1 = y_2+1*20;
						my_3 = y_2-1*20;
						blockType = 4;
					end
					else if(blockType == 4)begin
						mx0 = x2+1;
						mx1 = x2+1;
						mx3 = x2-1;
						my_0 = y_2-1*20;
						my_1 = y_2;
						my_3 = y_2;
						blockType = 5;
					end
					else if(blockType == 5)begin
						mx0 = x2+1;
						mx1 = x2;
						mx3 = x2;
						my_0 = y_2-1*20;
						my_1 = y_2-1*20;
						my_3 = y_2+1*20;
						blockType = 6;
					end
					else if(blockType == 6)begin
						mx0 = x2-1;
						mx1 = x2-1;
						mx3 = x2+1;
						my_0 = y_2-1*20;
						my_1 = y_2;
						my_3 = y_2;
						blockType = 3;
					end
					else if(blockType == 7)begin
						mx0 = x2-1;
						mx1 = x2;
						mx3 = x2;
						my_0 = y_2;
						my_1 = y_2+1*20;
						my_3 = y_2-1*20;
						blockType = 8;
					end
					else if(blockType == 8)begin
						mx0 = x2;
						mx1 = x2+1;
						mx3 = x2-1;
						my_0 = y_2+1*20;
						my_1 = y_2;
						my_3 = y_2;
						blockType = 9;
					end
					else if(blockType == 9)begin
						mx0 = x2+1;
						mx1 = x2;
						mx3 = x2;
						my_0 = y_2;
						my_1 = y_2-1*20;
						my_3 = y_2+1*20;
						blockType = 10;
					end
					else if(blockType == 10)begin
						mx0 = x2;
						mx1 = x2-1;
						mx3 = x2+1;
						my_0 = y_2-1*20;
						my_1 = y_2;
						my_3 = y_2;
						blockType = 7;
					end
					else if(blockType == 11)begin
						mx0 = x2-1;
						mx1 = x2;
						mx3 = x2;
						my_0 = y_2-1*20;
						my_1 = y_2-1*20;
						my_3 = y_2+1*20;
						blockType = 12;
					end
					else if(blockType == 12)begin
						mx0 = x2-1;
						mx1 = x2-1;
						mx3 = x2+1;
						my_0 = y_2+1*20;
						my_1 = y_2;
						my_3 = y_2;
						blockType = 13;
					end
					else if(blockType == 13)begin
						mx0 = x2+1;
						mx1 = x2;
						mx3 = x2;
						my_0 = y_2+1*20;
						my_1 = y_2+1*20;
						my_3 = y_2-1*20;
						blockType = 14;
					end
					else if(blockType == 14)begin
						mx0 = x2+1;
						mx1 = x2+1;
						mx3 = x2-1;
						my_0 = y_2-1*20;
						my_1 = y_2;
						my_3 = y_2;
						blockType = 11;
					end
					else if(blockType == 15)begin
						mx0 = x2-1;
						mx1 = x2-1;
						mx3 = x2;
						my_0 = y_2+1*20;
						my_1 = y_2;
						my_3 = y_2-1*20;
						blockType = 16;
					end
					else if(blockType == 16)begin
						mx0 = x2-1;
						mx1 = x2;
						mx3 = x2+1;
						my_0 = y_2-1*20;
						my_1 = y_2-1*20;
						my_3 = y_2;
						blockType = 15;
					end
					else if(blockType == 17)begin
						mx0 = x2-1;
						mx1 = x2-1;
						mx3 = x2;
						my_0 = y_2-1*20;
						my_1 = y_2;
						my_3 = y_2+1*20;
						blockType = 18;
					end
					else if(blockType == 18)begin
						mx0 = x2+1;
						mx1 = x2;
						mx3 = x2-1;
						my_0 = y_2-1*20;
						my_1 = y_2-1*20;
						my_3 = y_2;
						blockType = 17;
					end
				end
				if(staticBlock[((my_0-9)/20)*16+mx0-8] == 1'b0&&
				staticBlock[((my_1-9)/20)*16+mx1-8] == 1'b0&&
				staticBlock[((my_2-9)/20)*16+mx2-8] == 1'b0&&
				staticBlock[((my_3-9)/20)*16+mx3-8] == 1'b0&&
				staticBlock[((my_0+9)/20)*16+mx0-8] == 1'b0&&
				staticBlock[((my_1+9)/20)*16+mx1-8] == 1'b0&&
				staticBlock[((my_2+9)/20)*16+mx2-8] == 1'b0&&
				staticBlock[((my_3+9)/20)*16+mx3-8] == 1'b0&&
				staticBlock[(my_0/20)*16+mx0-8] == 1'b0&&
				staticBlock[(my_1/20)*16+mx1-8] == 1'b0&&
				staticBlock[(my_2/20)*16+mx2-8] == 1'b0&&
				staticBlock[(my_3/20)*16+mx3-8] == 1'b0&&
				mx0>=8 && mx0 <= 23 && mx1>=8 &&mx1<=23&& 
				mx2>=8 && mx2 <= 23&& mx3>=8 &&mx3<=23&&
				my_0<=480&&my_1<=480&&my_2<=480&&my_3<=480)begin
					x0 = mx0;
					x1 = mx1;
					x2 = mx2;
					x3 = mx3;
					y_0 = my_0;
					y_1 = my_1;
					y_2 = my_2;
					y_3 = my_3;
				end
				moveEnable = 1'b0;
			end
			if(y_0 + 10 < 480 && y_1 + 10 < 480 && y_2 + 10 < 480 && y_3 + 10 < 480) begin
				y_0 = y_0 + 1;
				y_1 = y_1 + 1;
				y_2 = y_2 + 1;
				y_3 = y_3 + 1;
			end

		end
		//increase speed if score >= 3
		if(score >= 3&&count == 300000&&
			y_0 + 10 < 480 && y_1 + 10 < 480 && y_2 + 10 < 480 && y_3 + 10 < 480) begin
				y_0 = y_0 + 1;
				y_1 = y_1 + 1;
				y_2 = y_2 + 1;
				y_3 = y_3 + 1;
		end
		//if(y < 480) y = y + 1;
		//generate new block
	   if(y_0 + 10 >=478 || y_1 + 10 >= 478 || y_2 + 10 >= 478 || y_3 + 10 >= 478||
		staticBlock[((y_0+10)/20)*16+x0-8] == 1'b1 ||
		staticBlock[((y_1+10)/20)*16+x1-8] == 1'b1 ||
		staticBlock[((y_2+10)/20)*16+x2-8] == 1'b1 ||
		staticBlock[((y_3+10)/20)*16+x3-8] == 1'b1)begin
			blockType = (x0+x1+x2+x3+y_0/20)%19;
			staticBlock[(y_0/20)*16+x0-8] = 1'b1;
			staticBlock[(y_1/20)*16+x1-8] = 1'b1;
			staticBlock[(y_2/20)*16+x2-8] = 1'b1;
			staticBlock[(y_3/20)*16+x3-8] = 1'b1;
			if(blockType == 0)begin
				x0 = 13;
				x1 = 14;
				x2 = 15;
				x3 = 16;
				y0 = 0;
				y1 = 0;
				y2 = 0;
				y3 = 0;
			end
			else if(blockType == 1)begin
				x0 = 13;
				x1 = 13;
				x2 = 13;
				x3 = 13;
				y0 = 0;
				y1 = 1;
				y2 = 2;
				y3 = 3;
			end
			else if(blockType == 2)begin
				x0 = 13;
				x1 = 14;
				x2 = 13;
				x3 = 14;
				y0 = 0;
				y1 = 0;
				y2 = 1;
				y3 = 1;
			end
			else if(blockType == 3)begin
				x0 = 13;
				y0 = 0;
				x1 = 13;
				y1 = 1;
				x2 = 14;
				y2 = 1;
				x3 = 15;
				y3 = 1;
			end
			else if(blockType == 4)begin
				x0 = 13;
				y0 = 2;
				x1 = 14;
				y1 = 2;
				x2 = 14;
				y2 = 1;
				x3 = 14;
				y3 = 0;
			end
			else if(blockType == 5)begin
				x0 = 16;
				y0 = 1;
				x1 = 16;
				y1 = 0;
				x2 = 15;
				y2 = 0;
				x3 = 14;
				y3 = 0;
			end
			else if(blockType == 6)begin
				x0 = 16;
				y0 = 0;
				x1 = 15;
				y1 = 0;
				x2 = 15;
				y2 = 1;
				x3 = 15;
				y3 = 2;
			end
			else if(blockType == 7)begin
				x0 = 15;
				x1 = 14;
				x2 = 15;
				x3 = 16;
				y0 =  0;
				y1 = 1;
				y2 = 1;
				y3 = 1;
			end
			else if(blockType == 8)begin
				x0 = 14;
				x1 = 15;
				x2 = 15;
				x3 = 15;
				y0 = 1;
				y1 = 2;
				y2 = 1;
				y3 = 0;
			end
			else if(blockType == 9)begin
				x0 = 15;
				x1 = 16;
				x2 = 15;
				x3 = 14;
				y0 = 1;
				y1 = 0;
				y2 = 0;
				y3 = 0;
			end
			else if(blockType == 10)begin
				x0 = 16;
				x1 = 15;
				x2 = 15;
				x3 = 15;
				y0 = 1;
				y1 = 0;
				y2 = 1;
				y3 = 2;
			end
			else if(blockType == 11)begin
				x0 = 16;
				x1 = 16;
				x2 = 15;
				x3 = 14;
				y0 = 0;
				y1 = 1;
				y2 = 1;
				y3 = 1;
			end
			else if(blockType == 12)begin
				x0 = 13;
				x1 = 14;
				x2 = 14;
				x3 = 14;
				y0 = 0;
				y1 = 0;
				y2 = 1;
				y3 = 2;
			end
			else if(blockType == 13)begin
				x0 = 13;
				x1 = 13;
				x2 = 14;
				x3 = 15;
				y0 = 1;
				y1 = 0;
				y2 = 0;
				y3 = 0;
			end
			else if(blockType == 14)begin
				x0 = 16;
				x1 = 15;
				x2 = 15;
				x3 = 15;
				y0 = 2;
				y1 = 2;
				y2 = 1;
				y3 = 0;
			end
			else if(blockType == 15)begin
				x0 = 13;
				x1 = 14;
				x2 = 14;
				x3 = 15;
				y0 = 0;
				y1 = 0;
				y2 = 1;
				y3 = 1;
			end
			else if(blockType == 16)begin
				x0 = 15;
				x1 = 15;
				x2 = 16;
				x3 = 16;
				y0 = 2;
				y1 = 1;
				y2 = 1;
				y3 = 0;
			end
			else if(blockType == 17)begin
				x0 = 16;
				x1 = 15;
				x2 = 15;
				x3 = 14;
				y0 = 0;
				y1 = 0;
				y2 = 1;
				y3 = 1;
			end
			else if(blockType == 18)begin
				x0 = 15;
				x1 = 15;
				x2 = 16;
				x3 = 16;
				y0 = 0;
				y1 = 1;
				y2 = 1;
				y3 = 2;
			end
			y_0 = y0*20+10;
			y_1 = y1*20+10;
			y_2 = y2*20+10;
			y_3 = y3*20+10;
		end
		if(ADDX >= x0*20 && ADDX < x0*20+19 && ADDY >= y_0 -10&& ADDY < y_0+9 ||
			ADDX >= x1*20 && ADDX < x1*20+19 && ADDY >= y_1 -10&& ADDY < y_1+9 ||
			ADDX >= x2*20 && ADDX < x2*20+19 && ADDY >= y_2 -10&& ADDY < y_2+9 ||
			ADDX >= x3*20 && ADDX < x3*20+19 && ADDY >= y_3 -10&& ADDY < y_3+9)
			index_new = 10;
		else if(ADDX >=160 && ADDX <= 480)begin
			ADDX_r = (ADDX-160)/20;
			ADDY_r = ADDY/20;
			if(staticBlock[ADDY_r*16+ADDX_r] == 1'b1) index_new = 10;
			else index_new = 5;
		end
		else if(score_img0[0]==1'b1 && ADDX>=100&&ADDX<=120&&ADDY>=20&&ADDY<=40 ||
		score_img0[1]==1'b1 && ADDX>=120&&ADDX<=140&&ADDY>=20&&ADDY<=40||
		score_img0[2]==1'b1 && ADDX>=140&&ADDX<=160&&ADDY>=20&&ADDY<=40||
		score_img0[3]==1'b1 && ADDX>=100&&ADDX<=120&&ADDY>=40&&ADDY<=60||
		score_img0[4]==1'b1 && ADDX>=120&&ADDX<=140&&ADDY>=40&&ADDY<=60||
		score_img0[5]==1'b1 && ADDX>=140&&ADDX<=160&&ADDY>=40&&ADDY<=60||
		score_img0[6]==1'b1 && ADDX>=100&&ADDX<=120&&ADDY>=60&&ADDY<=80||
		score_img0[7]==1'b1 && ADDX>=120&&ADDX<=140&&ADDY>=60&&ADDY<=80||
		score_img0[8]==1'b1 && ADDX>=140&&ADDX<=160&&ADDY>=60&&ADDY<=80||
		score_img0[9]==1'b1 && ADDX>=100&&ADDX<=120&&ADDY>=80&&ADDY<=100||
		score_img0[10]==1'b1 && ADDX>=120&&ADDX<=140&&ADDY>=80&&ADDY<=100||
		score_img0[11]==1'b1 && ADDX>=140&&ADDX<=160&&ADDY>=80&&ADDY<=100||
		score_img0[12]==1'b1 && ADDX>=100&&ADDX<=120&&ADDY>=100&&ADDY<=120||
		score_img0[13]==1'b1 && ADDX>=120&&ADDX<=140&&ADDY>=100&&ADDY<=120||
		score_img0[14]==1'b1 && ADDX>=140&&ADDX<=160&&ADDY>=100&&ADDY<=120||
		score_img1[0]==1'b1 && ADDX>=20&&ADDX<=40&&ADDY>=20&&ADDY<=40 ||
		score_img1[1]==1'b1 && ADDX>=40&&ADDX<=60&&ADDY>=20&&ADDY<=40||
		score_img1[2]==1'b1 && ADDX>=60&&ADDX<=80&&ADDY>=20&&ADDY<=40||
		score_img1[3]==1'b1 && ADDX>=20&&ADDX<=40&&ADDY>=40&&ADDY<=60||
		score_img1[4]==1'b1 && ADDX>=40&&ADDX<=60&&ADDY>=40&&ADDY<=60||
		score_img1[5]==1'b1 && ADDX>=60&&ADDX<=80&&ADDY>=40&&ADDY<=60||
		score_img1[6]==1'b1 && ADDX>=20&&ADDX<=40&&ADDY>=60&&ADDY<=80||
		score_img1[7]==1'b1 && ADDX>=40&&ADDX<=60&&ADDY>=60&&ADDY<=80||
		score_img1[8]==1'b1 && ADDX>=60&&ADDX<=80&&ADDY>=60&&ADDY<=80||
		score_img1[9]==1'b1 && ADDX>=20&&ADDX<=40&&ADDY>=80&&ADDY<=100||
		score_img1[10]==1'b1 && ADDX>=40&&ADDX<=60&&ADDY>=80&&ADDY<=100||
		score_img1[11]==1'b1 && ADDX>=60&&ADDX<=80&&ADDY>=80&&ADDY<=100||
		score_img1[12]==1'b1 && ADDX>=20&&ADDX<=40&&ADDY>=100&&ADDY<=120||
		score_img1[13]==1'b1 && ADDX>=40&&ADDX<=60&&ADDY>=100&&ADDY<=120||
		score_img1[14]==1'b1 && ADDX>=60&&ADDX<=80&&ADDY>=100&&ADDY<=120)begin
			index_new = 6;	
		end
		else index_new = index;
		
		count = count + 1;
		
		for(i = 0; i < 24; i = i+1)begin
			if(staticBlock[16*i +: 16] == 16'hFFFF)begin
				for(j = i; j >= 1; j = j - 1)begin
					staticBlock[16*j +: 16] = staticBlock[16*(j-1) +: 16];
				end
				staticBlock[15:0] = 16'h0000;
				score = score + 1;
			end
			//score0 = score/10;
			//score1 = score%10;			
		end
		if(score0 == 0) score_img0 = 15'b111101101101111;
		else if(score0 == 1) score_img0 = 15'b010010010010010;
		else if(score0 == 2) score_img0 = 15'b111001111100111;
		else if(score0 == 3) score_img0 = 15'b111100111100111;
		else if(score0 == 4) score_img0 = 15'b100100111101101;
		else if(score0 == 5) score_img0 = 15'b111100111001111;
		else if(score0 == 6) score_img0 = 15'b111101111001111;
		else if(score0 == 7) score_img0 = 15'b100100100100111;
		else if(score0 == 8) score_img0 = 15'b111101111101111;
		else if(score0 == 9) score_img0 = 15'b111100111101111;
		if(score1 == 0) score_img1 = 15'b111101101101111;
		else if(score1 == 1) score_img1 = 15'b010010010010010;
		else if(score1 == 2) score_img1 = 15'b111001111100111;
		else if(score1 == 3) score_img1 = 15'b111100111100111;
		else if(score1 == 4) score_img1 = 15'b100100111101101;
		else if(score1 == 5) score_img1 = 15'b111100111001111;
		else if(score1 == 6) score_img1 = 15'b111101111001111;
		else if(score1 == 7) score_img1 = 15'b100100100100111;
		else if(score1 == 8) score_img1 = 15'b111101111101111;
		else if(score1 == 9) score_img1 = 15'b111100111101111;		
	end
end

//always@(count) begin
//	if(count == 0) begin
//		if(left == 1 && right == 0) 
//			x = x - 1;
//		else if(left == 0 && right == 1)
//			x = x + 1;
//		if(up == 1 && down == 0)
//			y = y - 1;
//		else if(up == 0 && down == 1)
//			y = y + 1;
//	end
//	
//	if(ADDX >= x && ADDX < x+40 && ADDY >= y && ADDY < y+40)
//		index_new = 10;
//	else
//		index_new = index;
//end
//////Color table output
img_index	img_index_inst (
	.address ( index_new ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n)
begin 
	bgr_data <= bgr_data_raw;
end

assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 

///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















