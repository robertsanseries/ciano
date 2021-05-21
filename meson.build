# Project name, programming language and version
project (
    'com.github.robertsanseries.ciano',
    'vala', 'c',
    version: '0.2.3',
    license: 'GPL-3.0'
)

# Translation module
i18n = import ('i18n')

# GNOME module
gnome = import('gnome')

# Project arguments
add_project_arguments (
    '-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name ()),
    language: 'c'
)

# Compiling resources
asresources = gnome.compile_resources (
    'as-resources',
    join_paths ('data', meson.project_name ()) + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

# Configuring data
conf_data = configuration_data ()
conf_data.set_quoted ('GETTEXT_PACKAGE', meson.project_name ())
configure_file (
    output: 'config.h',
    configuration: conf_data
)

config_h_dir = include_directories ('.')

c_args = [
  '-include', 'config.h',
  '-DGWEATHER_I_KNOW_THIS_IS_UNSTABLE',
]

# Listing dependencies
dependencies = [
    dependency ('glib-2.0'),
    dependency ('gtk+-3.0'),
    dependency ('granite'),
    dependency ('gobject-2.0')
]

subdir ('src')

# Defining executable
executable (
    meson.project_name (),
    sources,
    asresources,
    c_args: c_args,
    dependencies: dependencies,
    install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
