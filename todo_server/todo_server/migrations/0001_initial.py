# Generated by Django 4.0.4 on 2022-08-25 00:53

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Todo',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=128)),
                ('description', models.CharField(max_length=1024)),
                ('completed', models.BooleanField(default=False)),
                ('date_completed', models.DateTimeField()),
                ('date_created', models.DateTimeField(auto_now=True)),
            ],
        ),
    ]