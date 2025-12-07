const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data: util.Str = @embedFile("data/day11.txt");

fn run() !void {
    var p1: usize = 0;
    var p2: usize = 0;

    p1 = 0;
    p2 = 0;

    util.print("({d}, {d})\n", .{ p1, p2 });
}

pub fn main() !void {
    const start = std.time.nanoTimestamp();
    try run();
    const end = std.time.nanoTimestamp();
    util.printTime(end - start);
}
