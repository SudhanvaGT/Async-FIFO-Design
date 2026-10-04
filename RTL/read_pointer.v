`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 11:30:40 PM
// Design Name: 
// Module Name: read_pointer
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


module read_pointer #(
parameter ADDR_WIDTH=4
)(
input wire read_clk,
input wire reset,
input wire read_enable,

output reg[ADDR_WIDTH:0] read_ptr_bin,
output reg[ADDR_WIDTH:0] read_ptr_gray,
output wire[ADDR_WIDTH:0] read_ptr_bin_next,
output wire[ADDR_WIDTH:0] read_ptr_gray_next

    );
   
    
    assign read_ptr_bin_next=read_ptr_bin + read_enable;
    
    assign read_ptr_gray_next=(read_ptr_bin_next>>1)^read_ptr_bin_next;
    
    always @(posedge read_clk or posedge reset)
    begin
    if(reset)
    begin
    read_ptr_bin<=0;
    read_ptr_gray<=0;
    end
    else
    begin
    read_ptr_bin<=read_ptr_bin_next;
    read_ptr_gray<=read_ptr_gray_next;
    end
    end
    
endmodule
