`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2026 11:59:55 AM
// Design Name: 
// Module Name: async_fifo_tb
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


`timescale 1ns/1ps

module async_fifo_tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    // =========================================================
    // Testbench signals
    // =========================================================

    reg write_clk;
    reg read_clk;
    reg reset;

    reg [DATA_WIDTH-1:0] write_data;
    reg write_en;
    reg read_en;

    wire [DATA_WIDTH-1:0] read_data;
    wire full;
    wire empty;


    // =========================================================
    // Instantiate DUT
    // =========================================================

    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .write_clk(write_clk),
        .read_clk(read_clk),
        .reset(reset),

        .write_data(write_data),
        .write_en(write_en),
        .read_en(read_en),

        .read_data(read_data),
        .full(full),
        .empty(empty)
    );


    // =========================================================
    // WRITE CLOCK
    // 100 MHz = 10 ns period
    // =========================================================

    initial begin
        write_clk = 0;

        forever #5 write_clk = ~write_clk;
    end


    // =========================================================
    // READ CLOCK
    // 80 MHz = 12.5 ns period
    // =========================================================

    initial begin
        read_clk = 0;

        forever #6.25 read_clk = ~read_clk;
    end


    // =========================================================
    // Task: Reset FIFO
    // =========================================================

    task reset_fifo;
    begin

        reset      = 1;
        write_en   = 0;
        read_en    = 0;
        write_data = 0;

        #30;

        reset = 0;

        #30;

    end
    endtask


    // =========================================================
    // Task: Write one value
    // =========================================================

    task write_fifo;
        input [DATA_WIDTH-1:0] data;
    begin

        // Change data away from write clock edge
        @(negedge write_clk);

        write_data = data;
        write_en   = 1;

        // Perform write
        @(posedge write_clk);

        #1;

        write_en = 0;

    end
    endtask


    // =========================================================
    // Task: Read one value
    // =========================================================

    task read_fifo;
        output [DATA_WIDTH-1:0] data;
    begin

        @(negedge read_clk);

        read_en = 1;

        @(posedge read_clk);

        #1;

        data = read_data;

        read_en = 0;

    end
    endtask


    // =========================================================
    // Variables for checking data
    // =========================================================

    reg [DATA_WIDTH-1:0] received_data;

    integer i;

    integer pass_count;
    integer fail_count;


    // =========================================================
    // MAIN TEST
    // =========================================================

    initial begin

        pass_count = 0;
        fail_count = 0;

        reset      = 1;
        write_en   = 0;
        read_en    = 0;
        write_data = 0;


        // =====================================================
        // TEST 1: RESET
        // =====================================================

        $display("");
        $display("==============================================");
        $display("TEST 1: RESET");
        $display("==============================================");

        reset_fifo;

        if (empty == 1'b1 && full == 1'b0) begin

            $display("PASS: FIFO is EMPTY after reset");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: Incorrect FIFO status after reset");
            fail_count = fail_count + 1;

        end


        // =====================================================
        // TEST 2: WRITE FOUR VALUES
        // =====================================================

        $display("");
        $display("==============================================");
        $display("TEST 2: WRITE FOUR VALUES");
        $display("==============================================");

        write_fifo(8'hA1);
        write_fifo(8'hB2);
        write_fifo(8'hC3);
        write_fifo(8'hD4);

        $display("Written: A1 B2 C3 D4");


        // Allow write pointer to synchronize
        #50;


        // =====================================================
        // TEST 3: READ FOUR VALUES
        // =====================================================

        $display("");
        $display("==============================================");
        $display("TEST 3: READ FOUR VALUES");
        $display("==============================================");

        read_fifo(received_data);

        if (received_data == 8'hA1) begin
            $display("PASS: Read A1");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: Expected A1, Got %h", received_data);
            fail_count = fail_count + 1;
        end


        read_fifo(received_data);

        if (received_data == 8'hB2) begin
            $display("PASS: Read B2");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: Expected B2, Got %h", received_data);
            fail_count = fail_count + 1;
        end


        read_fifo(received_data);

        if (received_data == 8'hC3) begin
            $display("PASS: Read C3");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: Expected C3, Got %h", received_data);
            fail_count = fail_count + 1;
        end


        read_fifo(received_data);

        if (received_data == 8'hD4) begin
            $display("PASS: Read D4");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: Expected D4, Got %h", received_data);
            fail_count = fail_count + 1;
        end


        // Allow EMPTY to update
        #30;


        // =====================================================
        // TEST 4: EMPTY PROTECTION
        // =====================================================

        $display("");
        $display("==============================================");
        $display("TEST 4: EMPTY PROTECTION");
        $display("==============================================");

        if (empty == 1'b1) begin

            $display("PASS: FIFO became EMPTY after reading all data");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: FIFO did not become EMPTY");
            fail_count = fail_count + 1;

        end


        // =====================================================
        // TEST 5: RESET BEFORE FULL TEST
        // =====================================================

        $display("");
        $display("==============================================");
        $display("TEST 5: RESET BEFORE FULL TEST");
        $display("==============================================");

        reset_fifo;


        // =====================================================
        // TEST 6: FILL FIFO
        // =====================================================

        $display("");
        $display("==============================================");
        $display("TEST 6: FILL FIFO WITH 16 VALUES");
        $display("==============================================");

        for (i = 0; i < 16; i = i + 1) begin

            write_fifo(i);

        end

        $display("16 values written");


        // Wait for full logic
        #30;


        // =====================================================
        // TEST 7: CHECK FULL
        // =====================================================

        $display("");
        $display("==============================================");
        $display("TEST 7: FULL FLAG");
        $display("==============================================");

        if (full == 1'b1) begin

            $display("PASS: FIFO is FULL");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: FIFO did not become FULL");
            fail_count = fail_count + 1;

        end


        // =====================================================
        // TEST 8: WRITE WHEN FULL
        // =====================================================

        $display("");
        $display("==============================================");
        $display("TEST 8: WRITE WHEN FULL");
        $display("==============================================");

        write_fifo(8'hFF);

        #10;

        if (full == 1'b1) begin

            $display("PASS: FIFO rejected write while FULL");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: FULL flag changed unexpectedly");
            fail_count = fail_count + 1;

        end


        // =====================================================
        // TEST 9: READ ALL 16 VALUES
        // =====================================================

        $display("");
        $display("==============================================");
        $display("TEST 9: READ 16 VALUES");
        $display("==============================================");

        for (i = 0; i < 16; i = i + 1) begin

            read_fifo(received_data);

            if (received_data == i[7:0]) begin

                $display("PASS: Read value %h", received_data);
                pass_count = pass_count + 1;

            end
            else begin

                $display(
                    "FAIL: Expected %h, Got %h",
                    i[7:0],
                    received_data
                );

                fail_count = fail_count + 1;

            end

        end


        // Allow EMPTY to update
        #30;


        // =====================================================
        // TEST 10: FINAL EMPTY CHECK
        // =====================================================

        $display("");
        $display("==============================================");
        $display("TEST 10: FINAL EMPTY CHECK");
        $display("==============================================");

        if (empty == 1'b1) begin

            $display("PASS: FIFO is EMPTY after all reads");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: FIFO is not EMPTY");
            fail_count = fail_count + 1;

        end


        // =====================================================
        // FINAL RESULT
        // =====================================================

        #50;

        $display("");
        $display("");
        $display("==============================================");
        $display("           FINAL TEST RESULT");
        $display("==============================================");

        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);

        if (fail_count == 0) begin

            $display("");
            $display("**********************************************");
            $display("          ALL TESTS PASSED!");
            $display("          ASYNC FIFO VERIFIED");
            $display("**********************************************");

        end
        else begin

            $display("");
            $display("**********************************************");
            $display("          SOME TESTS FAILED");
            $display("**********************************************");

        end

        $finish;

    end

endmodule