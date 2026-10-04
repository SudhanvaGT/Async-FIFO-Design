`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2026 11:26:23 AM
// Design Name: 
// Module Name: full_logic
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


module full_logic #(
    parameter ADDR_WIDTH = 4
)(
    input  wire                  write_clk,
    input  wire                  reset,

    input  wire [ADDR_WIDTH:0]   write_ptr_gray_next,
    input  wire [ADDR_WIDTH:0]   synced_read_ptr_gray,

    output reg                   full
);

    // Full condition
    wire full_condition;

    assign full_condition =
        (write_ptr_gray_next ==
        {
            ~synced_read_ptr_gray[ADDR_WIDTH:ADDR_WIDTH-1],
             synced_read_ptr_gray[ADDR_WIDTH-2:0]
        });

    // Register FULL flag
    always @(posedge write_clk or posedge reset) begin

        if (reset) begin
            full <= 1'b0;
        end

        else begin
            full <= full_condition;
        end

    end

endmodule
