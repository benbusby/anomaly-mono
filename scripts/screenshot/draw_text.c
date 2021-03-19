#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#include "anomaly_mono_regular.h"

#define font_lookup anomaly_mono_regular_lookup
#define font_pixels anomaly_mono_regular_pixels

const int W = 820;
const int H = 150;
const int TRANSPARENT_COLOR = 0;

void draw_text(uint8_t* buf, int pos_x, int pos_y, char* s) {
  char c = *s;
  while (c) {
    const struct font_char font_c = font_lookup[c];
    for (int y = 0; y < font_c.h; ++y) {
      for (int x = 0; x < font_c.w; ++x) {
        uint8_t v = font_pixels[font_c.offset + x + y * font_c.w];
        if (v != TRANSPARENT_COLOR) {
          buf[pos_x + x + font_c.left + (pos_y + y + font_c.top) * W] = v;
        }
      }
    }
    pos_x += font_c.advance;
    c = *(++s);
  }
}

void write_ppm(char* filename, uint8_t* buf) {
  FILE* fp = fopen(filename, "wb");
  fprintf(fp, "P6\n%d %d 255\n", W, H);
  for (int y = 0; y < H; ++y) {
    for (int x = 0; x < W; ++x) {
      uint8_t v = buf[x + (y * W)];
      fwrite(&v, 1, 1, fp);
      fwrite(&v, 1, 1, fp);
      fwrite(&v, 1, 1, fp);
    }
  }
}

int main(void) {
  uint8_t* buf = malloc(W * H * sizeof(uint8_t));
  draw_text(buf, 0, 0 * TALLEST_CHAR_PIXELS, " ABCDEFGHIJKLMNOPQRSTUVWXYZ | ANOMALY MONO ");
  draw_text(buf, 0, 1 * TALLEST_CHAR_PIXELS, " abcdefghijklmnopqrstuvwxyz | anomaly mono ");
  draw_text(buf, 0, 2 * TALLEST_CHAR_PIXELS, " !@#$%^&*+=()[]{};:?><\\/.,\" | -1.234567890 ");
  write_ppm("anomaly_mono.ppm", buf);
  return 0;
}
