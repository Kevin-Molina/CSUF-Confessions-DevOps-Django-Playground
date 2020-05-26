from django.contrib.auth.models import User
from django.db import models


class Confession(models.Model):
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=30)
    body = models.CharField(max_length=120)
    vote_count = models.IntegerField(default=0)
