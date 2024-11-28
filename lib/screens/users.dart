import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/user.dart';
import '../widget/button.dart';
import '../widget/search_text_field.dart';
import '../widget/tab_bar.dart';
import '../widget/title.dart';
import '../widget/user_form.dart';
import '../widget/users_list.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final Duration debounceTime = const Duration(milliseconds: 500);
  Timer? _debounce;
  ValueNotifier<String> searchQuery = ValueNotifier<String>("");
  final adminRoleController = PagingController<int, User>(firstPageKey: 0);
  final empRoleController = PagingController<int, User>(firstPageKey: 0);
  var listTab = const [
    Tab(text: "Admin"),
    Tab(text: "Pegawai"),
  ];

  @override
  void dispose() {
    super.dispose();
    adminRoleController.dispose();
    empRoleController.dispose();
    searchQuery.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleAndDate(title: "Users"),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: fillBtn(
              nameField: "Tambah user",
              context: context,
              onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const UserForm(),
              ).then((value) {
                if (value is bool && value == true) {
                  adminRoleController.refresh();
                  empRoleController.refresh();
                }
              }),
            ),
          ),
          const SizedBox(height: 16),
          SearchTextField(
            hintText: "Cari user...",
            icon: const Icon(Icons.search),
            onChanged: (query) {
              _debounce?.cancel();
              _debounce = Timer(debounceTime, () {
                searchQuery.value = query;
              });
            },
          ),
          Expanded(
            child: DefaultTabController(
              length: listTab.length,
              child: Column(
                children: [
                  MyTabBar(tabs: listTab),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListUsers(
                          scrollController: adminRoleController,
                          filter: "1",
                          search: searchQuery,
                        ),
                        ListUsers(
                          scrollController: empRoleController,
                          filter: "2",
                          search: searchQuery,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
