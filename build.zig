const std = @import("std");

const typstSrc = "src";
const htmlOutput = "docs";

fn typst2html(b: *std.Build) !*std.Build.Step {
    var typstFiles: std.ArrayList(std.Build.LazyPath) = try .initCapacity(b.allocator, 0x100);

    const dir = try std.fs.cwd().openDir(typstSrc, .{ .iterate = true });
    var it = dir.iterate();

    const typstStep = b.step("typst", "build the typst sources");
    _ = try typstStep.addDirectoryWatchInput(b.path("src"));

    while (try it.next()) |file| {
        if (std.mem.endsWith(u8, file.name, ".typ")) {
            const f = b.path(typstSrc).path(b, file.name);
            try typstFiles.append(b.allocator, f);

            const name = f.basename(b, null);
            const nameWithoutExt = name[0..(name.len - 4)];
            std.debug.print("basename {s}\n", .{nameWithoutExt});

            const typstCmd = b.addSystemCommand(&.{ "typst", "compile" });
            typstCmd.addFileArg(f);
            typstCmd.addFileInput(f);
            try typstCmd.step.addWatchInput(f);

            // if (std.mem.startsWith(u8, name, "feed")) {
            _ = try typstCmd.step.addDirectoryWatchInput(b.path(typstSrc));
            // }

            // --root ./src --format html --features html
            typstCmd.addArg("--root");
            typstCmd.addArg(typstSrc);
            typstCmd.addArg("--format");
            typstCmd.addArg("html");
            typstCmd.addArg("--features");
            typstCmd.addArg("html");

            const p = try std.mem.join(b.allocator, "", &.{ htmlOutput, "/", nameWithoutExt, ".html" });

            // _ = typstCmd.addOutputFileArg(p);
            typstCmd.addArg(p);

            typstStep.dependOn(&typstCmd.step);
            // b.addWriteFile(file_path: []const u8, data: []const u8)
        }
    }

    const installHTML = b.addInstallDirectory(.{ .source_dir = b.path(htmlOutput), .install_dir = .prefix, .install_subdir = htmlOutput });

    typstStep.dependOn(&installHTML.step);
    return typstStep;
}

fn feed(b: *std.Build) !*std.Build.Step {
    const feedStep = b.step("feed", "build the rss/atom/etc feeds");
    const pythonCmd = b.addSystemCommand(&.{"python3"});

    pythonCmd.addFileArg(b.path("src").path(b, "build_feed.py"));
    pythonCmd.addFileArg(b.path(htmlOutput).path(b, "feed.html"));
    _ = pythonCmd.addOutputFileArg(b.path(htmlOutput).path(b, "feed.rss").getDisplayName());

    feedStep.dependOn(&pythonCmd.step);

    return feedStep;
}

pub fn build(b: *std.Build) !void {
    const typstStep = try typst2html(b);
    const feedStep = try feed(b);
    feedStep.dependOn(typstStep);
}
