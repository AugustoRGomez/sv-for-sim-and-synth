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
    Literal values
    - 0, digital low
    - 1, digital high
    - Z, digital high impedance, usally assumed as don't care value
    - X, uninitialized or uncertain value, for synthesis compilers treat X
    as don't care value. Note: X is not an actual silicon value, just used for
    outline simulation uncertainty on how the actual silicon would behave.
*/