/*
for graphics we have these options:
, EFL EVAS
	https://packages.debian.org/bookworm/libevas1
	https://packages.debian.org/bookworm/libevas1-engines-wayland
, glfw + vkvg + bgfx
	vkvg needs vulkan, if vulkan driver is not available, mesa falls back to software redering
	in this case we can even replace vkvg with cairo + fcft4
, sdl3 + sdl3-ttf (needs vulkan)
	https://github.com/libsdl-org/SDL_shader_tools/blob/main/docs/README-SDL_gpu.md
	https://discourse.libsdl.org/t/is-there-is-any-guide-for-mixing-opengl-and-sdl-rendering
, blend2d: currently only supports X86 and ARM
, picasso: currently does not support text shaping
, raylib: no text shaping, low quality text rasterization

https://github.com/HOST-Oman/libraqm
https://github.com/fribidi/fribidi

libimlib2 libgraphicsmagick-q16-3
libavfilter
pipewire
libwpewebkit

widgets: containers, image/video (view and edit), text (view and edit)

https://notabug.org/bfgeshka/awesome-c
https://github.com/floooh/sokol
https://github.com/nothings/single_file_libs
https://github.com/nothings/stb
https://github.com/grz0zrg/fbg
https://github.com/rougier/freetype-gl
https://github.com/anoek/ex-sdl-cairo-freetype-harfbuzz
*/