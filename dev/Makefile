
RAYLIB_HEAD ?= $(shell pkgconf --variable=includedir raylib)
RAYLIB_LIB ?= $(shell pkgconf --variable=libdir raylib)

lua: clean buildnative buildlua run
fnl: clean buildnative buildfnl run
buildnative:
	mkdir -p out
	gcc -E $(RAYLIB_HEAD)/raylib.h | sed 's/#.*//' > out/praylib.h
	cp $(RAYLIB_LIB)/libraylib.so out/libraylib.so
buildlua:
	mkdir -p out
	cp bebra.lua out/main.lua
buildfnl:
	mkdir -p out
	fennel -c bebra.fnl > out/main.lua
clean:
	rm -rf out
run:
	-@cd out && luajit main.lua
love:
	@echo make war, not love
debugfnl:
	fennel -c bebra.fnl
.PHONY: lua fnl buildnative buildlua buildfnl clean run love
