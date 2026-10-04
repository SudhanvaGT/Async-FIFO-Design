`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2026 09:54:01 AM
// Design Name: 
// Module Name: async_fifo
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


module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input  wire                  write_clk,
    input  wire                  read_clk,
    input  wire                  reset,

    input  wire [DATA_WIDTH-1:0] write_data,
    input  wire                  write_en,
    input  wire                  read_en,

    output wire [DATA_WIDTH-1:0] read_data,
    output wire                  full,
    output wire                  empty
);

    // =========================================================
    // Internal signals
    // =========================================================

    // Write pointer signals
    wire [ADDR_WIDTH:0] write_ptr_bin;
    wire [ADDR_WIDTH:0] write_ptr_gray;

    wire [ADDR_WIDTH:0] write_ptr_bin_next;
    wire [ADDR_WIDTH:0] write_ptr_gray_next;

    // Read pointer signals
    wire [ADDR_WIDTH:0] read_ptr_bin;
    wire [ADDR_WIDTH:0] read_ptr_gray;

    wire [ADDR_WIDTH:0] read_ptr_bin_next;
    wire [ADDR_WIDTH:0] read_ptr_gray_next;

    // Synchronized pointers
    wire [ADDR_WIDTH:0] synced_write_ptr_gray;
    wire [ADDR_WIDTH:0] synced_read_ptr_gray;

    // Actual FIFO operations
    wire write_enable;
    wire read_enable;


    // =========================================================
    // Write enable control
    // =========================================================

    assign write_enable = write_en && !full;


    // =========================================================
    // Read enable control
    // =========================================================

    assign read_enable = read_en && !empty;


    // =========================================================
    // Write pointer
    // =========================================================

    write_pointer #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) write_pointer_inst (

        .write_clk(write_clk),
        .reset(reset),
        .write_enable(write_enable),

        .write_ptr_bin(write_ptr_bin),
        .write_ptr_gray(write_ptr_gray),

        .write_ptr_bin_next(write_ptr_bin_next),
        .write_ptr_gray_next(write_ptr_gray_next)
    );


    // =========================================================
    // Read pointer
    // =========================================================

    read_pointer #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) read_pointer_inst (

        .read_clk(read_clk),
        .reset(reset),
        .read_enable(read_enable),

        .read_ptr_bin(read_ptr_bin),
        .read_ptr_gray(read_ptr_gray),

        .read_ptr_bin_next(read_ptr_bin_next),
        .read_ptr_gray_next(read_ptr_gray_next)
    );


    // =========================================================
    // Synchronize WRITE pointer into READ clock domain
    // =========================================================

    synchronizer #(
        .WIDTH(ADDR_WIDTH + 1)
    ) sync_write_to_read (

        .clk(read_clk),
        .reset(reset),

        .async_signal(write_ptr_gray),

        .sync_signal(synced_write_ptr_gray)
    );


    // =========================================================
    // Synchronize READ pointer into WRITE clock domain
    // =========================================================

    synchronizer #(
        .WIDTH(ADDR_WIDTH + 1)
    ) sync_read_to_write (

        .clk(write_clk),
        .reset(reset),

        .async_signal(read_ptr_gray),

        .sync_signal(synced_read_ptr_gray)
    );


    // =========================================================
    // FULL logic
    // =========================================================

    full_logic #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) full_logic_inst (

        .write_clk(write_clk),
        .reset(reset),

        .write_ptr_gray_next(write_ptr_gray_next),
        .synced_read_ptr_gray(synced_read_ptr_gray),

        .full(full)
    );


    // =========================================================
    // EMPTY logic
    // =========================================================

    empty_logic #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) empty_logic_inst (

        .read_clk(read_clk),
        .reset(reset),

        .read_ptr_gray_next(read_ptr_gray_next),
        .synced_write_ptr_gray(synced_write_ptr_gray),

        .empty(empty)
    );


    // =========================================================
    // FIFO memory
    // =========================================================

    fifo_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) fifo_memory_inst (

        .write_clk(write_clk),
        .write_en(write_enable),
        .write_addr(write_ptr_bin[ADDR_WIDTH-1:0]),
        .write_data(write_data),

        .read_clk(read_clk),
        .read_addr(read_ptr_bin[ADDR_WIDTH-1:0]),
        .read_data(read_data)
    );

endmodule
