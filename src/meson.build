qt5 = import('qt5')

sources = [
    'main.cpp',
]

deps = [
    dependency('qt5', modules: ['Core', 'Quick', 'DBus']),
    dependency('auroraapp'),
    dependency('runtime-manager-qt5'),
]

mocs = qt5.compile_moc(sources: sources)

executable(meson.project_name(), sources, mocs, dependencies: deps, install: true)
