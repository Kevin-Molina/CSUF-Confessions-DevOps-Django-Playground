from django import forms
from django.forms import ModelForm
from .models import Confession, Comment, Vote


class ConfessionForm(ModelForm):
    title = forms.CharField(
        widget=forms.Textarea(
            attrs={"rows": 1, "cols": 30, "placeholder": "Title goes here..."}
        )
    )
    body = forms.CharField(
        widget=forms.Textarea(
            attrs={"rows": 3, "cols": 40, "placeholder": "It all started when..."}
        )
    )

    class Meta:
        model = Confession
        fields = ["title", "body"]


class CommentForm(ModelForm):
    class Meta:
        model = Comment
        fields = ["comment"]


class VoteForm(ModelForm):
    class Meta:
        model = Vote
        fields = ["vote"]
