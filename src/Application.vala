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
*
*/

using Ciano.Configs;

namespace Ciano {

    /**
     * The {@code Application} class is a foundation for all granite-based applications.
     *
     * @see Granite.Application
     * @since 0.1.0
     */
    public class Application : Granite.Application {

        private Window window { get; private set; default = null; }

        /**
         * Constructs a new {@code Application} object and create default output folder if it does not exist.
         *
         * @see Ciano.Configs.Constants
         */
        public Application () {
            Object (
                application_id: Constants.ID,
                flags: ApplicationFlags.FLAGS_NONE
            );
        }


        /**
         * Create the window of this application through the class {@code Window} and show it. If user clicks
         * <quit> or press <control + q> the window will be destroyed.
         *
         * @return {@code void}
         */
        public override void activate () {
            if (window == null) {
                window = new Window (this);
                add_window (window);
                window.show_all ();
            }

            var quit_action = new SimpleAction ("quit", null);
            quit_action.activate.connect (() => {
                if (window != null) {
                    window.destroy ();
                }
            });

            add_action (quit_action);
            set_accels_for_action ("app.quit", {"<Ctrl>q"});
        }
    }
}

