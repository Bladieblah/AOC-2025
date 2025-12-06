const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

pub fn main() !void {
    var lines = util.tokenizeSca(u8, data, '\n');
    var acc: i32 = 50;
    var p1: u32 = 0;
    var p2: u32 = 0;

    while (lines.next()) |line| {
        const dir = line[0];
        const num = util.parse_int(line[1..]);
        switch (dir) {
            'L' => {
                if (acc == 0) {
                    p2 -= 1;
                }
                acc = acc - num;
            },
            'R' => acc = acc + num,
            else => unreachable,
        }

        p2 += @abs(@divFloor(acc, 100));

        acc = @mod(acc, 100);

        if (acc == 0) {
            p1 += 1;
            if (dir == 'L') {
                p2 += 1;
            }
        }
    }

    util.print("({d}, {d})\n", .{ p1, p2 });
}
