from django.forms import ModelForm
from .models import Confession, Comment


class ConfessionForm(ModelForm):
    class Meta:
        model = Confession
        fields = ["title", "body"]


class CommentForm(ModelForm):
    class Meta:
        model = Comment
        fields = ["comment"]
