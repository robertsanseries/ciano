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

using Alvane.Utils;

namespace Ciano.Services {

    public class Settings : Granite.Services.Settings {

        private static Settings? instance;

        public int window_x                       { get; set; }
        public int window_y                       { get; set; }
        public int window_height                  { get; set; }
        public int window_width                   { get; set; }
        public int theme                          { get; set; }
        public bool focus_mode                    { get; set; }
        public int simultaneous_conversion        { get; set; }
        public bool output_source_file_folder     { get; set; }
        public bool shutdown_computer             { get; set; }
        public bool open_output_folder            { get; set; }
        public bool complete_notify               { get; set; }
        public bool error_notify                  { get; set; }
        public bool off_computer                  { get; set; }
        public bool continue_conversion           { get; set; }
        public bool delete_source_files           { get; set; }
        public bool delete_files_conversion_fails { get; set; }
        public bool open_output_folder_end        { get; set; }
        public bool suspend_computer              { get; set; }
        public string output_folder               { get; set; }

        private Settings () {
            base ("com.github.robertsanseries.ciano");

            if (StringUtil.is_empty (this.output_folder)) {
                this.output_folder = Path.build_path (
                    Path.DIR_SEPARATOR_S, Environment.get_user_data_dir (), "ciano"
                );
            }
        }

        public static unowned Settings get_instance () {
            if (instance == null) {
                instance = new Settings ();
            }

            return instance;
        }
    }
}
