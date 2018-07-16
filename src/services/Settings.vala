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

using Ciano.Utils;

namespace Ciano.Services {

    public class Settings : Granite.Services.Settings {

        private static Settings? instance;

        //public bool continue_conversion;
        public int simultaneous_conversion;
        //public bool delete_source_files;
        //public bool delete_files_conversion_fails;
        //public bool open_output_folder_end;
        //public bool suspend_computer;
        //public bool off_computer;
        public int window_x;
        public int window_y;
        public int window_height;
        public int window_width;
        public int theme;
        public int language;
        public string output_folder;
        public bool output_source_file_folder;
        public bool shutdown_computer;
        public bool open_output_folder;
        public bool complete_notify;
        public bool error_notify;
        
        

        private Settings () {
            base ("com.github.robertsanseries.ciano");

            if (StringUtil.is_empty (this.output_folder)) {
                this.output_folder = Path.build_path (
                    Path.DIR_SEPARATOR_S, 
                    Environment.get_user_data_dir (), 
                    "ciano"
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