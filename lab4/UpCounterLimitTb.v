module Upcounter_load_tb();

reg clk, reset, load;
reg [3:0] data_in;
wire [3:0] count;

up_counter uc1 (clk, load, reset, data_in, count);

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
task resetT();
begin
    @(negedge clk);
    reset = 0;
    @(negedge clk);
    reset = 1;
end
endtask

// Load task
task load_ip(input l, input [3:0] d);
begin 
    @(negedge clk);
    load = l;
    data_in = d;
end 
endtask

// Display outputs
initial begin
    $display("Time\tReset Load Data_in | Count");
    $monitor("%0t\t%b     %b    %b      | %b", $time, reset, load, data_in, count);
end

// Stimulus
initial begin
    initialize;
    resetT;

    load_ip(1'b1, 4'b0001);  // Load value 1
    #50;

    load_ip(1'b0, 4'b1111);  // Start counting up from 1
    #150;

    $finish;
end

endmodule
