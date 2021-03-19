// Header (.h) for font: anomaly_mono_regular

#include <stdint.h>

extern const int TALLEST_CHAR_PIXELS;

extern const uint8_t anomaly_mono_regular_pixels[];

struct font_char {
    int offset;
    int w;
    int h;
    int left;
    int top;
    int advance;
};

extern const struct font_char anomaly_mono_regular_lookup[];
