const std = @import("std");

fn vulkan_step(b: *std.Build, v: struct {
    vulkan_headers: *std.Build.Dependency,
}) struct { mod: *std.Build.Module } {
    // generate vulkan bindings from vk.xml and create a zig module from the generated code
    const registry = v.vulkan_headers.path("registry/vk.xml");
    const vk_gen = b.dependency("vulkan_zig", .{}).artifact("vulkan-zig-generator");
    const vk_generate_cmd = b.addRunArtifact(vk_gen);
    vk_generate_cmd.addFileArg(registry);
    const vulkan_zig = b.addModule("vulkan-zig", .{
        .root_source_file = vk_generate_cmd.addOutputFileArg("vk.zig"),
    });

    return .{ .mod = vulkan_zig };
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const vulkan = vulkan_step(b, .{ .vulkan_headers = b.dependency("vulkan_headers", .{}) });

    const exe = b.addExecutable(.{
        .name = "many_modules",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "vulkan", .module = vulkan.mod },
            },
        }),
    });
    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    run_step.dependOn(&run_cmd.step);
}
