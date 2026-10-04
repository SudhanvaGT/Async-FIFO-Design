`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 01:04:50 AM
// Design Name: 
// Module Name: empty_logic
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


module empty_logic #(
parameter ADDR_WIDTH=4
)(
input wire read_clk,
input wire reset,
input wire[ADDR_WIDTH:0] read_ptr_gray_next,
input wire[ADDR_WIDTH:0] synced_write_ptr_gray,
output reg empty
);
always @(posedge read_clk or posedge reset)
begin
if(reset)
begin
empty<=1'b1;
end
else
begin
empty<=(read_ptr_gray_next==synced_write_ptr_gray);
end
end
endmodule
