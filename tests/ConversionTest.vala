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
using Ciano.Utils;
using Ciano.Tests;

// Integration tests: every format offered in the sidebar is converted with the
// real ffmpeg binary, using exactly the arguments built by the application.
// Inputs are tiny generated clips, so the whole suite takes a few seconds.

string? ffmpeg;
string? ffprobe;
string work_dir;

/**
 * Runs a command and returns whether it succeeded. On failure the tail of
 * stderr is reported through the test log.
 */
bool run (string[] argv) {
    string stderr_text;
    return run_with_stderr (argv, out stderr_text);
}

bool run_with_stderr (string[] argv, out string stderr_text) {
    stderr_text = "";

    try {
        var proc = new Subprocess.newv (argv, SubprocessFlags.STDOUT_PIPE | SubprocessFlags.STDERR_PIPE);
        string stdout_text;
        proc.communicate_utf8 (null, null, out stdout_text, out stderr_text);

        if (!proc.get_successful ()) {
            Test.message ("command failed: %s", string.joinv (" ", argv));
            string tail = stderr_text.length > 1500 ? stderr_text.substring (stderr_text.length - 1500) : stderr_text;
            Test.message ("%s", tail);
            return false;
        }

        return true;
    } catch (Error e) {
        Test.message ("could not run %s: %s", argv[0], e.message);
        return false;
    }
}

/**
 * Generates an input clip with ffmpeg, returning its path or null on failure.
 */
string? generate (string name, string[] options) {
    string path = Path.build_filename (work_dir, name);
    string[] argv = { ffmpeg, "-v", "error", "-y" };

    foreach (string option in options) {
        argv += option;
    }

    argv += path;

    return run (argv) ? path : null;
}

/**
 * Returns the stream types of a media file (e.g. "audio", "video").
 */
string[] stream_types (string path) {
    try {
        var proc = new Subprocess.newv (
                { ffprobe, "-v", "error", "-show_entries", "stream=codec_type", "-of", "csv=p=0", path },
                SubprocessFlags.STDOUT_PIPE | SubprocessFlags.STDERR_SILENCE
        );
        string output;
        proc.communicate_utf8 (null, null, out output, null);

        var types = new GenericArray<string> ();
        foreach (string line in output.strip ().split ("\n")) {
            // Some containers (e.g. MPEG-PS) print extra empty CSV fields: "video,"
            string type = line.split (",")[0].strip ();
            if (type != "") {
                types.add (type);
            }
        }

        return (string[]) types.data;
    } catch (Error e) {
        error ("ffprobe failed: %s", e.message);
    }
}

/**
 * Returns the width of the first video stream.
 */
int video_width (string path) {
    try {
        var proc = new Subprocess.newv (
                {
                    ffprobe, "-v", "error", "-select_streams", "v:0",
                    "-show_entries", "stream=width", "-of", "csv=p=0", path
                },
                SubprocessFlags.STDOUT_PIPE | SubprocessFlags.STDERR_SILENCE
        );
        string output;
        proc.communicate_utf8 (null, null, out output, null);

        return int.parse (output.split (",")[0].strip ());
    } catch (Error e) {
        error ("ffprobe failed: %s", e.message);
    }
}

/**
 * Returns the number of frames of the first video stream.
 */
int count_frames (string path) {
    try {
        var proc = new Subprocess.newv (
                {
                    ffprobe, "-v", "error", "-count_frames", "-select_streams", "v:0",
                    "-show_entries", "stream=nb_read_frames", "-of", "csv=p=0", path
                },
                SubprocessFlags.STDOUT_PIPE | SubprocessFlags.STDERR_SILENCE
        );
        string output;
        proc.communicate_utf8 (null, null, out output, null);

        return int.parse (output.split (",")[0].strip ());
    } catch (Error e) {
        error ("ffprobe failed: %s", e.message);
    }
}

/**
 * Converts the input with the application's own arguments and checks the result.
 * Returns the output path.
 */
string convert (string? input, string format, TypeItemEnum type) {
    if (input == null) {
        Test.skip ("input could not be generated with this ffmpeg build");
        return "";
    }

    string output = FileUtil.build_output_path (input, format, false, Path.build_filename (work_dir, "out"));
    // Keep outputs of different conversions of the same input apart
    output = Path.build_filename (
            Path.get_dirname (output),
            "%s-%s".printf (Path.get_basename (input).replace (".", "_"), Path.get_basename (output))
    );

    DirUtils.create_with_parents (Path.get_dirname (output), 0755);

    string[] args = FFmpegUtil.build_arguments (ffmpeg, input, output, format, type);

    string stderr_text;
    if (!run_with_stderr (args, out stderr_text)) {
        if (stderr_text.contains ("Encoder not found")) {
            // Depends on how ffmpeg was built, not on the arguments of the application
            Test.incomplete ("this ffmpeg build has no encoder for %s, so this target always fails".printf (format));
            return "";
        }

        Test.fail_printf ("converting %s to %s failed", Path.get_basename (input), format);
        return output;
    }

    Posix.Stat st;
    assert_cmpint (Posix.stat (output, out st), CompareOperator.EQ, 0);
    assert_cmpint ((int) st.st_size, CompareOperator.GT, 0);

    return output;
}

void add_conversion_tests (
        string? video_input,
        string? audio_input,
        string? image_input,
        string? webm_input,
        string? large_video_input,
        string? large_image_input
) {
    foreach (string format in FormatUtil.get_video_targets ()) {
        Test.add_data_func ("/conversion/video/" + format, () => {
            string output = convert (video_input, format, TypeItemEnum.VIDEO);

            if (ffprobe != null && output != "" && !Test.failed ()) {
                string[] types = stream_types (output);
                assert_true (TestUtil.contains (types, "video"));
                assert_true (TestUtil.contains (types, "audio"));
            }
        });
    }

    foreach (string format in FormatUtil.get_audio_targets ()) {
        Test.add_data_func ("/conversion/audio/" + format, () => {
            string output = convert (audio_input, format, TypeItemEnum.MUSIC);

            if (ffprobe != null && output != "" && !Test.failed ()) {
                TestUtil.assert_strv_equal (stream_types (output), { "audio" });
            }
        });
    }

    foreach (string format in FormatUtil.get_audio_targets ()) {
        Test.add_data_func ("/conversion/audio-from-video/" + format, () => {
            string output = convert (video_input, format, TypeItemEnum.MUSIC);

            // -vn must leave only the audio stream
            if (ffprobe != null && output != "" && !Test.failed ()) {
                TestUtil.assert_strv_equal (stream_types (output), { "audio" });
            }
        });
    }

    foreach (string format in FormatUtil.get_image_targets ()) {
        Test.add_data_func ("/conversion/image/" + format, () => {
            string output = convert (image_input, format, TypeItemEnum.IMAGE);

            if (ffprobe != null && output != "" && !Test.failed ()) {
                TestUtil.assert_strv_equal (stream_types (output), { "video" });
            }
        });
    }

    Test.add_data_func ("/conversion/gif-from-video", () => {
        string output = convert (video_input, "GIF", TypeItemEnum.IMAGE);

        // The GIF must be animated, not just the first frame of the video
        if (ffprobe != null && output != "" && !Test.failed ()) {
            assert_cmpint (count_frames (output), CompareOperator.GT, 1);
        }
    });

    Test.add_data_func ("/conversion/gif-from-webm", () => {
        string output = convert (webm_input, "GIF", TypeItemEnum.IMAGE);

        if (ffprobe != null && output != "" && !Test.failed ()) {
            assert_cmpint (count_frames (output), CompareOperator.GT, 1);
        }
    });

    Test.add_data_func ("/conversion/gif-from-video/small-video-is-not-enlarged", () => {
        string output = convert (video_input, "GIF", TypeItemEnum.IMAGE);

        if (ffprobe != null && output != "" && !Test.failed ()) {
            assert_cmpint (video_width (output), CompareOperator.EQ, 64);
        }
    });

    Test.add_data_func ("/conversion/gif-from-video/large-video-is-limited", () => {
        string output = convert (large_video_input, "GIF", TypeItemEnum.IMAGE);

        if (ffprobe != null && output != "" && !Test.failed ()) {
            // 1280 px wide at 30 fps for 2 seconds -> 480 px wide at 10 fps
            assert_cmpint (video_width (output), CompareOperator.EQ, 480);
            int frames = count_frames (output);
            assert_cmpint (frames, CompareOperator.GE, 19);
            assert_cmpint (frames, CompareOperator.LE, 21);
        }
    });

    Test.add_data_func ("/conversion/gif-from-image/large-image-is-not-resized", () => {
        string output = convert (large_image_input, "GIF", TypeItemEnum.IMAGE);

        if (ffprobe != null && output != "" && !Test.failed ()) {
            assert_cmpint (video_width (output), CompareOperator.EQ, 1280);
        }
    });
}

int main (string[] args) {
    Test.init (ref args);
    // Report every failing format instead of stopping at the first one
    Test.set_nonfatal_assertions ();

    ffmpeg = Environment.find_program_in_path ("ffmpeg");
    ffprobe = Environment.find_program_in_path ("ffprobe");

    if (ffmpeg == null) {
        Test.add_func ("/conversion/ffmpeg-available", () => {
            Test.skip ("ffmpeg is not installed");
        });

        return Test.run ();
    }

    work_dir = TestUtil.make_tmp_dir ();

    // Built-in encoders only, so any ffmpeg build can create the inputs
    string? video_input = generate ("input.mkv", {
        "-f", "lavfi", "-i", "testsrc=duration=1:size=64x64:rate=10",
        "-f", "lavfi", "-i", "sine=duration=1",
        "-c:v", "mpeg4", "-c:a", "pcm_s16le", "-shortest"
    });
    string? audio_input = generate ("input.wav", { "-f", "lavfi", "-i", "sine=duration=1" });
    string? image_input = generate ("input.png", {
        "-f", "lavfi", "-i", "testsrc=size=64x64", "-frames:v", "1"
    });
    string? webm_input = generate ("input.webm", {
        "-f", "lavfi", "-i", "testsrc=duration=1:size=64x64:rate=10", "-c:v", "libvpx"
    });

    string? large_video_input = generate ("large.mkv", {
        "-f", "lavfi", "-i", "testsrc=duration=2:size=1280x720:rate=30", "-c:v", "mpeg4"
    });
    string? large_image_input = generate ("large.png", {
        "-f", "lavfi", "-i", "testsrc=size=1280x720", "-frames:v", "1"
    });

    add_conversion_tests (video_input, audio_input, image_input, webm_input, large_video_input, large_image_input);

    int result = Test.run ();
    TestUtil.remove_tree (work_dir);

    return result;
}
