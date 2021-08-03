import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_droidcon/models/ShoppingListItem.dart';
import 'package:flutter_droidcon/shoppinglist/shoppinglistitem_repository.dart';

abstract class ShoppingListState {}

class LoadingShoppingList extends ShoppingListState {}

class ShoppingListSuccess extends ShoppingListState {
  final List<ShoppingListItem> listItems;
  ShoppingListSuccess({required this.listItems});
}

class ShoppingListFailures extends ShoppingListState {
  final Exception exception;
  ShoppingListFailures({required this.exception});
}

class ShoppingListItemCubit extends Cubit<ShoppingListState> {
  final _shoppingListRepo = ShoppingListItemRepository();

  ShoppingListItemCubit() : super(LoadingShoppingList());

  void getListItems() async {
    if (state is ShoppingListSuccess == false) {
      emit(LoadingShoppingList());
    }

    try {
      final items = await _shoppingListRepo.getListItems();
      emit(ShoppingListSuccess(listItems: items));
    } catch (e) {}
  }

  void createListItems(String itemName) async {
    await _shoppingListRepo.createListItems(itemName);
  }

  void updateListItem(ShoppingListItem item, bool isComplete) async {
    await _shoppingListRepo.updateListItem(item, isComplete);
  }

  void observeItems() {
    final itemStream = _shoppingListRepo.observeTodos();
    itemStream.listen((_) => getListItems());
  }
}
