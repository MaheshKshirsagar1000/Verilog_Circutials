module dualport_tb();

    // -------------------------
    // Parameters
    // -------------------------
    parameter RAM_WIDTH = 16;
    parameter RAM_DEPTH = 8;
    parameter ADDR_SIZE = 3;
    parameter CYCLE = 10;

    // -------------------------
    // Signals
    // -------------------------
    reg wr_clk, rd_clk, clr, we, re;
    reg [RAM_WIDTH-1:0] data_in;
    wire [RAM_WIDTH-1:0] data_out;
    reg [ADDR_SIZE-1:0] rd_addr, wr_addr;

    integer i, j;

    // -------------------------
    // Instantiate DUT
    // -------------------------
    ram8x16_asynch_dualport dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .clr(clr),
        .we(we),
        .re(re),
        .data_in(data_in),
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .data_out(data_out)
    );

    // -------------------------
    // Clock Generation
    // -------------------------
    always #10 wr_clk = ~wr_clk;  // 20-unit write clock
    always #20 rd_clk = ~rd_clk;  // 40-unit read clock

    // -------------------------
    // Task: Initialize signals
    // -------------------------
    task initialize();
    begin
        wr_clk = 0;
        rd_clk = 0;
        clr = 0;
        we = 0;
        re = 0;
        wr_addr = 0;
        rd_addr = 0;
    end
    endtask

    // -------------------------
    // Task: Clear memory
    // -------------------------
    task clr_t;
    begin
        clr = 1'b1;
        #50;
        clr = 1'b0;
    end
    endtask

    // -------------------------
    // Task: Write data
    // -------------------------
    task write_t(input [15:0] a, input [2:0] b, input w);
    begin
        @ (negedge wr_clk)
        we = w;
        wr_addr = b;
        data_in = a;
    end
    endtask

    // -------------------------
    // Task: Read data
    // -------------------------
    task read_t(input [2:0] a, input r);
    begin
        @ (negedge rd_clk)
        re = r;
        rd_addr = a;
    end
    endtask

    // -------------------------
    // Main Test Sequence
    // -------------------------
    initial begin
        initialize;
        #10;
        clr_t;  // Clear the RAM

        // Write random values to RAM
        for (i = 0; i < RAM_DEPTH; i = i + 1)
            write_t({$random} % 16, i, 1'b1);  // Write random data to addr i

        // Read values back
        for (j = 0; j < RAM_DEPTH; j = j + 1)
            read_t(j, 1'b1);  // Read from addr j

        #100 $finish;
    end

endmodule
