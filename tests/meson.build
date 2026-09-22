# Unit tests
#
# Run with:
#   meson test -C build --print-errorlogs

core_dependencies = [
    dependency ('glib-2.0', version: '>=2.50', include_type: 'system'),
    dependency ('gobject-2.0', version: '>=2.50', include_type: 'system'),
    dependency ('gio-2.0', version: '>= 2.66', include_type: 'system')
]

test_c_args = c_args + [
    '-DCIANO_PROJECT_NAME="@0@"'.format (meson.project_name ()),
    '-DCIANO_PROJECT_VERSION="@0@"'.format (meson.project_version ())
]

# GTK-free application code, shared by every test executable
ciano_core = static_library (
    'ciano-core',
    core_sources,
    c_args: c_args,
    dependencies: core_dependencies
)

# Compile the GSettings schema so Settings can be tested without installing it.
# --strict also makes the build fail on an invalid schema.
test_schemas = custom_target (
    'test-schemas',
    input: join_paths (meson.project_source_root (), 'data', meson.project_name () + '.gschema.xml'),
    output: 'gschemas.compiled',
    command: [
        find_program ('glib-compile-schemas'),
        '--strict',
        '--targetdir', '@OUTDIR@',
        join_paths (meson.project_source_root (), 'data')
    ]
)

test_env = environment ()
test_env.set ('GSETTINGS_SCHEMA_DIR', meson.current_build_dir ())
test_env.set ('GSETTINGS_BACKEND', 'memory')
test_env.set ('G_DEBUG', 'gc-friendly')
test_env.set ('LC_ALL', 'C.UTF-8')

core_tests = [
    'ArrayUtilTest',
    'ConstantsTest',
    'FFmpegUtilTest',
    'FileUtilTest',
    'FormatUtilTest',
    'LoggerTest',
    'ObjectsTest',
    'SettingsTest',
    'StringUtilTest',
    'TimeUtilTest'
]

foreach name : core_tests
    exe = executable (
        name,
        [name + '.vala', 'TestUtil.vala'],
        c_args: test_c_args,
        dependencies: core_dependencies,
        link_with: ciano_core
    )

    test (
        name,
        exe,
        args: ['--tap'],
        protocol: 'tap',
        env: test_env,
        depends: test_schemas
    )
endforeach

# Integration tests: real ffmpeg conversions for every sidebar target
conversion_test = executable (
    'ConversionTest',
    ['ConversionTest.vala', 'TestUtil.vala'],
    c_args: test_c_args,
    vala_args: ['--pkg', 'posix'],
    dependencies: core_dependencies,
    link_with: ciano_core
)

test (
    'ConversionTest',
    conversion_test,
    args: ['--tap'],
    protocol: 'tap',
    env: test_env,
    timeout: 300
)

# Tests that need GTK. They are skipped when no display is available.
widget_test = executable (
    'WidgetUtilTest',
    ['WidgetUtilTest.vala', 'TestUtil.vala', join_paths (meson.project_source_root (), 'src', 'Utils', 'WidgetUtil.vala')],
    c_args: test_c_args,
    dependencies: core_dependencies + [dependency ('gtk4', version: '>=4.1', include_type: 'system')],
    link_with: ciano_core
)

test ('WidgetUtilTest', widget_test, args: ['--tap'], protocol: 'tap', env: test_env)
