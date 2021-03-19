#!/usr/bin/env python
# Adapted from rogerdahl/font-to-c

import freetype
import re
from io import StringIO
import os

FONT_FILE_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)),
                              'AnomalyMono.otf')
FONT_PIXEL_SIZE = 40
FIRST_CHAR = ' '
LAST_CHAR = '~'
TAB_STR = ' ' * 4
NAME = 'anomaly_mono_regular'

def main():
    ClangGenerator(FONT_FILE_PATH, FONT_PIXEL_SIZE)

class ClangGenerator(object):
    def __init__(self, fontFile_path, pixelSize_int):
        self.pixelSize_int = pixelSize_int
        self.face = freetype.Face(fontFile_path)
        self.face.set_pixel_sizes(0, pixelSize_int)
        self.h_file = open(self._get_header_name(), 'w')
        self.c_file = open(self._get_source_name(), 'w')
        self.generate_c_header()
        self.generate_c_source()

    def generate_c_header(self):
        self.h_file.write('// Header (.h) for font: {}\n\n'.format(NAME))
        self.h_file.write('#include <stdint.h>\n\n')
        self.h_file.write('extern const int TALLEST_CHAR_PIXELS;\n\n'.format(self._get_height_of_tallest_char()))
        self.h_file.write('extern const uint8_t {}_pixels[];\n\n'.format(NAME))
        self.h_file.write('struct font_char {\n')
        self.h_file.write('{}int offset;\n'.format(TAB_STR))
        self.h_file.write('{}int w;\n'.format(TAB_STR))
        self.h_file.write('{}int h;\n'.format(TAB_STR))
        self.h_file.write('{}int left;\n'.format(TAB_STR))
        self.h_file.write('{}int top;\n'.format(TAB_STR))
        self.h_file.write('{}int advance;\n'.format(TAB_STR))
        self.h_file.write('};\n\n')
        self.h_file.write('extern const struct font_char {}_lookup[];\n'.format(NAME))

    def generate_c_source(self):
        self.c_file.write('// Source (.c) for font: {}\n\n'.format(NAME))
        self.c_file.write('#include "{}"\n\n'.format(self._get_header_name()))
        self.c_file.write('const int TALLEST_CHAR_PIXELS = {};\n\n'.format(self._get_height_of_tallest_char()))
        self._generate_lookup_table()
        self._generate_pixel_table()

    def _generate_lookup_table(self):
        self.c_file.write('const struct font_char {}_lookup[] = {{\n'.format(NAME))
        self.c_file.write('{}// offset, width, height, left, top, advance\n'.format(TAB_STR))
        offset = 0
        for j in range(128):
            if j in range(ord(FIRST_CHAR), ord(LAST_CHAR) + 1):
                char = chr(j)
                char_bmp, buf, w, h, left, top, advance, pitch = self._get_char(char)
                self._generate_lookup_entry_for_char(char, offset, w, h, left, top, advance)
                offset += w * h
            else:
                self.c_file.write('{}{{0, 0, 0, 0, 0}},\n'.format(TAB_STR))
        self.c_file.write('{}{{0, 0, 0, 0, 0}}\n'.format(TAB_STR))
        self.c_file.write('};\n\n')

    def _generate_lookup_entry_for_char(self, char, offset, w, h, left, top, advance):
        self.c_file.write('{}{{{}, {}, {}, {}, {}, {}}}, // {} ({})\n'
                          .format(TAB_STR, offset, w, h, left, top, advance, char, ord(char)))

    def _generate_pixel_table(self):
        self.c_file.write('const uint8_t {}_pixels[] = {{\n'.format(NAME))
        self.c_file.write('{}// width, height, left, top, advance\n'.format(TAB_STR))
        for i in range(ord(FIRST_CHAR), ord(LAST_CHAR) + 1):
            char = chr(i)
            self._generate_pixel_table_for_char(char)
        self.c_file.write('{}0x00\n'.format(TAB_STR))
        self.c_file.write('};\n\n')

    def _generate_pixel_table_for_char(self, char):
        char_bmp, buf, w, h, left, top, advance, pitch = self._get_char(char)
        self.c_file.write('{}// {} ({})\n'.format(TAB_STR, char, ord(char)))
        if not buf:
            return ''
        for y in range(char_bmp.rows):
            self.c_file.write('{}'.format(TAB_STR))
            self._hex_line(buf, y, w, pitch)
            self.c_file.write(' // ')
            self._ascii_art_line(buf, y, w, pitch)
            self.c_file.write('\n')

    def _get_height_of_tallest_char(self):
        tallest = 0
        for i in range(ord(FIRST_CHAR), ord(LAST_CHAR) + 1):
            char = chr(i)
            char_bmp, buf, w, h, left, top, advance, pitch = self._get_char(char)
            if top - h  > tallest:
                tallest = top - h
        return tallest

    def _get_char(self, char):
        char_bmp = self._render_char(char) # Side effect: updates self.face.glyph
        assert(char_bmp.pixel_mode == 2) # 2 = FT_PIXEL_MODE_GRAY
        assert(char_bmp.num_grays == 256) # 256 = 1 byte per pixel
        w, h = char_bmp.width, char_bmp.rows
        left = self.face.glyph.bitmap_left
        top = FONT_PIXEL_SIZE - self.face.glyph.bitmap_top
        advance = self.face.glyph.linearHoriAdvance >> 16
        buf = char_bmp.buffer
        return char_bmp, buf, w, h, left, top, advance, char_bmp.pitch

    def _render_char(self, char):
        self.face.load_char(char, freetype.FT_LOAD_RENDER)
        return self.face.glyph.bitmap

    def _hex_line(self, buf, y, w, pitch):
        for x in range(w):
            v = buf[x + y * pitch]
            self.c_file.write('0x{:02x},'.format(v))

    def _ascii_art_line(self, buf, y, w, pitch):
        for x in range(w):
            v = buf[x + y * pitch]
            self.c_file.write(" .:-=+*#%@"[int(v / 26)])

    def _get_header_name(self):
        return '{}.h'.format(NAME)

    def _get_source_name(self):
        return '{}.c'.format(NAME)

if __name__ == '__main__':
    main()
