module d_ff (
    input wire din,
    input wire clk,
    input wire rst,
    output reg q,
    output wire qn
);

always @(posedge clk) begin
    if (rst)
        q <= 1'b0;
    else
        q <= din;
end

assign qn = ~q;

endmodule
