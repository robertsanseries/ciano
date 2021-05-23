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

namespace Ciano.Widgets {

    public class HeaderBar : Gtk.HeaderBar {

        public signal void icon_document_open_clicked ();
        public signal void icon_output_folder_clicked ();
        public signal void icon_start_pause_clicked ();
        public signal void icon_information_clicked ();
        public signal void icon_settings_clicked ();
        public signal void icon_about_clicked ();
        public signal void radio_button_color_clicked (int theme);

        public Gtk.Button document_open           { get; private set;}
        public Gtk.Button output_folder           { get; private set;}
        public Gtk.Button start_pause             { get; private set;}
        public Gtk.Button pause                   { get; private set;}
        public Gtk.Button information             { get; private set;}
        public Gtk.MenuButton settings            { get; private set;}
        public Gtk.Button button_color_elementary { get; private set;}
        public Gtk.Button button_color_ciano      { get; private set;}
        public Gtk.Button button_color_dark       { get; private set;}
        public Gtk.ToggleButton focusmode_button  { get; private set;}

        private bool start = true;

        public HeaderBar () {
            this.title = "Ciano";
            this.set_show_close_button (true);

            this.document_open = new Gtk.Button ();
            this.document_open.set_image (new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR));
            this.document_open.tooltip_text = (_("Add files to convert"));
            this.document_open.clicked.connect (() => { icon_document_open_clicked (); });

            this.output_folder = new Gtk.Button ();
            this.output_folder.set_image (new Gtk.Image.from_icon_name ("folder-saved-search", Gtk.IconSize.LARGE_TOOLBAR));
            this.output_folder.tooltip_text = (_("Open output folder"));
            this.output_folder.clicked.connect (() => { icon_output_folder_clicked (); });

            this.start_pause = new Gtk.Button ();
            this.start_pause.set_image (new Gtk.Image.from_icon_name ("media-playback-start", Gtk.IconSize.SMALL_TOOLBAR));
            this.start_pause.tooltip_text = (_("Start all conversions"));
            this.start_pause.clicked.connect (() => { icon_start_pause_clicked (); });

            this.information = new Gtk.Button ();
            this.information.set_image (new Gtk.Image.from_icon_name ("dialog-information", Gtk.IconSize.LARGE_TOOLBAR));
            this.information.tooltip_text = (_("Supported Formats"));
            this.information.clicked.connect (() => { icon_information_clicked (); });

            this.button_color_elementary = new Gtk.Button (); // selection-add.svg | object-select-symbolic | BUTTON
            this.button_color_elementary.image = new Gtk.Image.from_icon_name ("object-select-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            this.button_color_elementary.halign = Gtk.Align.CENTER;
            this.button_color_elementary.tooltip_text = _("theme elementary");
            this.button_color_elementary.height_request = 35;
            this.button_color_elementary.width_request = 35;
            this.button_color_elementary.clicked.connect(() => { radio_button_color_clicked (2); });

            var button_color_elementary_context = this.button_color_elementary.get_style_context ();
            button_color_elementary_context.add_class ("button-theme");
            button_color_elementary_context.add_class ("theme-elementary");

            this.button_color_ciano = new Gtk.Button ();
            this.button_color_ciano.image = new Gtk.Image.from_icon_name ("object-select-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            this.button_color_ciano.halign = Gtk.Align.CENTER;
            this.button_color_ciano.tooltip_text = _("theme ciano");
            this.button_color_ciano.height_request = 35;
            this.button_color_ciano.width_request = 35;
            this.button_color_ciano.clicked.connect(() => { radio_button_color_clicked (1); });

            var button_color_ciano_context = this.button_color_ciano.get_style_context ();
            button_color_ciano_context.add_class ("button-theme");
            button_color_ciano_context.add_class ("theme-ciano");

            this.button_color_dark = new Gtk.Button ();
            this.button_color_dark.image = new Gtk.Image.from_icon_name ("object-select-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            this.button_color_dark.halign = Gtk.Align.CENTER;
            this.button_color_dark.tooltip_text = _("theme dark");
            this.button_color_dark.height_request = 35;
            this.button_color_dark.width_request = 35;
            this.button_color_dark.clicked.connect(() => { radio_button_color_clicked (0); });

            var button_color_dark_context = this.button_color_dark.get_style_context ();
            button_color_dark_context.add_class ("button-theme");
            button_color_dark_context.add_class ("theme-dark");

            var box_color = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            box_color.pack_start (button_color_elementary, true, true, 0);
            box_color.pack_start (button_color_ciano, true, true, 0);
            box_color.pack_start (button_color_dark, true, true, 0);
            box_color.width_request = 200;
            box_color.margin_top = 5;
            box_color.margin_bottom = 3;

            this.focusmode_button = new Gtk.ToggleButton.with_label ((_("Focus Mode")));
            this.focusmode_button.set_image (new Gtk.Image.from_icon_name ("zoom-fit-best-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            this.focusmode_button.set_always_show_image (true);
            this.focusmode_button.tooltip_text = _("Enter focus mode");
            this.focusmode_button.margin_left = 8;
            this.focusmode_button.margin_right = 8;

            Ciano.Services.Settings settings = Ciano.Services.Settings.get_instance ();

             if (settings.focus_mode == false) {
                this.focusmode_button.set_active (false);
            } else {
                this.focusmode_button.set_active (settings.focus_mode);
            }

            this.focusmode_button.toggled.connect (() => {
    			if (this.focusmode_button.active) {
    				settings.focus_mode = true;
                    change_focus_mode_button_selected ();
    			} else {
    				settings.focus_mode = false;
                    change_focus_mode_button_selected ();
    			}

            });

            var item_preferences = new Gtk.ModelButton ();
            item_preferences.text = (_("Preferences"));
            item_preferences.clicked.connect(() => { icon_settings_clicked (); });

            var item_preferences_context = item_preferences.get_style_context ();
            item_preferences_context.add_class ("menuitem");

            var item_about = new Gtk.ModelButton ();
            item_about.text = (_("About"));
            item_about.clicked.connect(() => { icon_about_clicked (); });

            var item_about_context = item_about.get_style_context ();
            item_about_context.add_class ("menuitem");

            var menu_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            menu_separator.margin_top = 6;
            menu_separator.margin_bottom = 6;

            var list_grid = new Gtk.Grid ();
            list_grid.row_spacing = 5;
            list_grid.column_spacing = 12;
            list_grid.width_request = 200;
            list_grid.orientation = Gtk.Orientation.VERTICAL;
            list_grid.add (item_preferences);
            list_grid.add (item_about);

            var menu_grid = new Gtk.Grid ();
            menu_grid.margin_top = 10;
            menu_grid.margin_bottom = 5;
            menu_grid.row_spacing = 5;
            menu_grid.column_spacing = 12;
            menu_grid.width_request = 170;
            menu_grid.orientation = Gtk.Orientation.VERTICAL;
            menu_grid.add (focusmode_button);
            menu_grid.add (box_color);
            menu_grid.add (menu_separator);
            menu_grid.add (list_grid);
            //menu_grid.add (item_preferences);
            //menu_grid.add (item_about);
            menu_grid.show_all ();

            var style_popover = new Gtk.Popover (null);
            style_popover.add (menu_grid);

            this.settings = new Gtk.MenuButton ();
            this.settings.set_image (new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
            this.settings.tooltip_text = (_("Settings"));
            this.settings.popover = style_popover;
            
            this.pack_start (this.document_open);
            this.pack_start (this.output_folder);
            this.pack_start (this.start_pause);
            this.pack_end (this.settings);
            this.pack_end (this.information);
        }
        
        public void set_visible_icons (bool visible) {
            WidgetUtil.set_visible (this.document_open, visible);
            WidgetUtil.set_visible (this.output_folder, visible);
            WidgetUtil.set_visible (this.start_pause, visible);
            WidgetUtil.set_visible (this.information, visible);
        }

        public void set_visible_icon_document_open (bool visible) {
            WidgetUtil.set_visible (this.document_open, visible);
        }

        public void set_visible_icon_output_folder (bool visible) {
            WidgetUtil.set_visible (this.output_folder, visible);
        }

        public void set_visible_icon_start (bool visible) {
            WidgetUtil.set_visible (this.start_pause, visible);
        }

        public void set_visible_icon_information (bool visible) {
            WidgetUtil.set_visible (this.information, visible);
        }

        public void change_icon_start_pause () {

            Ciano.Services.Settings settings = Ciano.Services.Settings.get_instance ();

            if(this.start) {
                this.start = false;
                
                if (!this.focusmode_button.active) {
                    this.start_pause.set_image (new Gtk.Image.from_icon_name ("media-playback-pause", Gtk.IconSize.SMALL_TOOLBAR));
			    } else {
                    this.start_pause.set_image (new Gtk.Image.from_icon_name ("media-playback-pause-symbolic", Gtk.IconSize.SMALL_TOOLBAR));				    
                }
			
                this.start_pause.tooltip_text = (_("Pause all conversions"));
                this.start_pause.show_all ();
            } else {
                this.start = true;
                if (!this.focusmode_button.active) {
                    this.start_pause.set_image (new Gtk.Image.from_icon_name ("media-playback-start", Gtk.IconSize.SMALL_TOOLBAR));
			    } else {
                    this.start_pause.set_image (new Gtk.Image.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.SMALL_TOOLBAR));				    
                }
                
                this.start_pause.tooltip_text = (_("Start all conversions"));
                this.start_pause.show_all ();
            }

            
        }

        public void change_radio_button_selected (int theme) {
            switch (theme) {
                case 0:
                    button_color_dark.image = new Gtk.Image.from_icon_name ("object-select-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
                    button_color_elementary.image = null;
                    button_color_ciano.image = null;
                    break;
                case 1:
                    button_color_ciano.image = new Gtk.Image.from_icon_name ("object-select-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
                    button_color_elementary.image = null;
                    button_color_dark.image = null;
                    break;
                case 2:
                    button_color_elementary.image = new Gtk.Image.from_icon_name ("object-select-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
                    button_color_ciano.image = null;
                    button_color_dark.image = null;
                    break;
            }

            button_color_elementary.show_all ();
            button_color_ciano.show_all ();
            button_color_dark.show_all ();
        }

        public void change_focus_mode_button_selected () {
            Ciano.Services.Settings settings = Ciano.Services.Settings.get_instance ();

            if (settings.focus_mode) {
                this.document_open.set_image (new Gtk.Image.from_icon_name ("document-open-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
                this.output_folder.set_image (new Gtk.Image.from_icon_name ("folder-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
                this.start_pause.set_image (new Gtk.Image.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
                this.pause.set_image (new Gtk.Image.from_icon_name ("media-playback-pause-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
                this.information.set_image (new Gtk.Image.from_icon_name ("dialog-information-symbolic", Gtk.IconSize.LARGE_TOOLBAR));
                this.settings.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
this.show_all();
            } else {
                this.document_open.set_image (new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR));
                this.output_folder.set_image (new Gtk.Image.from_icon_name ("folder-saved-search", Gtk.IconSize.LARGE_TOOLBAR));
                this.start_pause.set_image (new Gtk.Image.from_icon_name ("media-playback-start", Gtk.IconSize.SMALL_TOOLBAR));
                this.pause.set_image (new Gtk.Image.from_icon_name ("media-playback-pause", Gtk.IconSize.LARGE_TOOLBAR));
                this.information.set_image (new Gtk.Image.from_icon_name ("dialog-information", Gtk.IconSize.LARGE_TOOLBAR));
                this.settings.image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
this.show_all();
           }
        }


    }
}
