from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django.urls import reverse_lazy, reverse
from django.views.generic.list import ListView
from django.views.generic.edit import CreateView, DeleteView
from django.db.models import Sum, Count, OuterRef, Subquery, IntegerField
from django.db.models.functions import Coalesce

from confessions.forms import ConfessionForm, VoteForm, CommentForm
from .models import Confession, Comment, Vote
from .utils import (
    get_confession_styles_cycle,
    get_alias_from_user_id,
    get_comment_styles_cycle,
)


class ConfessionListView(ListView):
    template_name = "confessions/confessions.html"
    context_object_name = "confessions"
    paginate_by = 10

    def get_queryset(self):
        styles_cycle = get_confession_styles_cycle()

        comment_count = Confession.objects.annotate(
            comment_count=Count("comment")
        ).filter(pk=OuterRef("pk"))
        vote_count = Confession.objects.annotate(vote_count=Sum("vote__vote")).filter(
            pk=OuterRef("pk")
        )

        confessions = Confession.objects.annotate(
            comment_count=Subquery(
                comment_count.values("comment_count"), output_field=IntegerField()
            ),
            vote_count=Subquery(
                vote_count.values("vote_count"), output_field=IntegerField()
            ),
        )

        # Re-use view to display only "own" confessions
        if (
            self.request.GET.get("owner") == "self"
            and self.request.user.is_authenticated
        ):
            confessions = confessions.filter(user=self.request.user)

        for confession in confessions:
            confession.css_class = next(styles_cycle)
            confession.alias = get_alias_from_user_id(confession.user_id)

            if (
                self.request.user.is_authenticated
                and confession.user == self.request.user
            ):
                confession.is_self_owned = True

        return confessions


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
        form.instance.confession_id = self.kwargs["pk"]
        try:
            vote = Vote.objects.get(
                user=self.request.user, confession_id=self.kwargs["pk"]
            )
            if vote.vote == form.instance.vote:
                form.instance.vote = 0
            vote.delete()  # Can just make this an update eventually
        except Vote.DoesNotExist:
            pass
        return super(VoteSubmitView, self).form_valid(form)

    def form_invalid(self, form):
        pass


class CommentListView(ListView):
    template_name = "confessions/comments.html"
    context_object_name = "comments"
    paginate_by = 4

    def get_queryset(self):
        return Comment.objects.filter(confession=self.kwargs["pk"]).order_by(
            "-created_at"
        )

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)

        styles_cycle = get_comment_styles_cycle()

        for comment in context["comments"]:
            comment.css_class = next(styles_cycle)
            comment.alias = get_alias_from_user_id(comment.user_id)

        confession = Confession.objects.get(id=self.kwargs["pk"])
        confession.alias = get_alias_from_user_id(confession.user_id)
        confession.css_class = next(get_confession_styles_cycle())
        context["confession"] = confession
        context["form"] = CommentForm
        return context


class CommentSubmitView(SuccessMessageMixin, LoginRequiredMixin, CreateView):
    model = Comment
    form_class = CommentForm
    success_message = "Comment Submitted"

    def get_success_url(self):
        return reverse("view_confession", kwargs={"pk": self.kwargs["pk"]})

    def form_valid(self, form):
        form.instance.user = self.request.user
        form.instance.confession_id = self.kwargs["pk"]
        return super(CommentSubmitView, self).form_valid(form)


class ConfessionDeleteView(LoginRequiredMixin, DeleteView):
    model = Confession
    success_url = reverse_lazy("confessions")
