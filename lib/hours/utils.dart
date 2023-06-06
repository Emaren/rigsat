import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<TimeOfDay?> showCustomTimePicker(
    BuildContext context, TimeOfDay initialTime) async {
  int selectedHour = initialTime.hour;
  int selectedMinute = initialTime.minute;

  final FixedExtentScrollController hourController =
      FixedExtentScrollController(initialItem: selectedHour);
  final FixedExtentScrollController minuteController =
      FixedExtentScrollController(initialItem: selectedMinute ~/ 15);

  return showCupertinoModalPopup<TimeOfDay>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 450,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 71, 72, 111),
              Color.fromARGB(255, 40, 40, 40)
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: hourController,
                      itemExtent: 70,
                      onSelectedItemChanged: (int index) {
                        selectedHour = index;
                      },
                      children: List<Widget>.generate(24, (int index) {
                        return Center(
                          child: Text(
                            '$index',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: minuteController,
                      itemExtent: 70,
                      onSelectedItemChanged: (int index) {
                        selectedMinute = index * 15;
                      },
                      children: List<Widget>.generate(4, (int index) {
                        return Center(
                          child: Text(
                            '${index * 15}'.padLeft(2, '0'),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: CupertinoButton(
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                onPressed: () {
                  Navigator.of(context).pop(
                      TimeOfDay(hour: selectedHour, minute: selectedMinute));
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

double calculateHoursWorked(
    TimeOfDay startTime, TimeOfDay endTime, bool lunchTaken) {
  double startHours = startTime.hour + startTime.minute / 60.0;
  double endHours = endTime.hour + endTime.minute / 60.0;
  double hoursWorked = endHours - startHours;

  if (lunchTaken) {
    hoursWorked -= 0.5;
  }

  return hoursWorked;
}

DateTime dateTimeWithTimeOfDay(DateTime date, TimeOfDay timeOfDay) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );
}

String formatTimeOfDay(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dateTime = dateTimeWithTimeOfDay(now, timeOfDay);
  final format = DateFormat.jm();
  return format.format(dateTime);
}
