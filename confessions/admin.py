from django.contrib import admin
from .models import Confession, Comment, Vote

admin.site.register((Confession, Comment, Vote))
