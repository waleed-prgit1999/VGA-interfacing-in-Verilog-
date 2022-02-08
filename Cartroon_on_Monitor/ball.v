`timescale 1ns / 1ps // timescale for following modules


module ball (v_sync, pixel_row, pixel_col, red, green, blue);


	input v_sync;
	input [9:0] pixel_row;
	input [9:0] pixel_col;
	output wire red;
	output wire green;
	output wire blue;

//	parameter size = 8;
	parameter size1 = 2;
	parameter size = 40;
	parameter	r=80;
	//  indicates whether ball is over current pixel position
	reg ball_on;
   
	//  current ball position - intitialized to center of screen
	reg [9:0] ball_x = 320;
	reg [9:0] ball_y = 200;

	//  current ball motion - initialized to +4 pixels/frame
	reg [9:0] ball_y_motion = 10'b0000000100;

	//  color setup for red ball on white background
/*	assign red = 1'b1;
	assign green = 1'b1;
	assign blue = 1'b1;*/
	
	assign red = 1'b1;
assign green = ~ball_on;
assign blue = ~ball_on;

	//  process to draw ball current pixel address is covered by ball position
	always @(ball_x or ball_y or pixel_row or pixel_col)
	begin
	
		/*if(pixel_col >= ball_x - size1 & pixel_col <= ball_x + size1 & 
			pixel_row >= ball_y - size & pixel_row <= ball_y + size) 
		*/
		if((((pixel_row - ball_x)*(pixel_row - ball_x)+(pixel_col - ball_y)*(pixel_col - ball_y)))<=r*r)
		begin
			ball_on <= 1'b 1;
		end

		else
      begin
			ball_on <= 1'b 0;
      end
   end

	//  process to move ball once every frame (i.e. once every vsync pulse)
	always @(posedge v_sync)
	begin
		if (ball_y + size >= 480)
		begin
			//   -4 pixels
			ball_y_motion <= 10'b1111111100;   
		end
		else if (ball_y <= size)
		begin
			//   +4 pixels
			ball_y_motion <= 10'b0000000100;   
		end
		
		//  compute next ball position 
		ball_y <= ball_y + ball_y_motion;   
	end


endmodule // module ball

