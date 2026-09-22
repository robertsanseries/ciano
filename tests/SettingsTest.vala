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

using Ciano.Configs;

// Runs with GSETTINGS_BACKEND=memory and the schema compiled by tests/meson.build,
// so the user's real settings are never read or changed.
//
// Settings is a singleton: tests that depend on the state before the first
// get_instance () run in a child process.

bool schema_available () {
    var source = SettingsSchemaSource.get_default ();
    return source != null && source.lookup (Constants.ID, true) != null;
}

bool skip_without_schema () {
    if (!schema_available ()) {
        Test.skip ("schema %s not found, run the tests through meson".printf (Constants.ID));
        return true;
    }

    return false;
}

int expected_default_limit () {
    return int.max (1, (int) GLib.get_num_processors () / 2);
}

void add_schema_tests () {
    Test.add_func ("/settings/schema/is-available", () => {
        if (skip_without_schema ()) {
            return;
        }

        var schema = SettingsSchemaSource.get_default ().lookup (Constants.ID, true);
        assert_cmpstr (schema.get_id (), CompareOperator.EQ, Constants.ID);
        assert_cmpstr (schema.get_path (), CompareOperator.EQ, "/com/github/robertsanseries/ciano/");
    });

    Test.add_func ("/settings/schema/keys", () => {
        if (skip_without_schema ()) {
            return;
        }

        var schema = SettingsSchemaSource.get_default ().lookup (Constants.ID, true);
        string[] expected = {
            "window-width", "window-height", "is-maximized", "output-folder", "output-source-file-folder",
            "shutdown-computer", "open-output-folder", "complete-notify", "error-notify", "theme",
            "follow-system-appearance", "max-simultaneous-conversions", "use-cpu-cores-limit"
        };

        foreach (string key in expected) {
            assert_true (schema.has_key (key));
        }

        assert_cmpint (schema.list_keys ().length, CompareOperator.EQ, expected.length);
    });

    Test.add_func ("/settings/schema/every-key-has-a-property", () => {
        if (skip_without_schema ()) {
            return;
        }

        var schema = SettingsSchemaSource.get_default ().lookup (Constants.ID, true);
        var klass = (ObjectClass) typeof (Ciano.Services.Settings).class_ref ();

        foreach (string key in schema.list_keys ()) {
            if (klass.find_property (key) == null) {
                Test.fail_printf ("schema key \"%s\" has no matching property", key);
            }
        }
    });

    Test.add_func ("/settings/schema/key-types", () => {
        if (skip_without_schema ()) {
            return;
        }

        var schema = SettingsSchemaSource.get_default ().lookup (Constants.ID, true);
        string[,] types = {
            { "window-width", "i" }, { "window-height", "i" }, { "is-maximized", "b" },
            { "output-folder", "s" }, { "output-source-file-folder", "b" }, { "shutdown-computer", "b" },
            { "open-output-folder", "b" }, { "complete-notify", "b" }, { "error-notify", "b" },
            { "theme", "i" }, { "follow-system-appearance", "b" }, { "max-simultaneous-conversions", "i" },
            { "use-cpu-cores-limit", "b" }
        };

        for (int i = 0; i < types.length[0]; i++) {
            var key = schema.get_key (types[i, 0]);
            assert_cmpstr ((string) key.get_value_type ().peek_string (), CompareOperator.EQ, types[i, 1]);
        }
    });

    Test.add_func ("/settings/schema/defaults", () => {
        if (skip_without_schema ()) {
            return;
        }

        var schema = SettingsSchemaSource.get_default ().lookup (Constants.ID, true);

        assert_cmpint (schema.get_key ("window-width").get_default_value ().get_int32 (), CompareOperator.EQ, 700);
        assert_cmpint (schema.get_key ("window-height").get_default_value ().get_int32 (), CompareOperator.EQ, 450);
        assert_false (schema.get_key ("is-maximized").get_default_value ().get_boolean ());
        assert_cmpstr (schema.get_key ("output-folder").get_default_value ().get_string (), CompareOperator.EQ, "");
        assert_false (schema.get_key ("output-source-file-folder").get_default_value ().get_boolean ());
        assert_false (schema.get_key ("shutdown-computer").get_default_value ().get_boolean ());
        assert_false (schema.get_key ("open-output-folder").get_default_value ().get_boolean ());
        assert_true (schema.get_key ("complete-notify").get_default_value ().get_boolean ());
        assert_true (schema.get_key ("error-notify").get_default_value ().get_boolean ());
        assert_cmpint (schema.get_key ("theme").get_default_value ().get_int32 (), CompareOperator.EQ, 0);
        assert_true (schema.get_key ("follow-system-appearance").get_default_value ().get_boolean ());
        assert_cmpint (
                schema.get_key ("max-simultaneous-conversions").get_default_value ().get_int32 (),
                CompareOperator.EQ,
                0
        );
        assert_false (schema.get_key ("use-cpu-cores-limit").get_default_value ().get_boolean ());
    });
}

void add_instance_tests () {
    Test.add_func ("/settings/instance/is-singleton", () => {
        if (skip_without_schema ()) {
            return;
        }

        unowned var first = Ciano.Services.Settings.get_instance ();
        unowned var second = Ciano.Services.Settings.get_instance ();

        assert_nonnull (first);
        assert_true (first == second);
        assert_nonnull (first.schema);
        assert_cmpstr (first.schema.schema_id, CompareOperator.EQ, Constants.ID);
    });

    Test.add_func ("/settings/instance/defaults-on-first-run", () => {
        if (skip_without_schema ()) {
            return;
        }

        if (Test.subprocess ()) {
            unowned var s = Ciano.Services.Settings.get_instance ();

            assert_cmpint (s.window_width, CompareOperator.EQ, 700);
            assert_cmpint (s.window_height, CompareOperator.EQ, 450);
            assert_false (s.is_maximized);
            assert_false (s.output_source_file_folder);
            assert_false (s.shutdown_computer);
            assert_false (s.open_output_folder);
            assert_true (s.complete_notify);
            assert_true (s.error_notify);
            assert_cmpint (s.theme, CompareOperator.EQ, 0);
            assert_true (s.follow_system_appearance);
            assert_false (s.use_cpu_cores_limit);
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
    });

    Test.add_func ("/settings/instance/default-output-folder", () => {
        if (skip_without_schema ()) {
            return;
        }

        if (Test.subprocess ()) {
            unowned var s = Ciano.Services.Settings.get_instance ();
            string expected = Environment.get_home_dir () + Constants.DIRECTORY_CIANO;

            assert_cmpstr (s.output_folder, CompareOperator.EQ, expected);
            // The default is also stored in the schema
            assert_cmpstr (s.schema.get_string ("output-folder"), CompareOperator.EQ, expected);
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
    });

    Test.add_func ("/settings/instance/keeps-existing-output-folder", () => {
        if (skip_without_schema ()) {
            return;
        }

        if (Test.subprocess ()) {
            new GLib.Settings (Constants.ID).set_string ("output-folder", "/custom/output");

            unowned var s = Ciano.Services.Settings.get_instance ();
            assert_cmpstr (s.output_folder, CompareOperator.EQ, "/custom/output");
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
    });

    Test.add_func ("/settings/instance/default-conversion-limit", () => {
        if (skip_without_schema ()) {
            return;
        }

        if (Test.subprocess ()) {
            unowned var s = Ciano.Services.Settings.get_instance ();

            assert_cmpint (s.max_simultaneous_conversions, CompareOperator.EQ, expected_default_limit ());
            assert_cmpint (s.max_simultaneous_conversions, CompareOperator.GE, 1);
            assert_cmpint (
                    s.schema.get_int ("max-simultaneous-conversions"), CompareOperator.EQ, expected_default_limit ()
            );
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
    });

    Test.add_func ("/settings/instance/keeps-existing-conversion-limit", () => {
        if (skip_without_schema ()) {
            return;
        }

        if (Test.subprocess ()) {
            new GLib.Settings (Constants.ID).set_int ("max-simultaneous-conversions", 3);

            unowned var s = Ciano.Services.Settings.get_instance ();
            assert_cmpint (s.max_simultaneous_conversions, CompareOperator.EQ, 3);
            return;
        }

        Test.trap_subprocess (null, 0, (TestSubprocessFlags) 0);
        Test.trap_assert_passed ();
    });
}

void add_binding_tests () {
    Test.add_func ("/settings/binding/property-to-schema", () => {
        if (skip_without_schema ()) {
            return;
        }

        unowned var s = Ciano.Services.Settings.get_instance ();

        s.window_width = 1024;
        s.window_height = 768;
        s.is_maximized = true;
        s.output_folder = "/tmp/out";
        s.output_source_file_folder = true;
        s.shutdown_computer = true;
        s.open_output_folder = true;
        s.complete_notify = false;
        s.error_notify = false;
        s.theme = 2;
        s.follow_system_appearance = false;
        s.max_simultaneous_conversions = 5;
        s.use_cpu_cores_limit = true;

        assert_cmpint (s.schema.get_int ("window-width"), CompareOperator.EQ, 1024);
        assert_cmpint (s.schema.get_int ("window-height"), CompareOperator.EQ, 768);
        assert_true (s.schema.get_boolean ("is-maximized"));
        assert_cmpstr (s.schema.get_string ("output-folder"), CompareOperator.EQ, "/tmp/out");
        assert_true (s.schema.get_boolean ("output-source-file-folder"));
        assert_true (s.schema.get_boolean ("shutdown-computer"));
        assert_true (s.schema.get_boolean ("open-output-folder"));
        assert_false (s.schema.get_boolean ("complete-notify"));
        assert_false (s.schema.get_boolean ("error-notify"));
        assert_cmpint (s.schema.get_int ("theme"), CompareOperator.EQ, 2);
        assert_false (s.schema.get_boolean ("follow-system-appearance"));
        assert_cmpint (s.schema.get_int ("max-simultaneous-conversions"), CompareOperator.EQ, 5);
        assert_true (s.schema.get_boolean ("use-cpu-cores-limit"));
    });

    Test.add_func ("/settings/binding/schema-to-property", () => {
        if (skip_without_schema ()) {
            return;
        }

        unowned var s = Ciano.Services.Settings.get_instance ();

        s.schema.set_int ("window-width", 800);
        s.schema.set_int ("window-height", 600);
        s.schema.set_boolean ("is-maximized", false);
        s.schema.set_string ("output-folder", "/srv/media");
        s.schema.set_boolean ("output-source-file-folder", false);
        s.schema.set_boolean ("shutdown-computer", false);
        s.schema.set_boolean ("open-output-folder", false);
        s.schema.set_boolean ("complete-notify", true);
        s.schema.set_boolean ("error-notify", true);
        s.schema.set_int ("theme", 1);
        s.schema.set_boolean ("follow-system-appearance", true);
        s.schema.set_int ("max-simultaneous-conversions", 2);
        s.schema.set_boolean ("use-cpu-cores-limit", false);

        assert_cmpint (s.window_width, CompareOperator.EQ, 800);
        assert_cmpint (s.window_height, CompareOperator.EQ, 600);
        assert_false (s.is_maximized);
        assert_cmpstr (s.output_folder, CompareOperator.EQ, "/srv/media");
        assert_false (s.output_source_file_folder);
        assert_false (s.shutdown_computer);
        assert_false (s.open_output_folder);
        assert_true (s.complete_notify);
        assert_true (s.error_notify);
        assert_cmpint (s.theme, CompareOperator.EQ, 1);
        assert_true (s.follow_system_appearance);
        assert_cmpint (s.max_simultaneous_conversions, CompareOperator.EQ, 2);
        assert_false (s.use_cpu_cores_limit);
    });

    Test.add_func ("/settings/binding/other-settings-instance", () => {
        if (skip_without_schema ()) {
            return;
        }

        unowned var s = Ciano.Services.Settings.get_instance ();
        var other = new GLib.Settings (Constants.ID);

        other.set_string ("output-folder", "/from/another/instance");
        assert_cmpstr (s.output_folder, CompareOperator.EQ, "/from/another/instance");

        s.theme = 3;
        assert_cmpint (other.get_int ("theme"), CompareOperator.EQ, 3);
    });

    Test.add_func ("/settings/binding/notify-on-external-change", () => {
        if (skip_without_schema ()) {
            return;
        }

        unowned var s = Ciano.Services.Settings.get_instance ();
        s.complete_notify = true;

        int count = 0;
        ulong handler = s.notify["complete-notify"].connect (() => {
            count++;
        });

        s.schema.set_boolean ("complete-notify", false);
        s.disconnect (handler);

        assert_cmpint (count, CompareOperator.GE, 1);
        assert_false (s.complete_notify);
    });

    Test.add_func ("/settings/binding/utf8-output-folder", () => {
        if (skip_without_schema ()) {
            return;
        }

        unowned var s = Ciano.Services.Settings.get_instance ();
        s.output_folder = "/home/usuário/Vídeos convertidos";

        assert_cmpstr (s.schema.get_string ("output-folder"), CompareOperator.EQ, "/home/usuário/Vídeos convertidos");
    });
}

int main (string[] args) {
    // Never touch the user's real settings, even when run outside meson
    Environment.set_variable ("GSETTINGS_BACKEND", "memory", true);

    Test.init (ref args);

    add_schema_tests ();
    add_instance_tests ();
    add_binding_tests ();

    return Test.run ();
}
