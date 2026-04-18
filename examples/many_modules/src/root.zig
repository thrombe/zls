const std = @import("std");
const Io = std.Io;

// NOTE: uncomment this, restart zls, and now the c.h import fails to resolve for `goto definition`
// const common = @import("common.zig");

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try std.testing.expect(add(3, 7) == 10);
}
