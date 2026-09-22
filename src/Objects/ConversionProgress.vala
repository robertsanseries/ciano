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

namespace Ciano.Objects {

    /**
     * The ConversionProgress class holds the progress state of a single FFmpeg
     * conversion while its output is parsed by {@link Ciano.Utils.FFmpegUtil.parse_progress}.
     *
     * Each conversion must use its own instance, so simultaneous conversions
     * never show each other's values.
     *
     * @since 0.2.5
     */
    public class ConversionProgress : Object {

        /**
         * Total duration of the input in seconds, 0 while unknown.
         */
        public int total_seconds { get; set; default = 0; }

        /**
         * Last output size reported by FFmpeg, already formatted (e.g. "1.4 MB").
         */
        public string size { get; set; default = ""; }

        /**
         * Last bitrate reported by FFmpeg (e.g. "1351.6kbits/s").
         */
        public string bitrate { get; set; default = ""; }
    }
}
