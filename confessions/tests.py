from django.test import TestCase
from django.contrib.auth.models import User
from confessions.models import Confession, Comment, Vote


class TestConfession(TestCase):
    def setUp(self):
        self.user = User.objects.create(username="testUser")
        self.confession = Confession.objects.create(
            user=self.user, title="title", body="body"
        )
        self.comment = Comment.objects.create(
            user=self.user, confession=self.confession, comment="comment"
        )
        self.vote = Vote.objects.create(
            user=self.user, confession=self.confession, vote=Vote.UPVOTE
        )

    def test_delete_confession(self):
        self.confession.delete()
        assert Confession.objects.count() == 0
        assert Comment.objects.count() == 0
        assert Vote.objects.count() == 0

    def test_delete_comment(self):
        self.comment.delete()
        assert Confession.objects.count() == 1
        assert Comment.objects.count() == 0
        assert Vote.objects.count() == 1
