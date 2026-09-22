/*
 * Copyright (c) 2026 Robert San <robertsanseries@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 */

using Ciano.Utils;
using Ciano.Tests;

void add_extension_tests () {
    Test.add_func ("/file-util/extension/simple", () => {
        assert_cmpstr (FileUtil.get_file_extension_name ("video.mp4"), CompareOperator.EQ, "mp4");
        assert_cmpstr (FileUtil.get_file_extension_name ("/home/user/video.mkv"), CompareOperator.EQ, "mkv");
        assert_cmpstr (FileUtil.get_file_extension_name ("file:///tmp/a.webm"), CompareOperator.EQ, "webm");
    });

    Test.add_func ("/file-util/extension/keeps-case", () => {
        assert_cmpstr (FileUtil.get_file_extension_name ("VIDEO.MP4"), CompareOperator.EQ, "MP4");
        assert_cmpstr (FileUtil.get_file_extension_name ("clip.WebM"), CompareOperator.EQ, "WebM");
    });

    Test.add_func ("/file-util/extension/last-dot-wins", () => {
        assert_cmpstr (FileUtil.get_file_extension_name ("archive.tar.gz"), CompareOperator.EQ, "gz");
        assert_cmpstr (FileUtil.get_file_extension_name ("my.holiday.video.avi"), CompareOperator.EQ, "avi");
    });

    Test.add_func ("/file-util/extension/none", () => {
        assert_cmpstr (FileUtil.get_file_extension_name ("README"), CompareOperator.EQ, "");
        assert_cmpstr (FileUtil.get_file_extension_name (""), CompareOperator.EQ, StringUtil.EMPTY);
        assert_cmpstr (FileUtil.get_file_extension_name ("/usr/bin/ffmpeg"), CompareOperator.EQ, "");
    });

    Test.add_func ("/file-util/extension/trailing-dot", () => {
        assert_cmpstr (FileUtil.get_file_extension_name ("file."), CompareOperator.EQ, "");
    });

    Test.add_func ("/file-util/extension/hidden-file", () => {
        // The leading dot of a hidden file is part of its name, not an extension
        assert_cmpstr (FileUtil.get_file_extension_name (".bashrc"), CompareOperator.EQ, "");
        assert_cmpstr (FileUtil.get_file_extension_name ("/home/user/.intro"), CompareOperator.EQ, "");
        assert_cmpstr (FileUtil.get_file_extension_name ("/home/user/.intro.mp4"), CompareOperator.EQ, "mp4");
    });

    Test.add_func ("/file-util/extension/utf8-name", () => {
        assert_cmpstr (FileUtil.get_file_extension_name ("/música/canção.flac"), CompareOperator.EQ, "flac");
    });

    Test.add_func ("/file-util/extension/dot-in-directory-name", () => {
        assert_cmpstr (FileUtil.get_file_extension_name ("/home/user/my.videos/clip"), CompareOperator.EQ, "");
        assert_cmpstr (FileUtil.get_file_extension_name ("/v1.0/2024.01/final.cut/movie"), CompareOperator.EQ, "");
        assert_cmpstr (FileUtil.get_file_extension_name ("file:///tmp/my.dir/clip"), CompareOperator.EQ, "");
    });

    Test.add_func ("/file-util/extension/dot-in-directory-and-file-name", () => {
        assert_cmpstr (FileUtil.get_file_extension_name ("/home/user/my.videos/clip.avi"), CompareOperator.EQ, "avi");
        assert_cmpstr (FileUtil.get_file_extension_name ("/a.b/c.d/e.f.MKV"), CompareOperator.EQ, "MKV");
    });

    Test.add_func ("/file-util/extension/relative-paths", () => {
        assert_cmpstr (FileUtil.get_file_extension_name ("./clip"), CompareOperator.EQ, "");
        assert_cmpstr (FileUtil.get_file_extension_name ("../videos/clip"), CompareOperator.EQ, "");
        assert_cmpstr (FileUtil.get_file_extension_name ("../videos/clip.wav"), CompareOperator.EQ, "wav");
    });

    Test.add_func ("/file-util/extension/agrees-with-output-path", () => {
        // Both functions must agree on where the extension starts
        string[] inputs = {
            "/in/clip.avi", "/in/clip", "/my.dir/clip", "/my.dir/clip.mkv", "/in/.intro", "/in/.intro.avi",
            "./clip", "../v/clip.wav", "/in/a.b.c"
        };

        foreach (string input in inputs) {
            string ext = FileUtil.get_file_extension_name (input);
            string output = FileUtil.build_output_path (input, "OUT", true, "");
            string expected_base = (ext == "") ? input : input.substring (0, input.length - ext.length - 1);

            assert_cmpstr (output, CompareOperator.EQ, expected_base + ".out");
        }
    });
}

void add_output_path_tests () {
    Test.add_func ("/file-util/output-path/source-folder", () => {
        assert_cmpstr (
                FileUtil.build_output_path ("/home/user/Videos/clip.avi", "MP4", true, "/unused"),
                CompareOperator.EQ,
                "/home/user/Videos/clip.mp4"
        );
    });

    Test.add_func ("/file-util/output-path/output-folder", () => {
        assert_cmpstr (
                FileUtil.build_output_path ("/home/user/Videos/clip.avi", "MP4", false, "/home/user/Ciano"),
                CompareOperator.EQ,
                "/home/user/Ciano/clip.mp4"
        );
    });

    Test.add_func ("/file-util/output-path/output-folder-trailing-slash", () => {
        assert_cmpstr (
                FileUtil.build_output_path ("/in/clip.avi", "MP4", false, "/home/user/Ciano/"),
                CompareOperator.EQ,
                "/home/user/Ciano/clip.mp4"
        );
    });

    Test.add_func ("/file-util/output-path/extension-is-lowercase", () => {
        assert_cmpstr (FileUtil.build_output_path ("/in/a.WAV", "MP3", true, ""), CompareOperator.EQ, "/in/a.mp3");
        assert_cmpstr (FileUtil.build_output_path ("/in/a.wav", "Mp3", true, ""), CompareOperator.EQ, "/in/a.mp3");
        assert_cmpstr (FileUtil.build_output_path ("/in/a.wav", "flac", true, ""), CompareOperator.EQ, "/in/a.flac");
    });

    Test.add_func ("/file-util/output-path/only-last-extension-replaced", () => {
        assert_cmpstr (
                FileUtil.build_output_path ("/in/my.holiday.avi", "MP4", true, ""),
                CompareOperator.EQ,
                "/in/my.holiday.mp4"
        );
        assert_cmpstr (
                FileUtil.build_output_path ("/in/my.holiday.avi", "MP4", false, "/out"),
                CompareOperator.EQ,
                "/out/my.holiday.mp4"
        );
    });

    Test.add_func ("/file-util/output-path/same-format-overwrites-input-path", () => {
        // Converting to the same format in the source folder targets the input path itself
        assert_cmpstr (FileUtil.build_output_path ("/in/a.mp4", "MP4", true, ""), CompareOperator.EQ, "/in/a.mp4");
    });

    Test.add_func ("/file-util/output-path/input-without-extension", () => {
        assert_cmpstr (FileUtil.build_output_path ("/in/clip", "MP4", true, ""), CompareOperator.EQ, "/in/clip.mp4");
        assert_cmpstr (
                FileUtil.build_output_path ("/in/clip", "MP4", false, "/out"),
                CompareOperator.EQ,
                "/out/clip.mp4"
        );
    });

    Test.add_func ("/file-util/output-path/spaces-and-utf8", () => {
        assert_cmpstr (
                FileUtil.build_output_path ("/home/user/Músicas/minha canção.wav", "MP3", false, "/saída dir"),
                CompareOperator.EQ,
                "/saída dir/minha canção.mp3"
        );
    });

    Test.add_func ("/file-util/output-path/does-not-touch-file-system", () => {
        string dir = TestUtil.make_tmp_dir ();
        string output_folder = Path.build_filename (dir, "does", "not", "exist");

        FileUtil.build_output_path ("/in/a.avi", "MP4", false, output_folder);

        assert_false (FileUtils.test (output_folder, FileTest.EXISTS));
        TestUtil.remove_tree (dir);
    });

    Test.add_func ("/file-util/output-path/dot-in-directory-name", () => {
        assert_cmpstr (
                FileUtil.build_output_path ("/home/user/my.videos/clip", "MP4", true, ""),
                CompareOperator.EQ,
                "/home/user/my.videos/clip.mp4"
        );
        assert_cmpstr (
                FileUtil.build_output_path ("/home/user/my.videos/clip", "MP4", false, "/out"),
                CompareOperator.EQ,
                "/out/clip.mp4"
        );
    });

    Test.add_func ("/file-util/output-path/dot-in-directory-and-file-name", () => {
        assert_cmpstr (
                FileUtil.build_output_path ("/home/user/my.videos/clip.avi", "MP4", true, ""),
                CompareOperator.EQ,
                "/home/user/my.videos/clip.mp4"
        );
        assert_cmpstr (
                FileUtil.build_output_path ("/a.b/c.d/e.f.avi", "MP4", true, ""),
                CompareOperator.EQ,
                "/a.b/c.d/e.f.mp4"
        );
        assert_cmpstr (
                FileUtil.build_output_path ("/a.b/c.d/e.f.avi", "MP4", false, "/out.dir"),
                CompareOperator.EQ,
                "/out.dir/e.f.mp4"
        );
    });

    Test.add_func ("/file-util/output-path/several-dotted-directories", () => {
        assert_cmpstr (
                FileUtil.build_output_path ("/v1.0/2024.01/final.cut/movie", "MKV", true, ""),
                CompareOperator.EQ,
                "/v1.0/2024.01/final.cut/movie.mkv"
        );
    });

    Test.add_func ("/file-util/output-path/hidden-file", () => {
        // The leading dot of a hidden file is part of its name, not an extension
        assert_cmpstr (
                FileUtil.build_output_path ("/in/.intro", "MP4", true, ""),
                CompareOperator.EQ,
                "/in/.intro.mp4"
        );
        assert_cmpstr (
                FileUtil.build_output_path ("/in/.intro", "MP4", false, "/out"),
                CompareOperator.EQ,
                "/out/.intro.mp4"
        );
        assert_cmpstr (
                FileUtil.build_output_path ("/in/.intro.avi", "MP4", true, ""),
                CompareOperator.EQ,
                "/in/.intro.mp4"
        );
    });

    Test.add_func ("/file-util/output-path/relative-paths", () => {
        assert_cmpstr (FileUtil.build_output_path ("clip.avi", "MP4", true, ""), CompareOperator.EQ, "clip.mp4");
        assert_cmpstr (FileUtil.build_output_path ("clip", "MP4", true, ""), CompareOperator.EQ, "clip.mp4");
        assert_cmpstr (FileUtil.build_output_path ("./clip", "MP4", true, ""), CompareOperator.EQ, "./clip.mp4");
        assert_cmpstr (
                FileUtil.build_output_path ("../videos/clip", "MP4", true, ""),
                CompareOperator.EQ,
                "../videos/clip.mp4"
        );
        assert_cmpstr (
                FileUtil.build_output_path ("../videos/clip", "MP4", false, "/out"),
                CompareOperator.EQ,
                "/out/clip.mp4"
        );
    });

    Test.add_func ("/file-util/output-path/file-in-root", () => {
        assert_cmpstr (FileUtil.build_output_path ("/clip.avi", "MP4", true, ""), CompareOperator.EQ, "/clip.mp4");
        assert_cmpstr (FileUtil.build_output_path ("/clip", "MP4", true, ""), CompareOperator.EQ, "/clip.mp4");
    });

    Test.add_func ("/file-util/output-path/trailing-dot", () => {
        assert_cmpstr (FileUtil.build_output_path ("/in/clip.", "MP4", true, ""), CompareOperator.EQ, "/in/clip.mp4");
    });
}

void add_create_file_tests () {
    Test.add_func ("/file-util/create-file/writes-words", () => {
        string dir = TestUtil.make_tmp_dir ();

        FileUtil.create_file (dir, "out.txt", { "a", "b", "c" });

        string path = Path.build_filename (dir, "out.txt");
        assert_true (FileUtils.test (path, FileTest.IS_REGULAR));
        // Every word is prefixed with a space
        assert_cmpstr (TestUtil.read_file (path), CompareOperator.EQ, " a b c");

        TestUtil.remove_tree (dir);
    });

    Test.add_func ("/file-util/create-file/no-words", () => {
        string dir = TestUtil.make_tmp_dir ();

        FileUtil.create_file (dir, "empty.txt", {});

        string path = Path.build_filename (dir, "empty.txt");
        assert_true (FileUtils.test (path, FileTest.IS_REGULAR));
        assert_cmpstr (TestUtil.read_file (path), CompareOperator.EQ, "");

        TestUtil.remove_tree (dir);
    });

    Test.add_func ("/file-util/create-file/creates-missing-directories", () => {
        string dir = TestUtil.make_tmp_dir ();
        string nested = Path.build_filename (dir, "x", "y", "z");

        FileUtil.create_file (nested, "f.txt", { "w" });

        assert_true (FileUtils.test (nested, FileTest.IS_DIR));
        assert_cmpstr (TestUtil.read_file (Path.build_filename (nested, "f.txt")), CompareOperator.EQ, " w");

        TestUtil.remove_tree (dir);
    });

    Test.add_func ("/file-util/create-file/does-not-overwrite", () => {
        string dir = TestUtil.make_tmp_dir ();
        string path = Path.build_filename (dir, "keep.txt");

        try {
            FileUtils.set_contents (path, "original");
        } catch (Error e) {
            error (e.message);
        }

        FileUtil.create_file (dir, "keep.txt", { "new", "content" });

        assert_cmpstr (TestUtil.read_file (path), CompareOperator.EQ, "original");
        TestUtil.remove_tree (dir);
    });

    Test.add_func ("/file-util/create-file/words-with-spaces-and-utf8", () => {
        string dir = TestUtil.make_tmp_dir ();

        FileUtil.create_file (dir, "u.txt", { "olá mundo", "ção" });

        assert_cmpstr (
                TestUtil.read_file (Path.build_filename (dir, "u.txt")), CompareOperator.EQ, " olá mundo ção"
        );
        TestUtil.remove_tree (dir);
    });

    Test.add_func ("/file-util/create-file/invalid-directory-logs-critical", () => {
        if (Test.subprocess ()) {
            // A regular file cannot be used as a directory
            string dir = TestUtil.make_tmp_dir ();
            string blocker = Path.build_filename (dir, "blocker");

            try {
                FileUtils.set_contents (blocker, "");
            } catch (Error e) {
                error (e.message);
            }

            FileUtil.create_file (Path.build_filename (blocker, "sub"), "f.txt", { "a" });
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_failed ();
        Test.trap_assert_stderr ("*Failed to create file*");
    });
}

void add_delete_file_tests () {
    Test.add_func ("/file-util/delete-file/existing", () => {
        string dir = TestUtil.make_tmp_dir ();
        string path = Path.build_filename (dir, "del.txt");

        try {
            FileUtils.set_contents (path, "x");
        } catch (Error e) {
            error (e.message);
        }

        FileUtil.delete_file (dir, "del.txt");

        assert_false (FileUtils.test (path, FileTest.EXISTS));
        assert_true (FileUtils.test (dir, FileTest.IS_DIR));
        TestUtil.remove_tree (dir);
    });

    Test.add_func ("/file-util/delete-file/missing-is-noop", () => {
        string dir = TestUtil.make_tmp_dir ();

        // Must not log a critical (which would abort the test)
        FileUtil.delete_file (dir, "does-not-exist.txt");
        FileUtil.delete_file (Path.build_filename (dir, "no-dir"), "x.txt");

        TestUtil.remove_tree (dir);
    });

    Test.add_func ("/file-util/delete-file/only-deletes-target", () => {
        string dir = TestUtil.make_tmp_dir ();

        try {
            FileUtils.set_contents (Path.build_filename (dir, "a.txt"), "a");
            FileUtils.set_contents (Path.build_filename (dir, "b.txt"), "b");
        } catch (Error e) {
            error (e.message);
        }

        FileUtil.delete_file (dir, "a.txt");

        assert_false (FileUtils.test (Path.build_filename (dir, "a.txt"), FileTest.EXISTS));
        assert_true (FileUtils.test (Path.build_filename (dir, "b.txt"), FileTest.EXISTS));
        TestUtil.remove_tree (dir);
    });

    Test.add_func ("/file-util/delete-file/non-empty-directory-logs-critical", () => {
        if (Test.subprocess ()) {
            string dir = TestUtil.make_tmp_dir ();
            string sub = Path.build_filename (dir, "sub");
            DirUtils.create (sub, 0755);

            try {
                FileUtils.set_contents (Path.build_filename (sub, "f"), "x");
            } catch (Error e) {
                error (e.message);
            }

            FileUtil.delete_file (dir, "sub");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_failed ();
        Test.trap_assert_stderr ("*Failed to delete file*");
    });

    Test.add_func ("/file-util/create-then-delete-roundtrip", () => {
        string dir = TestUtil.make_tmp_dir ();

        FileUtil.create_file (dir, "r.txt", { "x" });
        assert_true (FileUtils.test (Path.build_filename (dir, "r.txt"), FileTest.EXISTS));

        FileUtil.delete_file (dir, "r.txt");
        assert_false (FileUtils.test (Path.build_filename (dir, "r.txt"), FileTest.EXISTS));

        TestUtil.remove_tree (dir);
    });
}

int main (string[] args) {
    Test.init (ref args);

    add_extension_tests ();
    add_output_path_tests ();
    add_create_file_tests ();
    add_delete_file_tests ();

    return Test.run ();
}
