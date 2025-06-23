// ===========================
// Dual-Port RAM RTL
// ===========================
module dual_port_ram (
    input re, we, clk, reset,
    input [3:0] data_in,
    input [3:0] w_add, r_add,
    output reg [7:0] data_out
);

    reg [7:0] ram [15:0]; // 16 locations, each 8-bit wide
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            // Reset all memory locations to 0
            for (i = 0; i < 16; i = i + 1) begin
                ram[i] <= 8'b0;
            end
        end
        else if (we) begin
            // Write to memory
            ram[w_add] <= data_in;
        end
        else if (re) begin
            // Read from memory
            data_out <= ram[r_add];
        end
    end

endmodule
