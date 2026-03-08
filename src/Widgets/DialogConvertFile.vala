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

using Ciano.Utils;
using Ciano.Enums;
using Ciano.Controllers;
using Ciano.Objects;

namespace Ciano.Widgets {

    /**
     * DialogConvertFile provides an interface for users to manage files
     * before starting the conversion process.
     */
    public class DialogConvertFile : Gtk.Dialog {

        private string[] formats;
        private string name_format;
        private Gtk.ColumnView column_view;
        private GLib.ListStore list_store;
        private Gtk.SingleSelection selection;
        private ConverterController converter_controller;

        /**
         * Constructs a new DialogConvertFile.
         * @param converter_controller The application controller.
         * @param formats Array of supported output formats.
         * @param name_format The specific format selected.
         * @param parent The parent window.
         */
        public DialogConvertFile (
            ConverterController converter_controller,
            string[] formats,
            string name_format,
            Gtk.Window parent
        ) {
            Object (
                    transient_for: parent,
                    modal: true
            );

            this.title = _("Convert File");
            this.set_resizable (false);
            this.converter_controller = converter_controller;
            this.formats = formats;
            this.name_format = name_format;
            this.set_default_size (600, 400);
            this.add_css_class ("dialog-convert-file");

            // Setup HeaderBar without title buttons for a cleaner look
            var header = new Gtk.HeaderBar ();
            header.set_show_title_buttons (false);
            this.set_titlebar (header);

            this.build_ui ();
        }

        /**
         * Builds the main UI layout.
         */
        private void build_ui () {
            var root = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);
            root.margin_start = 20;
            root.margin_end = 20;
            root.margin_top = 15;
            root.margin_bottom = 15;

            var title_label = new Gtk.Label ("");
            title_label.set_markup (
                    "<span size='large' weight='bold'>%s %s</span>".printf (
                            _("Convert to"), name_format
                    )
            );
            title_label.halign = Gtk.Align.START;

            var description_label = new Gtk.Label (_("Add items to conversion:"));
            description_label.halign = Gtk.Align.START;
            description_label.add_css_class ("dim-label");

            var list_container = this.mount_list_container ();
            var action_box = this.mount_action_buttons ();

            root.append (title_label);
            root.append (description_label);
            root.append (list_container);
            root.append (action_box);

            this.set_child (root);
        }

        /**
         * Creates the list area using a ColumnView to display headers.
         * @return The list container widget.
         */
        private Gtk.Widget mount_list_container () {
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.add_css_class ("view");
            box.vexpand = true;

            // Model and Selection setup
            list_store = new GLib.ListStore (typeof (FileItem));
            selection = new Gtk.SingleSelection (list_store);

            // Initialize ColumnView
            column_view = new Gtk.ColumnView (selection);
            column_view.vexpand = true;
            column_view.hexpand = true;
            column_view.add_css_class ("data-table");

            // Add Columns
            this.append_column (_("Name"), true);
            this.append_column (_("Directory"), false);

            var scrolled = new Gtk.ScrolledWindow ();
            scrolled.set_child (column_view);
            scrolled.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
            scrolled.vexpand = true;

            var toolbar = this.mount_inline_toolbar ();

            box.append (scrolled);
            box.append (toolbar);

            var frame = new Gtk.Frame (null);
            frame.set_child (box);

            return frame;
        }

        /**
         * Helper to append a column to the ColumnView with Tooltip support.
         * @param title Column title.
         * @param is_name Whether this is the 'Name' or 'Directory' column.
         */
        private void append_column (string title, bool is_name) {
            var factory = new Gtk.SignalListItemFactory ();

            // Setup: Create the cell widget
            factory.setup.connect ((item) => {
                var list_item = (Gtk.ListItem) item;
                var label = new Gtk.Label ("");
                label.halign = Gtk.Align.START;
                label.margin_start = 12;
                label.margin_end = 12;
                label.ellipsize = Pango.EllipsizeMode.END;

                if (!is_name) {
                    label.add_css_class ("dim-label");
                }

                list_item.set_child (label);
            });

            // Bind: Populate widget and set Tooltip
            factory.bind.connect ((item) => {
                var list_item = (Gtk.ListItem) item;
                var file_item = (FileItem) list_item.get_item ();
                var label = (Gtk.Label) list_item.get_child ();

                string content = is_name ? file_item.name : file_item.directory;
                label.label = content;

                // Set the tooltip to show the full value on hover
                label.tooltip_text = content;
            });

            var col = new Gtk.ColumnViewColumn (title, factory);
            col.expand = true;
            column_view.append_column (col);
        }

        /**
         * Creates the inline toolbar for adding and removing files.
         * @return The toolbar widget.
         */
        private Gtk.Widget mount_inline_toolbar () {
            var toolbar = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            toolbar.add_css_class ("inline-toolbar");

            var btn_add = new Gtk.Button.from_icon_name ("list-add-symbolic");
            btn_add.tooltip_text = _("Add file");
            btn_add.clicked.connect (() => {
                this.converter_controller.on_activate_button_add_file (this.list_store, this.formats);
            });

            var btn_remove = new Gtk.Button.from_icon_name ("list-remove-symbolic");
            btn_remove.tooltip_text = _("Delete");
            btn_remove.sensitive = false;

            btn_remove.clicked.connect (() => {
                var pos = selection.get_selected ();
                if (pos != Gtk.INVALID_LIST_POSITION) {
                    list_store.remove (pos);
                }
            });

            // Update remove button sensitivity based on selection
            selection.notify["selected"].connect (() => {
                btn_remove.sensitive = selection.get_selected () != Gtk.INVALID_LIST_POSITION;
            });

            toolbar.append (btn_add);
            toolbar.append (btn_remove);

            return toolbar;
        }

        /**
         * Creates the bottom action buttons.
         * @return The action box widget.
         */
        private Gtk.Widget mount_action_buttons () {
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
            box.halign = Gtk.Align.END;
            box.margin_top = 8;

            var btn_cancel = new Gtk.Button.with_label (_("Cancel"));
            btn_cancel.clicked.connect (() => { this.destroy (); });

            var btn_convert = new Gtk.Button.with_label (_("Start conversion"));
            btn_convert.add_css_class ("suggested-action");
            btn_convert.clicked.connect (() => {
                this.converter_controller.on_activate_button_start_conversion (this.list_store, this.name_format);
                this.destroy ();
            });

            box.append (btn_cancel);
            box.append (btn_convert);

            return box;
        }
    }
}
