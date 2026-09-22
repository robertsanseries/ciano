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
using Ciano.Tests;

string[] all_format_constants () {
    return {
        Constants.TEXT_MP4, Constants.TEXT_3GP, Constants.TEXT_MPG, Constants.TEXT_AVI, Constants.TEXT_WMV,
        Constants.TEXT_FLV, Constants.TEXT_SWF, Constants.TEXT_MOV, Constants.TEXT_MKV, Constants.TEXT_VOB,
        Constants.TEXT_OGV, Constants.TEXT_WEBM,
        Constants.TEXT_MP3, Constants.TEXT_WMA, Constants.TEXT_AMR, Constants.TEXT_OGG, Constants.TEXT_AAC,
        Constants.TEXT_MMF, Constants.TEXT_M4A, Constants.TEXT_WAV, Constants.TEXT_FLAC, Constants.TEXT_AIFF,
        Constants.TEXT_OPUS, Constants.TEXT_AT9, Constants.TEXT_SHN,
        Constants.TEXT_JPG, Constants.TEXT_BMP, Constants.TEXT_PNG, Constants.TEXT_TIF, Constants.TEXT_ICO,
        Constants.TEXT_GIF, Constants.TEXT_TGA
    };
}

int main (string[] args) {
    Test.init (ref args);

    Test.add_func ("/constants/version-matches-meson", () => {
        assert_cmpstr (Constants.VERSION, CompareOperator.EQ, PROJECT_VERSION);
    });

    Test.add_func ("/constants/id-matches-meson-project-name", () => {
        assert_cmpstr (Constants.ID, CompareOperator.EQ, PROJECT_NAME);
    });

    Test.add_func ("/constants/app-icon-is-app-id", () => {
        assert_cmpstr (Constants.APP_ICON, CompareOperator.EQ, Constants.ID);
    });

    Test.add_func ("/constants/id-is-valid-application-id", () => {
        assert_true (GLib.Application.id_is_valid (Constants.ID));
    });

    Test.add_func ("/constants/program-name", () => {
        assert_cmpstr (Constants.PROGRAME_NAME, CompareOperator.EQ, "Ciano");
    });

    Test.add_func ("/constants/version-is-semver", () => {
        string[] parts = Constants.VERSION.split (".");
        assert_cmpint (parts.length, CompareOperator.EQ, 3);

        foreach (string part in parts) {
            uint64 number;
            try {
                assert_true (uint64.from_string (part, out number));
            } catch (Error e) {
                Test.fail_printf ("invalid version component \"%s\": %s", part, e.message);
            }
        }
    });

    Test.add_func ("/constants/urls-are-https", () => {
        string[] urls = {
            Constants.AUTHOR_URL, Constants.BUG_URL, Constants.HELP_URL,
            Constants.TRANSLATE_URL, Constants.LICENSE_URL
        };

        foreach (string url in urls) {
            assert_true (url.has_prefix ("https://"));
            assert_false (url.contains (" "));
            assert_true (Uri.is_valid (url, UriFlags.NONE));
        }
    });

    Test.add_func ("/constants/project-urls-point-to-repository", () => {
        assert_true (Constants.BUG_URL.has_prefix (Constants.AUTHOR_URL + "/ciano"));
        assert_true (Constants.HELP_URL.has_prefix (Constants.AUTHOR_URL + "/ciano"));
        assert_true (Constants.TRANSLATE_URL.has_prefix (Constants.AUTHOR_URL + "/ciano"));
    });

    Test.add_func ("/constants/output-directory", () => {
        assert_true (Constants.DIRECTORY_CIANO.has_prefix ("/"));
        assert_false (Constants.DIRECTORY_CIANO.has_suffix ("/"));
        assert_cmpstr (Path.get_basename (Constants.DIRECTORY_CIANO), CompareOperator.EQ, Constants.PROGRAME_NAME);
    });

    Test.add_func ("/constants/view-names-are-distinct", () => {
        assert_cmpstr (Constants.WELCOME_VIEW, CompareOperator.NE, Constants.LIST_BOX_VIEW);
        assert_true (Constants.WELCOME_VIEW.length > 0);
        assert_true (Constants.LIST_BOX_VIEW.length > 0);
    });

    Test.add_func ("/constants/formats-are-unique", () => {
        string[] formats = all_format_constants ();

        for (int i = 0; i < formats.length; i++) {
            for (int j = i + 1; j < formats.length; j++) {
                assert_cmpstr (formats[i], CompareOperator.NE, formats[j]);
            }
        }
    });

    Test.add_func ("/constants/formats-are-uppercase-extensions", () => {
        foreach (string f in all_format_constants ()) {
            assert_cmpstr (f, CompareOperator.EQ, f.up ());
            assert_true (f.length >= 3 && f.length <= 4);
            assert_false (f.contains ("."));
        }
    });

    Test.add_func ("/constants/icon-names", () => {
        string[] icons = {
            Constants.ICON_FOLDER_VIDEO, Constants.ICON_MEDIA_VIDEO, Constants.ICON_FOLDER_MUSIC,
            Constants.ICON_AUDIO_GENERIC, Constants.ICON_FOLDER_PICTURES, Constants.ICON_IMAGE_GENERIC
        };

        foreach (string icon in icons) {
            assert_true (icon.length > 0);
            assert_false (icon.contains (" "));
            assert_cmpstr (icon, CompareOperator.EQ, icon.ascii_down ());
        }
    });

    return Test.run ();
}
