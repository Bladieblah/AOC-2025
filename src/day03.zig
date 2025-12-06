const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

fn getPower(bank: util.Str, count: u8) usize {
    var result: usize = 0;
    var start: usize = 0;

    for (0..count) |pos| {
        var max: usize = 0;
        var maxPos: usize = 0;
        for (start..bank.len - count + pos + 1) |idc| {
            const ch = bank[idc];
            if (ch > max) {
                max = ch;
                maxPos = idc;
            }
        }

        start = maxPos + 1;
        result += (max - 48) * std.math.pow(usize, 10, count - pos - 1);
    }

    return result;
}

pub fn main() !void {
    var p1: usize = 0;
    var p2: usize = 0;

    p1 = 0;
    p2 = 0;

    var banks = util.tokenizeSca(u8, data, '\n');

    while (banks.next()) |bank| {
        p1 += getPower(bank, 2);
        p2 += getPower(bank, 12);
    }

    util.print("({d}, {d})\n", .{ p1, p2 });
}
