import random
from itertools import cycle


def get_confession_styles_cycle():
    """Returns repeated iterable to cycle through styles"""
    styles = [
        "card text-white bg-warning mb-3 cCard",
        "card text-white bg-primary mb-3 cCard",
    ]
    random.shuffle(styles)
    return cycle(styles)


def get_comment_styles_cycle():
    """Returns repeated iterable to cycle through styles"""
    styles = ["card text-white bg-warning mb-3", "card text-white bg-primary mb-3"]
    random.shuffle(styles)
    return cycle(styles)


def get_alias_from_user_id(user_id):
    aliases = [
        "SaucySheep",
        "ColonialClownFish",
        "CombatantCorgi",
        "DisappointedDog",
        "KookyKangaroo",
        "TacticalTurtle",
        "PeppyPig",
        "DistressedDuck",
        "WeatherproofWhale",
        "FascistFish",
        "BarbarianBull",
        "SeasickStork",
        "CalculatedCat",
        "CharmingChicken",
        "CaptivatingCaterpillar",
        "OblongOctopus",
        "SacrilegiousShark",
        "PuzzledPuffin",
        "PragmaticPrawn",
        "BashfulBee",
    ]
    return aliases[user_id % len(aliases)]
