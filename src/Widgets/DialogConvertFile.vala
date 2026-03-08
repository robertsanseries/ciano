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
        private Gtk.ListStore       list_store;
        private Gtk.TreeView        tree_view;
        private Gtk.TreeIter        iter;
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
            title.get_style_context ().add_class ("title-section-dialog");
            title.halign = Gtk.Align.CENTER;
            title.margin = 5;

            var label = new Gtk.Label (Properties.TEXT_ADD_ITEMS_TO_CONVERSION);
            label.halign = Gtk.Align.START;
            label.margin = 5;

            var frame = mount_frame ();
            var grid_buttons = mount_buttons ();

            var grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.VERTICAL;
            grid.margin_start = 15;
            grid.margin_end = 15;
            grid.margin_top = 0;
            grid.margin_bottom = 0;
            grid.add (title);
            grid.add (label);
            grid.add (frame);
            grid.add (grid_buttons);

            this.get_content_area ().add (grid);
        }

        /**
         * Mounts to {@code Gtk.Frame} structure with your widgets.
         * 1 - create the {@code Gtk.Treeview} and add the {@code Gtk.Grid} that will be in the {@code Gtk.Frame}.
         * 2 - create the {@code Gtk.Toobar} and add the {@code Gtk.Grid} that will be in the {@code Gtk.Frame}.
         *
         * @see mount_treeview
         * @see mount_toolbar
         * @return {@code Gtk.Frame}
         */
        private Gtk.Frame mount_frame () {
            var treeview = mount_treeview ();
            var toolbar = mount_toolbar ();

            var grid_itens = new Gtk.Grid ();
            grid_itens.orientation = Gtk.Orientation.VERTICAL;
            grid_itens.add (treeview);
            grid_itens.add (toolbar);

            var frame = new Gtk.Frame (null);
            frame.add (grid_itens);

            return frame;
        }

        /**
         * Mount the {@code Gtk.Treeview} structure. {@code Gtk.Treeview} will have only two columns "name"
         * and "Directory".
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Enums.ColumnEnum
         * @return Gtk.ScrolledWindow
         */
        private Gtk.ScrolledWindow mount_treeview () {
            this.list_store = new Gtk.ListStore (ColumnEnum.N_COLUMNS ,typeof (string), typeof (string));

            this.tree_view = new Gtk.TreeView.with_model (this.list_store);
            this.tree_view.vexpand = true;

            var name_column = new Gtk.TreeViewColumn ();
            var cell1 = new Gtk.CellRendererText ();
            name_column.title = Properties.NAME;
            name_column.expand = true;
            name_column.min_width = 200;
            name_column.max_width = 200;
            name_column.pack_start (cell1, false);
            name_column.add_attribute (cell1, "text", ColumnEnum.NAME);

            var directory_column = new Gtk.TreeViewColumn ();
            var cell2 = new Gtk.CellRendererText ();
            directory_column.title = Properties.DIRECTORY;
            directory_column.expand = true;
            directory_column.min_width = 200;
            directory_column.max_width = 200;
            directory_column.pack_start (cell2, false);
            directory_column.add_attribute (cell2, "text", ColumnEnum.DIRECTORY);

            this.tree_view.insert_column (name_column, -1);
            this.tree_view.insert_column (directory_column, -1);

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.expand = true;
            scrolled.add (this.tree_view);

            return scrolled;
        }

        /**
         * Mount the {@code Gtk.Toolbar} structure. The {@code Gtk.Toolbar} will have the option to add items
         * and remove them from the {@code Gtk.Treeview}. The methods responsible for performing the actions of
         * adding ({@code on_activate_button_add_file}) and removing ({@code on_activate_button_remove})
         * the items are implemented in the controller ({@code ConverterController}).
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Controllers.ConverterController
         * @return Gtk.Toolbar
         */
        private Gtk.Toolbar mount_toolbar () {
            var toolbar = new Gtk.Toolbar ();
            toolbar.get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
            toolbar.set_icon_size (Gtk.IconSize.SMALL_TOOLBAR);

            var button_add_file = new Gtk.ToolButton (new Gtk.Image.from_icon_name ("list-add-symbolic",    Gtk.IconSize.SMALL_TOOLBAR), null);
            button_add_file.tooltip_text = Properties.TEXT_ADD_FILE;
            button_add_file.clicked.connect (() => {
                this.converter_controller.on_activate_button_add_file (
                    this, this.tree_view, this.iter, this.list_store, this.formats
                );
            });

            var button_remove = new Gtk.ToolButton (new Gtk.Image.from_icon_name ("list-remove-symbolic", Gtk.IconSize.SMALL_TOOLBAR), null);
            button_remove.tooltip_text = Properties.TEXT_DELETE;
            button_remove.sensitive = false;
            button_remove.clicked.connect (() => {
                this.converter_controller.on_activate_button_remove (
                    this, this.tree_view, this.list_store, button_remove
                );
            });

            this.tree_view.cursor_changed.connect (() => {
                button_remove.sensitive = true;
            });

            toolbar.insert (button_add_file, -1);
            toolbar.insert (button_remove, -1);

            return toolbar;
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
        private Gtk.Grid mount_buttons () {
            var calcel_button = new Gtk.Button.with_label (Properties.TEXT_CANCEL);
            calcel_button.clicked.connect (() => { this.destroy (); });
            calcel_button.margin_end = 10;

            var convert_button = new Gtk.Button.with_label (Properties.TEXT_START_CONVERSION);
            convert_button.get_style_context ().add_class ("suggested-action");
            convert_button.clicked.connect (() => {
                this.destroy ();
                this.converter_controller.on_activate_button_start_conversion (this.list_store, this.name_format);
            });

            var grid_buttons = new Gtk.Grid ();
            grid_buttons.margin_top = 10;
            grid_buttons.halign = Gtk.Align.END;
            grid_buttons.attach (calcel_button, 0, 0, 1, 1);
            grid_buttons.attach_next_to (convert_button, calcel_button, Gtk.PositionType.RIGHT, 3, 1);

            return grid_buttons;
        }
    }
}

