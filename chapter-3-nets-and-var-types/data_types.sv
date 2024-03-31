/*
.########.....###....########....###.......########.##....##.########..########..######.
.##.....##...##.##......##......##.##.........##.....##..##..##.....##.##.......##....##
.##.....##..##...##.....##.....##...##........##......####...##.....##.##.......##......
.##.....##.##.....##....##....##.....##.......##.......##....########..######....######.
.##.....##.#########....##....#########.......##.......##....##........##.............##
.##.....##.##.....##....##....##.....##.......##.......##....##........##.......##....##
.########..##.....##....##....##.....##.......##.......##....##........########..######.
*/

/*
    Types and data types
    - Type: signal is net or variable
    - Data type: value in the system, which can be 2-state or 4-state
*/

/*
    Net types and variable types
    - Variable: temporal storage for programming (only simulation, is not
    needed by actual silicon)
    - Nets: connect design blocks together. Transfers data values from a source,
    referred to as a driver, to a destination or receiver
*/

/* 
    Two-state and four-state data types (bit and logic)
    - SV nets can only be 4-state data types.
    - Keyword "bit" defines a 2-state variable.
    - Keyword "logic" defines a 4-state variable.
*/ 

/* 
    Variable types
    - Required to be on the left-side of a procedural assignment.
    - The always_comb procedure will execute the assignment statement sum = a + b,
    every time a or b changes value. It'll be implemented as combinational logic 
    in silicon (no storage elements needed)
    - The always_ff procedure will execute the if-else decision statement on every 
    positive edge of clock. It'll be implemented in silicon as a flip-flop,
    which is a hardware storage device.
    - Temporary storage required by simulation does not necessarily mean that 
    actual silicon will require storage. 
*/
always_comb 
begin
    sum = a + b;
end

always_ff @(posedge elk)
    if (!rstN) 
        out <= '0;
    else       
        out <= sum;

/*
    Synthesizable variable data types
    - Keyword "var" specifies variable type (can be implicitly inferred). It is seldom
    used in actual SV code.
    - Several keywords for variable "data types" they infer either a "var logic" or 
    "var bit" variable type.
    - Several of this represent actual silicon behavior and are synthesizable.

    |---------------------------------------------------------------------------------|
    | Type       | Representation                                                     |
    |------------|--------------------------------------------------------------------|
    | reg        | An obsolete general purpose 4-state variable of a user-defined     |
    |            | vector size; equivalent to var logic                               |
    |---------------------------------------------------------------------------------|
    | logic      | Usually infers a general purpose var logic 4-state variable of a   |
    |            | user-defined vector size, except on module input/inout ports,      |
    |            | where wire logic is inferred                                       |
    |---------------------------------------------------------------------------------|
    | integer    | A 32-bit 4-state variable; equivalent to var logic [31:0]          |
    |---------------------------------------------------------------------------------|
    | bit        | A general purpose 2-state var variable with a user-defined vector  |
    |            | size; defaults to a 1-bit size if no size is specified             | 
    |---------------------------------------------------------------------------------|
    | int        | A 32-bit 2-state variable; equivalent to var bit [31:0]; synthesis |
    |            | compilers treat int as the 4-state integer type                    |
    |---------------------------------------------------------------------------------|
    | byte       | An 8-bit 2-state variable; equivalent to var bit [7:0]             |
    |---------------------------------------------------------------------------------|
    | shortint   | A 16-bit 2-state variable; equivalent to var bit [15:0]            |
    |---------------------------------------------------------------------------------|
    | longint    | A 64-bit 2-state variable; equivalent to var bit [63:0]            |
    |---------------------------------------------------------------------------------|

    - Use the 4-state logic data type to infer variables in RTL models. Do not use
    2-state types in RTL models. An exception to this guideline is to use the int
    type to declare for-loop iterator variables.
*/