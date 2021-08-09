import 'package:flutter_droidcon/auth/auth_cubit.dart';
import 'package:flutter_droidcon/auth/auth_navigator.dart';
import 'package:flutter_droidcon/profile/profile_view.dart';
import 'package:flutter_droidcon/session/session_cubit.dart';
import 'package:flutter_droidcon/session/session_state.dart';
import 'package:flutter_droidcon/shoppinglist/shoppinglistitem_view.dart';
import 'package:flutter_droidcon/views/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return new Navigator(
        pages: [
          // Show Loadign View
          if (state is UnknownSessionState) MaterialPage(child: LoadingView()),
          // Show show auth flow
          if (state is Unauthenticated)
            MaterialPage(
              child: BlocProvider(
                create: (context) =>
                    AuthCubit(sessionCubit: context.read<SessionCubit>()),
                child: AuthNavigator(),
              ),
            ),
          // show session flow
          //     if (state is Authenticated) MaterialPage(child: ProfileView())
          if (state is Authenticated)
            MaterialPage(child: ShoppingListItemsView())
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
