`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 11:12:08 PM
// Design Name: 
// Module Name: write_pointer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module write_pointer #(
parameter ADDR_WIDTH=4
)(
input wire write_clk,
input wire reset,
input wire write_enable,

output reg[ADDR_WIDTH:0] write_ptr_bin,
output reg[ADDR_WIDTH:0] write_ptr_gray,

output wire [ADDR_WIDTH:0] write_ptr_bin_next,//binary pointer calculation
output wire [ADDR_WIDTH:0] write_ptr_gray_next//gray code pointer calculation

);

assign write_ptr_bin_next=write_ptr_bin+write_enable;//next binary pointer

assign write_ptr_gray_next=(write_ptr_bin_next>>1)^write_ptr_bin_next;//convertion of binary to gray code
//pointer register
always @(posedge write_clk or posedge reset)
begin
if(reset)
begin
write_ptr_bin<=0;
write_ptr_gray<=0;
end
else
begin
write_ptr_bin<=write_ptr_bin_next;
write_ptr_gray<=write_ptr_gray_next;
end
end


endmodule
