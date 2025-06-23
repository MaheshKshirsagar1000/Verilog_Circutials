// ===============================
// Module: clk_buff (Clock Buffer)
// ===============================
module clk_buff(input mclk, output bclk);

    // Simple buffer: passes input clock (mclk) to output (bclk)
    buf buff(bclk, mclk);

endmodule


// ========================================
// Testbench: clk_buffer_tb (Test the Buffer)
// ========================================
module clk_buffer_tb();

    // Declare test signals
    reg mclk;           // Original clock signal
    wire bclk;          // Buffered clock signal

    // Time variables to record clock edge times
    time t1, t2, t3, t4, t5, t6;

    // Instantiate the clock buffer module
    clk_buff DUT(mclk, bclk); // DUT = Device Under Test

    // ---------------------------------------
    // Initial setup for mclk and clock toggle
    // ---------------------------------------
    initial begin
        mclk = 1'b0;         // Start clock at 0
    end

    // Toggle mclk every 10 time units => Clock period = 20
    always #10 mclk = ~mclk;

    // ---------------------------------------
    // Task: measure rising edges of mclk
    // ---------------------------------------
    task measure_mclk;
    begin
        @(posedge mclk) t1 = $time; // Capture time of 1st rising edge
        @(posedge mclk) t3 = $time; // Capture time of 2nd rising edge
    end
    endtask

    // ---------------------------------------
    // Task: measure rising edges of bclk
    // ---------------------------------------
    task measure_bclk;
    begin
        @(posedge bclk) t2 = $time; // Capture time of 1st rising edge
        @(posedge bclk) t4 = $time; // Capture time of 2nd rising edge
    end
    endtask

    // ---------------------------------------
    // Main test sequence
    // ---------------------------------------
    initial begin
        // Run both tasks in parallel to capture times
        fork
            measure_mclk;
            measure_bclk;
        join

        // -------- Check Phase --------
        if ((t1 == t2) && (t3 == t4))
            $display("Phase is same");
        else
            $display("Phase is not same");

        // -------- Check Frequency --------
        t5 = t3 - t1; // Time between mclk rising edges (period)
        t6 = t4 - t2; // Time between bclk rising edges (period)

        if (t5 == t6)
            $display("Frequency is same");
        else
            $display("Frequency is not same");

        // Finish simulation after a delay
        #50 $finish;
    end

endmodule
