lupdate = find_program('lupdate', required: true)
lrelease = find_program('lrelease', required: true)

translation_sources = [
    './dev.glazkov.BeerReminder.ts',
    './dev.glazkov.BeerReminder-ru.ts',
    '../src/main.cpp',
    '../qml/pages/BeerPage.qml',
    '../qml/pages/CoverPage.qml',
    '../qml/pages/MainPage.qml',
]

en_ts = custom_target(
    'en-ts',
    input: translation_sources,
    output: 'dev.glazkov.BeerReminder.ts',
    command: [
        lupdate,
        meson.project_source_root(),
        '-ts', meson.project_source_root() / '@OUTPUT@',
    ],
)

ru_ts = custom_target(
    'ru-ts',
    input: translation_sources,
    output: 'dev.glazkov.BeerReminder-ru.ts',
    command: [
        lupdate,
        meson.project_source_root(),
        '-ts', meson.project_source_root() / '@OUTPUT@',
    ],
)

custom_target(
    'en-qm',
    input: en_ts,
    output: f'dev.glazkov.BeerReminder.qm',
    command: [
        lrelease,
        meson.current_source_dir() / 'dev.glazkov.BeerReminder.ts',
        '-qm', '@OUTPUT@',
    ],
    install: true,
    install_dir: get_option('datadir') / meson.project_name() / 'translations',
)

custom_target(
    'ru-qm',
    input: ru_ts,
    output: f'dev.glazkov.BeerReminder-ru.qm',
    command: [
        lrelease,
        meson.current_source_dir() / 'dev.glazkov.BeerReminder-ru.ts',
        '-qm', '@OUTPUT@',
    ],
    install: true,
    install_dir: get_option('datadir') / meson.project_name() / 'translations',
)
