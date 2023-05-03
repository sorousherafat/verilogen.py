module half_adder (
    sum,
    carry,
    in1,
    in2
);

    output wire sum;
    output wire carry;
    input wire in1;
    input wire in2;

    xor xor_gate (sum, in1, in2);
    and and_gate (carry, in1, in2);

endmodule


module full_adder (
    sum,
    carry_out,
    in1,
    in2,
    carry_in
);

    output wire sum;
    output wire carry_out;
    input wire in1;
    input wire in2;
    input wire carry_in;

    wire inputs_adder_sum;
    wire inputs_adder_carry;
    wire carry_adder_carry;

    half_adder inputs_half_adder (
        .sum(inputs_adder_sum),
        .carry(inputs_adder_carry),
        .in1(in1),
        .in2(in2)
    );

    half_adder carry_half_adder (
        .sum(sum),
        .carry(carry_adder_carry),
        .in1(carry_in),
        .in2(inputs_adder_sum)
    );

    or carry_or_gate (carry_out, inputs_adder_carry, carry_adder_carry);

endmodule


module and_gates (
    out,
    in1,
    in2
);

    output wire [8:0] out;
    input wire [2:0] in1;
    input wire [2:0] in2;
    
    and and_0_0 (out[0], in1[0], in2[0]);
    and and_0_1 (out[1], in1[0], in2[1]);
    and and_0_2 (out[2], in1[0], in2[2]);
    and and_1_0 (out[3], in1[1], in2[0]);
    and and_1_1 (out[4], in1[1], in2[1]);
    and and_1_2 (out[5], in1[1], in2[2]);
    and and_2_0 (out[6], in1[2], in2[0]);
    and and_2_1 (out[7], in1[2], in2[1]);
    and and_2_2 (out[8], in1[2], in2[2]);

endmodule


module array_multiplier_3x3 (
    product,
    in1,
    in2
);

    output wire [5:0] product;
    input wire [2:0] in1;
    input wire [2:0] in2;

    wire [8:0] anded_inputs;
    and_gates inputs_and (
        .out(anded_inputs),
        .in1(in1),
        .in2(in2)
    );

    wire [5:0] sum_middleware;
    wire [11:0] carry_middleware;

    half_adder half_adder_0_0 (product[0], carry_middleware[0], {1'b0}, anded_inputs[0]);
    half_adder half_adder_0_1 (sum_middleware[0], carry_middleware[1], {1'b0}, anded_inputs[1]);
    half_adder half_adder_0_2 (sum_middleware[1], carry_middleware[2], {1'b0}, anded_inputs[2]);
    
    full_adder full_adder_1_0 (product[1], carry_middleware[3], sum_middleware[0], anded_inputs[3], carry_middleware[0]);
    full_adder full_adder_1_1 (sum_middleware[2], carry_middleware[4], sum_middleware[1], anded_inputs[4], carry_middleware[1]);
    half_adder half_adder_1_2 (sum_middleware[3], carry_middleware[5], carry_middleware[2], anded_inputs[5]);

    full_adder full_adder_2_0 (product[2], carry_middleware[6], sum_middleware[2], anded_inputs[6], carry_middleware[3]);
    full_adder full_adder_2_1 (sum_middleware[4], carry_middleware[7], sum_middleware[3], anded_inputs[7], carry_middleware[4]);
    half_adder half_adder_2_2 (sum_middleware[5], carry_middleware[8], carry_middleware[5], anded_inputs[8]);

    
    half_adder half_adder_r_0 (product[3], carry_middleware[9], sum_middleware[4], carry_middleware[6]);
    full_adder full_adder_r_1 (product[4], carry_middleware[10], sum_middleware[5], carry_middleware[7], carry_middleware[9]);
    half_adder half_adder_r_2 (product[5], carry_middleware[11], carry_middleware[8], carry_middleware[10]);

endmodule