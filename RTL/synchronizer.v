`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 12:54:18 AM
// Design Name: 
// Module Name: synchronizer
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


module synchronizer #(
parameter WIDTH=5
)(
input wire clk,
input wire reset,
input wire[WIDTH-1:0] async_signal,
output reg[WIDTH-1:0] sync_signal
);
reg[WIDTH-1:0] sync_ff1;
reg[WIDTH-1:0] sync_ff2;

always @(posedge clk or posedge reset)
begin
if(reset)
begin
sync_ff1<=0;
sync_ff2<=0;
sync_signal<=0;
end
else
begin
sync_ff1<=async_signal;
sync_ff2<=sync_ff1;
sync_signal<=sync_ff2;
end
end
endmodule
