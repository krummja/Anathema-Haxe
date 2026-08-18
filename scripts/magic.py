from enum import StrEnum
import itertools


class Element(StrEnum):
    HEAVEN = "HEAVEN"
    LAKE = "LAKE"
    FIRE = "FIRE"
    THUNDER = "THUNDER"
    EARTH = "EARTH"
    MOUNTAIN = "MOUNTAIN"
    WATER = "WATER"
    WIND = "WIND"


if __name__ == "__main__":
    results = itertools.permutations(
        [
            Element.HEAVEN,
            Element.LAKE,
            Element.FIRE,
            Element.THUNDER,
            Element.EARTH,
            Element.MOUNTAIN,
            Element.WATER,
            Element.WIND,
        ],
        r=2,
    )

    permutations = []
    # permutations = [f"{result[0]}_{result[1]}" for result in results]

    for result in results:
        permutations.append(f"{result[0]}_{result[1]}")

    maximal_permutations = itertools.permutations(permutations, r=2)

    print(len([_ for _ in maximal_permutations]))
