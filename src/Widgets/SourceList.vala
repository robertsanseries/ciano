/*
* Copyright (c) 2016 Robert San <robertsanseries@gmail.com>
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

using Granite;
using Granite.Widgets;
using Ciano.Configs;

namespace Ciano.Widgets {

    public class SourceList : Gtk.Box {
    
        private Gtk.ScrolledWindow scrolled_window;
        private Gtk.ListView list_view;
        private Gtk.TreeListModel tree_model;
        
        /* Reference to the root item to allow appending children from subclasses */
        public SourceItem root_item;

        /* Signal emitted when a leaf item is selected */
        public signal void item_selected (SourceItem item);

        public SourceList (SourceItem root) {
            this.orientation = Gtk.Orientation.VERTICAL;
            
            this.root_item = root;

            /* Create ScrolledWindow internally */
            scrolled_window = new Gtk.ScrolledWindow ();
            scrolled_window.set_hexpand (true);
            scrolled_window.set_vexpand (true);
            append (scrolled_window);
        
        
        }

          public void initialize_model () {

            // Cria o TreeListModel sem autoexpand
            tree_model = new Gtk.TreeListModel (
                root_item.get_child_model (),
                false,
                false,
                (item) => {
                    var model = ((SourceItem)item).get_child_model ();
                    return model.get_n_items () > 0 ? model : null;
                }
            );

            // Controle de seleção
            var selection = new Gtk.SingleSelection (tree_model);
            selection.set_autoselect (true);
            selection.set_can_unselect (false);

            // Criação da ListView
            list_view = new Gtk.ListView (selection, create_factory ());
            list_view.add_css_class ("navigation-sidebar");

            scrolled_window.set_child (list_view);

            // Expansão inicial controlada
            Idle.add (() => {

                for (uint i = 0; i < tree_model.get_n_items (); i++) {

                    var row = (Gtk.TreeListRow) tree_model.get_item (i);
                    var item = (SourceItem) row.get_item ();

                    // Expandir nível 0: "Convert file to"
                    if (item.name == Properties.TEXT_CONVERT_FILE_TO) {
                        row.set_expanded (true);
                    }

                    // Expandir nível 1: "Video"
                    if (item.name == Properties.TEXT_VIDEO) {
                        row.set_expanded (true);
                    }
                }

                return false;
            });
        }


        private Gtk.ListItemFactory create_factory () {

            var factory = new Gtk.SignalListItemFactory ();

            factory.setup.connect ((list_item_obj) => {

                var list_item = (Gtk.ListItem) list_item_obj;

                var expander = new Gtk.TreeExpander ();
                var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);

                var main_icon = new Gtk.Image ();
                var label = new Gtk.Label ("");
                label.xalign = 0;

                box.append (main_icon);
                box.append (label);

                expander.set_child (box);
                list_item.set_child (expander);

                // Clique para leaf
                var click = new Gtk.GestureClick ();
                click.released.connect (() => {

                    var row = list_item.get_item () as Gtk.TreeListRow;
                    if (row == null)
                        return;

                    if (!row.is_expandable ()) {
                        var item = row.get_item () as SourceItem;
                        this.item_selected (item);
                        item.activated ();
                    }
                });

                expander.add_controller (click);
            });

            factory.bind.connect ((list_item_obj) => {

                var list_item = (Gtk.ListItem) list_item_obj;
                var row = list_item.get_item () as Gtk.TreeListRow;
                if (row == null)
                    return;

                var item = row.get_item () as SourceItem;

                var expander = list_item.get_child () as Gtk.TreeExpander;
                expander.set_list_row (row);

                var box = expander.get_child () as Gtk.Box;
                var main_icon = box.get_first_child () as Gtk.Image;
                var label = main_icon.get_next_sibling () as Gtk.Label;

                main_icon.icon_name = item.icon_name;
                main_icon.visible = (item.icon_name != null);
                label.label = item.name;

                box.margin_start = (int) row.get_depth () * 6;
            });

            return factory;
        }


    }
}
