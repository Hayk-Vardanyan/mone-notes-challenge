cd ..
dart run build_runner build --delete-conflicting-outputs && dart run easy_localization:generate -f keys -O lib/gen -o locale_keys.g.dart -S assets/translations -s en-US.json -u true
