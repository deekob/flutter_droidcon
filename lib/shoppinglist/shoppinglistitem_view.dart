import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_droidcon/app_navigator.dart';
import 'package:flutter_droidcon/auth/auth_repository.dart';
import 'package:flutter_droidcon/models/ShoppingListItem.dart';
import 'package:flutter_droidcon/profile/profile_bloc.dart';
import 'package:flutter_droidcon/profile/profile_state.dart';
import 'package:flutter_droidcon/profile/profile_view.dart';
import 'package:flutter_droidcon/session/session_cubit.dart';
import 'package:flutter_droidcon/shoppinglist/shoppinglistitem_bloc.dart';
import 'package:flutter_droidcon/views/loading_view.dart';

import '../data_repository.dart';

class ShoppingListItemsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShoppingListItemsViewState();
}

class _ShoppingListItemsViewState extends State<ShoppingListItemsView> {
  final _itemNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: _floatingActionButton(),
      body: BlocBuilder<ShoppingListItemCubit, ShoppingListState>(
          builder: (context, state) {
        if (state is ShoppingListSuccess) {
          return state.listItems.isEmpty
              ? _emptyTodosView()
              : _shoppingItemListView(state.listItems);
        } else if (state is ShoppingListFailures) {
          return _exceptionView(state.exception);
        } else {
          return LoadingView();
        }
      }),
    );
  }

  Widget _exceptionView(Exception exception) {
    return Center(child: Text(exception.toString()));
  }

  AppBar _navBar() {
    return AppBar(
      title: Text('My Shopping List'),
    );
  }

  PreferredSizeWidget _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        title: Text('My Shopping List'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<SessionCubit>(
                builder: (_) => ProfileView(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (context) => _newItemView());
        });
  }

  Widget _newItemView() {
    return Column(
      children: [
        TextField(
          controller: _itemNameController,
          decoration: InputDecoration(hintText: 'Enter groceries here'),
        ),
        ElevatedButton(
            onPressed: () {
              BlocProvider.of<ShoppingListItemCubit>(context)
                  .createListItems(_itemNameController.text);
              recordNewEvent("NewItemAdded", _itemNameController.text);
              _itemNameController.text = '';

              Navigator.of(context).pop();
            },
            child: Text('Add to shopping list'))
      ],
    );
  }

  Widget _emptyTodosView() {
    return Center(
      child: Text('Your shopping list is empty',
          style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.5),
    );
  }

  Widget _shoppingItemListView(List<ShoppingListItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: CheckboxListTile(
              title: Text(item.itemName),
              value: item.isComplete,
              onChanged: (newValue) {
                BlocProvider.of<ShoppingListItemCubit>(context)
                    .updateListItem(item, newValue!);
              }),
        );
      },
    );
  }

  void recordNewEvent(String eventName, String eventValue) {
    AnalyticsEvent event = AnalyticsEvent(eventName);
    event.properties.addStringProperty(eventName, eventValue);
    Amplify.Analytics.recordEvent(event: event);
  }
}
