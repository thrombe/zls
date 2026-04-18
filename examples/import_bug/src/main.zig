const std = @import("std");
const Io = std.Io;

// trying `goto definition` on this @cInclude in helix takes me to .zig-cache/c.h
// this is because we added a wrong include path of .zig-cache in build.zig
// root cause: https://github.com/zigtools/zls/blob/295cedd8ddd040c77e6666ddab6ef6da8c0beffa/src/features/goto.zig#L269
//  - this should be a `continue`
const c = @cImport({
    @cInclude("c.h");
});

pub fn main(_: std.process.Init) !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
}
