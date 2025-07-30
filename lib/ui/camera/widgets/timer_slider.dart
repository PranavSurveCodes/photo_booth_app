import 'package:flutter/material.dart';

class TimerSlider extends StatelessWidget {
  const TimerSlider({super.key, required this.onChanged, required this.value});
  final void Function(double) onChanged;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withAlpha((0.3 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "⏱️ Set Selfie Timer",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text("3s"), Text("5s"), Text("10s"), Text("15s")],
          ),
          Slider(
            padding: const EdgeInsets.symmetric(vertical: 8),
            value: value,
            min: 3,
            max: 15,
            divisions: 3,
            label: "${value.round()}s",
            onChanged: onChanged,
            // onChanged: (value) {
            //   double snappedValue;
            //   if (value < 4) {
            //     snappedValue = 3;
            //   } else if (value < 7.5) {
            //     snappedValue = 5;
            //   } else if (value < 12.5) {
            //     snappedValue = 10;
            //   } else {
            //     snappedValue = 15;
            //   }

            //   context.read<CameraBloc>().add(
            //     TimerChangeEvent(timerValue: snappedValue),
            //   );
            // },
          ),
        ],
      ),
    );
  }
}
