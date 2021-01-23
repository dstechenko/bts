#include <drivers/colors.hpp>
#include <drivers/screen.hpp>
#include <kernel/bits.hpp>
#include <kernel/ports.hpp>
#include <kernel/utils.hpp>
#include <portability/layout.hpp>

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
  uint8_t text;
  uint8_t data;
  static VideoTextData* get(int16_t offset = 0) {
    return reinterpret_cast<VideoTextData*>(VGA_VIDEO_ADDRESS) + offset;
  }
  static uint8_t* getBytes(int16_t offset = 0) {
    return reinterpret_cast<uint8_t*>(get(offset));
  }
} PACKED;

int16_t getScreenOffset(int16_t col, int16_t row) {
  return VGA_MAX_COLS * row + col;
}

int16_t getScreenRow(int16_t offset) { return offset / VGA_MAX_COLS; }

int16_t handleScrolling(int16_t offset) {
  if (offset >= VGA_MAX_COLS * VGA_MAX_ROWS) {
    for (int16_t row = 1; row < VGA_MAX_ROWS; row++) {
      Utils::copyMemory(
          VideoTextData::getBytes(getScreenOffset(/* col = */ 0, row - 1)),
          VideoTextData::getBytes(getScreenOffset(/* col = */ 0, row)),
          sizeof(VideoTextData) * VGA_MAX_COLS);
    }

    const auto lastLine = getScreenOffset(/* col = */ 0, VGA_MAX_ROWS - 1);
    auto* video = VideoTextData::get(lastLine);
    for (int16_t col = 0; col < VGA_MAX_COLS; col++) {
      video[col].text = 0;
    }

    offset -= VGA_MAX_COLS;
  }
  return offset;
}

int16_t getCursorOffset() {
  Ports::writeByte(REG_SCREEN_CTRL, REG_SCREEN_CURSOR_HB);
  int16_t offset = Ports::readByte(REG_SCREEN_DATA) << 8;
  Ports::writeByte(REG_SCREEN_CTRL, REG_SCREEN_CURSOR_LB);
  offset |= Ports::readByte(REG_SCREEN_DATA);
  return offset;
}

void setCursorOffset(int16_t offset) {
  Ports::writeByte(REG_SCREEN_CTRL, REG_SCREEN_CURSOR_HB);
  Ports::writeByte(REG_SCREEN_DATA, HIGH_BYTE(offset));
  Ports::writeByte(REG_SCREEN_CTRL, REG_SCREEN_CURSOR_LB);
  Ports::writeByte(REG_SCREEN_DATA, LOW_BYTE(offset));
}

void printCharacter(char text, uint8_t data, int16_t col, int16_t row) {
  auto* video = VideoTextData::get();

  int16_t offset;
  if (col >= 0 && row >= 0) {
    offset = getScreenOffset(col, row);
  } else {
    offset = getCursorOffset();
  }

  if (text == '\n') {
    offset = getScreenOffset(VGA_MAX_COLS - 1, getScreenRow(offset));
  } else {
    video[offset] = {.text = static_cast<uint8_t>(text), .data = data};
  }

  offset++;
  offset = handleScrolling(offset);
  setCursorOffset(offset);
}

}  // namespace

/* static */
void Screen::print(const char* text) {
  printAt(text, /* col = */ -1, /* row = */ -1);
}

/* static */
void Screen::printAt(const char* text, int16_t col, int16_t row) {
  if (col >= 0 && row >= 0) {
    setCursorOffset(getScreenOffset(col, row));
  }
  for (int16_t it = 0; text[it] != 0; it++) {
    printCharacter(text[it], Colors::makeDefault(), col, row);
  }
}

/* static */
void Screen::printLine(const char* text) {
  print(text);
  printLine();
}

/* static */
void Screen::printLine() { print("\n"); }

/* static */
void Screen::clear() {
  for (int16_t row = 0; row < VGA_MAX_ROWS; row++) {
    for (int16_t col = 0; col < VGA_MAX_COLS; col++) {
      printCharacter(/* text = */ ' ', Colors::makeDefault(), col, row);
    }
  }
  setCursorOffset(getScreenOffset(/* col = */ 0, /* row = */ 0));
}

}  // namespace dokkan::drivers
