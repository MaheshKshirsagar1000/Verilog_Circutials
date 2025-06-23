module up_counter (
    input clk,
    input load,
    input reset,
    input [3:0] data_in,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (~reset)
        count <= 4'b0000;
    else if (~load)
        count <= count + 1'b1;
    else
        count <= data_in;
end

endmodule
