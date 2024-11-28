import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constant.dart';
import '../models/user.dart';
import 'avatar_profile.dart';

class ImagePickerFormField extends FormField<dynamic> {
  ImagePickerFormField({
    Key? key,
    FormFieldSetter<dynamic>? onSaved,
    FormFieldValidator<dynamic>? validator,
    dynamic initialValue,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    dynamic item,
    // bool? showNameField = false,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator ??
              (value) =>
                  value == null && item == null ? "Photo diperlukan!." : null,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<dynamic> state) {
            void setImage() async {
              final ImagePicker picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                if (kIsWeb) {
                  Uint8List? imageBytes = await image.readAsBytes();
                  state.didChange(imageBytes);
                } else {
                  state.didChange(File(image.path));
                }
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // showNameField == true
                //     ? Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           ConstrainedBox(
                //             constraints: fixedMobileSize,
                //             child: Text(
                //               "Photo",
                //               style: labelMedBold,
                //             ),
                //           ),
                //           const SizedBox(height: 8),
                //         ],
                //       )
                //     : const SizedBox.shrink(),
                GestureDetector(
                  onTap: setImage,
                  child: Visibility(
                    visible: state.value == null && item == null ? true : false,
                    replacement: AvatarProfile(
                      height: 120,
                      width: 120,
                      url: item is User
                          ? "$apiImageUsers/${item.photo}"
                          : "${item?.photo}",
                      id: "Photo-${item?.id}",
                      image: state.value,
                      customGesture: setImage,
                    ),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F3F6),
                        border: Border.all(color: Colors.black, width: 1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_rounded,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                if (state.hasError)
                  Text(
                    state.errorText ?? '',
                    style: labelMedReg.copyWith(color: errorColor),
                  ),
              ],
            );
          },
        );
}
