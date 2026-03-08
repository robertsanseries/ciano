/*
 * Copyright (c) 2017 Robert San <robertsanseries@gmail.com>
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
     * The TimeUtil class provides utility methods for handling and 
     * converting time-related data and formats.
     *
     * @since 0.1.0
     */
    public class TimeUtil {

        /**
         * Parses a duration string in "HH:MM:SS" format (optionally including 
         * milliseconds or additional frames) and returns the total value in seconds.
         *
         * Example:
         * {{{
         * TimeUtil.duration_in_seconds ("00:01:14.00") = 74
         * }}}
         *
         * @param duration The duration string to parse.
         * @return The total duration in seconds, or 0 if the format is invalid.
         */
        public static int duration_in_seconds (string? duration) {
            if (StringUtil.is_blank (duration) || duration.contains ("N/A")) {
                return 0;
            }

            // Remove milliseconds/frames if present and split by time separators
            var clean_duration = duration.split (".")[0];
            var parts = clean_duration.split (":");

            // Basic validation for HH:MM:SS structure
            if (parts.length < 3) {
                return 0;
            }

            // Convert parts to integers and calculate total seconds
            var hours = int.parse (parts[0]);
            var mins = int.parse (parts[1]);
            var secs = int.parse (parts[2]);

            return secs + (hours * 3600) + (mins * 60);
        }
    }
}
