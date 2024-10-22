// EcoMender Bot : Task 2A - UART Receiver
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to receive UART Rx data packet from receiver line and then update the rx_msg and rx_complete data lines.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Receiver

Baudrate: 230400 

Input:  clk_3125 - 3125 KHz clock
        rx      - UART Receiver

Output: rx_msg - received input message of 8-bit width
        rx_parity - received parity bit
        rx_complete - successful uart packet processed signal
*/

// module declaration
module uart_rx(
    input clk_3125,
    input rx,
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
    );

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

initial begin
    rx_msg = 0;
	 rx_parity = 0;
    rx_complete = 0;
end

// Add your code here....

// State encoding
localparam IDLE       = 3'b000;
localparam START_BIT  = 3'b001;
localparam DATA_BITS  = 3'b010;
localparam PARITY_BIT = 3'b100;
localparam STOP_BIT   = 3'b101;
localparam DONE       = 3'b110;

localparam BIT_DURATION = 15;

// State machine variables
reg [2:0] state = IDLE;
reg [3:0] bit_counter = 0;
reg [3:0] data_counter =0;
reg [7:0] data;
//reg parity_bit;
//reg idle=1;


// State machine for UART transmission
always @(posedge clk_3125) begin
	
	if(!rx && rx_complete) state=START_BIT;
	
    case (state)
        IDLE: begin
				rx_complete=0;
				data=0;
				if(!rx) state = START_BIT;
        end

        START_BIT: begin
				rx_complete=0;
				data=0;
				data_counter=0;
				if(rx) state=IDLE;
            bit_counter = bit_counter + 1;
            if (bit_counter == BIT_DURATION-1) begin
                bit_counter = 0;
                state = DATA_BITS; 
            end
        end

        DATA_BITS: begin
            data[data_counter]=rx;
            bit_counter = bit_counter + 1;
            if (bit_counter == BIT_DURATION-1) begin
                bit_counter = 0;
                data_counter = data_counter + 1;
                if (data_counter == 8) begin
                    state = PARITY_BIT;
                end
            end
						
        end

        PARITY_BIT: begin
				//parity_bit = ^data;
            bit_counter = bit_counter + 1;
            if (bit_counter == BIT_DURATION-1) begin
                bit_counter = 0;
                state = STOP_BIT;
            end
        end

        STOP_BIT: begin
            bit_counter = bit_counter + 1;
            if (bit_counter == BIT_DURATION-1) begin
					 rx_msg[7] = data[0];
					 rx_msg[6] = data[1];
					 rx_msg[5] = data[2];
					 rx_msg[4] = data[3];
					 rx_msg[3] = data[4];
					 rx_msg[2] = data[5];
					 rx_msg[1] = data[6];
					 rx_msg[0] = data[7];
					 rx_complete = 1;
					 rx_parity=^data;
					 bit_counter = 0;
					 state = IDLE;
            end
        end

//        DONE: begin
//				    rx_msg[7] = data[0];
//					 rx_msg[6] = data[1];
//					 rx_msg[5] = data[2];
//					 rx_msg[4] = data[3];
//					 rx_msg[3] = data[4];
//					 rx_msg[2] = data[5];
//					 rx_msg[1] = data[6];
//					 rx_msg[0] = data[7];
//            rx_complete = 1;
//				rx_parity=^data;
//            state = IDLE;
//        end

        //default: state = IDLE;
    endcase
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////


endmodule

