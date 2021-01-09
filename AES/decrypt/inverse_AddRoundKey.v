module inverse_AddRoundKey(input   [127:0] state,
    input   [127:0] inp_key,
    output  [127:0] out_state);

assign out_state =  state ^ inp_key ;

endmodule 
