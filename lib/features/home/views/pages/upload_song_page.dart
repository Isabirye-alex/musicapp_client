import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/auth/view/widgets/audio_wave.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';
import 'package:little_music/utilis/custom_text_field.dart';
import 'package:little_music/utilis/error.dart';
import 'package:little_music/utilis/loader.dart';
import 'package:little_music/utilis/success.dart';

import '../../../../utilis/utilis.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final TextEditingController artistNameController = TextEditingController();
  final TextEditingController songNameController = TextEditingController();
  final selectedColor = AColorTheme.cardColor;
  File? selectedImage;
  File? selectedAudio;

  void selectImage() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        // ✅ triggers rebuild
        selectedImage = image;
      });
    }
  }

  void selectAudio() async {
    final audio =
        await pickAudio(); // ✅ also fix: was calling pickImage() for audio
    if (audio != null) {
      setState(() {
        selectedAudio = audio;
      });
    }
  }

  @override
  void dispose() {
    artistNameController.dispose();
    songNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewmodelProvider.select((val) => val.isLoading == true),
    );
    ref.listen(homeViewmodelProvider, (_, data) {
      data.when(
        data: (data) {
          SuccessHelper.showSuccess(
            context,
            'Song uploaded successfully',
            'Success',
          );
        },
        error: (error, str) {
          ErrorHelper.showError(context, '$error', 'Upload Error');
        },
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Song', style: TextTheme.of(context).headlineLarge),
        centerTitle: true,
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: isLoading
                    ? null
                    : () {
                        ref
                            .read(homeViewmodelProvider.notifier)
                            .upload(
                              selectedAudio!,
                              selectedImage!,
                              songNameController.text.trim(),
                              artistNameController.text.trim(),
                              'FFFFFF',
                            );
                      },
                icon: Icon(Icons.check),
              ),
              Text('Save', style: TextTheme.of(context).bodySmall),
            ],
          ),
        ],
      ),
      body: isLoading
          ? Loader()
          : ListView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              children: [
                GestureDetector(
                  onTap: selectImage,
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            selectedImage!,
                            height: 150,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : DottedBorder(
                          ignoring: true,
                          options: RectDottedBorderOptions(
                            dashPattern: [10, 10],
                            color: AColorTheme.gradient3,
                            padding: EdgeInsets.all(4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: 10),
                                    Text(
                                      'Select Thumbnail for your song',
                                      style: TextTheme.of(context).bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: 20),
                selectedAudio != null
                    ? AudioWave(path: selectedAudio!.path)
                    : CustomTextField(
                        readOnly: true,
                        songOnTap: selectAudio,
                        controller: null,
                        hintText: 'Pick a song',
                      ),
                SizedBox(height: 40),
                CustomTextField(
                  controller: artistNameController,
                  hintText: 'Artist name',
                ),
                SizedBox(height: 40),
                CustomTextField(
                  controller: songNameController,
                  hintText: 'Song name',
                ),
                SizedBox(height: 20),
                ColorPicker(
                  pickersEnabled: {ColorPickerType.wheel: true},
                  color: selectedColor,
                  onColorChanged: (Color color) {},
                ),
              ],
            ),
    );
  }
}
