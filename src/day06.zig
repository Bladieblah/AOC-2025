const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day06.txt");

const ROWS = 4;
const PROBLEMS = 1000;

fn run() !void {
    var p1: usize = 0;
    var p2: usize = 0;

    p1 = 0;
    p2 = 0;

    var problems: [PROBLEMS][ROWS]usize = .{.{0} ** ROWS} ** PROBLEMS;
    var lines = util.tokenizeSca(u8, data, '\n');

    for (0..ROWS) |line| {
        var nums = util.tokenizeSca(u8, lines.next().?, ' ');
        var problem: usize = 0;

        while (nums.next()) |num| {
            problems[problem][line] = util.parse_usize(num);
            problem += 1;
        }
    }

    var operations = util.tokenizeSca(u8, lines.next().?, ' ');
    var problem: usize = 0;
    while (operations.next()) |operation| {
        switch (operation[0]) {
            '*' => p1 += util.product(&problems[problem]),
            '+' => p1 += util.sum(&problems[problem]),
            else => unreachable,
        }
        problem += 1;
    }

    util.print("({d}, {d})\n", .{ p1, p2 });
}

pub fn main() !void {
    const start = std.time.nanoTimestamp();
    try run();
    const end = std.time.nanoTimestamp();
    util.printTime(end - start);
}
