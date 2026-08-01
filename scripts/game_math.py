from typing import NamedTuple
import random


class RollResult(NamedTuple):
    die: str
    rolls: list[int]
    total: int


class Die:
    def __init__(self, sides: int) -> None:
        self.sides: int = sides

    def roll(self, amount: int) -> RollResult:
        results: list[int] = []
        for _ in range(amount):
            results.append(random.randint(1, self.sides))
        result = sum(results)
        return RollResult(f"{amount}d{self.sides}", results, result)


coin_flip = Die(2)
d3 = Die(3)
d4 = Die(4)
d5 = Die(5)
d6 = Die(6)
d7 = Die(7)
d8 = Die(8)
d10 = Die(10)
d12 = Die(12)
d20 = Die(20)


class Dice(NamedTuple):
    amount: int
    die: Die


class Roller:
    def __init__(self, dice_pool: list[Dice]) -> None:
        self._pool: list[Dice] = dice_pool

    def roll(self) -> list[RollResult]:
        result: list[RollResult] = []
        for dice in self._pool:
            result.append(dice.die.roll(dice.amount))
        return result


def main() -> None:
    roller = Roller([Dice(1, d10)])
    result = roller.roll()
    print(result)


if __name__ == "__main__":
    main()
