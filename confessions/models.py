from django.contrib.auth.models import User
from django.db import models


class Confession(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, db_index=True)
    title = models.CharField(max_length=30)
    body = models.CharField(max_length=120)
    date_created = models.DateTimeField(db_index=True)


class Comment(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, db_index=True)
    confession = models.ForeignKey(Confession, on_delete=models.CASCADE, db_index=True)
    comment = models.CharField(max_length=120)


class Vote(models.Model):
    DOWNVOTE = -1
    UPVOTE = 1
    VOTE_CHOICES = ((DOWNVOTE, "Downvote"), (UPVOTE, "Upvote"))

    confession = models.ForeignKey(Confession, on_delete=models.CASCADE, db_index=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    vote = models.SmallIntegerField(choices=VOTE_CHOICES)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["user", "confession"], name="unique_vote")
        ]
