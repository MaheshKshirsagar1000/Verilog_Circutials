// ===========================
// Testbench for Dual-Port RAM
// ===========================
module dual_port_tb();

    reg re, we, clk, reset;
    reg [3:0] data_in;
    reg [3:0] w_add, r_add;
    wire [7:0] data_out;
    integer i;

    // Instantiate the DUT
    dual_port_ram DUT (
        .re(re), .we(we), .clk(clk), .reset(reset),
        .data_in(data_in), .w_add(w_add), .r_add(r_add),
        .data_out(data_out)
    );

    // Clock generation
    initial clk = 1'b1;
    always #10 clk = ~clk;  // 20 time unit clock period

    // -------------------------
    // Tasks
    // -------------------------
    
    // Initialize signals
    task initialize;
    begin
        re = 0;
        we = 0;
        reset = 0;
        w_add = 0;
        r_add = 0;
        data_in = 0;
    end
    endtask

    // Reset the DUT
    task rst_dut;
    begin
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;
    end
    endtask

    // Write data to memory
    task write(input [3:0] w_add1, input [7:0] data_in1);
    begin
        @(negedge clk);
        we = 1;
        w_add = w_add1;
        data_in = data_in1;
        @(negedge clk);
        we = 0;
    end
    endtask

    // Read data from memory
    task read(input [3:0] r_add1);
    begin
        @(negedge clk);
        re = 1;
        r_add = r_add1;
        @(negedge clk);
        re = 0;
    end
    endtask

    // -------------------------
    // Main Test Logic
    // -------------------------
    initial begin
        initialize;
        rst_dut;

        // Test write and read one value
        write(4'd1, 8'd55);
        read(4'd1);

        // Test writing and reading full RAM
        for (i = 0; i < 16; i = i + 1) begin
            write(i[3:0], i); // Write i to address i
        end

        for (i = 0; i < 16; i = i + 1) begin
            read(i[3:0]); // Read from address i
        end

        #50 $finish;
    end

endmodule
