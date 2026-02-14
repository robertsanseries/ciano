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
using Ciano.Enums;
using Ciano.Controllers;


namespace Ciano.Widgets {

    /**
     * The {@code DialogConvertFile} class is responsible for displaying
     * the dialog where the user can add and remove items for conversion.
     *
     * @see Gtk.Dialog
     * @since 0.1.0
     */
    public class DialogConvertFile : Gtk.Dialog {

        private string []           formats;
        private string              name_format;
        private Gtk.ListView        list_view;
        private GLib.ListStore      list_store;
        private Gtk.SingleSelection selection;
        private ConverterController converter_controller;

        /**
         * Constructs a new {@code DialogConvertFile} object responsible for assemble the structure of the dialog.
         * Defines the title and description to be performed. Then mount the grid using the "mount_frame" method
         * and add the buttons with the method "mount_buttons".
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Controllers.ConverterController
         * @see mount_frame
         * @see mount_buttons
         * @param {@code ConverterController}  converter_controller
         * @param {@code string[]}             formats
         * @param {@code string}               name_format
         * @param {@code Gtk.Window}           parent
         */
        public DialogConvertFile (ConverterController converter_controller, string [] formats, string name_format, Gtk.Window parent) {
            this.title = Properties.TEXT_CONVERT_FILE;
            this.resizable = false;
            this.deletable = false;
            this.converter_controller = converter_controller;
            this.formats = formats;
            this.name_format = name_format;
            this.set_transient_for (parent);
            this.set_default_size (800, 600);
            this.set_size_request (800, 600);
            this.set_modal (true);

            var title = new Gtk.Label ("<b>%s %s</b>".printf (Properties.TEXT_CONVERT_FILE_TO, name_format));
            title.set_use_markup (true);
            title.add_css_class ("title-section-dialog");
            title.halign = Gtk.Align.CENTER;
            title.margin_start = 5;
            title.margin_end = 5;
            title.margin_top = 5;
            title.margin_bottom = 5;

            var label = new Gtk.Label (Properties.TEXT_ADD_ITEMS_TO_CONVERSION);
            label.halign = Gtk.Align.START;
            label.margin_start = 5;
            label.margin_end = 5;
            label.margin_top = 5;
            label.margin_bottom = 5;

            var frame = mount_frame ();
            var grid_buttons = mount_buttons ();

            var grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.VERTICAL;
            grid.margin_start = 15;
            grid.margin_end = 15;
            grid.margin_top = 0;
            grid.margin_bottom = 0;
            grid.attach (title, 0, 0, 1, 1);
            grid.attach (label, 0, 1, 1, 1);
            grid.attach (frame, 0, 2, 1, 1);
            grid.attach (grid_buttons, 0, 3, 1, 1);

            this.get_content_area ().append (grid);
        }

        /**
         * Mounts to {@code Gtk.Frame} structure with your widgets.
         * 1 - create the {@code Gtk.ListView} and add the {@code Gtk.Grid} that will be in the {@code Gtk.Frame}.
         * 2 - create the toolbar container and attach it below the list.
         *
         * @see mount_listview
         * @see mount_toolbar
         * @return {@code Gtk.Frame}
         */
        private Gtk.Frame mount_frame () {
            var listview = mount_listview ();
            var toolbar = mount_toolbar ();

            var grid_itens = new Gtk.Grid ();
            grid_itens.orientation = Gtk.Orientation.VERTICAL;
            grid_itens.attach (listview, 0, 0, 1, 1);
            grid_itens.attach (toolbar, 0, 1, 1, 1);

            var frame = new Gtk.Frame (null);
            frame.set_child (grid_itens);

            return frame;
        }

        /**
         * Mount the {@code Gtk.ListView} structure using {@code GLib.ListStore}
         * as the model. The list displays two pieces of information:
         * file "name" and "directory".
         *
         * This implementation uses modern GTK4 list APIs
         * based on {@code GLib.ListStore} and {@code Gtk.ListView}.
         *
         * @see Ciano.Objects.FileItem
         * @see Gtk.ListView
         * @see GLib.ListStore
         * @return {@code Gtk.Widget}
         */
        private Gtk.Widget mount_listview () {
            // Create modern list store
            list_store = new GLib.ListStore (typeof (Ciano.Objects.FileItem));

            // Create selection model
            selection = new Gtk.SingleSelection (list_store);

            // Create factory
            var factory = new Gtk.SignalListItemFactory ();

            factory.setup.connect ((item) => {

                var list_item = (Gtk.ListItem) item;

                var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
                box.margin_start = 12;
                box.margin_end = 12;
                box.margin_top = 6;
                box.margin_bottom = 6;

                var label_name = new Gtk.Label ("");
                label_name.hexpand = true;
                label_name.halign = Gtk.Align.START;

                var label_directory = new Gtk.Label ("");
                label_directory.halign = Gtk.Align.END;
                label_directory.add_css_class ("dim-label");

                box.append (label_name);
                box.append (label_directory);

                list_item.set_child (box);
            });

            factory.bind.connect ((item) => {

                var list_item = (Gtk.ListItem) item;
                var obj = list_item.get_item ();

                if (obj == null) {
                    return;
                }

                var file_item = (Ciano.Objects.FileItem) obj;
                var box_widget = list_item.get_child ();

                if (box_widget == null) {
                    return;
                }

                var box = (Gtk.Box) box_widget;

                var label_name = (Gtk.Label) box.get_first_child ();
                var label_directory = (Gtk.Label) label_name.get_next_sibling ();

                label_name.label = file_item.name;
                label_directory.label = file_item.directory;
            });

            list_view = new Gtk.ListView (selection, factory);
            list_view.set_vexpand (true);

            return list_view;
        }

        /**
         * Mount the toolbar structure. The toolbar provides options to add
         * and remove items from the {@code Gtk.ListView}.
         *
         * The add logic is delegated to the controller.
         *
         * @return Gtk.Box
         */
        private Gtk.Box mount_toolbar () {

            var toolbar_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
            toolbar_box.add_css_class ("inline-toolbar");

            var button_add_file = new Gtk.Button.from_icon_name ("application-add-symbolic");
            button_add_file.tooltip_text = Properties.TEXT_ADD_FILE;

            button_add_file.clicked.connect (() => {
                this.converter_controller.on_activate_button_add_file (
                    this.list_store,
                    this.formats
                );
            });

            var button_remove = new Gtk.Button.from_icon_name ("list-remove-symbolic");
            button_remove.tooltip_text = Properties.TEXT_DELETE;
            button_remove.sensitive = false;

            button_remove.clicked.connect (() => {

                var position = selection.get_selected ();

                if (position != Gtk.INVALID_LIST_POSITION) {
                    list_store.remove (position);
                }
            });

            // Update remove button sensitivity when selection changes
            selection.notify["selected"].connect (() => {
                button_remove.sensitive =
                    selection.get_selected () != Gtk.INVALID_LIST_POSITION;
            });

            toolbar_box.append (button_add_file);
            toolbar_box.append (button_remove);

            return toolbar_box;
        }


        /**
         * Mount the {@code Gtk.Grid} where the cancel and start conversion buttons are displayed.
         * When you click the convert_button button, the "{@code on_activate_button_start_conversion}" method of
         * the "{@code ConverterController}" is responsible for performing all operations after the click.
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Controllers.ConverterController
         * @return Gtk.Grid
         */
        private Gtk.Box mount_buttons () {
            var cancel_button = new Gtk.Button.with_label (Properties.TEXT_CANCEL);
            cancel_button.clicked.connect (() => { this.destroy (); });

            var convert_button = new Gtk.Button.with_label (Properties.TEXT_START_CONVERSION);
            convert_button.add_css_class ("suggested-action");
            convert_button.clicked.connect (() => {
                this.destroy ();
                this.converter_controller.on_activate_button_start_conversion (this.list_store, this.name_format);
            });

            var box_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
            box_buttons.margin_top = 10;
            box_buttons.halign = Gtk.Align.END;
            
            box_buttons.append (cancel_button);
            box_buttons.append (convert_button);

            return box_buttons;
        }
    }
}

