import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final int number;
  final bool isPencilActivated;
  final int? selectedNumber;
  final List<int> remainingNumbers;
  final Function(int) handlePencil;
  final Function(int) updateSelectedNumber;
  final Function(int) updateCell;

  const NumberButton({
    super.key,
    required this.number,
    required this.isPencilActivated,
    required this.selectedNumber,
    required this.remainingNumbers,
    required this.handlePencil,
    required this.updateSelectedNumber,
    required this.updateCell,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // Check if pencil mode is activated
    if (isPencilActivated) {
      return IgnorePointer(
        ignoring: false,
        child: Opacity(
          opacity: 1.0,
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                handlePencil(number);
              },
              child: SizedBox(
                height: 70,
                width: width / 11,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // Render normal number buttons
      Color? buttonColor = selectedNumber == number
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColor;

      int remainingNumber = remainingNumbers[number - 1];

      return IgnorePointer(
        ignoring: remainingNumber == 0,
        child: Opacity(
          opacity: remainingNumber == 0 ? 0.5 : 1.0,
          child: Ink(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: remainingNumber != 0
                  ? () {
                      updateSelectedNumber(number);
                      updateCell(number);
                    }
                  : null,
              child: SizedBox(
                height: 85,
                width: width / 11,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$number',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //Expanded(child: Container()),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              '$remainingNumber',
                              style: TextStyle(
                                fontFamily: 'PoppinsSemiBold',
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
