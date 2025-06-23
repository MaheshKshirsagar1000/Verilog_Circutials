module sr_latch (
    input s,
    input r,
    output q,
    output qn
);

    // Internal wires to hold outputs of the NOR gates
    wire w1, w2;

    // Gate-level modeling
    nor n1(w1, s, qn);  // w1 = ~(s + qn)
    nor n2(w2, r, q);   // w2 = ~(r + q)

    // Outputs
    assign q = w1;
    assign qn = w2;

endmodule
