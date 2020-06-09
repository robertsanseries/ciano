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

using Ciano.Configs;
using Ciano.Utils;

namespace Ciano.Services {

    /**
     * The {@code Settings} class is responsible for defining all 
     * the texts that are displayed in the application and must be translated.
     *
     * @see Granite.Services.Settings
     * @since 0.1.0
     */
    public class Settings : Granite.Services.Settings {

        /**
         * This static property represents the {@code Settings} type.
         */
        private static Settings? instance;

        /**
         * This property will represent the location x of the screen.
         * Variable of type {@code int} as declared.
         */
        public int window_x { get; set; }

        /**
         * This property will represent the location y of the screen.
         * Variable of type {@code int} as declared.
         */
        public int window_y { get; set; }

        /**
         * This property will receive the name of the output folder which
         * can be altered through dialog preferences.
         * Variable of type {@code string} as declared.
         */
        public string output_folder    { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if option
         * save the converted files to the same folder "is active on the 
         * dialog Preferences. If the option is not activated the value of the same
         * will be {@code false} and the application will use {@code output_folder} 
         * as the standard output.
         */
        public bool output_source_file_folder { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if option
         * "shutdown computer" in dialog preferences is enabled the computer will
         * shutdown when all conversions are finished. 
         * Otherwise the value will be {@code false}.
         */
        public bool shutdown_computer { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if
         * the "open output folder" option in dialog preferences is enabled by opening
         * an output folder after completing all conversions. Otherwise,
         * the value will be {@code false}.
         */
        public bool open_output_folder { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if 
         * the "complete notify" option in the dialog preferences is enabled by
         * displaying a notification at the end of the conversion.
         * Otherwise, the value will be {@code false}.
         */
        public bool complete_notify { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if
         * the "complete notify" option in the dialog preferences is enabled
         * by displaying a notification when there is a conversion error. 
         * Otherwise, the value will be {@code false}.
         */
        public bool error_notify { get; set; }

        /**
         * Constructs a new {@code Settings} object 
         * and sets the default exit folder.
         * 
         * @see Ciano.Utils.StringUtil#is_empty(string)
         * @see Ciano.Constants
         */
        private Settings () {
            base (Constants.ID);

            if (StringUtil.is_empty (this.output_folder)) {
                this.output_folder = Environment.get_home_dir () + Constants.DIRECTORY_CIANO;
            }
        }

        /**
         * Returns a single instance of this class.
         * 
         * @return {@code Settings}
         */
        public static unowned Settings get_instance () {
            if (instance == null) {
                instance = new Settings ();
            }

            return instance;
        }
    }
}