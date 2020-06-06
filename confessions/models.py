from django.contrib.auth.models import User
from django.db import models
from django.urls import reverse


class Snitch(User):
    class Meta:
        proxy = True

    def get_alias(self):
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
        return aliases[self.id % len(aliases)]


class Confession(models.Model):
    snitch = models.ForeignKey(Snitch, on_delete=models.CASCADE, db_index=True)
    title = models.CharField(max_length=30)
    body = models.CharField(max_length=120)

    def get_absolute_url(self):
        return reverse("view_confession", args=[self.id])

    class Meta:
        ordering = ["-id"]


class Comment(models.Model):
    snitch = models.ForeignKey(Snitch, on_delete=models.CASCADE, db_index=True)
    confession = models.ForeignKey(Confession, on_delete=models.CASCADE, db_index=True)
    comment = models.CharField(max_length=120)


class Vote(models.Model):
    DOWNVOTE = -1
    UPVOTE = 1
    VOTE_CHOICES = ((DOWNVOTE, "Downvote"), (UPVOTE, "Upvote"))

    confession = models.ForeignKey(Confession, on_delete=models.CASCADE, db_index=True)
    snitch = models.ForeignKey(Snitch, on_delete=models.CASCADE)
    vote = models.SmallIntegerField(choices=VOTE_CHOICES)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["snitch", "confession"], name="unique_vote")
        ]
