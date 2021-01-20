#include <drivers/colors.hpp>
#include <drivers/screen.hpp>
#include <kernel/ports.hpp>
#include <kernel/utils.hpp>

#define VGA_VIDEO_ADDRESS 0x000B8000

#define VGA_MAX_ROWS 25
#define VGA_MAX_COLS 80

#define REG_SCREEN_CTRL 0x03D4
#define REG_SCREEN_DATA 0x03D5
#define REG_SCREEN_CURSOR_HB 0x0E
#define REG_SCREEN_CURSOR_LB 0x0F

using dokkan::kernel::Ports;
using dokkan::kernel::Utils;

namespace dokkan::drivers {

namespace {

struct VideoTextData {
  byte_t text;
  byte_t data;
  static VideoTextData* get(int offset = 0) {
    return reinterpret_cast<VideoTextData*>(VGA_VIDEO_ADDRESS) + offset;
  }
  static byte_t* getBytes(int offset = 0) {
    return reinterpret_cast<byte_t*>(get(offset));
  }
};

int getScreenOffset(int col, int row) { return VGA_MAX_COLS * row + col; }

int getScreenRow(int offset) { return offset / VGA_MAX_COLS; }

int handleScrolling(int offset) {
  if (offset >= VGA_MAX_COLS * VGA_MAX_ROWS) {
    for (int row = 1; row < VGA_MAX_ROWS; row++) {
      Utils::copyMemory(
          VideoTextData::getBytes(getScreenOffset(/* col = */ 0, row)),
          VideoTextData::getBytes(getScreenOffset(/* col = */ 0, row - 1)),
          sizeof(VideoTextData) * VGA_MAX_COLS);
    }

    const auto lastLine = getScreenOffset(/* col = */ 0, VGA_MAX_ROWS - 1);
    auto* video = VideoTextData::get(lastLine);
    for (int col = 0; col < VGA_MAX_COLS; col++) {
      video[col].text = 0;
    }

    offset -= VGA_MAX_COLS;
  }
  return offset;
}

int getCursorOffset() {
  Ports::writeByte(REG_SCREEN_CTRL, REG_SCREEN_CURSOR_HB);
  int offset = Ports::readByte(REG_SCREEN_DATA) << 8;
  Ports::writeByte(REG_SCREEN_CTRL, REG_SCREEN_CURSOR_LB);
  offset += Ports::readByte(REG_SCREEN_DATA);
  return offset;
}

void setCursorOffset(int offset) {
  Ports::writeByte(REG_SCREEN_CTRL, REG_SCREEN_CURSOR_HB);
  Ports::writeByte(REG_SCREEN_DATA, static_cast<byte_t>(offset >> 8));
  Ports::writeByte(REG_SCREEN_CTRL, REG_SCREEN_CURSOR_LB);
  Ports::writeByte(REG_SCREEN_DATA, static_cast<byte_t>(offset));
}

void printCharacter(char text, int col, int row, byte_t data) {
  auto* video = VideoTextData::get();

  int offset;
  if (col >= 0 && row >= 0) {
    offset = getScreenOffset(col, row);
  } else {
    offset = getCursorOffset();
  }

  if (text == '\n') {
    offset = getScreenOffset(VGA_MAX_COLS - 1, getScreenRow(offset));
  } else {
    video[offset] = {.text = static_cast<byte_t>(text), .data = data};
  }

  offset++;
  offset = handleScrolling(offset);
  setCursorOffset(offset);
}

}  // namespace

/* static */
void Screen::print(string_t data) {
  printAt(data, /* col = */ -1, /* row = */ -1);
}

/* static */
void Screen::printAt(string_t data, int col, int row) {
  if (col >= 0 && row >= 0) {
    setCursorOffset(getScreenOffset(col, row));
  }
  for (int it = 0; data[it] != 0; it++) {
    printCharacter(data[it], col, row, Colors::makeDefault());
  }
}

/* static */
void Screen::printLine(string_t data) {
  print(data);
  printLine();
}

/* static */
void Screen::printLine() { print("\n"); }

/* static */
void Screen::clear() {
  for (int row = 0; row < VGA_MAX_ROWS; row++) {
    for (int col = 0; col < VGA_MAX_COLS; col++) {
      printCharacter(/* data = */ ' ', col, row, Colors::makeDefault());
    }
  }
  setCursorOffset(getScreenOffset(/* col = */ 0, /* row = */ 0));
}

}  // namespace dokkan::drivers
