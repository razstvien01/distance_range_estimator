import 'package:distance_range_estimator/types/constants.dart';
import 'package:distance_range_estimator/widgets/default_button.dart';
import 'package:flutter/material.dart';

class MeasurementDialog extends StatefulWidget {
  final Function(String) onMeasurementSelected;
  var selectedMeasurement;

  MeasurementDialog(this.onMeasurementSelected, this.selectedMeasurement);

  @override
  _MeasurementDialogState createState() => _MeasurementDialogState();
}

class _MeasurementDialogState extends State<MeasurementDialog> {
  
  
  @override
  Widget build(BuildContext context) {
  
    return SimpleDialog(
      backgroundColor: kBGColor,
      title: Text(
        'Select Measurement Unit',
        // style: TextStyle(fontSize: 18.0),
        style: kSubTextStyle,
      ),
      children: <Widget>[
        RadioListTile<String>(
          title: Text(
            'Centimeters (cm)',
            style: kSmallTextStyle,
          ),
          value: 'cm',
          groupValue: widget.selectedMeasurement,
          onChanged: (value) {
            setState(() {
              widget.selectedMeasurement = value as String;
            });
          },
        ),
        RadioListTile<String>(
          title: Text(
            'Inches (in)',
            style: kSmallTextStyle,
          ),
          value: 'in',
          groupValue: widget.selectedMeasurement,
          onChanged: (value) {
            setState(() {
              widget.selectedMeasurement = value as String;
            });
          },
        ),
        RadioListTile<String>(
          title: Text(
            'Feet (ft)',
            style: kSmallTextStyle,
          ),
          value: 'ft',
          groupValue: widget.selectedMeasurement,
          onChanged: (value) {
            setState(() {
              widget.selectedMeasurement = value as String;
            });
          },
        ),
        SizedBox(height: 10.0),
        DefaultButton(
            btnText: "OK",
            onPressed: () {
              Navigator.of(context).pop(widget.selectedMeasurement);
              widget.onMeasurementSelected(widget.selectedMeasurement);
            })
      ],
    );
  }
}
