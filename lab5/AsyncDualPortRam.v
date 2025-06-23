module ram8x16_asynch_dualport (
    wr_clk, rd_clk, clr, we, re, data_in, rd_addr, wr_addr, data_out
);

    // -------------------------
    // Parameters
    // -------------------------
    parameter RAM_WIDTH = 16;   // Data width
    parameter RAM_DEPTH = 8;    // Number of locations (addresses)
    parameter ADDR_SIZE = 3;    // Address width (log2(RAM_DEPTH))

    // -------------------------
    // Ports
    // -------------------------
    input wr_clk, rd_clk, clr;                     // Clocks and reset
    input we, re;                                  // Write and read enables
    input [RAM_WIDTH-1:0] data_in;                 // Input data
    input [ADDR_SIZE-1:0] wr_addr, rd_addr;        // Write and read addresses
    output reg [RAM_WIDTH-1:0] data_out;           // Output data

    // -------------------------
    // Internal memory array
    // -------------------------
    reg [RAM_WIDTH-1:0] mem [RAM_DEPTH-1:0];
    integer i;

    // -------------------------
    // Write logic (wr_clk domain)
    // -------------------------
    always @ (posedge wr_clk or posedge clr)
    begin
        if (clr) begin
            // Clear all memory locations
            for (i = 0; i < RAM_DEPTH; i = i + 1)
                mem[i] <= 0;
        end
        else if (we) begin
            // Write to memory
            mem[wr_addr] <= data_in;
        end
    end

    // -------------------------
    // Read logic (rd_clk domain)
    // -------------------------
    always @ (posedge rd_clk or posedge clr)
    begin
        if (clr) begin
            data_out <= 0; // Clear output
        end
        else if (re) begin
            data_out <= mem[rd_addr]; // Read from memory
        end
    end

endmodule
