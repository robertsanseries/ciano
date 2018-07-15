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

using Ciano.Widgets;

namespace Ciano.Facades {

	public class DialogFacade : Object {

	    public DialogFacade () { }

	    public static void open_dialog_preferences (Gtk.Window window) {
        	DialogPreferences dialog_preferences = new DialogPreferences (window);
            dialog_preferences.show_all ();
        }

        public static void open_dialog_informations (Gtk.Window window) {
        	DialogInformations dialog_informations = new DialogInformations (window);
            dialog_informations.show_all ();
        }

        public static void open_dialog_about (Gtk.Window window) {
            DialogAbout dialog_about = new DialogAbout (window);
            dialog_about.show_all ();
        }
	}
}