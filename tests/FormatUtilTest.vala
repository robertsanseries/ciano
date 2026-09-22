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

using Ciano.Configs;
using Ciano.Enums;
using Ciano.Utils;
using Ciano.Tests;

string[] video () {
    return (string[]) FormatUtil.get_video_formats ().data;
}

string[] audio () {
    return (string[]) FormatUtil.get_audio_formats ().data;
}

string[] image () {
    return (string[]) FormatUtil.get_image_formats ().data;
}

void assert_no_duplicates (string[] formats) {
    for (int i = 0; i < formats.length; i++) {
        for (int j = i + 1; j < formats.length; j++) {
            if (formats[i] == formats[j]) {
                Test.fail_printf ("duplicated format: %s", formats[i]);
            }
        }
    }
}

void add_list_tests () {
    Test.add_func ("/format-util/lists/video", () => {
        TestUtil.assert_strv_equal (video (), {
            Constants.TEXT_MP4, Constants.TEXT_3GP, Constants.TEXT_MPG, Constants.TEXT_AVI,
            Constants.TEXT_WMV, Constants.TEXT_FLV, Constants.TEXT_SWF, Constants.TEXT_MOV,
            Constants.TEXT_MKV, Constants.TEXT_VOB, Constants.TEXT_OGV, Constants.TEXT_WEBM
        });
    });

    Test.add_func ("/format-util/lists/audio", () => {
        TestUtil.assert_strv_equal (audio (), {
            Constants.TEXT_MP3, Constants.TEXT_WMA, Constants.TEXT_AMR, Constants.TEXT_OGG,
            Constants.TEXT_WAV, Constants.TEXT_AAC, Constants.TEXT_FLAC, Constants.TEXT_AIFF,
            Constants.TEXT_MMF, Constants.TEXT_M4A, Constants.TEXT_OPUS, Constants.TEXT_AT9,
            Constants.TEXT_SHN
        });
    });

    Test.add_func ("/format-util/lists/image", () => {
        TestUtil.assert_strv_equal (image (), {
            Constants.TEXT_JPG, Constants.TEXT_BMP, Constants.TEXT_PNG, Constants.TEXT_TIF,
            Constants.TEXT_ICO, Constants.TEXT_GIF, Constants.TEXT_TGA
        });
    });

    Test.add_func ("/format-util/lists/no-duplicates", () => {
        assert_no_duplicates (video ());
        assert_no_duplicates (audio ());
        assert_no_duplicates (image ());
    });

    Test.add_func ("/format-util/lists/categories-are-disjoint", () => {
        foreach (string f in video ()) {
            assert_false (TestUtil.contains (audio (), f));
            assert_false (TestUtil.contains (image (), f));
        }

        foreach (string f in audio ()) {
            assert_false (TestUtil.contains (image (), f));
        }
    });

    Test.add_func ("/format-util/lists/uppercase-and-non-empty", () => {
        var all = new GenericArray<string> ();
        foreach (string f in video ()) { all.add (f); }
        foreach (string f in audio ()) { all.add (f); }
        foreach (string f in image ()) { all.add (f); }

        foreach (string f in all.data) {
            assert_true (f.length > 0);
            assert_cmpstr (f, CompareOperator.EQ, f.up ());
            assert_false (f.contains ("."));
            assert_false (f.contains (" "));
        }
    });

    Test.add_func ("/format-util/lists/each-call-returns-a-new-array", () => {
        var first = FormatUtil.get_video_formats ();
        first.add ("XYZ");
        first.remove_index (0);

        var second = FormatUtil.get_video_formats ();
        assert_cmpuint (second.length, CompareOperator.EQ, 12);
        assert_cmpstr (second.get (0), CompareOperator.EQ, Constants.TEXT_MP4);
        assert_false (TestUtil.contains ((string[]) second.data, "XYZ"));
    });
}

void add_category_tests () {
    Test.add_func ("/format-util/is-video/all-video-formats", () => {
        foreach (string f in video ()) {
            assert_true (FormatUtil.is_video (f));
            assert_false (FormatUtil.is_audio (f));
        }
    });

    Test.add_func ("/format-util/is-audio/all-audio-formats", () => {
        foreach (string f in audio ()) {
            assert_true (FormatUtil.is_audio (f));
            assert_false (FormatUtil.is_video (f));
        }
    });

    Test.add_func ("/format-util/is-audio/shn", () => {
        assert_true (FormatUtil.is_audio (Constants.TEXT_SHN));
        assert_false (FormatUtil.is_video (Constants.TEXT_SHN));
    });

    Test.add_func ("/format-util/image-formats-are-neither-video-nor-audio", () => {
        foreach (string f in image ()) {
            assert_false (FormatUtil.is_video (f));
            assert_false (FormatUtil.is_audio (f));
        }
    });

    Test.add_func ("/format-util/categories-are-case-sensitive", () => {
        // The controller always passes the uppercase constants from the sidebar
        assert_false (FormatUtil.is_video ("mp4"));
        assert_false (FormatUtil.is_audio ("mp3"));
    });

    Test.add_func ("/format-util/unknown-formats", () => {
        string[] unknown = { "", "XYZ", "MP5", " MP4", "MP4 ", "M4V", "MPEG" };

        foreach (string f in unknown) {
            assert_false (FormatUtil.is_video (f));
            assert_false (FormatUtil.is_audio (f));
        }
    });

    Test.add_func ("/format-util/resolve-type-item/video", () => {
        foreach (string f in video ()) {
            assert_true (FormatUtil.resolve_type_item (f) == TypeItemEnum.VIDEO);
        }
    });

    Test.add_func ("/format-util/resolve-type-item/audio", () => {
        foreach (string f in audio ()) {
            assert_true (FormatUtil.resolve_type_item (f) == TypeItemEnum.MUSIC);
        }

        assert_true (FormatUtil.resolve_type_item (Constants.TEXT_SHN) == TypeItemEnum.MUSIC);
    });

    Test.add_func ("/format-util/resolve-type-item/image", () => {
        foreach (string f in image ()) {
            assert_true (FormatUtil.resolve_type_item (f) == TypeItemEnum.IMAGE);
        }
    });

    Test.add_func ("/format-util/resolve-type-item/unknown-falls-back-to-image", () => {
        assert_true (FormatUtil.resolve_type_item ("") == TypeItemEnum.IMAGE);
        assert_true (FormatUtil.resolve_type_item ("XYZ") == TypeItemEnum.IMAGE);
        assert_true (FormatUtil.resolve_type_item ("mp4") == TypeItemEnum.IMAGE);
    });

    Test.add_func ("/format-util/shn-is-accepted-as-input", () => {
        // FFmpeg can decode Shorten files, so they can be converted to any audio format
        assert_true (TestUtil.contains (audio (), Constants.TEXT_SHN));

        foreach (string target in audio ()) {
            assert_true (TestUtil.contains (FormatUtil.get_input_formats (target), Constants.TEXT_SHN));
        }
    });

    Test.add_func ("/format-util/shn-is-not-accepted-for-video-or-image", () => {
        assert_false (TestUtil.contains (FormatUtil.get_input_formats (Constants.TEXT_MP4), Constants.TEXT_SHN));
        assert_false (TestUtil.contains (FormatUtil.get_input_formats (Constants.TEXT_PNG), Constants.TEXT_SHN));
    });

    Test.add_func ("/format-util/every-audio-format-is-recognized", () => {
        // is_audio () and get_audio_formats () must describe the same set of formats
        string[] candidates = {
            Constants.TEXT_MP3, Constants.TEXT_WMA, Constants.TEXT_AMR, Constants.TEXT_OGG, Constants.TEXT_AAC,
            Constants.TEXT_MMF, Constants.TEXT_M4A, Constants.TEXT_WAV, Constants.TEXT_FLAC, Constants.TEXT_AIFF,
            Constants.TEXT_OPUS, Constants.TEXT_AT9, Constants.TEXT_SHN
        };

        foreach (string f in candidates) {
            assert_true (FormatUtil.is_audio (f) == TestUtil.contains (audio (), f));
        }
    });
}

void add_input_format_tests () {
    Test.add_func ("/format-util/input-formats/video-target", () => {
        foreach (string target in video ()) {
            TestUtil.assert_strv_equal (FormatUtil.get_input_formats (target), video ());
        }
    });

    Test.add_func ("/format-util/input-formats/audio-target-accepts-audio-and-video", () => {
        var expected = new GenericArray<string> ();
        foreach (string f in audio ()) { expected.add (f); }
        foreach (string f in video ()) { expected.add (f); }

        foreach (string target in audio ()) {
            TestUtil.assert_strv_equal (FormatUtil.get_input_formats (target), (string[]) expected.data);
        }
    });

    Test.add_func ("/format-util/input-formats/audio-target-lists-audio-first", () => {
        string[] formats = FormatUtil.get_input_formats (Constants.TEXT_MP3);

        assert_cmpint (formats.length, CompareOperator.EQ, 25);
        assert_cmpint (TestUtil.index_of (formats, Constants.TEXT_MP3), CompareOperator.EQ, 0);
        assert_cmpint (TestUtil.index_of (formats, Constants.TEXT_SHN), CompareOperator.EQ, 12);
        assert_cmpint (TestUtil.index_of (formats, Constants.TEXT_MP4), CompareOperator.EQ, 13);
        assert_no_duplicates (formats);
    });

    Test.add_func ("/format-util/input-formats/audio-target-excludes-images", () => {
        string[] formats = FormatUtil.get_input_formats (Constants.TEXT_WAV);

        foreach (string f in image ()) {
            assert_false (TestUtil.contains (formats, f));
        }
    });

    Test.add_func ("/format-util/input-formats/video-target-excludes-audio-and-images", () => {
        string[] formats = FormatUtil.get_input_formats (Constants.TEXT_MKV);

        foreach (string f in audio ()) {
            assert_false (TestUtil.contains (formats, f));
        }

        foreach (string f in image ()) {
            assert_false (TestUtil.contains (formats, f));
        }
    });

    Test.add_func ("/format-util/input-formats/image-target", () => {
        foreach (string target in image ()) {
            if (target != Constants.TEXT_GIF) {
                TestUtil.assert_strv_equal (FormatUtil.get_input_formats (target), image ());
            }
        }
    });

    Test.add_func ("/format-util/input-formats/gif-accepts-images-and-video", () => {
        var expected = new GenericArray<string> ();
        foreach (string f in image ()) { expected.add (f); }
        foreach (string f in video ()) { expected.add (f); }

        string[] formats = FormatUtil.get_input_formats (Constants.TEXT_GIF);

        TestUtil.assert_strv_equal (formats, (string[]) expected.data);
        assert_cmpint (formats.length, CompareOperator.EQ, 19);
        assert_cmpint (TestUtil.index_of (formats, Constants.TEXT_JPG), CompareOperator.EQ, 0);
        assert_cmpint (TestUtil.index_of (formats, Constants.TEXT_MP4), CompareOperator.EQ, 7);
        assert_no_duplicates (formats);
    });

    Test.add_func ("/format-util/input-formats/gif-excludes-audio", () => {
        string[] formats = FormatUtil.get_input_formats (Constants.TEXT_GIF);

        foreach (string f in audio ()) {
            assert_false (TestUtil.contains (formats, f));
        }
    });

    Test.add_func ("/format-util/input-formats/other-images-do-not-accept-video", () => {
        foreach (string target in FormatUtil.get_image_targets ()) {
            if (target == Constants.TEXT_GIF) {
                continue;
            }

            foreach (string f in video ()) {
                assert_false (TestUtil.contains (FormatUtil.get_input_formats (target), f));
            }
        }
    });

    Test.add_func ("/format-util/input-formats/gif-is-case-sensitive-like-other-targets", () => {
        // Targets always come from the uppercase sidebar constants
        TestUtil.assert_strv_equal (FormatUtil.get_input_formats ("gif"), image ());
    });

    Test.add_func ("/format-util/input-formats/unknown-target-uses-images", () => {
        TestUtil.assert_strv_equal (FormatUtil.get_input_formats ("XYZ"), image ());
    });
}

void assert_mime (string format, string? expected) {
    assert_cmpstr (FormatUtil.get_mime_type (format), CompareOperator.EQ, expected);
}

void add_mime_tests () {
    Test.add_func ("/format-util/mime/video", () => {
        assert_mime ("MP4", "video/mp4");
        assert_mime ("3GP", "video/3gpp");
        assert_mime ("MPG", "video/mpeg");
        assert_mime ("AVI", "video/x-msvideo");
        assert_mime ("WMV", "video/x-ms-wmv");
        assert_mime ("FLV", "video/x-flv");
        assert_mime ("SWF", "application/x-shockwave-flash");
        assert_mime ("MOV", "video/quicktime");
        assert_mime ("MKV", "video/x-matroska");
        assert_mime ("VOB", "video/dvd");
        assert_mime ("OGV", "video/ogg");
        assert_mime ("WEBM", "video/webm");
    });

    Test.add_func ("/format-util/mime/audio", () => {
        assert_mime ("MP3", "audio/mpeg");
        assert_mime ("WMA", "audio/x-ms-wma");
        assert_mime ("AMR", "audio/amr");
        assert_mime ("OGG", "audio/ogg");
        assert_mime ("WAV", "audio/wav");
        assert_mime ("AAC", "audio/aac");
        assert_mime ("FLAC", "audio/flac");
        assert_mime ("AIFF", "audio/x-aiff");
        assert_mime ("M4A", "audio/mp4");
        assert_mime ("OPUS", "audio/opus");
        assert_mime ("SHN", "audio/x-shorten");
    });

    Test.add_func ("/format-util/mime/image", () => {
        assert_mime ("JPG", "image/jpeg");
        assert_mime ("BMP", "image/bmp");
        assert_mime ("PNG", "image/png");
        assert_mime ("TIF", "image/tiff");
        assert_mime ("ICO", "image/x-icon");
        assert_mime ("GIF", "image/gif");
        assert_mime ("TGA", "image/x-tga");
    });

    Test.add_func ("/format-util/mime/formats-without-mime-use-glob-fallback", () => {
        assert_mime ("MMF", null);
        assert_mime ("AT9", null);
    });

    Test.add_func ("/format-util/mime/case-insensitive", () => {
        assert_mime ("mp4", "video/mp4");
        assert_mime ("Mp4", "video/mp4");
        assert_mime ("wAv", "audio/wav");
        assert_mime ("jpg", "image/jpeg");
    });

    Test.add_func ("/format-util/mime/unknown", () => {
        assert_mime ("", null);
        assert_mime ("XYZ", null);
        assert_mime (".mp4", null);
        assert_mime (" mp4", null);
        assert_mime ("jpeg", null);
    });

    Test.add_func ("/format-util/mime/matches-category", () => {
        foreach (string f in video ()) {
            string? mime = FormatUtil.get_mime_type (f);
            assert_nonnull (mime);
            // SWF is served as a Flash application, every other video format is video/*
            assert_true (mime.has_prefix ("video/") || f == Constants.TEXT_SWF);
        }

        foreach (string f in audio ()) {
            string? mime = FormatUtil.get_mime_type (f);
            if (mime != null) {
                assert_true (mime.has_prefix ("audio/"));
            }
        }

        foreach (string f in image ()) {
            string? mime = FormatUtil.get_mime_type (f);
            assert_nonnull (mime);
            assert_true (mime.has_prefix ("image/"));
        }
    });

}

void assert_targets_have_inputs (string[] targets) {
    foreach (string target in targets) {
        assert_cmpint (FormatUtil.get_input_formats (target).length, CompareOperator.GT, 0);
    }
}

void add_target_tests () {
    Test.add_func ("/format-util/targets/video", () => {
        TestUtil.assert_strv_equal (FormatUtil.get_video_targets (), {
            "MP4", "MPG", "AVI", "WMV", "FLV", "SWF", "MKV", "3GP", "MOV", "VOB", "OGV", "WEBM"
        });
    });

    Test.add_func ("/format-util/targets/audio", () => {
        TestUtil.assert_strv_equal (FormatUtil.get_audio_targets (), {
            "MP3", "WMA", "OGG", "WAV", "AAC", "FLAC", "AIFF", "MMF", "M4A", "OPUS"
        });
    });

    Test.add_func ("/format-util/targets/image", () => {
        TestUtil.assert_strv_equal (FormatUtil.get_image_targets (), {
            "JPG", "BMP", "PNG", "TIF", "GIF", "TGA", "ICO"
        });
    });

    Test.add_func ("/format-util/targets/read-only-formats-are-not-targets", () => {
        // FFmpeg can decode ATRAC9 and Shorten, but has no encoder for them.
        // AMR has an encoder only in some builds, so it is not offered either.
        foreach (string f in new string[] { Constants.TEXT_AT9, Constants.TEXT_SHN, Constants.TEXT_AMR }) {
            assert_false (TestUtil.contains (FormatUtil.get_audio_targets (), f));
            assert_false (TestUtil.contains (FormatUtil.get_video_targets (), f));
            assert_false (TestUtil.contains (FormatUtil.get_image_targets (), f));
        }
    });

    Test.add_func ("/format-util/targets/read-only-formats-are-still-inputs", () => {
        string[] inputs = FormatUtil.get_input_formats (Constants.TEXT_MP3);

        assert_true (TestUtil.contains (inputs, Constants.TEXT_AT9));
        assert_true (TestUtil.contains (inputs, Constants.TEXT_SHN));
        assert_true (TestUtil.contains (inputs, Constants.TEXT_AMR));
    });

    Test.add_func ("/format-util/targets/belong-to-their-category", () => {
        foreach (string f in FormatUtil.get_video_targets ()) {
            assert_true (TestUtil.contains (video (), f));
            assert_true (FormatUtil.resolve_type_item (f) == TypeItemEnum.VIDEO);
        }

        foreach (string f in FormatUtil.get_audio_targets ()) {
            assert_true (TestUtil.contains (audio (), f));
            assert_true (FormatUtil.resolve_type_item (f) == TypeItemEnum.MUSIC);
        }

        foreach (string f in FormatUtil.get_image_targets ()) {
            assert_true (TestUtil.contains (image (), f));
            assert_true (FormatUtil.resolve_type_item (f) == TypeItemEnum.IMAGE);
        }
    });

    Test.add_func ("/format-util/targets/every-writable-format-is-a-target", () => {
        // Only the read-only formats may be missing from the targets
        foreach (string f in video ()) {
            assert_true (TestUtil.contains (FormatUtil.get_video_targets (), f));
        }

        foreach (string f in audio ()) {
            bool read_only = f == Constants.TEXT_AT9 || f == Constants.TEXT_SHN || f == Constants.TEXT_AMR;
            assert_true (TestUtil.contains (FormatUtil.get_audio_targets (), f) != read_only);
        }

        foreach (string f in image ()) {
            assert_true (TestUtil.contains (FormatUtil.get_image_targets (), f));
        }
    });

    Test.add_func ("/format-util/targets/no-duplicates", () => {
        assert_no_duplicates (FormatUtil.get_video_targets ());
        assert_no_duplicates (FormatUtil.get_audio_targets ());
        assert_no_duplicates (FormatUtil.get_image_targets ());
    });

    Test.add_func ("/format-util/targets/every-target-has-inputs", () => {
        assert_targets_have_inputs (FormatUtil.get_video_targets ());
        assert_targets_have_inputs (FormatUtil.get_audio_targets ());
        assert_targets_have_inputs (FormatUtil.get_image_targets ());
    });
}

int main (string[] args) {
    Test.init (ref args);

    add_list_tests ();
    add_target_tests ();
    add_category_tests ();
    add_input_format_tests ();
    add_mime_tests ();

    return Test.run ();
}
