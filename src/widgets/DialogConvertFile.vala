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

using Ciano.Config;
using Ciano.Utils;
using Ciano.Enums;
using Ciano.Controllers;


namespace Ciano.Widgets {

	/**
	 * @description 
	 * 
	 * @author  Robert San <robertsanseries@gmail.com>
	 * @type    Gtk.Dialog
	 */
	public class DialogConvertFile : Gtk.Dialog {

		private string [] formats;
		private Gtk.ListStore list_store;
		private Gtk.TreeView tree_view;
		private Gtk.TreeIter iter;
		private ConverterController converter_controller;

		/**
		 * @construct
		 */
		public DialogConvertFile (ConverterController converter_controller, string [] formats, Gtk.Window parent) {
			this.title = Properties.TEXT_CONVERT_FILE;
			this.resizable = false;
            this.deletable = false;
            this.converter_controller = converter_controller;
            this.formats = formats;
			this.set_transient_for (parent);
            this.set_default_size (800, 600);
            this.set_size_request (800, 600);
            this.set_modal (true);

            var label = new Gtk.Label (Properties.TEXT_ADD_ITEMS_TO_CONVERSION);
			label.halign = Gtk.Align.START;
			label.margin = 5;

			var frame = mount_frame ();
			var grid_buttons = mount_buttons ();
            
			var grid = new Gtk.Grid ();
			grid.orientation = Gtk.Orientation.VERTICAL;
			grid.margin_left = 15;
			grid.margin_right = 15;
			grid.margin_top = 0;
			grid.margin_bottom = 0;
			grid.add (label);
			grid.add (frame);
			grid.add (grid_buttons);

			this.get_content_area ().add (grid);
		}

		/**
		 * [mount_frame description]
		 * @return {[type]} [description]
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
		 * [mount_treeview description]
		 * @return {[type]} [description]
		 */
		private Gtk.ScrolledWindow mount_treeview () {
			this.list_store = new Gtk.ListStore (ColumnEnum.N_COLUMNS ,typeof (string), typeof (string));

			this.tree_view = new Gtk.TreeView.with_model (this.list_store);
			this.tree_view.vexpand = true;

			// setup name column
			var name_column = new Gtk.TreeViewColumn ();
			var cell1 = new Gtk.CellRendererText ();
			name_column.title = "Name";
			name_column.expand = true;
			name_column.min_width = 200;
			name_column.max_width = 200;
			
			name_column.pack_start (cell1, false);
			name_column.add_attribute (cell1, "text", ColumnEnum.NAME);
			this.tree_view.insert_column (name_column, -1);

			// column 
			var directory_column = new Gtk.TreeViewColumn ();
			var cell2 = new Gtk.CellRendererText ();
			directory_column.title = "Directory";
			directory_column.expand = true;
			directory_column.min_width = 200;
			directory_column.max_width = 200;
			directory_column.pack_start (cell2, false);
			directory_column.add_attribute (cell2, "text", ColumnEnum.DIRECTORY);
			this.tree_view.insert_column (directory_column, -1);

			var scrolled = new Gtk.ScrolledWindow (null, null);
			scrolled.expand = true;
			scrolled.add (this.tree_view);

			return scrolled;
		}

		/**
		 * [mount_toolbar description]
		 * @return {[type]} [description]
		 */
		private Gtk.Toolbar mount_toolbar () {
			var toolbar = new Gtk.Toolbar ();
			toolbar.get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
			toolbar.set_icon_size (Gtk.IconSize.SMALL_TOOLBAR);

			var button_add_file = new Gtk.ToolButton (new Gtk.Image.from_icon_name ("application-add-symbolic",	Gtk.IconSize.SMALL_TOOLBAR), null);
			button_add_file.tooltip_text = Properties.TEXT_ADD_FILE;
			button_add_file.clicked.connect (() => {
				this.converter_controller.on_activate_button_add_file (
					this, this.tree_view, this.iter, this.list_store, this.formats 
				);				
			});

			var button_add_folder = new Gtk.ToolButton (new Gtk.Image.from_icon_name ("folder-new-symbolic", Gtk.IconSize.SMALL_TOOLBAR), null);
			button_add_folder.tooltip_text = Properties.TEXT_ADD_FOLDER;
			button_add_folder.clicked.connect (() => {
				this.converter_controller.on_activate_button_add_folder (
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
			//toolbar.insert (button_add_folder, -1);
			toolbar.insert (button_remove, -1);

			return toolbar;
		}

		/**
		 * [mount_buttons description]
		 * @return {[type]} [description]
		 */
		private Gtk.Grid mount_buttons () {

			var calcel_button = new Gtk.Button.with_label (Properties.TEXT_CANCEL);
			calcel_button.clicked.connect (() => { this.destroy (); });
			calcel_button.margin_right = 10;
			
			var convert_button = new Gtk.Button.with_label (Properties.TEXT_START_CONVERSION);
			convert_button.get_style_context ().add_class ("suggested-action");
			//convert_button.clicked.connect (() => { this.destroy (); });

			var grid_buttons = new Gtk.Grid ();
			grid_buttons.margin_top = 10;
			grid_buttons.halign = Gtk.Align.END;
	        grid_buttons.attach (calcel_button, 0, 0, 1, 1);
			grid_buttons.attach_next_to (convert_button, calcel_button, Gtk.PositionType.RIGHT, 3, 1);

			return grid_buttons;
		}
	}
}