def xcalc(x: float, zone_width: float, view_width: float):
    if x >= zone_width - view_width:
        return zone_width - view_width
    return x


def main() -> None:
    zone_width = 100
    view_width = 40

    for val in range(30, 100, 5):
        print(xcalc(val, zone_width, view_width))


if __name__ == "__main__":
    main()
