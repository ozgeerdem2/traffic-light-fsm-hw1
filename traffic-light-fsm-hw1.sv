module traffic_fsm (
    input  logic clk,
    input  logic reset,
    input  logic TAORB,
    output logic [2:0] LA,
    output logic [2:0] LB
);

    typedef enum logic [1:0] {
        S0,
        S1,
        S2,
        S3
    } state_t;

    state_t current_state, next_state;
    logic [2:0] timer;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            timer <= 3'd0;
        end else begin
            current_state <= next_state;
            if (current_state == S1 || current_state == S3) begin
                if (timer < 3'd5)
                    timer <= timer + 3'd1;
                else
                    timer <= 3'd0;
            end else begin
                timer <= 3'd0;
            end
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            S0: begin
                if (!TAORB) next_state = S1;
            end
            S1: begin
                if (timer >= 3'd5) next_state = S2;
            end
            S2: begin
                if (TAORB) next_state = S3;
            end
            S3: begin
                if (timer >= 3'd5) next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    always_comb begin
        LA = 3'b100;
        LB = 3'b100;
        case (current_state)
            S0: begin LA = 3'b001; LB = 3'b100; end
            S1: begin LA = 3'b010; LB = 3'b100; end
            S2: begin LA = 3'b100; LB = 3'b001; end
            S3: begin LA = 3'b100; LB = 3'b010; end
        endcase
    end

endmodule



