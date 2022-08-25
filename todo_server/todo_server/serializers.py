from datetime import datetime
from rest_framework import serializers
from .models import Todo

def getTime():
    return datetime.min

class TodoSerializer(serializers.Serializer):
    title = serializers.CharField(max_length=128)
    description = serializers.CharField(max_length=1024)
    completed = serializers.BooleanField()
    date_completed = serializers.HiddenField(default=datetime.min)
    date_created = serializers.HiddenField(default=getTime())

    def create(self, validated_data):
        return Todo.objects.create(**validated_data)

    def update(self, instance, validated_data):
        instance.title = validated_data.get('title', instance.title)
        instance.description = validated_data.get('description', instance.description)
        instance.completed = validated_data.get('completed', instance.completed)
        instance.date_completed = validated_data.get('date_completed', instance.date_completed)
        instance.date_created = validated_data.get('date_created', instance.date_created)
        instance.save()
        return instance