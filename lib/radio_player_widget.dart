import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';

import 'app_parameters.dart';

class RadioPlayerWidget extends StatefulWidget {
  const RadioPlayerWidget({Key? key}) : super(key: key);

  @override
  _RadioPlayerWidgetState createState() => _RadioPlayerWidgetState();
}

class _RadioPlayerWidgetState extends State<RadioPlayerWidget> {
  late final RadioPlayer _radioPlayer;
  String radioStationImagePath = AppParameters.radioStationImagePath;
  late bool radioIsPlaying = false;
  late List<String>? metadata;

  @override
  void initState() {
    super.initState();
    _radioPlayer = RadioPlayer();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    _radioPlayer.setChannel(
      title: AppParameters.radioStationName,
      url: AppParameters.radioStationURL,
      imagePath: AppParameters.radioStationImagePath,
    );

    _radioPlayer.stateStream.listen((value) {
      setState(() {
        radioIsPlaying = value;
      });
    });

    _radioPlayer.metadataStream.listen((value) {
      setState(() {
        metadata = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define the custom color using RGB values of radio station website brand color
    const customColor1 = Color.fromRGBO(115, 1, 3, 1.0); // CCR red brand color

    // This code adjusts the icon sizes for different screen sizes, phones , iPads, TVs.
    // It gets the device screen size from MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double sizeAdjustFactor = screenWidth;
    double iconSize = sizeAdjustFactor * 0.6; //60% of container size
    double maxSize = 200.0; // set a max jic - realistic
    sizeAdjustFactor = sizeAdjustFactor.clamp(0.0, maxSize); // clamp to maxsize
    iconSize = iconSize.clamp(0.0, maxSize * 0.5); //clamp to max size

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Cork Community Radio Brand Circle Image
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: sizeAdjustFactor * 0.8,
            height: sizeAdjustFactor * 0.8, // auto adjusted for different screen sizes

            child: ClipRRect(
              child: Image.asset(
                radioStationImagePath,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),

        // Listen Live Radio Button
        ElevatedButton(
          onPressed: () {
            // Define the action to be performed when the button is pressed.
            // radioIsPlaying boolean value is set to false on initialization.
            radioIsPlaying ? _radioPlayer.pause() : _radioPlayer.play();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(customColor1),
          ),
          child: radioIsPlaying
              ? Image.asset(
                  'assets/listen_live_pause.jpg',
                  width: sizeAdjustFactor * 0.6,
                  height: sizeAdjustFactor / 3,
                  fit: BoxFit.scaleDown,
                )
              : Image.asset(
                  'assets/listen_live.jpg',
                  width: sizeAdjustFactor * 0.6,
                  height: sizeAdjustFactor / 3,
                  fit: BoxFit.scaleDown,
                ),
        ),
      ],
    );
  }
}
