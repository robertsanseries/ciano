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
        public signal void icon_start_clicked ();
        public signal void icon_information_clicked ();
        public signal void icon_settings_clicked ();
        public signal void icon_report_problem_clicked ();
        public signal void icon_about_clicked ();

        public Gtk.Button document_open { get; private set;}
        public Gtk.Button output_folder { get; private set;}
        public Gtk.Button start         { get; private set;}
        public Gtk.Button information   { get; private set;}
        public Gtk.MenuButton settings  { get; private set;}

        public HeaderBar () {
            this.title = "Ciano";
            this.set_show_close_button (true);

            this.document_open = new Gtk.Button ();
            this.document_open.set_image (new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR));
            this.document_open.tooltip_text = (_("Open output folder"));
            this.document_open.clicked.connect (() => { icon_document_open_clicked (); });

            this.output_folder = new Gtk.Button ();
            this.output_folder.set_image (new Gtk.Image.from_icon_name ("folder-saved-search", Gtk.IconSize.LARGE_TOOLBAR));
            this.output_folder.tooltip_text = (_("Open output folder"));
            this.output_folder.clicked.connect (() => { icon_output_folder_clicked (); });

            this.start = new Gtk.Button ();
            this.start.set_image (new Gtk.Image.from_icon_name ("media-playback-start", Gtk.IconSize.LARGE_TOOLBAR));
            this.start.tooltip_text = (_("Open output folder"));
            this.start.clicked.connect (() => { icon_start_clicked (); });

            this.information = new Gtk.Button ();
            this.information.set_image (new Gtk.Image.from_icon_name ("dialog-information", Gtk.IconSize.LARGE_TOOLBAR));
            this.information.tooltip_text = (_("Open output folder"));
            this.information.clicked.connect (() => { icon_information_clicked (); });
            
            Gtk.MenuItem item_preferences = new Gtk.MenuItem.with_label (_("Preferences"));
            item_preferences.activate.connect(() => { icon_settings_clicked (); });

            Gtk.MenuItem item_report_problem = new Gtk.MenuItem.with_label (_("Report a Problem…"));
            item_report_problem.activate.connect (() => { icon_report_problem_clicked (); });

            Gtk.MenuItem item_about = new Gtk.MenuItem.with_label (_("About"));
            item_about.activate.connect(() => { icon_about_clicked (); });
            
            Gtk.Menu menu = new Gtk.Menu ();
            menu.add (item_preferences);
            menu.add (new Gtk.SeparatorMenuItem());
            menu.add (item_report_problem);
            menu.add (item_about);
            menu.show_all ();

            this.settings = new Gtk.MenuButton ();
            this.settings.set_image (new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
            this.settings.tooltip_text = (_("Settings"));
            this.settings.popup = menu;
            
            this.pack_start (this.document_open);
            this.pack_start (this.output_folder);
            this.pack_start (this.start);
            this.pack_end (this.settings);
            this.pack_end (this.information);
        }
        
        public void set_visible_icons (bool visible) {
            WidgetUtil.set_visible (this.document_open, visible);
            WidgetUtil.set_visible (this.output_folder, visible);
            WidgetUtil.set_visible (this.start, visible);
            WidgetUtil.set_visible (this.information, visible);
        }

        public void set_visible_icon_document_open (bool visible) {
            WidgetUtil.set_visible (this.document_open, visible);
        }

        public void set_visible_icon_output_folder (bool visible) {
            WidgetUtil.set_visible (this.output_folder, visible);
        }

        public void set_visible_icon_start (bool visible) {
            WidgetUtil.set_visible (this.start, visible);
        }

        public void set_visible_icon_information (bool visible) {
            WidgetUtil.set_visible (this.information, visible);
        }
    }
}