import 'package:bloc/bloc.dart';
import 'package:smart/Screens/BottomBar/BottomBar.dart';
import 'package:smart/Screens/HomeScreen/Home.dart';

enum NavigationEvents {
  IntroPageClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc(NavigationStates initialState) : super(initialState);
  @override
  NavigationStates get initialState => HomePage();
  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.IntroPageClickedEvent:
        yield HomePage();
        break;
    }
  }
}
