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

namespace Ciano.Objects {

    /**
     * The FileItem class represents a file object within the application,
     * storing its name and the path to its directory.
     *
     * @since 0.1.0
     */
    public class FileItem : Object {

        /**
         * The display name of the file (e.g., "video.mp4").
         */
        public string name { get; set; }

        /**
         * The absolute path to the directory containing the file.
         */
        public string directory { get; set; }

        /**
         * Constructs a new FileItem instance.
         *
         * @param name The name of the file.
         * @param directory The path to the file's directory.
         */
        public FileItem (string name, string directory) {
            this.name = name;
            this.directory = directory;
        }
    }
}
