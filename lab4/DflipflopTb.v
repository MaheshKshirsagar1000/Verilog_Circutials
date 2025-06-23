

module D_ff_tb;

reg clk, rst, din;
wire q, qn;

d_ff uut (
    .din(din),
    .clk(clk),
    .rst(rst),
    .q(q),
    .qn(qn)
);

task reset;
begin
    @(negedge clk);
    rst = 1'b1;
    @(negedge clk);
    rst = 1'b0;
end
endtask

task initialize;
begin
    clk = 0;
    rst = 0;
    din = 0;
end
endtask

task ip_set(input reg d);
begin
    @(negedge clk);
    din = d;
end
endtask

// Clock generation
always #5 clk = ~clk;

initial begin
    initialize;
    reset;

    ip_set(1'b1);
    ip_set(1'b0);
    ip_set(1'b1);
    ip_set(1'b0);
    ip_set(1'b1);
    #20 $finish;
end

endmodule
