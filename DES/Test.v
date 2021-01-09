
module test();
  

  reg [64:1] key;
  
  reg [64:1] message;
  wire [64:1] ciphertext;
  wire [64:1] decrypted_plaintext;

  Encrypt e(ciphertext, message, key);
  decrypt dec(.cipher_text(ciphertext),.plain_text(decrypted_plaintext), .key(key));
  initial
  begin
    key = 64'b00010011_00110100_01010111_01111001_10011011_10111100_11011111_11110001;
    message =  64'b0000_0001_0010_0011_0100_0101_0110_0111_1000_1001_1010_1011_1100_1101_1110_1111;
  end
  

endmodule