from django.urls import path

from . import views

urlpatterns = [path("", views.Confession.as_view(), name="confessions")]
