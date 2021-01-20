#include <drivers/screen.hpp>

#define VGA_VIDEO_ADDRESS 0x000B8000

#define VGA_DATA_SIZE 2

#define VGA_MAX_ROWS 25
#define VGA_MAX_COLS 80

#define DEFAULT_COLORS 0x0F

#define REG_SCREEN_CTRL 0x03D4
#define REG_SCREEN_DATA 0x03D5

namespace dokkan::drivers {

namespace {

int get_offset(int col, int row) {
  return VGA_DATA_SIZE * (VGA_MAX_COLS * row + col);
}

int get_offset_row(int offset) {
  return offset / (VGA_DATA_SIZE * VGA_MAX_COLS);
}

int get_offset_col(int offset) {
  return (offset / VGA_DATA_SIZE) - (get_offset_row(offset) * VGA_MAX_COLS);
}

// void print_char(byte_t character, int col, int row, byte_t attribute) {
//   auto *memory = static_cast<byte_t *>(VGA_VIDEO_ADDRESS);

//   if (attribute == 0) {
//     attribute = DEFAULT_COLORS;
//   }

//   int offset;
//   if (col >= 0 && row >= 0) {
//     offset = get_screen_offset(col, row);
//   } else {
//     offset = get_cursor();
//   }

//   if (character == '\n') {
//     offset = get_screen_offset(VGA_MAX_COLS - 1, get_offset_row(offset));
//   } else {
//     memory[offset] = character;
//     memory[offset + 1] = attribute;
//   }

//   offset += 2;
//   offset = handle_scrolling(offset);
//   set_cursor(offset);
// }

int get_cursor_offset() { return 0; }

void set_cursor_offset() {}

void clear_screen() {}

} // namespace

/* static */
void Screen::print(string_t data) {}

/* static */
void Screen::print(string_t data, int col, int row) {}

} // namespace dokkan::drivers
