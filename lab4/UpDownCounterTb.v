module Upcounter_load_tb();

    reg clk, reset, load, mode;
    reg [3:0] data_in;
    wire [3:0] count;

    // Instantiate the design
    up_counter1 uc1 (
        .clk(clk),
        .load(load),
        .reset(reset),
        .mode(mode),
        .data_in(data_in),
        .count(count)
    );

    // Clock generation: toggles every 10 time units
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    // Task to initialize all inputs
    task initialize();
    begin
        clk = 0;
        reset = 0;
        load = 0;
        mode = 0;
        data_in = 4'b0000;
    end
    endtask

    // Task to apply reset
    task resetT();
    begin
        @(negedge clk);
        reset = 0;
        #5;
        @(negedge clk);
        reset = 1;
    end
    endtask

    // Task to load values
    task load_ip(input l, input m, input [3:0] d);
    begin
        @(negedge clk);
        load = l;
        mode = m;
        data_in = d;
    end
    endtask

    // Main stimulus
    initial begin
        initialize;
        resetT;

        load_ip(1'b1, 1'b1, 4'b0001);  // Load value 1
        #50;

        load_ip(1'b0, 1'b0, 4'b1111);  // Start counting down
        #100;

        $finish;
    end

endmodule
