"""Create the LEARNERS DIC. launcher artwork using only Python's stdlib."""

from pathlib import Path
import struct
import zlib


SIZE = 512
SCALE = 3
INK = (49, 91, 72, 255)
PAPER = (245, 243, 236, 255)
RULE = (115, 143, 127, 255)


def blank():
    return bytearray(SIZE * SCALE * SIZE * SCALE * 4)


def polygon(pixels, points, color):
    width = height = SIZE * SCALE
    points = [(int(x * SCALE), int(y * SCALE)) for x, y in points]
    for y in range(max(0, min(p[1] for p in points)), min(height, max(p[1] for p in points))):
        scan = y + 0.5
        crossings = []
        for index, (x1, y1) in enumerate(points):
            x2, y2 = points[(index + 1) % len(points)]
            if (y1 <= scan < y2) or (y2 <= scan < y1):
                crossings.append(x1 + (scan - y1) * (x2 - x1) / (y2 - y1))
        crossings.sort()
        for left, right in zip(crossings[::2], crossings[1::2]):
            start, end = max(0, int(left)), min(width, int(right + 1))
            for x in range(start, end):
                offset = (y * width + x) * 4
                pixels[offset : offset + 4] = bytes(color)


def rect(pixels, x1, y1, x2, y2, color):
    polygon(pixels, [(x1, y1), (x2, y1), (x2, y2), (x1, y2)], color)


def resize(pixels):
    output = bytearray(SIZE * SIZE * 4)
    source_width = SIZE * SCALE
    for y in range(SIZE):
        for x in range(SIZE):
            sums = [0, 0, 0, 0]
            for dy in range(SCALE):
                for dx in range(SCALE):
                    offset = (((y * SCALE + dy) * source_width) + x * SCALE + dx) * 4
                    for channel in range(4):
                        sums[channel] += pixels[offset + channel]
            target = (y * SIZE + x) * 4
            for channel in range(4):
                output[target + channel] = (sums[channel] + SCALE * SCALE // 2) // (SCALE * SCALE)
    return output


def png_bytes(pixels):
    rows = bytearray()
    for y in range(SIZE):
        start = y * SIZE * 4
        rows.append(0)
        rows.extend(pixels[start : start + SIZE * 4])

    def chunk(name, data):
        return struct.pack(">I", len(data)) + name + data + struct.pack(">I", zlib.crc32(name + data) & 0xFFFFFFFF)

    return (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", struct.pack(">2I5B", SIZE, SIZE, 8, 6, 0, 0, 0))
        + chunk(b"IDAT", zlib.compress(bytes(rows), 9))
        + chunk(b"IEND", b"")
    )


def draw_book(pixels):
    polygon(pixels, [(104, 150), (242, 184), (242, 360), (104, 326)], PAPER)
    polygon(pixels, [(270, 184), (408, 150), (408, 326), (270, 360)], PAPER)
    rect(pixels, 252, 186, 260, 360, RULE)
    for y in (232, 268, 304):
        rect(pixels, 128, y, 218 if y < 304 else 202, y + 7, RULE)
        rect(pixels, 294 if y < 304 else 310, y, 384, y + 7, RULE)


def main():
    output = Path(__file__).resolve().parents[1] / "build" / "brand"
    output.mkdir(parents=True, exist_ok=True)

    foreground = blank()
    draw_book(foreground)
    (output / "app_icon_foreground.png").write_bytes(png_bytes(resize(foreground)))

    full = blank()
    rect(full, 0, 0, SIZE, SIZE, INK)
    draw_book(full)
    (output / "app_icon.png").write_bytes(png_bytes(resize(full)))

    print("Generated LEARNERS DIC. launcher artwork.")


if __name__ == "__main__":
    main()
