// EcoMender Bot : Task 2A - UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_3125 - 3125 KHz clock
        parity_type - even(0)/odd(1) parity type
        tx_start - signal to start the communication.
        data    - 8-bit data line to transmit

Output: tx      - UART Transmission Line
        tx_done - message transmitted flag
*/

// module declaration
module uart_tx(
    input clk_3125,
    input parity_type,tx_start,
    input [7:0] data,
    output reg tx, tx_done
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

// State encoding
localparam IDLE       = 3'b000;
localparam START_BIT  = 3'b001;
localparam DATA_BITS  = 3'b010;
localparam LAST_BIT   = 3'b011;
localparam PARITY_BIT = 3'b100;
localparam STOP_BIT   = 3'b101;
localparam DONE       = 3'b110;

// Baud rate parameters
localparam BAUD_RATE   = 230400;
localparam CLOCK_FREQ  = 3125000;
localparam BIT_DURATION = 15;

// State machine variables
reg [2:0] state;
reg [3:0] bit_counter = 0;
reg [2:0] data_counter;
reg parity_bit;

// Initialize output signals
initial begin
    tx = 1;
	 tx_done=0;
end

// State machine for UART transmission
always @(posedge clk_3125) begin

	if(tx_start) state = START_BIT;
	
    case (state)
        IDLE: begin
            tx = 1;  
				tx_done=0;
        end

        START_BIT: begin
            tx = 0;
            parity_bit = ^data;
				if(parity_type) parity_bit = ~parity_bit;
            data_counter = 7;
            bit_counter = bit_counter + 1;
            if (bit_counter == BIT_DURATION-1) begin
                bit_counter = 0;
                state = DATA_BITS; 
            end
        end

        DATA_BITS: begin
            tx = data[data_counter];
            bit_counter = bit_counter + 1;
            if (bit_counter == BIT_DURATION-1) begin
                bit_counter = 0;
                data_counter = data_counter - 1;
                if (data_counter == 0) begin
                    state = LAST_BIT;
                end
            end
						
        end
		  
		  LAST_BIT: begin
            tx = data[0];
            bit_counter = bit_counter + 1;
            if (bit_counter == BIT_DURATION-1) begin
                bit_counter = 0;
                state = PARITY_BIT;
            end
		  end

        PARITY_BIT: begin
            tx = parity_bit;
            bit_counter = bit_counter + 1;
            if (bit_counter == BIT_DURATION-1) begin
                bit_counter = 0;
                state = STOP_BIT;
            end
        end

        STOP_BIT: begin
            tx = 1;
            bit_counter = bit_counter + 1;
            if (bit_counter == BIT_DURATION-2) begin
                bit_counter = 0;
                state = DONE;
            end
        end

        DONE: begin
            tx_done = 1;
            state = IDLE;
        end

        //default: state = IDLE;
    endcase
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule


