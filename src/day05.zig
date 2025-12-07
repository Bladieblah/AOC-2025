const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day05.txt");

fn checkIngredient(ingredient: usize, ranges: *const List([2]usize)) usize {
    for (ranges.items) |range| {
        const start, const end = range;
        if (ingredient >= start and ingredient <= end) {
            return 1;
        }
    }

    return 0;
}

fn cmpRanges(_: void, a: [2]usize, b: [2]usize) bool {
    if (a[0] < b[0]) {
        return true;
    } else if (a[0] == b[0] and a[1] < b[1]) {
        return true;
    } else {
        return false;
    }
}

fn mergeRanges(ranges: *List([2]usize)) !usize {
    var newRanges = try List([2]usize).initCapacity(gpa, 1000);
    errdefer newRanges.deinit(gpa);

    std.mem.sort([2]usize, ranges.items, {}, cmpRanges);

    var curRange = ranges.items[0];

    for (ranges.items[1..]) |range| {
        if (range[0] <= curRange[1]) {
            curRange[1] = @max(curRange[1], range[1]);
        } else {
            try newRanges.append(gpa, curRange);
            curRange = range;
        }
    }

    try newRanges.append(gpa, curRange);

    var result: usize = 0;
    for (newRanges.items) |range| {
        result += range[1] - range[0] + 1;
    }

    return result;
}

fn run() !void {
    var p1: usize = 0;
    var p2: usize = 0;

    var it = util.tokenizeSeq(u8, data, "\n\n");
    var rangesRaw = util.tokenizeSca(u8, it.next().?, '\n');
    var ingredients = util.tokenizeSca(u8, it.next().?, '\n');

    var ranges = try util.List([2]usize).initCapacity(gpa, 1000);
    errdefer ranges.deinit(gpa);

    while (rangesRaw.next()) |range| {
        var it2 = util.tokenizeSca(u8, range, '-');
        const start = util.parse_usize(it2.next().?);
        const end = util.parse_usize(it2.next().?);
        try ranges.append(gpa, .{ start, end });
    }

    while (ingredients.next()) |ingredient| {
        p1 += checkIngredient(util.parse_usize(ingredient), &ranges);
    }

    p2 = try mergeRanges(&ranges);

    util.print("({d}, {d})\n", .{ p1, p2 });
}

pub fn main() !void {
    const start = std.time.nanoTimestamp();
    try run();
    const end = std.time.nanoTimestamp();
    util.printTime(end - start);
}
