const std = @import("std");
const Io = std.Io;

// when hitting `goto definition` on this via the examples/simlinked dir, it resolves just fine
// but resolution via the examples/simlink dir fails
const vk = @import("vulkan");

pub fn main(_: std.process.Init) !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
}
