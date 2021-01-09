module AES_inverse_tb();

wire [127:0] plain_text;
reg [127:0] cipher_text;
reg [127:0] cipher_key;
AES_decrypt_core decryp_core( .plain_text(plain_text), .cipher_key(cipher_key), .cipher_text(cipher_text));

initial begin 
	cipher_text = 128'h17fbf1a43fbd521deb784ffd035dadda;
	cipher_key  = 128'h68c470a53b8f4ffcf9bd74a21fc6b311;

end 
endmodule 