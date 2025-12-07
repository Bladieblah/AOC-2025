const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data: util.Str = @embedFile("data/day06.txt");

const ROWS = 4;
const PROBLEMS = 1000;

fn part2() usize {
    var result: usize = 0;
    const lineLength = data.len / (ROWS + 1);
    var problem: [5]usize = .{0} ** 5;
    var chars: [ROWS + 1]u8 = .{' '} ** (ROWS + 1);

    var idNum: usize = 0;
    var column = lineLength - 1;
    while (true) {
        for (0..ROWS) |row| {
            chars[row] = data[row * (lineLength + 1) + column];
        }

        problem[idNum] = util.parse_usize(&chars);
        chars = .{' '} ** (ROWS + 1);
        idNum += 1;

        const operation = data[ROWS * (lineLength + 1) + column];

        if (operation != ' ') {
            switch (operation) {
                '*' => result += util.product(problem[0..idNum]),
                '+' => result += util.sum(problem[0..idNum]),
                else => unreachable,
            }

            if (column == 0) break;

            idNum = 0;
            column -= 1;
        }

        column -= 1;
    }

    return result;
}

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

    p2 = part2();

    util.print("({d}, {d})\n", .{ p1, p2 });
}

pub fn main() !void {
    const start = std.time.nanoTimestamp();
    try run();
    const end = std.time.nanoTimestamp();
    util.printTime(end - start);
}
