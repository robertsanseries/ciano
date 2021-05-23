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

using Ciano.Config;
using Ciano.Enums;
using Ciano.Helpers;
using Ciano.Models.Objects;
using Ciano.Utils;
using Ciano.Widgets;
using Ciano.Views.Factory;
using Ciano.Controllers;

namespace Ciano.Views {

    public class ApplicationView : Gtk.ApplicationWindow {

        public Gtk.Stack stack;
        public ActionController action;
        public Widgets.HeaderBar headerbar;
        public ConversionListBox conversion_list;
        
        public ApplicationView (Gtk.Application application, ActionController action) {
            this.application = application;
            this.action = action;
            this.resizable = true;
            this.window_position = Gtk.WindowPosition.CENTER;
            this.set_default_size (500, 400);
            this.set_size_request (500, 400);
            this.get_style_context ().add_class ("window-background-color");
            
            this.begin_event ();
            this.headerbar = new Widgets.HeaderBar ();
            this.load_css_provider ();

            this.headerbar.icon_document_open_clicked.connect (() => { 
                this.open_dialog_file_chooser ();
            });

            this.headerbar.icon_output_folder_clicked.connect (() => { 
                this.open_dialog_file_chooser ();
            }); 

            this.headerbar.icon_start_pause_clicked.connect (() => { 
                this.headerbar.change_icon_start_pause ();
            }); 

            this.headerbar.icon_information_clicked.connect (() => { 
                DialogFactory.open_dialog (this, DialogEnum.INFORMATIONS);
            }); 
            
            this.headerbar.icon_settings_clicked.connect (() => { 
                DialogFactory.open_dialog (this, DialogEnum.PREFERENCES);
            });

            this.headerbar.icon_about_clicked.connect (() => { 
                DialogFactory.open_dialog (this, DialogEnum.ABOUT);
            });

            this.headerbar.radio_button_color_clicked.connect ((theme) => {
                this.load_css_provider (theme);
            });
           
            this.headerbar.set_visible_icons(false);

            Widgets.Welcome welcome = new Widgets.Welcome ();
            welcome.activated.connect ((index) => {
                switch (index) {
                    case 0:
                        this.open_dialog_file_chooser ();
                        break;
                    case 1:
                        DialogFactory.open_dialog (this, DialogEnum.INFORMATIONS);
                        break;
                 }
            });

            this.conversion_list = new ConversionListBox ();

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.hscrollbar_policy = Gtk.PolicyType.NEVER;
            scrolled.add (this.conversion_list);

            this.stack = new Gtk.Stack ();
            this.stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            this.stack.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            this.stack.add_named (welcome, Constants.WELCOME_VIEW);
            this.stack.add_named (scrolled, Constants.CONVERSION_VIEW);

            this.set_titlebar (headerbar);
            this.add (this.stack);
            this.show_all ();
        }

        public void load_css_provider (int? radio_button_value = null) {
            Ciano.Services.Settings settings = Ciano.Services.Settings.get_instance ();
            Gtk.Settings gtk_settings = Gtk.Settings.get_default ();
            Gtk.CssProvider css_provider = new Gtk.CssProvider ();

            int theme = settings.theme;

            if(radio_button_value != null) {
                theme = radio_button_value;
            }

            switch (theme) {
                case 0:
                    this.headerbar.change_radio_button_selected (theme);
                    gtk_settings.gtk_application_prefer_dark_theme = true;
                    css_provider.load_from_resource ("com/github/robertsanseries/ciano/css/dark.css");
                    settings.theme = 0;
                    break;
                case 1:
                    this.headerbar.change_radio_button_selected (theme);
                    gtk_settings.gtk_application_prefer_dark_theme = false;
                    css_provider.load_from_resource ("com/github/robertsanseries/ciano/css/ciano.css");
                    settings.theme = 1;
                    break;
                case 2:
                    this.headerbar.change_radio_button_selected (theme);
                    gtk_settings.gtk_application_prefer_dark_theme = false;
                    css_provider.load_from_resource ("com/github/robertsanseries/ciano/css/elementary.css");
                    settings.theme = 2;
                    break;
            }

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (), css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

        private void open_dialog_file_chooser () {
            Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog (
                "Select packages to install",
                this,
                Gtk.FileChooserAction.OPEN
            );

            chooser.add_buttons (
                _("Cancel"), Gtk.ResponseType.CANCEL,
                _("Open"), Gtk.ResponseType.ACCEPT
            );

            Gtk.FileFilter filter = new Gtk.FileFilter ();
            foreach (string format in FormatsHelper.get_supported_types ()) {
                filter.add_pattern ("*.".concat (format.down ()));
            } 

            chooser.select_multiple = true;
            chooser.set_filter (filter);

            chooser.response.connect ((response) => {
                if (response == Gtk.ResponseType.ACCEPT) {
                    SList<string> uris = chooser.get_filenames ();

                    int count = 0;

                    foreach (unowned string uri in uris)  {

                        ArchiveBuilder builder = new ArchiveBuilder ();
                        builder.set_name ("nome do video");
                        builder.set_progress (1);
                        builder.set_status ("carregando...");

                        this.conversion_list.add_archive ("media-playback-start-symbolic", builder.get_archive ());
                        //this.conversion_list.add_archive ("media-playback-pause-symbolic", builder.get_archive ());
                        //this.conversion_list.add_archive ("process-completed", builder.get_archive ());
                        
                        this.conversion_list.show_all ();

                       // this.action 
                        var file         = File.new_for_uri (uri);
                        int index        = file.get_basename ().last_index_of("/");
                        string name      = file.get_basename ().substring(index + 1, -1);
                        string directory = file.get_basename ().substring(0, index + 1);

                        message ("name: ".concat(name).concat(" directory: ").concat(directory));
                        count++;
                    }

                    if (count > 0) {
                        this.stack.visible_child_name = Constants.CONVERSION_VIEW;
                        this.headerbar.set_visible_icons(true);   
                    }
                    
                    chooser.destroy ();
                } else {
                    chooser.destroy ();
                }
            });

            chooser.run ();
        }

        private void begin_event () {
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