build:

install:
	install -d ~/.config/kak/autoload
	install rc/crystal.kak ~/.config/kak/autoload

uninstall:
	rm -f ~/.config/kak/autoload/crystal.kak
