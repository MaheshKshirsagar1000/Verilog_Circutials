module singleport_tb();

    reg [2:0] addr;           // Address
    reg we, re;               // Write and Read Enable
    wire [15:0] data;         // Bidirectional data line
    reg [15:0] temp;          // Temporary register to drive data during write
    integer i;

    // Instantiate the RAM
    singleport8x16_async_ram dut(addr, we, re, data);

    // -------------------------
    // Task: Initialize signals
    // -------------------------
    task initialize();
        begin
            we = 1'b0;
            re = 1'b0;
            addr = 3'b0;
            temp = 16'b0;
        end
    endtask

    // Control data line for writing
    assign data = (we && !re) ? temp : 16'bz;

    // -------------------------
    // Task: Set write mode
    // -------------------------
    task write_t();
        begin
            we = 1'b1;
            re = 1'b0;
        end
    endtask

    // -------------------------
    // Task: Set read mode
    // -------------------------
    task read_t();
        begin
            we = 1'b0;
            re = 1'b1;
        end
    endtask

    // -------------------------
    // Task: Stimulus for writing
    // -------------------------
    task stimulusw(input [2:0] a, input [15:0] d);
        begin
            addr = a;
            temp = d;      // Drive data to write
        end
    endtask

    // -------------------------
    // Task: Stimulus for reading
    // -------------------------
    task stimulusr(input [2:0] ad);
        begin
            addr = ad;
        end
    endtask

    // -------------------------
    // Main Test Procedure
    // -------------------------
    initial begin
        initialize;
        #10;
        write_t;

        // Write 8 values to memory
        for (i = 0; i < 8; i = i + 1)
        begin
            stimulusw(i, {$random} % 65536);
            #10;
        end

        read_t;

        // Read values back
        for (i = 0; i < 8; i = i + 1)
        begin
            stimulusr(i);
            #10;
        end

        #1000 $finish;
    end

endmodule
