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

/* 
    The context dependent logic data type. 
    
    In almost all contexts, the "logic" data type infers a 4-state variable the same as reg. 
    A variable is inferred when the logic keyword is used by itself, or in conjunction with
    the declaration of a module "output" port. 
    A net type will be inferred, when logic is used in conjunction with the declaration of 
    a module "input" or "inout" port.

    The obsolete reg data type
    
    Obsolete data type left over from the original Verilog language. The logic type should 
    be used instead of reg.
    The original Verilog language used the reg data type as a general purpose variable.
    The use of keyword reg is a misnomer that might seem to be short for “register”, a 
    hardware device built with flip-flops. But there is no correlation between using a reg 
    variable and the hardware that is inferred. 
    It is the context in which a variable is used that determines if the hardware represented 
    is combinational logic or sequential flip-flop logic. Using logic instead of reg can help 
    prevent this misconception that a hardware register will be inferred.

    An X value can indicate a design problem
    
    When an X value occurs during simulation, it is often an indication that there is a design 
    problem. Some types of design bugs that will result in an X value include:
        • Registers that were not reset or otherwise initialized.
        • Circuitry that did not correctly retain state during low power mode.
        • Unconnected module input ports (unconnected input ports float at high-impedance, which 
        often results in an X value as the high-impedance value propagates to other logic).
        • Multi-driver conflicts (bus contention).
        • Operations with an unknown result.
        • Out-of-range bit-selects and array indices.
        • Setup or hold timing violations.

    Avoid 2-state data types in RTL models. 
    
    The bit, byte, shortint, int and longint data types only store 2-state values. These types 
    cannot represent a high-impedance (Z value), and cannot use an X value to represent 
    uninitialized or unknown simulation conditions. 
    An X value that indicates potential design bugs, such as those in the list above, 
    will not occur when 2-state data types are used. Since 2-state data types can only 
    have a 0 or 1 value, a design with errors can appear to be functioning correctly during 
    simulation. This is not good! An appropriate place to use 2-state variables is for 
    randomized stimulus in verification testbenches.

    Non synthesizable variable types

    SystemVerilog has several variable types that are intended primarily for verification, and 
    are not generally supported by RTL synthesis compilers. Table 3-2 lists these additional 
    variable types. These data types are not used in any examples in this book that are intended 
    to be synthesized.

    | Type              | Representation                                                                                        
    |-----------------  |-------------------------------------------------------------------------------------------------------
    | real              | A double precision floating-point variable                                                            
    | shortreal         | A single precision floating-point variable                                                            
    | time              | A 64-bit unsigned 4-state variable with timeunit and timeprecision attributes                         
    | realtime          | A double precision floating-point variable, identical to real                                         
    | string            | A dynamically sized array of byte types that can store a string of 8-bit ASCII characters             
    | event             | A pointer variable that stores a handle to a simulation synchronization object                        
    | class handle      | A pointer variable that stores a handle to a class object (the declaration type is the name of a class
                        | not the keyword "class")
    | chandle           | A pointer variable that stores pointers passed into simulation from the SystemVerilog Direct Programming
                        | Interface
    | virtual interface | A pointer variable that stores a handle to an interface port (the interface keyword is optional)      

*/

/*
    Variable declaration rules

    Variables are declared by specifying both a type and a data type. The type is the
    keyword var, which can be explicitly specified or implicitly inferred. The var keyword 
    is seldom used in actual SystemVerilog code. Instead, the var type is inferred 
    from other keywords and context.
*/

    logic v1; // infers var logic (1-bit 4-state)
    bit v2; // infers var bit (1-bit 2-state)
    integer v3; // infers var integer (32-bit 4-state)
    int v4; // infers var int (32-bit 2-state)

/*
    The only place where the var keyword is required is when declaring an input or
    inout port as a 4-state variable. These port directions will default to a net type if not
    explicitly declared as a variable. This is an appropriate default. It is very seldom that
    an input port needs to be a variable.
*/

/* 
    Scalar variables
    
    A scalar variable is a 1-bit variable. The "reg", "logic" and "bit" data types default to 1-bit scalars.
*/
    logic v5; // a 1-bit scalar variable
    logic v6, v7, v8; // a list of three scalar variables

/* 
    Vector variables (packed arrays)
    
    A vector is an array of consecutive bits. The IEEE SystemVerilog standard refers to vectors as packed arrays. 
    The reg, logic and bit data types can represent a vector of any size.
    The range is declared as [most-significant_bit_number : least-significant_bit_number]. 
    The MSB and LSB can be any number, and the LSB can be smaller or larger than the MSB. A vector range where the LSB is
    the smaller number is referred to as little endian. A vector range where the LSB is the larger number is referred to 
    as big endian.

    The byte, shortint, int, longint and integer data types have a predefined vector size. The predefined ranges are little
    endian, with the LSB numbered as bit 0.
*/
    logic [31:0] v9; // 32-bit vector, little endian
    logic [1:32] v10; // 32-bit vector, big endian

/*
    Signed and unsigned variables
    
    The value stored in a vector variable can be treated as either signed or unsigned in operations. An unsigned variable 
    only stores positive values. A signed variable can store positive and negative values. SystemVerilog uses two’s-complement 
    to represent negative values. The most significant bit of a signed variable is the sign bit. When the sign bit is set, 
    the remaining bits of the vector represent a negative value in two’s-complement form.

    By default, the reg, logic, bit and time data types are unsigned variables, and the byte, shortint, int, integer, and 
    longint data types are signed variables. This default can be changed by explicitly declaring a variable as signed or
    unsigned.
*/
    logic signed [23:0] vll; // 24-bit signed 4-state variable
    int unsigned vl2; // 32-bit unsigned 2-state variable

/*
    Constant bit selects and part selects
    
    A vector can be referenced in its entirety, or in part. A bit select references a single bit of a vector. A bit select 
    is performed using the name of the vector, followed by a bit number in square brackets. A part select references 
    multiple contiguous bits of a vector. A part select is performed using the name of the vector, followed by a range of 
    bit numbers in square brackets.

    Part selects must meet two rules: the range of bits must be contiguous, and the endian of the part select must be the
    same endian as the vector declaration. The result of a bit select or part select is always unsigned, even if the full 
    variable is signed.
*/
    logic [31:0] data;  // 32-bit vector variable
    logic [31:0] dbus;  // 32-bit vector variable
    logic [ 7:0] byte2; // 8-bit vector variable
    logic msb;          // 1-bit scalar variable

    assign dbus = data; // reference entire data variable
    assign msb = data[31]; // bit select of data, bit 31
    assign byte2 = data[23:16]; // part select of data bits 23
                                // down to 16

/*
    Variable bit and part selects
    
    The bit select for msb in the preceding code snippet used a hard-coded bit number. This is referred to as a fixed bit 
    select. The index number of a bit select can also be a variable.
*/
    logic [31:0] data; // 32-bit vector variable
    logic bit_out; // 1-bit scalar variable
    
    always @(posedge shift_clk)
        if (shift_enable) begin
            for (int i=0; i<=31; i++) begin
                @(posedge shift_clk) bit_out <= data[i];
            end
        end

/* 
    The starting point of a part select can also be variable. The part select can either increment or decrement from 
    the variable starting point. The total number of bits selected is a fixed range. The form of a variable 
    part select is:

    [ starting_point_variable +: part_select_size ]
    [ starting_point_variable -: part_select_size ]
    
    The +: token indicates to increment from the starting point bit number. The -: token indicates to decrement from 
    the starting point bit number. The following example uses a variable part select to iterate through the bytes of a
    32-bit vector.
*/
    logic [31:0] data; // 32-bit vector variable
    logic [ 7:0] byte_out; // 8-bit vector variable

    always @ (posedge shift_clk)
        if (shift_enable) begin
            for (int i=0; i<=31; i=i+8) begin
                @(posedge shift_clk) byte_out <= data[i+:8];
            end
        end
   
/*
    Vector with subfields
*/
    logic [31:0] a; // 32-bit simple vector
    logic [3:0][7:0] b; // 32-bit vector. divided into 4 8-bit subfields

    // loop through vector variable
    always @(posedge shift_clk)
        if (shift_enable) 
        begin
            for (int i=0; i<=3; i++) 
            begin
                @(posedge shift_clk) byte_out <= b [i];
            end
        end

/* 
    Variable assignment rules

    Note: Variables can only assigned by a single source (either procedural or continuos)
*/
    logic [15:0] q; // 16-bit 4-state unassigned variable

    // this multiple assigments are treated as a signle driver
    always_ff @( posedge clk ) 
    begin: procedural_loop 
        if (!rstN) q <= '0; // procedural assignment
        else       q <= d;  // another procedural assignment
    end

/* 
    Uninitialized variables

    for 4-state variable -> 'x
    for 2-state variable -> '0

    Uninitialized 2-state variables can hide design problems. An uninitialized 2-
    state variable has the value of 0, which can appear to be a legitimate reset
    value. This can potentially hide problems with reset logic in a design.
*/
    logic [15:0] q; // uninitialized 4-state variable
    always_ff @(posedge clk)
        if (!rstN) q <= '0; // active-low synchronous reset
        else q <= d; // clocked assignment to q

/*
    in-line variable initialization

    Only executed one time, at the begining of simulation
    Some FPGA can be programmed that some registers powers-up in a known state
*/
    int i = 5;