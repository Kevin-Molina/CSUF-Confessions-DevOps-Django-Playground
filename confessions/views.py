from django.views import View
from django.views.generic.list import ListView
from django.shortcuts import render
from django.db.models import Sum
from django.db.models.functions import Coalesce

import random
import copy
from itertools import cycle
from .models import Confession, Comment, Vote


class ConfessionListView(ListView):
    template_name = "confessions/confessions.html"
    context_object_name = "confessions"
    paginate_by = 10

    def get_queryset(self):
        owner_id = self.request.GET.get("owner_id")
        # TODO - Edge cases
        if (
            owner_id
            and self.request.user.is_authenticated
            and owner_id == self.request.user.id
        ):
            confessions = Confession.objects.filter(user=self.request.user)
        else:
            confessions = Confession.objects.all()

        # Default vote count to 0
        confessions = confessions.annotate(vote_count=Coalesce(Sum("vote__vote"), 0))

        styles_cycle = self.__get_styles_cycle()

        for confession in confessions:
            confession.css_class = next(styles_cycle)
            confession.alias = self.__get_alias_from_user_id(confession.user.id)
        return confessions

    @staticmethod
    def __get_alias_from_user_id(user_id):
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

    @staticmethod
    def __get_styles_cycle():
        """Returns repeated iterable to cycle through styles"""
        styles = [
            "card text-white bg-warning mb-3 cCard",
            "card text-white bg-danger mb-3 cCard",
            "card text-white bg-primary mb-3 cCard",
            "card text-white bg-secondary mb-3 cCard",
            "card text-white bg-success mb-3 cCard",
            "card text-white bg-info mb-3 cCard",
            "card bg-light mb-3 cCard",
        ]
        random.shuffle(styles)
        return cycle(styles)


class ConfessionView(View):
    confession_styles = [
        "card text-white bg-warning mb-3 cCard",
        "card text-white bg-danger mb-3 cCard",
        "card text-white bg-primary mb-3 cCard",
        "card text-white bg-secondary mb-3 cCard",
        "card text-white bg-success mb-3 cCard",
        "card text-white bg-info mb-3 cCard",
        "card bg-light mb-3 cCard",
    ]

    def get(self, request):
        offset = request.GET.get("page")
        if request.user.is_authenticated:
            pass

    def post(self, request):
        pass

    def delete(self, request):
        pass
