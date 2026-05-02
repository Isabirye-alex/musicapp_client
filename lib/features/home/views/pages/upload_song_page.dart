import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/current_user_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/auth/view/widgets/audio_wave.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';
import 'package:little_music/features/home/views/widgets/login_prompt.dart';
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
  Color selectedColor = AColorTheme.cardColor;
  File? selectedImage;
  File? selectedAudio;

  void selectImage() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void selectAudio() async {
    final audio = await pickAudio(); //
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
    final currentUser = ref.watch(currentUserProvider);
    final isLoading = ref.watch(
      homeViewmodelProvider.select((val) => val.isLoading == true),
    );

    ref.listen(homeViewmodelProvider, (_, data) {
      data.when(
        data: (data) {
          Navigator.pop(context);
          SuccessHelper.showSuccess(
            context,
            'Song uploaded successfully',
            'Success',
          );
          ref.invalidate(getAllSongsProvider);
        },
        error: (error, str) {
          ErrorHelper.showError(context, '$error', error.toString());
        },
        loading: () {},
      );
    });

    //if user is not logged in — prompt to login
    if (currentUser == null) {
      return Scaffold(body: LoginPrompt());
    }

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
                    : () async {
                        if (selectedAudio == null || selectedImage == null) {
                          ErrorHelper.showError(
                            context,
                            'Please select both a song and thumbnail',
                            'Missing Fields',
                          );
                          return;
                        }
                        await ref
                            .read(homeViewmodelProvider.notifier)
                            .upload(
                              selectedAudio!,
                              selectedImage!,
                              songNameController.text.trim(),
                              artistNameController.text.trim(),
                              selectedColor
                                  .toARGB32()
                                  .toRadixString(16)
                                  .substring(2)
                                  .toUpperCase(),
                            );
                      },
                icon: const Icon(Icons.check),
              ),
              Text('Save', style: TextTheme.of(context).bodySmall),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GestureDetector(
                  onTap: selectImage,
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            selectedImage!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : DottedBorder(
                          ignoring: true,
                          options: RectDottedBorderOptions(
                            dashPattern: [10, 10],
                            color: AColorTheme.gradient3,
                            padding: const EdgeInsets.all(4),
                          ),
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.folder_open, size: 40),
                                const SizedBox(height: 10),
                                Text(
                                  'Select Thumbnail for your song',
                                  style: TextTheme.of(context).bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                selectedAudio != null
                    ? AudioWave(path: selectedAudio!.path)
                    : CustomTextField(
                        readOnly: true,
                        songOnTap: selectAudio,
                        controller: null,
                        hintText: 'Pick a song',
                      ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: artistNameController,
                  hintText: 'Artist name',
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: songNameController,
                  hintText: 'Song name',
                ),
                const SizedBox(height: 20),
                ColorPicker(
                  pickersEnabled: const {ColorPickerType.wheel: true},
                  color: selectedColor,
                  onColorChanged: (Color color) {
                    selectedColor = color;
                  },
                ),
              ],
            ),
    );
  }
}
