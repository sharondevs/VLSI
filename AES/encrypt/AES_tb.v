module AES_tb();

reg [127:0] plain_text;
wire [127:0] cipher_text;
reg [127:0] cipher_key;
AES_core core( .plain_text(plain_text), .cipher_key(cipher_key), .cipher_text(cipher_text));

initial begin 
	plain_text = 128'h40c04bfb58b64df803d23d594879f300;
	cipher_key = 128'h68c470a53b8f4ffcf9bd74a21fc6b311;

end 
endmodule 