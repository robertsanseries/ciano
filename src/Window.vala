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
using Ciano.Widgets;
using Ciano.Facades;

namespace Ciano {

    public class Window : Gtk.ApplicationWindow {
         
        public Window (Gtk.Application app) {
            Object (
                application: app,
                resizable: true
            );

            this.window_position = Gtk.WindowPosition.CENTER;
            this.set_default_size (500, 400);
            this.set_size_request (500, 400);
            this.get_style_context ().add_class ("window-background-color");
            
            this.load_window_position_size ();
            this.style_provider ();

            Widgets.HeaderBar headerbar = new Widgets.HeaderBar ();
            
            headerbar.icon_settings_clicked.connect (() => { 
                DialogFacade.open_dialog_preferences (this);
            });

            headerbar.icon_report_problem_clicked.connect (() => { 
                CoreUtil.launch_uri ("https://github.com/robertsanseries/ciano/issues");
            });           

            headerbar.icon_about_clicked.connect (() => { 
                DialogFacade.open_dialog_about (this);
            });
           
            headerbar.set_visible_icons(false);

            Widgets.Welcome welcome = new Widgets.Welcome ();
            welcome.activated.connect ((index) => {
                switch (index) {
                    case 0:
                        
                        break;
                    case 1:
                        DialogFacade.open_dialog_informations (this);
                        break;
                 }
            });

            Gtk.Stack stack = new Gtk.Stack ();
            stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            stack.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            stack.add_named (welcome, "WELCOME_ID");

            this.set_titlebar (headerbar);
            this.add (stack);
            this.show_all ();
        }

        public void style_provider () {
            Ciano.Services.Settings settings = Ciano.Services.Settings.get_instance ();
            Gtk.Settings gtk_settings = Gtk.Settings.get_default ();
            Gtk.CssProvider css_provider = new Gtk.CssProvider ();

            switch (settings.theme) {
                case 0:
                    gtk_settings.gtk_application_prefer_dark_theme = true;
                    css_provider.load_from_resource ("com/github/robertsanseries/ciano/css/dark.css");
                    break;
                case 1:
                    gtk_settings.gtk_application_prefer_dark_theme = false;
                    css_provider.load_from_resource ("com/github/robertsanseries/ciano/css/default.css");
                    break;
                case 2:
                    gtk_settings.gtk_application_prefer_dark_theme = false;
                    css_provider.load_from_resource ("com/github/robertsanseries/ciano/css/elementary.css");
                    break;
            }

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (), css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

        private void load_window_position_size () {
            Ciano.Services.Settings settings = Ciano.Services.Settings.get_instance ();
            int x = settings.window_x;
            int y = settings.window_y;
            int h = settings.window_height;
            int w = settings.window_width;

            if (x != -1 && y != -1) {
                this.move (x, y);
            }

            if (w != 0 && h != 0) {
                this.resize (w, h);
            }
        }

        public override bool delete_event (Gdk.EventAny event) {
            int x, y, w, h;
            this.get_position (out x, out y);
            this.get_size (out w, out h);

            Ciano.Services.Settings settings = Ciano.Services.Settings.get_instance ();
            settings.window_x = x;
            settings.window_y = y;
            settings.window_width = w;
            settings.window_height = h;

            return false;
        }
    }
}