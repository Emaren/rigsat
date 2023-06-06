import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'hours_entry_page.dart';
import 'utils.dart';

class PayDateCard extends StatefulWidget {
  final PayDate payDate;
  final String userId;
  final Function(PayDate payDate, int index, String userId) saveTime;
  final int index;

  const PayDateCard({
    Key? key,
    required this.payDate,
    required this.userId,
    required this.saveTime,
    required this.index,
  }) : super(key: key);

  @override
  _PayDateCardState createState() => _PayDateCardState();
}

List<PayDate> payDates = [];

class _PayDateCardState extends State<PayDateCard> {
  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;
    PayDate payDate = widget.payDate;

    TimeOfDay startTime =
        payDate.startTime ?? const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay endTime = payDate.endTime ?? const TimeOfDay(hour: 0, minute: 0);
    bool lunchTaken = payDate.lunchTaken;
    double totalHours = calculateHoursWorked(startTime, endTime, lunchTaken);

    return Card(
        child: GestureDetector(
      onTap: () async {
        TimeOfDay currentStartTime = TimeOfDay(
            hour: payDate.startTime?.hour ?? 0,
            minute: payDate.startTime?.minute ?? 0);
        TimeOfDay currentEndTime = TimeOfDay(
            hour: payDate.endTime?.hour ?? 0,
            minute: payDate.endTime?.minute ?? 0);

        TimeOfDay? newStartTime =
            await showCustomTimePicker(context, currentStartTime);
        TimeOfDay? newEndTime =
            await showCustomTimePicker(context, newStartTime ?? currentEndTime);

        if (newStartTime != null && newEndTime != null) {
          setState(() {
            payDate.startTime = newStartTime;
            payDate.endTime = newEndTime;
          });

          await widget.saveTime(payDate, widget.index, userId);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(payDate.date),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: DateTime.now().year == payDate.date.year &&
                                  DateTime.now().month == payDate.date.month &&
                                  DateTime.now().day == payDate.date.day
                              ? const Color.fromARGB(255, 11, 11, 191)
                              : Colors.black,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Builder(
                            builder: (BuildContext context) {
                              return const IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 30.0,
                                  color: Color.fromARGB(255, 82, 82, 82),
                                ),
                                padding: EdgeInsets.all(
                                    0), // adjust this to change the padding around the icon
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start: ${formatTimeOfDay(startTime)}',
                          ),
                          Text(
                            'End: ${formatTimeOfDay(endTime)}',
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Lunch Taken:',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            lunchTaken ? 'Yes' : 'No',
                          ),
                          Switch(
                            value: lunchTaken,
                            onChanged: (bool? value) {
                              setState(() {
                                payDate.lunchTaken = value ?? false;
                              });
                              widget.saveTime(payDate, widget.index, userId);
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hours Worked:',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            totalHours.toStringAsFixed(2),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
