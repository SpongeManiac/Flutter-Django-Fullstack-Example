# Flutter/Django Fullstack Todo App

An example project to demonstrate how to create a fullstack, cross-platform app using Flutter and Django.
This project is purely for learning purposes and is not production ready.
Originally inspired by [Dennis Ivanov](https://www.youtube.com/watch?v=VnztChBw7Og&ab_channel=DennisIvy)'s livestream.

## Requirements
To run this example stack, you will need Python3 and Flutter.
It is recommended you use a virtual environment for the Django server.
## Setup & Start
After pulling the repo, open a terminal/powershell in the `todo_server` folder.
```
.../Flutter-Django-Fullstack-Example/todo_server
```

Use `pim` to install the packages listed in `requirements.txt`.
```
python -m pim install -r requirements.txt
```

After all python dependencies have downloaded and installed, the server is ready to be run.
Use `manage.py` to start the server.
```
python manage.py runserver
```

In another terminal/powershell, navigate to the `todo_client` folder.
```
.../Flutter-Django-Fullstack-Example/todo_client
```

Use `flutter` to get all dependencies.
```
flutter pub get
```

The app can now be run. Use `flutter` to start the app.
```
flutter run
```

Enter a number to select the platform to run the app on.
```
Multiple devices found:
Windows (desktop) • windows • windows-x64    • Microsoft Windows [Version 10.0.19044.1826]
Chrome (web)      • chrome  • web-javascript • Google Chrome 104.0.5112.102
Edge (web)        • edge    • web-javascript • Microsoft Edge 104.0.1293.70
[1]: Windows (windows)
[2]: Chrome (chrome)
[3]: Edge (edge)
Please choose one (To quit, press "q/Q"): 2
```

## Viewing/Editing Todos Manually
You can view and edit the Todo database manually by navigating to [http://localhost:8000/todos/](http://localhost:8000/todos/). To view or edit an individual todo, add the todo's `id` to the end of the URL: `http://localhost:8000/todos/1` will show you the first todo.
