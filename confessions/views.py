from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django.http import HttpResponseRedirect
from django.shortcuts import redirect
from django.urls import reverse_lazy, reverse
from django.views import View
from django.views.generic.list import ListView
from django.views.generic.edit import CreateView, DeleteView
from django.db.models import Sum
from django.db.models.functions import Coalesce

import random
import copy
from itertools import cycle

from confessions.forms import ConfessionForm, VoteForm
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
            "card text-white bg-primary mb-3 cCard",
            "card text-white bg-info mb-3 cCard",
            "card bg-light mb-3 cCard",
            "card text-white bg-warning mb-3 cCard",
            "card text-white bg-primary mb-3 cCard",
            "card text-white bg-info mb-3 cCard",
            "card bg-light mb-3 cCard",
        ]
        random.shuffle(styles)
        return cycle(styles)


class ConfessionCreateView(SuccessMessageMixin, LoginRequiredMixin, CreateView):
    model = Confession
    form_class = ConfessionForm
    success_url = reverse_lazy("confessions")
    success_message = "Confession submitted ;)"

    def form_valid(self, form):
        form.instance.user = self.request.user
        response = super(ConfessionCreateView, self).form_valid(form)
        Vote.objects.create(
            confession=self.object, user=self.request.user, vote=Vote.UPVOTE
        )
        return response

    def get_success_message(self, cleaned_data):
        return self.success_message


class VoteSubmitView(SuccessMessageMixin, LoginRequiredMixin, CreateView):
    model = Vote
    form_class = VoteForm
    success_url = reverse_lazy("confessions")
    success_message = "Vote recorded"
    template_name = "confessions/confessions.html"

    def form_valid(self, form):
        form.instance.user = self.request.user
        form.instance.confession_id = self.kwargs["id"]
        try:
            vote = Vote.objects.get(
                user=self.request.user, confession_id=self.kwargs["id"]
            )
            if vote.vote == form.instance.vote:
                form.instance.vote = 0
            vote.delete()  # Can just make this an update eventually
        except Vote.DoesNotExist:
            pass
        return super(VoteSubmitView, self).form_valid(form)

    def form_invalid(self, form):
        pass


# class ConfessionDeleteView(DeleteView):
#     model = Confession
#     success_url = reverse_lazy()
