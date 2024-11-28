import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constant.dart';
import '../models/user.dart';
import '../services/users.dart';
import 'user_item.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({
    super.key,
    required this.scrollController,
    this.filter,
    required this.search,
  });

  final PagingController<int, User> scrollController;
  final String? filter;
  final ValueNotifier<String> search;

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  static const _pageSize = 15;

  @override
  void initState() {
    widget.search.addListener(() {
      widget.scrollController.refresh();
    });
    widget.scrollController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController
        .removePageRequestListener((pageKey) => _fetchPage(pageKey));
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await UserService.getUsers(
        limit: _pageSize,
        offset: pageKey,
        filter: widget.filter,
        search: widget.search.value,
      );
      final isLastPage = newItems.length < _pageSize;

      if (!mounted) return;

      if (isLastPage) {
        widget.scrollController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        widget.scrollController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      if (!mounted) return;
      widget.scrollController.error = error;
    }
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    widget.scrollController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PagedListView<int, User>(
          pagingController: widget.scrollController,
          builderDelegate: PagedChildBuilderDelegate(
            noItemsFoundIndicatorBuilder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Users Kosong !.",
                  style: bodyLargeBold,
                ),
                Text(
                  "Belum ada user yang ditambahkan.",
                  style: labelLargeMed,
                ),
              ],
            ),
            itemBuilder: (context, item, index) => UserItem(
              user: item,
              pagingController: widget.scrollController,
            ),
          ),
        ),
      ),
    );
  }
}
