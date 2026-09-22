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

using Ciano.Enums;
using Ciano.Objects;
using Ciano.Utils;
using Ciano.Tests;

const string FFMPEG = "/usr/bin/ffmpeg";
const string PALETTE_FILTER = "format=rgb24,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse";
const string VIDEO_LIMIT = "fps=10,scale='min(480,iw)':-1:flags=lanczos";
const string VIDEO_PALETTE_FILTER = VIDEO_LIMIT + "," + PALETTE_FILTER;

// Copies the lists, so they outlive the temporary GenericArray
string[] video_formats () {
    return (string[]) FormatUtil.get_video_formats ().data;
}

string[] audio_formats () {
    return (string[]) FormatUtil.get_audio_formats ().data;
}

string[] build (string input, string format, TypeItemEnum type, string output = "/out/result") {
    return FFmpegUtil.build_arguments (FFMPEG, input, output, format, type);
}

/**
 * Builds the expected argument list: the fixed prefix, the given options and the fixed suffix.
 */
string[] expected_args (string input, string output, string[] options) {
    var args = new GenericArray<string> ();

    foreach (string a in new string[] { FFMPEG, "-y", "-progress", "pipe:2", "-nostats", "-i", input }) {
        args.add (a);
    }

    foreach (string a in options) {
        args.add (a);
    }

    args.add ("-strict");
    args.add ("-2");
    args.add (output);

    return (string[]) args.data;
}

void add_build_arguments_tests () {
    Test.add_func ("/ffmpeg-util/args/video-to-video", () => {
        TestUtil.assert_strv_equal (
                build ("/in/a.avi", "MP4", TypeItemEnum.VIDEO, "/out/a.mp4"),
                expected_args ("/in/a.avi", "/out/a.mp4", {})
        );
    });

    Test.add_func ("/ffmpeg-util/args/uses-given-executable", () => {
        string[] args = FFmpegUtil.build_arguments (
                "/app/bin/ffmpeg", "/in/a.avi", "/o.mp4", "MP4", TypeItemEnum.VIDEO
        );
        assert_cmpstr (args[0], CompareOperator.EQ, "/app/bin/ffmpeg");
    });

    Test.add_func ("/ffmpeg-util/args/prefix-and-suffix-for-every-format", () => {
        foreach (string f in video_formats ()) {
            string[] args = build ("/in/x.mkv", f, TypeItemEnum.VIDEO, "/o/x");
            assert_cmpstr (args[0], CompareOperator.EQ, FFMPEG);
            assert_cmpstr (args[1], CompareOperator.EQ, "-y");
            assert_cmpstr (args[5], CompareOperator.EQ, "-i");
            assert_cmpstr (args[6], CompareOperator.EQ, "/in/x.mkv");
            assert_cmpstr (args[args.length - 3], CompareOperator.EQ, "-strict");
            assert_cmpstr (args[args.length - 2], CompareOperator.EQ, "-2");
            assert_cmpstr (args[args.length - 1], CompareOperator.EQ, "/o/x");
        }
    });

    Test.add_func ("/ffmpeg-util/args/overwrite-and-progress-flags", () => {
        string[] args = build ("/in/a.avi", "MKV", TypeItemEnum.VIDEO);
        assert_true (TestUtil.contains (args, "-y"));
        int progress = TestUtil.index_of (args, "-progress");
        assert_cmpint (progress + 1, CompareOperator.EQ, TestUtil.index_of (args, "pipe:2"));
        assert_true (TestUtil.contains (args, "-nostats"));
    });

    Test.add_func ("/ffmpeg-util/args/paths-with-spaces-are-single-arguments", () => {
        string[] args = build ("/my videos/a b.avi", "MP4", TypeItemEnum.VIDEO, "/out dir/a b.mp4");
        assert_true (TestUtil.contains (args, "/my videos/a b.avi"));
        assert_true (TestUtil.contains (args, "/out dir/a b.mp4"));
    });

    Test.add_func ("/ffmpeg-util/args/3gp-forces-codecs", () => {
        TestUtil.assert_strv_equal (
                build ("/in/a.mp4", "3GP", TypeItemEnum.VIDEO, "/o.3gp"),
                expected_args ("/in/a.mp4", "/o.3gp", { "-vcodec", "libx264", "-acodec", "aac" })
        );
    });

    Test.add_func ("/ffmpeg-util/args/flv-forces-codecs", () => {
        TestUtil.assert_strv_equal (
                build ("/in/a.mp4", "FLV", TypeItemEnum.VIDEO, "/o.flv"),
                expected_args ("/in/a.mp4", "/o.flv", { "-vcodec", "libx264", "-acodec", "aac" })
        );
    });

    Test.add_func ("/ffmpeg-util/args/target-format-is-case-insensitive", () => {
        string[] upper = build ("/in/a.mp4", "FLV", TypeItemEnum.VIDEO);
        string[] lower = build ("/in/a.mp4", "flv", TypeItemEnum.VIDEO);
        string[] mixed = build ("/in/a.mp4", "Flv", TypeItemEnum.VIDEO);

        TestUtil.assert_strv_equal (lower, upper);
        TestUtil.assert_strv_equal (mixed, upper);
    });

    Test.add_func ("/ffmpeg-util/args/other-video-formats-have-no-extra-options", () => {
        string[] plain = { "MP4", "MPG", "AVI", "WMV", "SWF", "MOV", "MKV", "VOB", "OGV", "WEBM" };

        foreach (string f in plain) {
            TestUtil.assert_strv_equal (
                    build ("/in/a.avi", f, TypeItemEnum.VIDEO, "/o"),
                    expected_args ("/in/a.avi", "/o", {})
            );
        }
    });

    Test.add_func ("/ffmpeg-util/args/audio-to-audio", () => {
        TestUtil.assert_strv_equal (
                build ("/in/a.wav", "MP3", TypeItemEnum.MUSIC, "/o.mp3"),
                expected_args ("/in/a.wav", "/o.mp3", {})
        );
    });

    Test.add_func ("/ffmpeg-util/args/audio-to-audio-never-drops-video", () => {
        // Keeps embedded cover art of audio files
        foreach (string input in audio_formats ()) {
            string[] args = build ("/in/a." + input.ascii_down (), "MP3", TypeItemEnum.MUSIC);
            assert_false (TestUtil.contains (args, "-vn"));
        }

        assert_false (TestUtil.contains (build ("/in/a.shn", "MP3", TypeItemEnum.MUSIC), "-vn"));
    });

    Test.add_func ("/ffmpeg-util/args/video-to-audio-drops-video", () => {
        TestUtil.assert_strv_equal (
                build ("/in/a.mp4", "MP3", TypeItemEnum.MUSIC, "/o.mp3"),
                expected_args ("/in/a.mp4", "/o.mp3", { "-vn" })
        );
    });

    Test.add_func ("/ffmpeg-util/args/every-video-input-to-every-audio-target-drops-video", () => {
        foreach (string input in video_formats ()) {
            foreach (string target in audio_formats ()) {
                string[] args = build ("/in/a." + input.ascii_down (), target, TypeItemEnum.MUSIC);
                assert_cmpint (TestUtil.index_of (args, "-vn"), CompareOperator.GT, TestUtil.index_of (args, "-i"));
            }
        }
    });

    Test.add_func ("/ffmpeg-util/args/drop-video-ignores-input-extension-case", () => {
        assert_true (TestUtil.contains (build ("/in/A.MP4", "MP3", TypeItemEnum.MUSIC), "-vn"));
        assert_true (TestUtil.contains (build ("/in/a.Mkv", "MP3", TypeItemEnum.MUSIC), "-vn"));
        assert_false (TestUtil.contains (build ("/in/A.WAV", "MP3", TypeItemEnum.MUSIC), "-vn"));
        assert_false (TestUtil.contains (build ("/in/a.Flac", "MP3", TypeItemEnum.MUSIC), "-vn"));
    });

    Test.add_func ("/ffmpeg-util/args/unknown-input-to-audio-drops-video", () => {
        // Anything that is not a known audio file is treated as video
        assert_true (TestUtil.contains (build ("/in/a.m4v", "MP3", TypeItemEnum.MUSIC), "-vn"));
        assert_true (TestUtil.contains (build ("/in/no-extension", "MP3", TypeItemEnum.MUSIC), "-vn"));
    });

    Test.add_func ("/ffmpeg-util/args/video-target-never-drops-video", () => {
        foreach (string target in video_formats ()) {
            assert_false (TestUtil.contains (build ("/in/a.mp4", target, TypeItemEnum.VIDEO), "-vn"));
        }
    });

    Test.add_func ("/ffmpeg-util/args/mmf-sets-sample-rate", () => {
        TestUtil.assert_strv_equal (
                build ("/in/a.wav", "MMF", TypeItemEnum.MUSIC, "/o.mmf"),
                expected_args ("/in/a.wav", "/o.mmf", { "-ar", "44100" })
        );
    });

    Test.add_func ("/ffmpeg-util/args/video-to-mmf", () => {
        TestUtil.assert_strv_equal (
                build ("/in/a.mp4", "MMF", TypeItemEnum.MUSIC, "/o.mmf"),
                expected_args ("/in/a.mp4", "/o.mmf", { "-ar", "44100", "-vn" })
        );
    });

    Test.add_func ("/ffmpeg-util/args/image-to-image", () => {
        foreach (string f in new string[] { "JPG", "BMP", "PNG", "TIF", "ICO", "TGA" }) {
            TestUtil.assert_strv_equal (
                    build ("/in/a.png", f, TypeItemEnum.IMAGE, "/o"),
                    expected_args ("/in/a.png", "/o", {})
            );
        }
    });

    Test.add_func ("/ffmpeg-util/args/image-target-ignores-video-and-audio-options", () => {
        // 3GP/FLV/MMF options only apply to video and audio conversions
        foreach (string f in new string[] { "3GP", "FLV", "MMF" }) {
            TestUtil.assert_strv_equal (
                    build ("/in/a.png", f, TypeItemEnum.IMAGE, "/o"),
                    expected_args ("/in/a.png", "/o", {})
            );
        }
    });

    Test.add_func ("/ffmpeg-util/args/gif-uses-palette", () => {
        TestUtil.assert_strv_equal (
                build ("/in/a.png", "GIF", TypeItemEnum.IMAGE, "/o.gif"),
                expected_args ("/in/a.png", "/o.gif", { "-ss", "00:00:00.000", "-vf", PALETTE_FILTER })
        );
    });

    Test.add_func ("/ffmpeg-util/args/video-to-gif-uses-palette", () => {
        TestUtil.assert_strv_equal (
                build ("/in/a.mp4", "GIF", TypeItemEnum.IMAGE, "/o.gif"),
                expected_args ("/in/a.mp4", "/o.gif", { "-ss", "00:00:00.000", "-vf", VIDEO_PALETTE_FILTER })
        );
    });

    Test.add_func ("/ffmpeg-util/args/every-video-to-gif-is-limited", () => {
        foreach (string f in video_formats ()) {
            string input = "/in/a." + f.ascii_down ();
            string[] args = build (input, "GIF", TypeItemEnum.IMAGE, "/o.gif");
            int vf = TestUtil.index_of (args, "-vf");

            assert_cmpint (vf, CompareOperator.GT, 0);
            assert_true (args[vf + 1].has_prefix (VIDEO_LIMIT));
        }
    });

    Test.add_func ("/ffmpeg-util/args/video-to-gif-ignores-input-extension-case", () => {
        TestUtil.assert_strv_equal (
                build ("/in/A.MP4", "GIF", TypeItemEnum.IMAGE, "/o.gif"),
                expected_args ("/in/A.MP4", "/o.gif", { "-ss", "00:00:00.000", "-vf", VIDEO_PALETTE_FILTER })
        );
    });

    Test.add_func ("/ffmpeg-util/args/image-to-gif-is-not-limited", () => {
        // Images keep their size, only videos are resized and resampled
        foreach (string f in new string[] { "jpg", "bmp", "png", "tif", "ico", "gif", "tga", "PNG" }) {
            string input = "/in/a." + f;
            TestUtil.assert_strv_equal (
                    build (input, "GIF", TypeItemEnum.IMAGE, "/o.gif"),
                    expected_args (input, "/o.gif", { "-ss", "00:00:00.000", "-vf", PALETTE_FILTER })
            );
        }
    });

    Test.add_func ("/ffmpeg-util/args/video-limit-comes-before-palette", () => {
        // The palette must be generated from the resized frames
        assert_true (VIDEO_PALETTE_FILTER.index_of ("scale=") < VIDEO_PALETTE_FILTER.index_of ("palettegen"));
        assert_true (VIDEO_PALETTE_FILTER.index_of ("fps=") < VIDEO_PALETTE_FILTER.index_of ("palettegen"));
    });

    Test.add_func ("/ffmpeg-util/args/other-targets-are-not-limited", () => {
        // Only GIF gets the frame rate and size limit
        foreach (string f in video_formats ()) {
            foreach (string arg in build ("/in/a.mp4", f, TypeItemEnum.VIDEO)) {
                assert_false (arg.contains ("fps=10"));
            }
        }

        foreach (string f in new string[] { "PNG", "JPG" }) {
            foreach (string arg in build ("/in/a.mp4", f, TypeItemEnum.IMAGE)) {
                assert_false (arg.contains ("fps=10"));
            }
        }
    });

    Test.add_func ("/ffmpeg-util/args/webm-to-gif-uses-rgb8", () => {
        TestUtil.assert_strv_equal (
                build ("/in/a.webm", "GIF", TypeItemEnum.IMAGE, "/o.gif"),
                expected_args ("/in/a.webm", "/o.gif", { "-vf", VIDEO_LIMIT, "-pix_fmt", "rgb8" })
        );
        TestUtil.assert_strv_equal (
                build ("/in/a.webm", "gif", TypeItemEnum.IMAGE, "/o.gif"),
                expected_args ("/in/a.webm", "/o.gif", { "-vf", VIDEO_LIMIT, "-pix_fmt", "rgb8" })
        );
    });

    Test.add_func ("/ffmpeg-util/args/webm-to-gif-ignores-input-extension-case", () => {
        string[] inputs = { "/in/A.WEBM", "/in/a.WebM", "/in/a.wEbM" };

        foreach (string input in inputs) {
            TestUtil.assert_strv_equal (
                    build (input, "GIF", TypeItemEnum.IMAGE, "/o.gif"),
                    expected_args (input, "/o.gif", { "-vf", VIDEO_LIMIT, "-pix_fmt", "rgb8" })
            );
        }
    });

    Test.add_func ("/ffmpeg-util/args/webm-only-in-directory-name-is-not-webm", () => {
        // Only the file extension counts, not a directory that looks like one
        TestUtil.assert_strv_equal (
                build ("/in/clips.webm/a.mp4", "GIF", TypeItemEnum.IMAGE, "/o.gif"),
                expected_args ("/in/clips.webm/a.mp4", "/o.gif", { "-ss", "00:00:00.000", "-vf", VIDEO_PALETTE_FILTER })
        );
        TestUtil.assert_strv_equal (
                build ("/in/a.webm.mp4", "GIF", TypeItemEnum.IMAGE, "/o.gif"),
                expected_args ("/in/a.webm.mp4", "/o.gif", { "-ss", "00:00:00.000", "-vf", VIDEO_PALETTE_FILTER })
        );
    });

    Test.add_func ("/ffmpeg-util/args/does-not-mutate-inputs", () => {
        string input = "/in/a.MP4";
        string format = "MP3";

        build (input, format, TypeItemEnum.MUSIC);

        assert_cmpstr (input, CompareOperator.EQ, "/in/a.MP4");
        assert_cmpstr (format, CompareOperator.EQ, "MP3");
    });
}

/**
 * Creates the progress state of a conversion whose duration is already known.
 */
ConversionProgress progress_with_duration (int total_seconds) {
    var progress = new ConversionProgress ();
    progress.total_seconds = total_seconds;
    return progress;
}

/**
 * Feeds a single line to the parser and returns the results.
 */
double feed (string line, ConversionProgress progress, out string status) {
    double fraction;
    FFmpegUtil.parse_progress (line, progress, out fraction, out status);
    return fraction;
}

void add_parse_progress_tests () {
    Test.add_func ("/ffmpeg-util/progress/unrelated-line", () => {
        var progress = progress_with_duration (50);
        string status;

        assert_cmpfloat (feed ("frame=100", progress, out status), CompareOperator.EQ, -1.0);
        assert_cmpstr (status, CompareOperator.EQ, "");
        assert_cmpint (progress.total_seconds, CompareOperator.EQ, 50);

        assert_cmpfloat (feed ("", progress, out status), CompareOperator.EQ, -1.0);
        assert_cmpfloat (feed ("   ", progress, out status), CompareOperator.EQ, -1.0);
        assert_cmpfloat (feed ("progress=continue", progress, out status), CompareOperator.EQ, -1.0);
    });

    Test.add_func ("/ffmpeg-util/progress/duration-sets-total", () => {
        var progress = progress_with_duration (0);
        string status;

        double fraction = feed ("  Duration: 00:01:32.28, start: 0.000000, bitrate: 1411 kb/s", progress, out status);

        assert_cmpint (progress.total_seconds, CompareOperator.EQ, 92);
        assert_cmpfloat (fraction, CompareOperator.EQ, -1.0);
        assert_cmpstr (status, CompareOperator.EQ, "");
    });

    Test.add_func ("/ffmpeg-util/progress/duration-with-hours", () => {
        var progress = progress_with_duration (0);
        string status;

        feed ("Duration: 02:00:01.00, start: 0.000000", progress, out status);
        assert_cmpint (progress.total_seconds, CompareOperator.EQ, 7201);
    });

    Test.add_func ("/ffmpeg-util/progress/duration-not-available", () => {
        var progress = progress_with_duration (10);
        string status;

        feed ("  Duration: N/A, bitrate: N/A", progress, out status);
        assert_cmpint (progress.total_seconds, CompareOperator.EQ, 0);
    });

    Test.add_func ("/ffmpeg-util/progress/duration-without-comma-is-ignored", () => {
        var progress = progress_with_duration (10);
        string status;

        feed ("Duration: 00:01:00.00", progress, out status);
        assert_cmpint (progress.total_seconds, CompareOperator.EQ, 10);
    });

    Test.add_func ("/ffmpeg-util/progress/out-time-without-duration", () => {
        var progress = progress_with_duration (0);
        string status;

        assert_cmpfloat (feed ("out_time=00:00:10.000000", progress, out status), CompareOperator.EQ, -1.0);
        assert_cmpstr (status, CompareOperator.EQ, "");
    });

    Test.add_func ("/ffmpeg-util/progress/out-time-not-available", () => {
        var progress = progress_with_duration (100);
        string status;

        assert_cmpfloat (feed ("out_time=N/A", progress, out status), CompareOperator.EQ, -1.0);
        assert_cmpstr (status, CompareOperator.EQ, "");
    });

    Test.add_func ("/ffmpeg-util/progress/half-way", () => {
        var progress = progress_with_duration (100);
        string status;

        feed ("total_size=1048576", progress, out status);
        feed ("bitrate=128.0kbits/s", progress, out status);
        double fraction = feed ("out_time=00:00:50.000000", progress, out status);

        assert_cmpfloat_with_epsilon (fraction, 0.5, 1e-9);
        assert_cmpstr (status, CompareOperator.EQ, "50% - 1.0 MB - 128.0kbits/s");
    });

    Test.add_func ("/ffmpeg-util/progress/start", () => {
        var progress = progress_with_duration (100);
        string status;

        feed ("total_size=0", progress, out status);
        feed ("bitrate=N/A", progress, out status);
        double fraction = feed ("out_time=00:00:00.000000", progress, out status);

        assert_cmpfloat (fraction, CompareOperator.EQ, 0.0);
        assert_cmpstr (status, CompareOperator.EQ, "0% - 0 B - N/A");
    });

    Test.add_func ("/ffmpeg-util/progress/percentage-is-truncated", () => {
        var progress = progress_with_duration (3);
        string status;

        feed ("total_size=10", progress, out status);
        feed ("bitrate=1kbits/s", progress, out status);

        double fraction = feed ("out_time=00:00:01.000000", progress, out status);
        assert_cmpfloat_with_epsilon (fraction, 1.0 / 3.0, 1e-9);
        assert_true (status.has_prefix ("33% - "));

        fraction = feed ("out_time=00:00:02.999999", progress, out status);
        assert_cmpfloat_with_epsilon (fraction, 2.0 / 3.0, 1e-9);
        assert_true (status.has_prefix ("66% - "));
    });

    Test.add_func ("/ffmpeg-util/progress/fraction-is-clamped", () => {
        var progress = progress_with_duration (10);
        string status;

        feed ("total_size=10", progress, out status);
        feed ("bitrate=1kbits/s", progress, out status);

        assert_cmpfloat (feed ("out_time=00:00:30.000000", progress, out status), CompareOperator.EQ, 1.0);
        assert_true (status.has_prefix ("100% - "));

        // Negative out_time at the very beginning
        assert_cmpfloat (feed ("out_time=-00:00:00.023220", progress, out status), CompareOperator.EQ, 0.0);
    });

    Test.add_func ("/ffmpeg-util/progress/leading-whitespace-is-ignored", () => {
        var progress = progress_with_duration (10);
        string status;

        double fraction = feed ("   out_time=00:00:05.000000  ", progress, out status);
        assert_cmpfloat_with_epsilon (fraction, 0.5, 1e-9);
    });

    Test.add_func ("/ffmpeg-util/progress/key-must-be-at-start-of-line", () => {
        var progress = progress_with_duration (10);
        string status;

        assert_cmpfloat (feed ("x out_time=00:00:05.000000", progress, out status), CompareOperator.EQ, -1.0);
    });

    Test.add_func ("/ffmpeg-util/progress/other-time-keys-are-ignored", () => {
        var progress = progress_with_duration (10);
        string status;

        assert_cmpfloat (feed ("out_time_ms=5000000", progress, out status), CompareOperator.EQ, -1.0);
        assert_cmpfloat (feed ("out_time_us=5000000", progress, out status), CompareOperator.EQ, -1.0);
    });

    Test.add_func ("/ffmpeg-util/progress/end", () => {
        var progress = progress_with_duration (10);
        string status;

        feed ("total_size=2048", progress, out status);
        feed ("bitrate=64.0kbits/s", progress, out status);
        double fraction = feed ("progress=end", progress, out status);

        assert_cmpfloat (fraction, CompareOperator.EQ, 1.0);
        assert_cmpstr (status, CompareOperator.EQ, "100% - 2.0 KB - 64.0kbits/s");
    });

    Test.add_func ("/ffmpeg-util/progress/end-without-duration", () => {
        // Image conversions have no duration, but must still end at 100%
        var progress = progress_with_duration (0);
        string status;

        assert_cmpfloat (feed ("progress=end", progress, out status), CompareOperator.EQ, 1.0);
        assert_true (status.has_prefix ("100% - "));
    });

    Test.add_func ("/ffmpeg-util/progress/size-and-bitrate-lines-do-not-report-progress", () => {
        var progress = progress_with_duration (10);
        string status;

        assert_cmpfloat (feed ("total_size=1024", progress, out status), CompareOperator.EQ, -1.0);
        assert_cmpstr (status, CompareOperator.EQ, "");
        assert_cmpfloat (feed ("bitrate=1.0kbits/s", progress, out status), CompareOperator.EQ, -1.0);
        assert_cmpstr (status, CompareOperator.EQ, "");
    });

    Test.add_func ("/ffmpeg-util/progress/size-formatting", () => {
        var progress = progress_with_duration (10);
        string status;
        string[,] cases = {
            { "0", "0 B" },
            { "1", "1 B" },
            { "1023", "1023 B" },
            { "1024", "1.0 KB" },
            { "1536", "1.5 KB" },
            { "1048575", "1024.0 KB" },
            { "1048576", "1.0 MB" },
            { "5767168", "5.5 MB" },
            { "1073741823", "1024.0 MB" },
            { "1073741824", "1.0 GB" },
            { "1610612736", "1.5 GB" },
            // Around the int limit, which used to overflow
            { "2147483647", "2.0 GB" },
            { "2147483648", "2.0 GB" },
            { "4294967296", "4.0 GB" },
            { "4294967297", "4.0 GB" },
            { "53687091200", "50.0 GB" },
            { "5497558138880", "5120.0 GB" }
        };

        feed ("bitrate=1kbits/s", progress, out status);

        for (int i = 0; i < cases.length[0]; i++) {
            feed ("total_size=" + cases[i, 0], progress, out status);
            feed ("out_time=00:00:05.000000", progress, out status);
            assert_cmpstr (status, CompareOperator.EQ, "50%% - %s - 1kbits/s".printf (cases[i, 1]));
        }
    });

    Test.add_func ("/ffmpeg-util/progress/invalid-size", () => {
        var progress = progress_with_duration (10);
        string status;

        feed ("bitrate=1kbits/s", progress, out status);
        feed ("total_size=N/A", progress, out status);
        feed ("out_time=00:00:05.000000", progress, out status);

        assert_cmpstr (status, CompareOperator.EQ, "50% - 0 B - 1kbits/s");
    });

    Test.add_func ("/ffmpeg-util/progress/size-above-2-gb", () => {
        var progress = progress_with_duration (10);
        string status;

        feed ("bitrate=1kbits/s", progress, out status);
        feed ("total_size=3221225472", progress, out status);
        feed ("out_time=00:00:05.000000", progress, out status);

        assert_cmpstr (status, CompareOperator.EQ, "50% - 3.0 GB - 1kbits/s");
        assert_cmpstr (progress.size, CompareOperator.EQ, "3.0 GB");
    });

    Test.add_func ("/ffmpeg-util/progress/size-grows-past-2-gb", () => {
        // Sizes reported while a long conversion crosses the old int limit
        var progress = progress_with_duration (100);
        string status;
        string[,] steps = {
            { "2000000000", "1.9 GB" },
            { "2147483647", "2.0 GB" },
            { "2147483648", "2.0 GB" },
            { "2500000000", "2.3 GB" },
            { "4294967296", "4.0 GB" }
        };

        feed ("bitrate=1kbits/s", progress, out status);

        for (int i = 0; i < steps.length[0]; i++) {
            feed ("total_size=" + steps[i, 0], progress, out status);
            feed ("out_time=00:00:50.000000", progress, out status);

            assert_false (progress.size.has_prefix ("-"));
            assert_cmpstr (status, CompareOperator.EQ, "50%% - %s - 1kbits/s".printf (steps[i, 1]));
            assert_cmpstr (progress.size, CompareOperator.EQ, steps[i, 1]);
        }
    });

    Test.add_func ("/ffmpeg-util/progress/full-ffmpeg-session", () => {
        var progress = progress_with_duration (0);
        string status = "";
        double last = -1.0;

        // Same key order FFmpeg uses in each "-progress" block
        string[] lines = {
            "Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'in.mp4':",
            "  Duration: 00:00:04.00, start: 0.000000, bitrate: 1200 kb/s",
            "Stream mapping:",
            "frame=25",
            "bitrate=16.4kbits/s",
            "total_size=4096",
            "out_time_us=1000000",
            "out_time_ms=1000000",
            "out_time=00:00:01.000000",
            "speed=2.0x",
            "progress=continue",
            "frame=75",
            "bitrate=32.8kbits/s",
            "total_size=8192",
            "out_time_us=3000000",
            "out_time_ms=3000000",
            "out_time=00:00:03.000000",
            "speed=2.0x",
            "progress=continue",
            "frame=100",
            "bitrate=40.0kbits/s",
            "total_size=10240",
            "out_time=00:00:04.000000",
            "progress=end"
        };

        var statuses = new GenericArray<string> ();

        foreach (string line in lines) {
            double f = feed (line, progress, out status);
            if (f >= 0) {
                assert_cmpfloat (f, CompareOperator.GE, last);
                last = f;
                statuses.add (status);
            }
        }

        assert_cmpint (progress.total_seconds, CompareOperator.EQ, 4);
        TestUtil.assert_strv_equal ((string[]) statuses.data, {
            "25% - 4.0 KB - 16.4kbits/s",
            "75% - 8.0 KB - 32.8kbits/s",
            "100% - 10.0 KB - 40.0kbits/s",
            "100% - 10.0 KB - 40.0kbits/s"
        });
    });

    Test.add_func ("/ffmpeg-util/progress/new-state-is-empty", () => {
        var progress = new ConversionProgress ();

        assert_cmpint (progress.total_seconds, CompareOperator.EQ, 0);
        assert_cmpstr (progress.size, CompareOperator.EQ, "");
        assert_cmpstr (progress.bitrate, CompareOperator.EQ, "");
    });

    Test.add_func ("/ffmpeg-util/progress/parser-updates-state", () => {
        var progress = new ConversionProgress ();
        string status;

        feed ("  Duration: 00:00:10.00, start: 0.000000", progress, out status);
        feed ("bitrate=64.0kbits/s", progress, out status);
        feed ("total_size=2048", progress, out status);

        assert_cmpint (progress.total_seconds, CompareOperator.EQ, 10);
        assert_cmpstr (progress.size, CompareOperator.EQ, "2.0 KB");
        assert_cmpstr (progress.bitrate, CompareOperator.EQ, "64.0kbits/s");
    });

    Test.add_func ("/ffmpeg-util/progress/first-status-has-no-stale-values", () => {
        // A conversion must never show values left by a previous one
        var previous = progress_with_duration (10);
        string status;

        feed ("bitrate=999.0kbits/s", previous, out status);
        feed ("total_size=5767168", previous, out status);
        feed ("out_time=00:00:05.000000", previous, out status);

        var current = progress_with_duration (10);
        feed ("out_time=00:00:05.000000", current, out status);

        assert_cmpstr (status, CompareOperator.EQ, "50% -  - ");
    });

    Test.add_func ("/ffmpeg-util/progress/state-is-not-shared-between-conversions", () => {
        var a = progress_with_duration (10);
        var b = progress_with_duration (20);
        string status_a;
        string status_b;

        feed ("total_size=1024", a, out status_a);
        feed ("bitrate=1kbits/s", a, out status_a);

        // Another conversion reports its own values in between
        feed ("total_size=2097152", b, out status_b);
        feed ("bitrate=2000kbits/s", b, out status_b);

        feed ("out_time=00:00:05.000000", a, out status_a);
        feed ("out_time=00:00:05.000000", b, out status_b);

        assert_cmpstr (status_a, CompareOperator.EQ, "50% - 1.0 KB - 1kbits/s");
        assert_cmpstr (status_b, CompareOperator.EQ, "25% - 2.0 MB - 2000kbits/s");

        assert_cmpint (a.total_seconds, CompareOperator.EQ, 10);
        assert_cmpint (b.total_seconds, CompareOperator.EQ, 20);
    });

    Test.add_func ("/ffmpeg-util/progress/interleaved-conversions", () => {
        // Lines of two running conversions arrive interleaved, as in the main loop
        var a = new ConversionProgress ();
        var b = new ConversionProgress ();
        string status;

        feed ("  Duration: 00:00:04.00, start: 0.000000", a, out status);
        feed ("  Duration: 00:01:40.00, start: 0.000000", b, out status);
        feed ("bitrate=10.0kbits/s", a, out status);
        feed ("bitrate=20.0kbits/s", b, out status);
        feed ("total_size=1024", b, out status);
        feed ("total_size=4096", a, out status);

        string status_a;
        string status_b;
        double fraction_a = feed ("out_time=00:00:02.000000", a, out status_a);
        double fraction_b = feed ("out_time=00:00:10.000000", b, out status_b);

        assert_cmpfloat_with_epsilon (fraction_a, 0.5, 1e-9);
        assert_cmpfloat_with_epsilon (fraction_b, 0.1, 1e-9);
        assert_cmpstr (status_a, CompareOperator.EQ, "50% - 4.0 KB - 10.0kbits/s");
        assert_cmpstr (status_b, CompareOperator.EQ, "10% - 1.0 KB - 20.0kbits/s");

        assert_cmpfloat (feed ("progress=end", a, out status_a), CompareOperator.EQ, 1.0);
        assert_cmpstr (status_a, CompareOperator.EQ, "100% - 4.0 KB - 10.0kbits/s");
        assert_cmpstr (b.size, CompareOperator.EQ, "1.0 KB");
    });
}

void add_executable_tests () {
    Test.add_func ("/ffmpeg-util/executable/resolves", () => {
        if (Environment.find_program_in_path ("ffmpeg") == null && !FileUtils.test (FFMPEG, FileTest.EXISTS)) {
            Test.skip ("ffmpeg is not installed");
            return;
        }

        try {
            string path = FFmpegUtil.get_executable ();

            assert_true (Path.is_absolute (path));
            assert_cmpstr (Path.get_basename (path), CompareOperator.EQ, "ffmpeg");
            assert_true (FileUtils.test (path, FileTest.IS_EXECUTABLE));
            assert_true (FileUtils.test (path, FileTest.IS_REGULAR));
        } catch (Error e) {
            Test.fail_printf ("unexpected error: %s", e.message);
        }
    });

    Test.add_func ("/ffmpeg-util/executable/is-cached", () => {
        if (Environment.find_program_in_path ("ffmpeg") == null && !FileUtils.test (FFMPEG, FileTest.EXISTS)) {
            Test.skip ("ffmpeg is not installed");
            return;
        }

        try {
            string first = FFmpegUtil.get_executable ();

            // Even with an empty PATH the cached value is returned
            string? old_path = Environment.get_variable ("PATH");
            Environment.set_variable ("PATH", "", true);
            string second = FFmpegUtil.get_executable ();
            Environment.set_variable ("PATH", old_path ?? "", true);

            assert_cmpstr (first, CompareOperator.EQ, second);
        } catch (Error e) {
            Test.fail_printf ("unexpected error: %s", e.message);
        }
    });

    Test.add_func ("/ffmpeg-util/executable/fallback-when-not-in-path", () => {
        if (!FileUtils.test (FFMPEG, FileTest.IS_EXECUTABLE)) {
            Test.skip ("%s does not exist".printf (FFMPEG));
            return;
        }

        if (Test.subprocess ()) {
            // Fresh process: nothing is cached yet. The result goes to a file
            // because the parent can only match the child output, not read it.
            Environment.set_variable ("PATH", "/nonexistent", true);
            string result;

            try {
                result = FFmpegUtil.get_executable ();
            } catch (Error e) {
                result = "error: " + e.message;
            }

            try {
                FileUtils.set_contents (Environment.get_variable ("CIANO_TEST_RESULT"), result);
            } catch (Error e) {
                error (e.message);
            }

            return;
        }

        string dir = TestUtil.make_tmp_dir ();
        string result_file = Path.build_filename (dir, "result");
        Environment.set_variable ("CIANO_TEST_RESULT", result_file, true);

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();

        string result = TestUtil.read_file (result_file);
        TestUtil.remove_tree (dir);

        // /usr/bin/ffmpeg is the first candidate
        assert_cmpstr (result, CompareOperator.EQ, FFMPEG);
    });
}

int main (string[] args) {
    Test.init (ref args);

    add_build_arguments_tests ();
    add_parse_progress_tests ();
    add_executable_tests ();

    return Test.run ();
}
