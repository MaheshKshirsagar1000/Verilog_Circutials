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
    else if (load == 1'b1 && data_in < 4'd11)
        count <= data_in;
    else if (count == 4'd11)
        count <= 4'b0000;
    else
        count <= count + 1'b1;
end

endmodule
