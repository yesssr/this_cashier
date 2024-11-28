import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:this_cashier/widget/form_pass.dart';

import '../constant.dart';
import '../models/user.dart';
import '../services/users.dart';
import 'button.dart';
import 'dropdown.dart';
import 'form_image.dart';
import 'form_input.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key, this.user});
  final User? user;

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final listRole = [
    {"id": 1, "role": "Admin"},
    {"id": 2, "role": "Pegawai"},
  ];
  dynamic photo;
  int? roleId;

  @override
  void initState() {
    if (widget.user != null) {
      User user = widget.user!;
      usernameController.text = user.username!;
      phoneController.text = user.phone!;
      roleId = user.roleId;
    }
    super.initState();
  }

  void createUser() async {
    await UserService.postUser(
      context: context,
      username: usernameController.text,
      photo: photo,
      roleId: roleId!,
      phone: phoneController.text,
      password: passwordController.text,
    );
  }

  void editUser() async {
    await UserService.editUser(
      id: widget.user!.id!,
      context: context,
      username: usernameController.text,
      password: passwordController.text,
      photo: photo,
      roleId: roleId!,
      photoName: widget.user?.photo,
      phone: phoneController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.user == null ? "Tambah User" : "Edit User",
        style: bodyLargeBold,
      ),
      scrollable: true,
      content: SizedBox(
        width: 312,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImagePickerFormField(
                item: widget.user,
                onSaved: (newValue) => setState(() {
                  if (newValue != null) {
                    if (newValue is Uint8List) {
                      photo = newValue;
                    } else {
                      photo = File(newValue.path);
                    }
                  }
                }),
              ),
              const SizedBox(height: 8),
              FormInputWidget(
                nameField: "Username",
                fieldController: usernameController,
                validator: (string) {
                  if (string!.isEmpty) return "Username diperlukan!.";
                  if (string.contains(" ")) return "Jangan gunakan spasi!.";
                  return null;
                },
              ),
              const SizedBox(height: 8),
              FormPasswordWidget(
                passwordController: passwordController,
                validator: (value) {
                  if (value!.isNotEmpty && value.length < 8) {
                    return "Password minimal 8 karakter!.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              MyDropdown(
                nameField: "Role",
                hintText: "Pilih role",
                initValue: roleId,
                items: listRole
                    .map(
                      (e) => DropdownMenuItem<dynamic>(
                        value: e['id'],
                        child: Text("${e['role']}"),
                      ),
                    )
                    .toList(),
                onChanged: (value) => roleId = value,
              ),
              const SizedBox(height: 8),
              FormInputWidget(
                nameField: "No. Hp",
                fieldController: phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  otlBtn(
                    nameField: "Batal",
                    negActions: true,
                    context: context,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  fillBtn(
                    nameField: "Simpan",
                    context: context,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        widget.user == null ? createUser() : editUser();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
