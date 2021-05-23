/*
 * Copyright (c) 2017-2018 Robert San <robertsanseries@gmail.com>
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

namespace Ciano.Models.Objects {

    public class ArchiveBuilder {

        public Archive archive;

        public ArchiveBuilder () {
            this.archive = new Archive ();
        }

        public ArchiveBuilder set_name (string name) {
            this.archive.name = name;
            return this;
        } 

        public ArchiveBuilder set_size (long size) {
            this.archive.size = size;
            return this;
        }

        public ArchiveBuilder set_converted_size (long converted_size) {
            this.archive.converted_size = converted_size;
            return this;
        }

        public ArchiveBuilder set_percentage (int percentage) {
            this.archive.percentage = percentage;
            return this;
        }    

        public ArchiveBuilder set_progress (double progress) {
            this.archive.progress = progress;
            return this;
        }

        public ArchiveBuilder set_duration (string duration) {
            this.archive.duration = duration;
            return this;
        }

        public ArchiveBuilder set_status (string status) {
            this.archive.status = status;
            return this;
        }

        public ArchiveBuilder set_directory (string directory) {
            this.archive.directory = directory;
            return this;
        }

        public ArchiveBuilder set_uri (string uri) {
            this.archive.uri = uri;
            return this;
        }

        public Archive get_archive () {
            return this.archive;
        }         
    }
}