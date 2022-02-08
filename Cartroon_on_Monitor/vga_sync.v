`timescale 1ns / 1ps // timescale for following modules


module vga_sync (clock_25MHz, red, green, blue, red_out, green_out, 
						blue_out, hsync, vsync, pixel_row, pixel_col);
 

	input clock_25MHz;
	input red;
	input green;
	input blue;
	output reg red_out;
	output reg green_out;
	output reg blue_out;
	output reg hsync;
	output reg vsync;
	output reg [9:0] pixel_row;
	output reg [9:0] pixel_col;

	reg [9:0] h_cnt;
	reg [9:0] v_cnt;
	reg  video_on;


	always @(posedge clock_25MHz)
   begin
		if (h_cnt >= 799)				//(Res+Front_porch+Sync_Pulse+Back_porch=640+16+96+48=800)
			h_cnt <= 10'b0000000000;
		else
			h_cnt <= h_cnt + 1;

		if (h_cnt >= 659 & h_cnt <= 755)   //HS of 96 (Start=Res+Front_porch=640+16=656->+4 b/c 25.17Mhz, End=659+ 96 (sync_pulse)=755)
			hsync <= 1'b0;
		else
			hsync <= 1'b1;

		//  Generate Vertical Timing Signals for Video Signal
		//  v_cnt counts lines down screen (525 total = 480 active + extras for sync and blanking)
		//  Active picture for 0 <= v_cnt <= 479
		//  Vsync for 493 <= h_cnt <= 494
		if (v_cnt >= 524 & h_cnt == 799)  //V_res=480+extras  
			v_cnt <= 10'b0000000000;
		else if (h_cnt == 799)
			v_cnt <= v_cnt + 1;

		if (v_cnt >= 493 & v_cnt <= 494)
			vsync <= 1'b0;
		else
			vsync <= 1'b1;

		//  Generate Video Signals and Pixel Address
		if (h_cnt <= 639 & v_cnt <= 479)
			video_on = 1'b1;
		else
			video_on = 1'b0;

		pixel_col <= h_cnt;   
		pixel_row <= v_cnt;

		//  Register video to clock edge and suppress video during blanking and sync periods
		red_out <= red & video_on;
		green_out <= green & video_on;
		blue_out <= blue & video_on;
   end

endmodule // module vga_sync

