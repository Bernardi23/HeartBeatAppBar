import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class AnimatedAppBarController implements BlocBase {
  var _scrollingController = BehaviorSubject<bool>();

  Stream<bool> get outScroll => _scrollingController.stream;
  Sink<bool> get inScroll => _scrollingController.sink;

  @override
  void dispose() {
    _scrollingController.close();
  }
}
