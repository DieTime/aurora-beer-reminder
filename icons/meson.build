foreach resolution : ['86x86', '108x108', '128x128', '172x172']
    install_data(
        f'@resolution@.png',
        install_dir: get_option('datadir') / f'icons/hicolor/@resolution@/apps',
        rename: '@0@.png'.format(meson.project_name()),
    )
endforeach
