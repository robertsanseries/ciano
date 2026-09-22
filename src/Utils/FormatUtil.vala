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

namespace Ciano.Utils {

    /**
     * The FormatUtil class groups the knowledge about the media formats
     * supported by the application: which category each format belongs to,
     * which input formats are accepted for a given target and their MIME types.
     *
     * @since 0.2.5
     */
    public class FormatUtil {

        /**
         * Checks whether the given format is a supported video format.
         *
         * @param format Canonical format name (e.g., "MP4").
         * @return true if the format is a video format.
         */
        public static bool is_video (string format) {
            return format == Constants.TEXT_MP4
            || format == Constants.TEXT_3GP
            || format == Constants.TEXT_MPG
            || format == Constants.TEXT_AVI
            || format == Constants.TEXT_WMV
            || format == Constants.TEXT_FLV
            || format == Constants.TEXT_SWF
            || format == Constants.TEXT_MOV
            || format == Constants.TEXT_MKV
            || format == Constants.TEXT_VOB
            || format == Constants.TEXT_OGV
            || format == Constants.TEXT_WEBM;
        }

        /**
         * Checks whether the given format is a supported audio format.
         *
         * @param format Canonical format name (e.g., "MP3").
         * @return true if the format is an audio format.
         */
        public static bool is_audio (string format) {
            return format == Constants.TEXT_MP3
            || format == Constants.TEXT_WMA
            || format == Constants.TEXT_AMR
            || format == Constants.TEXT_OGG
            || format == Constants.TEXT_WAV
            || format == Constants.TEXT_AAC
            || format == Constants.TEXT_FLAC
            || format == Constants.TEXT_AIFF
            || format == Constants.TEXT_MMF
            || format == Constants.TEXT_M4A
            || format == Constants.TEXT_AT9
            || format == Constants.TEXT_OPUS
            || format == Constants.TEXT_SHN;
        }

        /**
         * Resolves the media type category for a given target format.
         * Anything that is neither video nor audio is treated as an image.
         *
         * @param name_format Target format (e.g., "MP4", "MP3", "GIF").
         * @return The matching media type category.
         */
        public static TypeItemEnum resolve_type_item (string name_format) {
            if (is_video (name_format)) {
                return TypeItemEnum.VIDEO;
            } else if (is_audio (name_format)) {
                return TypeItemEnum.MUSIC;
            } else {
                return TypeItemEnum.IMAGE;
            }
        }

        /**
         * Returns the input formats accepted when converting to the given target.
         * Audio targets also accept video files, so the audio track can be extracted,
         * and GIF also accepts video files, so a clip can become an animated GIF.
         *
         * @param name_format Target format selected.
         * @return Supported input extensions.
         */
        public static string[] get_input_formats (string name_format) {
            GenericArray<string> formats;

            if (is_video (name_format)) {
                formats = get_video_formats ();
            } else if (is_audio (name_format)) {
                formats = ArrayUtil.join_generic_string_arrays (get_audio_formats (), get_video_formats ());
            } else if (name_format == Constants.TEXT_GIF) {
                formats = ArrayUtil.join_generic_string_arrays (get_image_formats (), get_video_formats ());
            } else {
                formats = get_image_formats ();
            }

            return (string[]) formats.data;
        }

        /**
         * Returns the video formats offered as conversion targets in the sidebar.
         */
        public static string[] get_video_targets () {
            return {
                Constants.TEXT_MP4,
                Constants.TEXT_MPG,
                Constants.TEXT_AVI,
                Constants.TEXT_WMV,
                Constants.TEXT_FLV,
                Constants.TEXT_SWF,
                Constants.TEXT_MKV,
                Constants.TEXT_3GP,
                Constants.TEXT_MOV,
                Constants.TEXT_VOB,
                Constants.TEXT_OGV,
                Constants.TEXT_WEBM
            };
        }

        /**
         * Returns the audio formats offered as conversion targets in the sidebar.
         * AT9 and SHN are not included: FFmpeg can read them but cannot write them.
         * AMR is not included either: its encoder is missing from most FFmpeg builds
         * (e.g. Ubuntu and elementary OS), so the conversion would usually fail.
         */
        public static string[] get_audio_targets () {
            return {
                Constants.TEXT_MP3,
                Constants.TEXT_WMA,
                Constants.TEXT_OGG,
                Constants.TEXT_WAV,
                Constants.TEXT_AAC,
                Constants.TEXT_FLAC,
                Constants.TEXT_AIFF,
                Constants.TEXT_MMF,
                Constants.TEXT_M4A,
                Constants.TEXT_OPUS
            };
        }

        /**
         * Returns the image formats offered as conversion targets in the sidebar.
         */
        public static string[] get_image_targets () {
            return {
                Constants.TEXT_JPG,
                Constants.TEXT_BMP,
                Constants.TEXT_PNG,
                Constants.TEXT_TIF,
                Constants.TEXT_GIF,
                Constants.TEXT_TGA,
                Constants.TEXT_ICO
            };
        }

        /**
         * Returns all supported video formats.
         */
        public static GenericArray<string> get_video_formats () {
            string[] raw = {
                Constants.TEXT_MP4,
                Constants.TEXT_3GP,
                Constants.TEXT_MPG,
                Constants.TEXT_AVI,
                Constants.TEXT_WMV,
                Constants.TEXT_FLV,
                Constants.TEXT_SWF,
                Constants.TEXT_MOV,
                Constants.TEXT_MKV,
                Constants.TEXT_VOB,
                Constants.TEXT_OGV,
                Constants.TEXT_WEBM
            };

            return to_generic_array (raw);
        }

        /**
         * Returns all supported audio formats.
         * AT9, SHN and AMR are only read: FFmpeg always decodes them, but cannot
         * write AT9 and SHN and usually lacks an AMR encoder, so they are accepted
         * as input but are not targets.
         */
        public static GenericArray<string> get_audio_formats () {
            string[] raw = {
                Constants.TEXT_MP3,
                Constants.TEXT_WMA,
                Constants.TEXT_AMR,
                Constants.TEXT_OGG,
                Constants.TEXT_WAV,
                Constants.TEXT_AAC,
                Constants.TEXT_FLAC,
                Constants.TEXT_AIFF,
                Constants.TEXT_MMF,
                Constants.TEXT_M4A,
                Constants.TEXT_OPUS,
                Constants.TEXT_AT9,
                Constants.TEXT_SHN
            };

            return to_generic_array (raw);
        }

        /**
         * Returns all supported image formats.
         */
        public static GenericArray<string> get_image_formats () {
            string[] raw = {
                Constants.TEXT_JPG,
                Constants.TEXT_BMP,
                Constants.TEXT_PNG,
                Constants.TEXT_TIF,
                Constants.TEXT_ICO,
                Constants.TEXT_GIF,
                Constants.TEXT_TGA
            };

            return to_generic_array (raw);
        }

        /**
         * Returns the MIME type for a given format string.
         * Using MIME types instead of glob patterns ensures all known file
         * extensions and capitalizations are matched by the system automatically,
         * including variants like .3gpp and .3ga for 3GP, and uppercase .WAV etc.
         *
         * @param format The format string, in any case (e.g., "MP4", "wav").
         * @return The MIME type string, or null if not known.
         */
        public static string? get_mime_type (string format) {
            switch (format.ascii_down ()) {
                // Video
                case "mp4": return "video/mp4";
                case "3gp": return "video/3gpp";
                case "mpg": return "video/mpeg";
                case "avi": return "video/x-msvideo";
                case "wmv": return "video/x-ms-wmv";
                case "flv": return "video/x-flv";
                case "swf": return "application/x-shockwave-flash";
                case "mov": return "video/quicktime";
                case "mkv": return "video/x-matroska";
                case "vob": return "video/dvd";
                case "ogv": return "video/ogg";
                case "webm": return "video/webm";
                // Audio
                case "mp3": return "audio/mpeg";
                case "wma": return "audio/x-ms-wma";
                case "amr": return "audio/amr";
                case "ogg": return "audio/ogg";
                case "wav": return "audio/wav";
                case "aac": return "audio/aac";
                case "flac": return "audio/flac";
                case "aiff": return "audio/x-aiff";
                case "m4a": return "audio/mp4";
                case "opus": return "audio/opus";
                case "shn": return "audio/x-shorten";
                // Image
                case "jpg": return "image/jpeg";
                case "bmp": return "image/bmp";
                case "png": return "image/png";
                case "tif": return "image/tiff";
                case "ico": return "image/x-icon";
                case "gif": return "image/gif";
                case "tga": return "image/x-tga";
                // No known MIME type — fall back to glob pattern
                default: return null;
            }
        }

        private static GenericArray<string> to_generic_array (string[] raw) {
            var array = new GenericArray<string> ();

            foreach (var f in raw) {
                array.add (f);
            }

            return array;
        }
    }
}
