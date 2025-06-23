module singleport8x16_async_ram(addr, we, re, data);

    input [2:0] addr;       // 3-bit address (8 locations)
    input we, re;           // Write and Read Enable
    inout [15:0] data;      // Bidirectional data line

    reg [15:0] mem [7:0];   // Memory array (8 locations x 16 bits)

    // Write operation (when we=1 and re=0)
    always @ (*)
    begin
        if (we && ~re)
            mem[addr] = data;
    end

    // Read operation (when re=1 and we=0)
    assign data = (re && !we) ? mem[addr] : 16'bz;  // High impedance if not reading

endmodule
