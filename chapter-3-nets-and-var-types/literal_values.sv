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
    Four-state data values 01ZX (RTL modeling)
    - 0, digital low
    - 1, digital high
    - Z, digital high impedance, usally assumed as don't care value
    - X, uninitialized or uncertain value, for synthesis compilers treat X
    as don't care value. Note: X is not an actual silicon value, just used for
    outline simulation uncertainty on how the actual silicon would behave.
*/

/*
    Literal integer values
    - decimal integers
    - binary, octal or hex integers
    - sized literal integers
    - signed or unsigned integers

    Synthesis and sim tools need to know certain characteristics of them
    - bit width (vector size)
    - signedness
    - base (radix)
    - 2-state or 4-state value
*/

/* 
    Decimal literal integer
    - 32-bit wide value
    - signed
    - decimal
    - 2-state
*/
result = d + 9;

/* 
    Binary, octal, decimal and hex literal integers
    (this case numbers don't specify sizes just only radixes)
    - if no size -> assumed as 32-bit wide value
    - unsigned
    - base specified
    - 4-state
*/
result = 'd9 + 'h2f + 'b1010;

/* 
    Signed literal integers
    (add "s" after tick and before radix specifier)
*/
result = 'sd9 + 'sh2f + 'sb1010;

/* 
    Sized literal integers
*/
result = 16'd9 + 8'h2f + 4'b1010;

/*
    Mismatched size and vlaue rules
    - If size < value, left-most bits of value are truncated
    - If size > value, value is left-extended according to the following
    rules.
        * If left-most bit is 0 or 1, additional bits are filled with 0
        (NO sign extension)
        * If left-most bit is Z, additional bits are filled with Z
        * If left-most bit is X, additional bits are filled with X
*/
val = 4'hFACE; // truncates to 4'hE
val = 16'sh8 ; // extends to 16'sh0008
val = 32'bZ  ; // extends to 32'bZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ

/*
    Additional literal value rules
    - ? can be used as Z to represent hi-imp
    - _ character can be anywhere in value, it is ignored by tools
*/
val = 16'b0000_0110_1100_0001;  // show 4-bit nibbles for readability
val = 20'h2_FACE;               // 20-bit value with 4-bit opcode and 16-bit data

/* 
    Vector fill literal values
    - 0 fills all bits on the left-hand side with 0
    - 1 fills all bits on the left-hand side with 1
    - z or 'Z fills all bits on the left-hand side with z
    - x or 'X fills all bits on the left-hand side with x
*/
always_ff @(posedge clk)
    if (!setN) // active low set
    q <= '1; // set all bits of q to 1, regardless of size
    else
    q <= d;

