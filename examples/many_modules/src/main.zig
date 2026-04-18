const std = @import("std");
const Io = std.Io;

const common = @import("common.zig");

pub fn main(_: std.process.Init) !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
}
