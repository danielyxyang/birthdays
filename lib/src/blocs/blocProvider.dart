import 'package:flutter/material.dart';

//// Generic Interface for all BLoCs
abstract class BlocBase {
  void dispose();
}

class Provider<B> extends InheritedWidget {
  final B bloc;

  const Provider({
    Key key,
    this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(Provider<B> oldWidget) {
    return oldWidget.bloc != bloc;
  }

  static B of<B>(BuildContext context) {
    final type = _typeOf<Provider<B>>();
    final Provider<B> provider = context.inheritFromWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<B>() => B;
}

class BlocProvider<B extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final B bloc;
  final Widget child;

  @override
  _BlocProviderState<B> createState() => _BlocProviderState<B>();
}

class _BlocProviderState<B extends BlocBase> extends State<BlocProvider<B>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}
