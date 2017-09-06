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

namespace Ciano.Utils {

    /**
     * The {@code WidgetUtil} class is responsible for customizing widget actions.
     *
     * @since 0.1.0
     */
    public class WidgetUtil {

        /**
         * Change component visibility status.
         *
         * Exemple:
         * > WidgetUtil.set_visible(widget, true)
         * 
         * @param   {@code widget} widget - component
         * @param   {@code bool} visible - if true the component is displayed if false is not displayed
         * @return  {@code void} 
         */
        public static void set_visible (Gtk.Widget widget, bool visible) {
            widget.no_show_all = !visible;
            widget.visible = visible;
        }
    }
}