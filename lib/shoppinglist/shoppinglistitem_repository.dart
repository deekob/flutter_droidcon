import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_droidcon/models/ShoppingListItem.dart';

class ShoppingListItemRepository {
  Future<List<ShoppingListItem>> getListItems() async {
    List<ShoppingListItem> items = new List.empty();
    try {
      items = await Amplify.DataStore.query(ShoppingListItem.classType);
    } catch (e) {
      print("Could not query DataStore: ");
    }
    return items;
  }

  Future<void> createListItems(String itemName) async {
    final item = ShoppingListItem(itemName: itemName, isComplete: false);
    try {
      await Amplify.DataStore.save(item);
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateListItem(ShoppingListItem item, bool isComplete) async {
    final updatedItem = item.copyWith(isComplete: isComplete);
    try {
      await Amplify.DataStore.save(updatedItem);
    } catch (e) {
      throw e;
    }
  }

  Stream observeTodos() {
    return Amplify.DataStore.observe(ShoppingListItem.classType);
  }
}
