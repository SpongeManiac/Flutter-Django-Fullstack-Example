import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {
  BasePage({super.key, required this.title});
  String title;
}
