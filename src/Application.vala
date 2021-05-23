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

using Ciano.Controllers;
using Ciano.Database;
using Ciano.Views;

namespace Ciano {

    public class Application : Granite.Application {

        private ApplicationView _window;

        public Application () {
            Object (
                application_id: "com.github.robertsanseries.ciano",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }

        public override void activate () {
            if (this._window == null) {
                SQLiteSchemaHandler.init_loader ();
                ActionController action = new ActionController ();
                this._window = new ApplicationView (this, action);
                this.add_window (this._window);
                this._window.show_all ();
            }

            SimpleAction quit_action = new SimpleAction ("quit", null);
            quit_action.activate.connect (() => {
                if (this._window != null) {
                    this._window.destroy ();
                }
            });

            this.add_action (quit_action);
            this.add_accelerator ("<Control>q", "app.quit", null);
        }
    }
}