module T_ff_tb();

reg clk, rst, Tin;
wire q, qn;

parameter CYCLE = 10;

// Instantiate T flip-flop
T_ff T1 (.clk(clk), .rst(rst), .T(Tin), .q(q), .qn(qn));

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10 time units full cycle
end

// Initialization
task initialize();
begin
    rst = 0;
    Tin = 0;
end
endtask

// Reset pulse
task reset();
begin
    @(negedge clk);
    rst = 1'b1;
    @(negedge clk);
    rst = 1'b0;
end
endtask

// Set T input
task ip_set(input bit T_val);
begin
    @(negedge clk);
    Tin = T_val;
end
endtask

// Main stimulus
initial begin
    initialize();
    reset();

    ip_set(1'b1);
    #10;
    ip_set(1'b0);
    #10;
    ip_set(1'b1);
    #10;
    ip_set(1'b0);
    #10;
    ip_set(1'b1);
    #10;

    $finish;
end

// Monitor signals
initial begin
    $monitor("Time=%0t | T=%b clk=%b rst=%b | q=%b qn=%b", $time, Tin, clk, rst, q, qn);
end

endmodule
