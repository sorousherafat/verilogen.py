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

    output wire [{{ m * n - 1 }}:0] out;
    input wire [{{ m - 1 }}:0] in1;
    input wire [{{ n - 1 }}:0] in2;
    {% for i in range(m * n) %}
    and and_{{ i // n }}_{{ i % n }} (out[{{ i }}], in1[{{ i // n }}], in2[{{ i % n }}]);{% endfor %}

endmodule


module array_multiplier_{{ m }}x{{ n }} (
    product,
    in1,
    in2
);

    output wire [{{ m + n - 1 }}:0] product;
    input wire [{{ m - 1 }}:0] in1;
    input wire [{{ n - 1 }}:0] in2;

    wire [{{ m * n - 1 }}:0] anded_inputs;
    and_gates inputs_and (
        .out(anded_inputs),
        .in1(in1),
        .in2(in2)
    );

    wire [{{ m * (n - 1) - 1 }}:0] sum_middleware;
    wire [{{ (m + 1) * n - 1 }}:0] carry_middleware;

    half_adder half_adder_0_0 (product[0], carry_middleware[0], {1'b0}, anded_inputs[0]);
    {% for i in range(n - 1) %}half_adder half_adder_0_{{ i + 1 }} (sum_middleware[{{ i }}], carry_middleware[{{ i + 1 }}], {1'b0}, anded_inputs[{{ i + 1 }}]);
    {% endfor %}
    {% for i in range(m - 1) %}full_adder full_adder_{{ i + 1 }}_0 (product[{{ i + 1 }}], carry_middleware[{{ (i + 1) * n }}], sum_middleware[{{ i * (n - 1) }}], anded_inputs[{{ (i + 1) * n }}], carry_middleware[{{ i * n }}]);
    {% for j in range(n - 2) %}full_adder full_adder_{{ i + 1 }}_{{ j + 1 }} (sum_middleware[{{ (i + 1) * (n - 1) + j }}], carry_middleware[{{ (i + 1) * n + j + 1 }}], sum_middleware[{{ i * (n - 1) + j + 1 }}], anded_inputs[{{ (i + 1) * n + j + 1 }}], carry_middleware[{{ i * n + j + 1 }}]);
    {% endfor %}half_adder half_adder_{{ i + 1 }}_{{ n - 1 }} (sum_middleware[{{ (i + 2) * (n - 1) - 1 }}], carry_middleware[{{ (i + 2) * n - 1 }}], carry_middleware[{{ (i + 1) * n - 1 }}], anded_inputs[{{ (i + 2) * n - 1 }}]);

    {% endfor %}
    half_adder half_adder_r_0 (product[{{ m }}], carry_middleware[{{ m * n }}], sum_middleware[{{ (m - 1) * (n - 1) }}], carry_middleware[{{ (m - 1) * n }}]);
    {% for i in range(n - 2) %}full_adder full_adder_r_{{ i + 1 }} (product[{{ m + i + 1 }}], carry_middleware[{{ m * n + i + 1 }}], sum_middleware[{{ (m - 1) * (n - 1) + i + 1 }}], carry_middleware[{{ (m - 1) * n + i + 1 }}], carry_middleware[{{ m * n + i }}]);
    {% endfor %}half_adder half_adder_r_{{ n - 1 }} (product[{{ m + n - 1 }}], carry_middleware[{{ (m + 1) * n - 1 }}], carry_middleware[{{ m * n - 1 }}], carry_middleware[{{ (m + 1) * n - 2 }}]);

endmodule
