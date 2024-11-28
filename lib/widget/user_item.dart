import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:this_cashier/services/users.dart';

import '../constant.dart';
import '../models/user.dart';
import '../utils/utils.dart';
import 'avatar_profile.dart';
import 'button.dart';
import 'user_form.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.user,
    required this.pagingController,
  });
  final User user;
  final PagingController<int, User> pagingController;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      leading: AvatarProfile(
        url: "$apiImageUsers/${user.photo}",
        id: "Profile-${user.id}",
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.username}",
                style: titleSmall,
              ),
              Text(
                "${user.phone}",
                style: labelMedReg,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              fillBtn(
                nameField: "Edit",
                color: addColor,
                context: context,
                onPressed: () async {
                  var isUpdated = await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => UserForm(user: user),
                  );
                  if (isUpdated != null && isUpdated == true) {
                    pagingController.refresh();
                  }
                },
              ),
              const SizedBox(width: 8),
              otlBtn(
                nameField: "Hapus",
                negActions: true,
                context: context,
                onPressed: () => Utils.showConfirmDialog(
                  context: context,
                  isNegativeAction: true,
                  title: "Hapus User ?",
                  content: "Yakin menghapus user ini ?",
                  onNotOke: () => UserService.deleteUser(
                    context,
                    user.id!,
                  ),
                  onOke: () => Navigator.of(context).pop(),
                  onValue: (value) {
                    if (value != null && value == true) {
                      pagingController.refresh();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
