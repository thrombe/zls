const std = @import("std");
const Io = std.Io;

// when hitting `goto definition` on this via the examples/simlinked dir, it resolves just fine
// but resolution via the examples/simlink dir fails
const vk = @import("vulkan");

pub fn main(_: std.process.Init) !void {
    std.debug.print("printing vk.TRUE: {d}", .{@as(u32, vk.TRUE)});
}
