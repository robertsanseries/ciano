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

using Ciano.Widgets;

namespace Ciano.Services {

    /**
     * The {@code DialogManager} class is responsible for defining all 
     * the texts that are displayed in the application and must be translated.
     *
     * @since 0.1.0
     */
    public class DialogManager : Object {

        /**
         * This static property represents the {@code DialogManager} type.
         */
        private static DialogManager? instance;

        /**
         * Constructs a new {@code DialogManager} object 
         * and sets the default exit folder.
         */
        private DialogManager () { }

        public void open_dialog_preferences (Gtk.Window window) {
        	DialogPreferences dialog_preferences = new DialogPreferences (window);
            dialog_preferences.show_all ();
        }

        public void open_dialog_informations (Gtk.Window window) {
        	DialogInformations dialog_informations = new DialogInformations (window);
            dialog_informations.show_all ();
        }

        public void open_dialog_about () {
            DialogAbout dialog_about = new DialogAbout ();
            dialog_about.response.connect(() => { dialog_about.destroy (); });
        }

        /**
         * Returns a single instance of this class.
         * 
         * @return {@code DialogManager}
         */
        public static unowned DialogManager get_instance () {
            if (instance == null) {
                instance = new DialogManager ();
            }

            return instance;
        }
    }
}