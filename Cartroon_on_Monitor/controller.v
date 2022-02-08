`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:22:37 12/13/2021 
// Design Name: 
// Module Name:    controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module controller(
		input [9:0] s_pixel_row, s_pixel_col,
		input clk_25,
		output reg [15:0] address =0
	);

always@(posedge clk_25)
begin
	if(s_pixel_row < 256 && s_pixel_col < 256)
		begin
			address = address+1;
		end
	else 
		begin
			address = address;
		end
	if (address == 65536)
		address = 0;
end

endmodule
