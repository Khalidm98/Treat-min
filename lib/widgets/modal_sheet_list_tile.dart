import 'package:flutter/material.dart';
import 'package:custom_switch_button/custom_switch_button.dart';

class ModalSheetListTile extends StatefulWidget {
  final String text;
  final bool value;

  ModalSheetListTile({@required this.text, @required this.value});

  @override
  _ModalSheetListTileState createState() =>
      _ModalSheetListTileState(this.value);
}

class _ModalSheetListTileState extends State<ModalSheetListTile> {
  bool val;

  _ModalSheetListTileState(this.val);

  void onSwitchChange() {
    setState(() {
      this.val = !this.val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      title: Text(widget.text),
      trailing: GestureDetector(
        onTap: () {
          onSwitchChange();
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.5,
                blurRadius: 2,
                offset: Offset(0, 0),
              )
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: CustomSwitchButton(
            checked: this.val,
            unCheckedColor: theme.primaryColorLight,
            checkedColor: Colors.white,
            animationDuration: Duration(milliseconds: 200),
            backgroundColor: this.val ? theme.primaryColorLight : Colors.white,
          ),
        ),
      ),
    );
  }
}
