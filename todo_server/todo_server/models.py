from pydoc import describe
from django.db import models


class Todo (models.Model):
    title = models.CharField(max_length=128)
    description = models.CharField(max_length=1024)
    completed = models.BooleanField(default=False)
    date_completed = models.DateTimeField()
    date_created = models.DateTimeField(auto_now=True)