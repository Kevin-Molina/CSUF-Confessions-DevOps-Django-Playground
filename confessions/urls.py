from django.urls import path, re_path

from . import views

urlpatterns = [
    path("submit/", views.ConfessionView.as_view(), name="submit_confession"),
    path("<int:id>/", views.ConfessionView.as_view(), name="view_confession"),
    path("", views.ConfessionListView.as_view(), name="confessions"),
]
