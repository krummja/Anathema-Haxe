from dataclasses import dataclass, field


@dataclass(frozen=True)
class Card:
    value: int


@dataclass
class Hand:
    value: int
    cards: list[Card] = field(default_factory=list)
    may_hit: bool = True

    def add_card(self, card: Card) -> None:
        self.cards.append(card)
        self.value += card.value

    def hold(self) -> int:
        self.may_hit = False
        return self.value

    def bust(self) -> None:
        self.may_hit = False
        self.value = 0
