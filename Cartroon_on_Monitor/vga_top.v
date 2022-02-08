`timescale 1ns / 1ps


module vga_top (clk_50MHz, vga_red, vga_green, vga_blue, vga_hsync, vga_vsync);


	input   clk_50MHz; 
	output   [2:0] vga_red; 
	output   [2:0] vga_green; 
	output   [1:0] vga_blue; 
	output   vga_hsync; 
	output   vga_vsync; 

	wire    [2:0] vga_red; 
	wire    [2:0] vga_green; 
	wire    [1:0] vga_blue; 
	wire    vga_hsync; 
	wire    vga_vsync; 
	reg     ck_25; 

	//  internal signals to connect modules
	wire    S_red; 
	wire    S_green; 
	wire    S_blue; 
	wire    S_vsync; 
	wire    [9:0] S_pixel_row; 
	wire    [9:0] S_pixel_col; 
	wire [15:0] address;
	wire [2:0] dout;
	

	//   Process to generate 25 MHz clock from 50 MHz system clock


	always @(posedge clk_50MHz)
	begin
		ck_25 <= ~ck_25;   
   end

	//  vga_driver only drives MSB of red, green & blue
	//  so set other bits to zero
	assign vga_red[1:0] = 2'b00;
	assign vga_green[1:0] = 2'b00;
	assign vga_blue[0] = 1'b0;

	// instantiate ball component//ball (v_sync, pixel_row, pixel_col, red, green, blue)
	rom_2 a1(ck_25,address,dout);
	controller C(S_pixel_row,S_pixel_col,ck_25,address);
	// instantiate vga_sync component (clock_25MHz, red, green, blue, red_out, green_out, lue_out, hsync, vsync, pixel_row, pixel_col);
	vga_sync vga_driver (
          .clock_25MHz(ck_25),
          .red(dout[2]),
          .green(dout[1]),
          .blue(dout[0]),
          .red_out(vga_red[2]),
          .green_out(vga_green[2]),
          .blue_out(vga_blue[1]),
          .pixel_row(S_pixel_row),
          .pixel_col(S_pixel_col),
          .hsync(vga_hsync),
          .vsync(S_vsync));

	assign vga_vsync = S_vsync; 

endmodule