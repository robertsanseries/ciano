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

namespace Ciano.Utils {

    /**
     * The FFmpegUtil class provides helper methods to interact with the FFmpeg binary
     * and to parse its terminal output during conversion.
     *
     * It handles binary resolution, progress parsing, and output formatting.
     *
     * @since 0.1.0
     */
    public class FFmpegUtil : Object {

        private static string last_size = "";
        private static string last_bitrate = "";

        /**
         * Cached absolute path to the ffmpeg binary, resolved once at first use.
         * Null means resolution has not yet been attempted.
         */
        private static string? resolved_executable = null;

        /**
         * Candidate paths to search for the ffmpeg binary, in order of preference.
         * This covers native installs, Flatpak sandboxes, and common distro layouts.
         */
        private static string[] candidate_paths = {
            "/usr/bin/ffmpeg",
            "/usr/local/bin/ffmpeg",
            "/app/bin/ffmpeg"
        };

        /**
         * Resolves and returns the absolute path to the ffmpeg binary.
         *
         * Resolution strategy:
         *   1. Return the cached result if already resolved.
         *   2. Search via GLib.find_program_in_path (respects $PATH).
         *   3. Fall back to known candidate paths, verifying executability.
         *
         * @throws Error if no executable ffmpeg binary can be found.
         * @return Absolute path to the ffmpeg binary.
         */
        public static string get_executable () throws Error {
            if (resolved_executable != null) {
                return resolved_executable;
            }

            // 1. Honour the runtime PATH (works for native installs and Flatpak)
            string? from_path = GLib.Environment.find_program_in_path ("ffmpeg");

            if (from_path != null && is_executable (from_path)) {
                resolved_executable = from_path;
                Logger.debug ("FFmpeg resolved via PATH: %s".printf (resolved_executable));
                return resolved_executable;
            }

            // 2. Fall back to known fixed locations
            foreach (string candidate in candidate_paths) {
                if (is_executable (candidate)) {
                    resolved_executable = candidate;
                    Logger.debug ("FFmpeg resolved via fallback: %s".printf (resolved_executable));
                    return resolved_executable;
                }
            }

            throw new IOError.NOT_FOUND (
                    "FFmpeg binary not found. Please install ffmpeg and ensure it is available in PATH."
            );
        }

        /**
         * Checks whether the given path points to a regular, executable file.
         *
         * @param path Absolute path to check.
         * @return true if the file exists and is executable.
         */
        private static bool is_executable (string path) {
            return FileUtils.test (path, FileTest.IS_EXECUTABLE)
            && FileUtils.test (path, FileTest.IS_REGULAR);
        }

        /**
         * Parses FFmpeg progress output when using:
         * -progress pipe:2 -nostats
         *
         * This method reads key=value lines emitted by FFmpeg and updates:
         * - total duration (extracted from "Duration:")
         * - current progress based on "out_time="
         * - formatted size based on "total_size="
         * - bitrate based on "bitrate="
         *
         * @param raw_line The raw line read from FFmpeg stderr.
         * @param total_seconds Reference to the total duration in seconds.
         * @param fraction Output progress fraction (0.0 → 1.0).
         * @param status_text Output formatted status text for UI.
         */
        public static void parse_progress (
                string raw_line,
                ref int total_seconds,
                out double fraction,
                out string status_text
        ) {
            fraction = -1.0;
            status_text = "";

            string line = raw_line.strip ();

            // 1. Extract total duration (appears once at the beginning)
            // Example:
            // Duration: 00:01:32.28, start: ...
            if (line.contains ("Duration:")) {

                int start = line.index_of ("Duration:") + 10;
                int end = line.index_of (",", start);

                if (end != -1) {
                    string dur_str = line.substring (start, end - start).strip ();
                    total_seconds = TimeUtil.duration_in_seconds (dur_str);
                }
            }

            // 2. Capture total_size (bytes)
            // Example:
            // total_size=262144
            if (line.has_prefix ("total_size=")) {
                string raw = line.substring (11);
                int bytes = int.parse (raw);
                last_size = format_size (bytes);
            }

            // 3. Capture bitrate
            // Example:
            // bitrate=1351.6kbits/s
            if (line.has_prefix ("bitrate=")) {
                last_bitrate = line.substring (8);
            }

            // 4. Update progress using out_time
            // Example:
            // out_time=00:00:01.551550
            if (line.has_prefix ("out_time=") && total_seconds > 0) {

                string time_val = line.substring (9);

                if (!time_val.contains ("N/A")) {

                    int current = TimeUtil.duration_in_seconds (time_val);

                    fraction = ((double) current / total_seconds)
                    .clamp (0.0, 1.0);

                    // Build UI status text
                    status_text = "%d%% - %s - %s"
                    .printf (
                            (int)(fraction * 100),
                            last_size,
                            last_bitrate
                    );
                }
            }

            // 5. Force 100% when progress ends
            // Example:
            // progress=end
            if (line.has_prefix ("progress=end")) {
                fraction = 1.0;
                status_text = "100%% - %s - %s".printf (last_size, last_bitrate);
            }
        }

        /**
         * Converts bytes to a human-readable string.
         *
         * @param bytes Size in bytes.
         * @return Formatted string (e.g. "1.4 MB", "512.0 KB", "256 B").
         */
        private static string format_size (int bytes) {
            if (bytes >= 1024 * 1024) {
                return "%.1f MB".printf ((double) bytes / (1024 * 1024));
            } else if (bytes >= 1024) {
                return "%.1f KB".printf ((double) bytes / 1024);
            } else {
                return "%d B".printf (bytes);
            }
        }
    }
}
