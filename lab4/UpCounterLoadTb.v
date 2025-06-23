module Upcounter_load_tb();
    reg clk, reset, load;
    reg [3:0] data_in;
    wire [3:0] count;

    // Instantiate the counter module
    up_counter uut (
        .clk(clk),
        .load(load),
        .reset(reset),
        .data_in(data_in),
        .count(count)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Initialization task
    task initialize();
    begin
        reset = 0;
        load = 0;
        data_in = 4'b0000;
    end
    endtask

    // Reset task
    task apply_reset();
    begin
        @(negedge clk);
        reset = 0;
        @(negedge clk);
        reset = 1;
    end
    endtask

    // Load input task
    task load_ip(input l, input [3:0] d);
    begin
        @(negedge clk);
        load = l;
        data_in = d;
    end
    endtask

    // Test sequence
    initial begin
        initialize;
        apply_reset;

        load_ip(1'b1, 4'b0001); // Load 1
        #50;

        load_ip(1'b0, 4'b0001); // Start counting up
        #100;

        $finish;
    end

endmodule
