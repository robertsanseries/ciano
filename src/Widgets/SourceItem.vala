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

namespace Ciano.Widgets {

    /**
     * SourceItem represents a single entry in a navigation list or sidebar.
     * It supports hierarchical structures by allowing child items.
     *
     * @since 0.1.0
     */
    public class SourceItem : GLib.Object {

        /**
         * The display name of the item.
         */
        public string name { get; set; }

        /**
         * The optional icon name associated with the item.
         */
        public string? icon_name { get; set; }

        /**
         * Determines if the item can be selected in the UI.
         */
        public bool selectable { get; set; default = true; }

        /**
         * Internal store for child items, enabling tree structures.
         */
        private GLib.ListStore children = new GLib.ListStore (typeof (SourceItem));

        /**
         * Signal emitted when the item is activated (e.g., clicked).
         */
        public signal void activated ();

        /**
         * Constructs a new SourceItem.
         * @param name The display name for the item.
         * @param icon_name An optional icon name.
         */
        public SourceItem (string name, string? icon_name = null) {
            this.name = name;
            this.icon_name = icon_name;
        }

        /**
         * Retrieves the model containing the children of this item.
         * @return GLib.ListStore The children's model.
         */
        public GLib.ListStore get_child_model () {
            return children;
        }

        /**
         * Adds a new child item to this object.
         * @param item The SourceItem to append.
         */
        public void append_child (SourceItem item) {
            children.append (item);
        }
    }
}
