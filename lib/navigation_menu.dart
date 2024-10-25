import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/ui/screens/profile_screen.dart';

class NavigationMenu extends ConsumerWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Widget> screens = [
      const Center(child: Text('Todos Screen')),
      const Center(child: Text('Chat Screen')),
      const ProfileScreen(),
    ];

    return ref.watch(todoUserProvider).when(
          loading: () => _loadingUI(context),
          error: (error, stackTrace) => _errorUI(error),
          data: (data) {
            return Scaffold(
              body: SafeArea(child: screens[ref.watch(navigationMenuIndexProvider)]),
              bottomNavigationBar: NavigationBar(
                selectedIndex: ref.watch(navigationMenuIndexProvider),
                destinations: const [
                  NavigationDestination(
                    icon: FaIcon(FontAwesomeIcons.listUl),
                    label: 'Todos',
                  ),
                  NavigationDestination(
                    icon: FaIcon(FontAwesomeIcons.comment),
                    label: 'Chat',
                  ),
                  NavigationDestination(
                    icon: FaIcon(FontAwesomeIcons.user),
                    label: 'Profile',
                  ),
                ],
                onDestinationSelected: (value) {
                  ref.read(navigationMenuIndexProvider.notifier).update((previousIndex) => value);
                },
              ),
            );
          },
        );
  }

  Widget _errorUI(Object error) {
    return Scaffold(
      body: Center(
        child: Text(error.toString()),
      ),
    );
  }

  Widget _loadingUI(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitThreeBounce(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
