const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // NEW: master "check everything compiles" step
    const check = b.step("check", "Check that all AoC binaries compile");

    // ---- GENERATOR ----
    const gen_mod = b.addModule("generate_mod", .{
        .root_source_file = b.path("template/generate.zig"),
        .target = target,
        .optimize = optimize,
    });

    const gen_exe = b.addExecutable(.{
        .name = "generate",
        .root_module = gen_mod,
    });

    // include generator in "check"
    check.dependOn(&gen_exe.step);

    const gen_run = b.addRunArtifact(gen_exe);
    gen_run.setCwd(b.path("."));
    const gen_step = b.step("generate", "Generate stubs");
    gen_step.dependOn(&gen_run.step);

    // ---- LOOP OVER DAYS ----
    var day: u32 = 1;
    while (day <= 12) : (day += 1) {
        const day_name = b.fmt("day{:0>2}", .{day});
        const zig_path = b.fmt("src/{s}.zig", .{day_name});

        // module
        const mod = b.addModule(b.fmt("{s}_mod", .{day_name}), .{
            .root_source_file = b.path(zig_path),
            .optimize = optimize,
            .target = target,
        });

        // exe
        const exe = b.addExecutable(.{
            .name = day_name,
            .root_module = mod,
        });

        // include this day's exe in "check"
        check.dependOn(&exe.step);

        const install = b.addInstallArtifact(exe, .{});

        // test module
        const test_mod = b.addModule(b.fmt("{s}_test_mod", .{day_name}), .{
            .root_source_file = b.path(zig_path),
            .optimize = optimize,
            .target = target,
        });

        const tests = b.addTest(.{
            .root_module = test_mod,
        });

        const run_tests = b.addRunArtifact(tests);

        // run step
        const run = b.addRunArtifact(exe);
        if (b.args) |args| run.addArgs(args);

        const step_run = b.step(day_name, b.fmt("Run {s}", .{day_name}));
        step_run.dependOn(&run.step);

        const step_test = b.step(b.fmt("test_{s}", .{day_name}), b.fmt("Test {s}", .{zig_path}));
        step_test.dependOn(&run_tests.step);

        const step_install = b.step(b.fmt("install_{s}", .{day_name}), b.fmt("Install {s}", .{day_name}));
        step_install.dependOn(&install.step);
    }

    // ---- util tests ----
    const util_mod = b.addModule("util_mod", .{
        .root_source_file = b.path("src/util.zig"),
        .optimize = optimize,
        .target = target,
    });

    const util_tests = b.addTest(.{
        .root_module = util_mod,
    });

    const util_run = b.addRunArtifact(util_tests);
    const util_step = b.step("test_util", "Test util.zig");
    util_step.dependOn(&util_run.step);

    // (OPTIONAL) include util tests in "check" if you don't mind
    // tests running on each save:
    // check.dependOn(&util_tests.step);

    // ---- test_all ----
    const all_mod = b.addModule("all_tests_mod", .{
        .root_source_file = b.path("src/test_all.zig"),
        .optimize = optimize,
        .target = target,
    });

    const all_tests = b.addTest(.{
        .root_module = all_mod,
    });

    const all_run = b.addRunArtifact(all_tests);
    const all_step = b.step("test", "Run all tests");
    all_step.dependOn(&all_run.step);

    // (OPTIONAL) same note as util_tests:
    // check.dependOn(&all_tests.step);
}
