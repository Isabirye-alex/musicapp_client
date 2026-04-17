import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_field.dart';

import '../../utilis/utilis.dart';

class UploadSongPage extends StatefulWidget {
  const UploadSongPage({super.key});

  @override
  State<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends State<UploadSongPage> {
  final TextEditingController artistNameController = TextEditingController();
  final TextEditingController songNameController = TextEditingController();
  final selectedColor = AColorTheme.cardColor;
  File? selectedImage;
  File? selectedAudio;

  void selectImage() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {           // ✅ triggers rebuild
        selectedImage = image;
      });
    }
  }

  void selectAudio() async {
    final audio = await pickAudio();  // ✅ also fix: was calling pickImage() for audio
    if (audio != null) {
      setState(() {
        selectedAudio = audio;
      });
    }
  }




  @override
  void dispose(){
    artistNameController.dispose();
    songNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Song',
            style: TextTheme.of(context).headlineLarge),
        centerTitle: true,
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.check),),
            Text('Save', style: TextTheme.of(context).bodySmall,)
          ],
        )
      ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: selectImage,
            child:selectedImage != null ? Image.file(selectedImage!) : DottedBorder(
              ignoring: true,
               options: RectDottedBorderOptions(
                 dashPattern: [10,10],
                 color: AColorTheme.gradient3,
                 padding: EdgeInsets.all(4)
               ),
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 150,
                    width: double.infinity,
                    child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.folder_open, size: 40,),
                    SizedBox(height: 10,),
                    Text('Select Thumbnail for your song', style: TextTheme.of(context).bodyLarge,)
                  ],
                )
                ),

              ],
            ),
            ),
          ),
          SizedBox(height: 20,),
          CustomTextField(
            readOnly: true,
            songOnTap: (){},
            controller: null,
            hintText: 'Pick a song',
          ),
          SizedBox(height: 40,),
          CustomTextField(controller: artistNameController, hintText: 'Artist name',),
          SizedBox(height: 40,),
          CustomTextField(controller: songNameController, hintText: 'Song name',),
          SizedBox(height: 20,),
          ColorPicker(
            pickersEnabled: {
            ColorPickerType.wheel : true
            },
              color: selectedColor,
              onColorChanged: (Color color){},
          ),

        ],
      ),
    );
  }
}
