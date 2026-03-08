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

using Ciano.Enums;

namespace Ciano.Objects {

    /**
     * The ItemConversion class represents an active or pending conversion task.
     * It stores metadata about the file, its target format, and current progress.
     *
     * @see Ciano.Enums.TypeItemEnum
     * @since 0.1.0
     */
    public class ItemConversion : Object {

        /**
         * Unique identifier for the conversion item.
         */
        public int id { get; set; }

        /**
         * The display name of the file.
         */
        public string name { get; set; }

        /**
         * The absolute path to the directory containing the file.
         */
        public string directory { get; set; }

        /**
         * The target format for the conversion (e.g., "MP3", "MP4").
         */
        public string convert_to { get; set; default = ""; }

        /**
         * The current progress fraction (from 0.0 to 1.0).
         */
        public double progress { get; set; default = 0.0; }

        /**
         * The media type category of the item.
         */
        public TypeItemEnum type_item { get; set; }

        /**
         * Constructs a new ItemConversion instance.
         *
         * @param id Unique ID.
         * @param name File name.
         * @param directory File path.
         * @param convert_to Target extension.
         * @param progress Initial progress value.
         * @param type_item Media type (Video, Audio, or Image).
         */
        public ItemConversion (
            int id,
            string name,
            string directory,
            string? convert_to,
            double? progress,
            TypeItemEnum type_item
        ) {
            this.id = id;
            this.name = name;
            this.directory = directory;
            this.type_item = type_item;

            if (convert_to != null) {
                this.convert_to = convert_to;
            }

            if (progress != null) {
                this.progress = progress;
            }
        }
    }
}
