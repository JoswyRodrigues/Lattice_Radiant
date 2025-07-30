module spi_rs422_test (
    input  wire clk,         // 50 MHz main clock
    output reg  spi_clk,     // SPI Clock
    output reg  spi_mosi,    // SPI MOSI
    output wire spi_cs,      // Chip select (active low)
    output wire spi_de       // Driver enable (active high)
);

wire hf_clk;
clas __(.hf_out_en_i(1'b1 ),
        .hf_clk_out_o(hf_clk ));
		
    // Constants
    parameter CLK_DIV = 5;   // clk divider for ~5MHz (50MHz / 2*5 = 5MHz)

    // SPI lines
    assign spi_cs  = 1'b0;   // Always enabled for testing
    assign spi_de  = 1'b1;   // Always enabled for testing

    // Test data: 8'hA5 = 1010 0101
     reg [7:0] data_byte = 8'b10100101;
    reg [3:0] bit_index = 7;  
    reg [3:0] clk_div_cnt = 0;
    reg spi_clk_int = 0;

    always @(posedge hf_clk) begin
        clk_div_cnt <= clk_div_cnt + 1;
        if (clk_div_cnt == (CLK_DIV - 1)) begin
            clk_div_cnt <= 0;
            spi_clk_int <= ~spi_clk_int;  // Toggle SPI clock
		end 
		end
     always @(posedge spi_clk_int) begin
            // On rising edge: send next bit
            if (spi_clk_int == 1'b1) begin
				//spi_mosi <= {data_byte[7:0], 1'b0};

               spi_mosi <= data_byte[bit_index];
			   //spi_mosi <= data_byte[7 - bit_index]; //gives 2D data
                if (bit_index == 0)
                    bit_index <= 7;
               else
                    bit_index <= bit_index - 1;
            end
        end
 

    // Output clock
    always @(posedge hf_clk)
        spi_clk <= spi_clk_int;

endmodule
