/*
 * Copyright (c) 2026 Robert San <robertsanseries@gmail.com>
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

// Every log line is written in a child process so its output can be inspected.

int main (string[] args) {
    // print () converts to the locale charset, as the application does after setlocale ()
    Intl.setlocale (LocaleCategory.ALL, "");
    Test.init (ref args);

    Test.add_func ("/logger/debug-mode-is-off-by-default", () => {
        assert_false (Logger.debug_mode);
    });

    Test.add_func ("/logger/info/writes-to-stdout", () => {
        if (Test.subprocess ()) {
            Logger.info ("hello info");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
        Test.trap_assert_stdout ("*[INFO] hello info\n");
        Test.trap_assert_stderr_unmatched ("*hello info*");
    });

    Test.add_func ("/logger/info/format", () => {
        if (Test.subprocess ()) {
            Logger.info ("msg");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
        // Green timestamp in HH:MM:SS
        Test.trap_assert_stdout ("\033[1;32m[??:??:??]\033[0m [INFO] msg\n");
    });

    Test.add_func ("/logger/info/visible-without-debug-mode", () => {
        if (Test.subprocess ()) {
            Logger.debug_mode = false;
            Logger.info ("always visible");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_stdout ("*always visible*");
    });

    Test.add_func ("/logger/info/percent-sign-is-not-a-format", () => {
        if (Test.subprocess ()) {
            Logger.info ("100% done %s %d");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
        Test.trap_assert_stdout ("*[INFO] 100% done %s %d\n");
    });

    Test.add_func ("/logger/error/writes-to-stderr", () => {
        if (Test.subprocess ()) {
            Logger.error ("something failed");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        // Logger.error only prints, it must not abort like GLib.error ()
        Test.trap_assert_passed ();
        Test.trap_assert_stderr ("*[ERROR] something failed\n");
        Test.trap_assert_stdout_unmatched ("*something failed*");
    });

    Test.add_func ("/logger/error/format", () => {
        if (Test.subprocess ()) {
            Logger.error ("msg");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        // Red timestamp in HH:MM:SS
        Test.trap_assert_stderr ("\033[1;31m[??:??:??]\033[0m [ERROR] msg\n");
    });

    Test.add_func ("/logger/debug/hidden-when-disabled", () => {
        if (Test.subprocess ()) {
            Logger.debug_mode = false;
            Logger.debug ("secret %d", 1);
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
        Test.trap_assert_stdout ("");
        Test.trap_assert_stderr ("");
    });

    Test.add_func ("/logger/debug/shown-when-enabled", () => {
        if (Test.subprocess ()) {
            Logger.debug_mode = true;
            Logger.debug ("value");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
        // Blue timestamp in HH:MM:SS
        Test.trap_assert_stdout ("\033[1;34m[??:??:??]\033[0m [DEBUG] value\n");
    });

    Test.add_func ("/logger/debug/formats-arguments", () => {
        if (Test.subprocess ()) {
            Logger.debug_mode = true;
            Logger.debug ("%s has %d items (%.1f%%)", "list", 3, 42.5);
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
        // "?" matches the decimal separator of any locale (42.5 or 42,5)
        Test.trap_assert_stdout ("*[DEBUG] list has 3 items (42?5%)\n");
    });

    Test.add_func ("/logger/debug/can-be-toggled", () => {
        if (Test.subprocess ()) {
            Logger.debug_mode = true;
            Logger.debug ("first");
            Logger.debug_mode = false;
            Logger.debug ("second");
            Logger.debug_mode = true;
            Logger.debug ("third");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_stdout ("*[DEBUG] first\n*[DEBUG] third\n");
        Test.trap_assert_stdout_unmatched ("*second*");
    });

    Test.add_func ("/logger/order-is-preserved", () => {
        if (Test.subprocess ()) {
            Logger.info ("one");
            Logger.info ("two");
            Logger.info ("three");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_stdout ("*one\n*two\n*three\n");
    });

    Test.add_func ("/logger/utf8-message", () => {
        if (Test.subprocess ()) {
            Logger.info ("conversão concluída ✓");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_stdout ("*[INFO] conversão concluída ✓\n");
    });

    Test.add_func ("/logger/empty-message", () => {
        if (Test.subprocess ()) {
            Logger.info ("");
            Logger.error ("");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
        Test.trap_assert_stdout ("*[INFO] \n");
        Test.trap_assert_stderr ("*[ERROR] \n");
    });

    return Test.run ();
}
