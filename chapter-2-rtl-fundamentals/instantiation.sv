/*
.####.##....##..######..########....###....##....##.########.####....###....########.####..#######..##....##
..##..###...##.##....##....##......##.##...###...##....##.....##....##.##......##.....##..##.....##.###...##
..##..####..##.##..........##.....##...##..####..##....##.....##...##...##.....##.....##..##.....##.####..##
..##..##.##.##..######.....##....##.....##.##.##.##....##.....##..##.....##....##.....##..##.....##.##.##.##
..##..##..####.......##....##....#########.##..####....##.....##..#########....##.....##..##.....##.##..####
..##..##...###.##....##....##....##.....##.##...###....##.....##..##.....##....##.....##..##.....##.##...###
.####.##....##..######.....##....##.....##.##....##....##....####.##.....##....##....####..#######..##....##
*/

/* Dot-name inferred named port connection shortcut */
controller cntlr 
(
    .instruction(instruction),
    .zero       (zero       ),
    .branching  (branching  ),
    .error      (error      ),
    .clk        (clk        ),
    .rstN       (rstN       ),
    .opcode     (opcode     ),
    .branch     (branch     ),
    .done       (done       ),
    .setN       (setN       ),
    .data_sel   (data_sel   ),
    .load_b     (load_b     ),
    .load_s     (load_s     ),
    .load_d     (load_d     )
);

/* 
    Dot-star inferred named port connection shortcut:
    - Infer port connections with existing nets 
    - Note: nets must match ports in both name and sizes
    to their connections to be inferred
*/
alu alu 
(
    .a          (a_data     ),
    .b          (b_data     ), 
    .*          // infer connections from here on
);
