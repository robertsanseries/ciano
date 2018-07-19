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

using Ciano.Enums;
using Ciano.Views;
using Ciano.Widgets;

namespace Ciano.Views.Factory {

    public class DialogFactory {
       
        public static void open_dialog (ApplicationView parent, DialogEnum dialog) {
            
            switch (dialog) {
                
                case DialogEnum.ABOUT:
                    DialogAbout dialog_about = new DialogAbout (parent);
                    dialog_about.show_all ();
                     break;

                case DialogEnum.INFORMATIONS:
                    DialogInformations dialog_informations = new DialogInformations (parent);
                    dialog_informations.show_all ();
                    break;

                case DialogEnum.PREFERENCES:
                    DialogPreferences dialog_preferences = new DialogPreferences (parent);
                    dialog_preferences.show_all ();
                    break;
            }
        }
    }
}