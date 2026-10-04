`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 10:44:34 PM
// Design Name: 
// Module Name: fifo_memory
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


module fifo_memory #(parameter DATA_WIDTH=8,
parameter ADDR_WIDTH=4
)( 
input wire write_clk,
input wire write_en,
input wire[ADDR_WIDTH-1:0]write_addr,
input wire[DATA_WIDTH-1:0]write_data,

input wire read_clk,
input wire [ADDR_WIDTH-1:0]read_addr,
output reg [DATA_WIDTH-1:0]read_data

    );
    
    reg [DATA_WIDTH-1:0] memory[0:(1<<ADDR_WIDTH)-1]; //fifo storage creation
    
    always @(posedge write_clk)
    begin
    if(write_en)
    memory[write_addr]<=write_data;//writing the data in the memory
    end
    
    always @(posedge read_clk)
    begin
    read_data<=memory[read_addr];//raeding the data from memory
    end
    
endmodule
