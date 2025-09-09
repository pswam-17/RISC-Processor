module FlagRegister (
    input clk,
    input start,
    input reset,
    input update,
    input clear,
    input CarryIn,
    input OverflowIn,
    output logic C,
    output logic V

);


always_ff @(posedge clk) begin
    if(start || reset || clear) begin
        C <= 0;
        V <= 0;
    end
    else if (update) begin
        C <= CarryIn;
        V <= OverflowIn;
    end
end

endmodule