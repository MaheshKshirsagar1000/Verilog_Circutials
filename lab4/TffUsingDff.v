module d_ff (
    input d, clk, rst,
    output reg q,
    output wire qn
);

always @(posedge clk) begin
    if (rst)
        q <= 1'b0;
    else
        q <= d;
end

assign qn = ~q;

endmodule



module T_ff (
    input clk, rst, T,
    output wire q,
    output wire qn
);

wire d_in;
xor x1 (d_in, T, q);

// Use an internal reg to connect to d_ff's q
wire q_internal;

d_ff d1 (.d(d_in), .clk(clk), .rst(rst), .q(q_internal), .qn(qn));
assign q = q_internal;

endmodule
