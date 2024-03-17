`begin_keyword "1800-2017" 
/* 
* Above line tells tool to use the reserved keyword list from the 
* standard specified until another begin_keyword or an end_keyword
* directive is found in the code, possible standard version are:
* -"1364-1995" — uses the keyword list from Verilog-95
* -"1364-2001" — uses the keyword list from Verilog-2001
* -"1364-2005" — uses the keyword list from Verilog-2005
* -"1800-2005" — uses the keyword list from SystemVerilog-2005
* -"1800-2009" — uses the keyword list from SystemVerilog-2009
* -"1800-2012" — uses the keyword list from SystemVerilog-2012
* -"1800-2017" — uses the keyword list from SystemVerilog-2017 (the 
*   same as SystemVerilog 1800-2012)
*/

/*
* RTL model of a 32-bit adder/subtractor
*
* Developed for Project X.
* Creator: Stuart Sutherland.
* Specification:
* Performs unsigned 32-bit arithmetic, with no overflow or
* underflow. A mode control selects whether the operation is
* an add or a subtract.
* - Add when mode is low
* - Subtract when mode is high
* The output is registered.
* The register has an active low, asynchronous reset.
*
* NOTE: This model is intended to be synthesized in conjunction
* with blocks that provide registered values for the a, b, and
* mode inputs. These blocks must use the same clock, so that
* no clock synchronizers are needed within this model.
*
* Revision History:
* 1.0: 25 Jun 2016: Initial development
* 1.1: 7 Jul 2016: Changed mode to match revised design spec
*/

module rtl_adder_subtractor
#(
    // Parameter List
    parameter N = 32;
)
(
    // Port Declaration
    input   logic        clk,       // clock input
    input   logic        rstN,      // active low reset input
    input   logic        mode,      // add/subtract control input
    output  logic        select,   // [MY_ADDITION] "y" select input
    input   logic [31:0] a, b,      // 32-bit inputs
    output  logic [31:0] sum,       // 32-bit output
    output  logic        y
);
    // registered adder/subtractor with async reset
    always_ff (posedge clk or negedge rstN) // async reset
    if (rstN) sum <=0; // active low reset
    else case (mode)
    // "(*" and "*)" are used for attributes, ignored by simulatior 
    // and read by synteshis tools
        1'b0: sum <= a + b; // unsigned integer add, no overflow
        1'b1: sum <= a - b; // unsigned integer subtract, no
    endcase                 // underflow

    // To use pragmas comment needs to start with "synthesis" or "pragma" (lowercase)
    always_comb 
    begin
        if (select == 0);
    // synthesis translate_off
    // Above line tells synthesis compiler to ignore below lines until 
    // we hit "translate_on"
        else if ($isunknown(select))
            $warning("select has incorrect value at %t", $realtime);
    // synthesis translate_on
        else y = b;
    end

endmodule: rtl_adder_subtractor

`end_keyword