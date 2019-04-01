import 'package:bloc/bloc.dart';
import 'package:my_mini_app/provider/base_event.dart';
import 'package:my_mini_app/provider/base_state.dart';

class DetailPageEventTextField extends BaseEvent {
  final bool isEmpty;

  DetailPageEventTextField(this.isEmpty);
}

class DetailPageTextFieldInput extends BaseState {}

class DetailPageTextFieldNotInput extends BaseState {}

class TextFieldProvider extends Bloc<BaseEvent, BaseState> {
  @override
  BaseState get initialState => DetailPageTextFieldNotInput();

  @override
  Stream<BaseState> mapEventToState(BaseState currentState, BaseEvent event) async* {
    if (event is DetailPageEventTextField) {
      if (event.isEmpty) {
        yield DetailPageTextFieldInput();
      } else {
        yield DetailPageTextFieldNotInput();
      }
    }
  }

//  @override
//  Stream<BaseState> mapEventToState(BaseEvent event) async* {
//    if (event is DetailPageEventTextField) {
//      if (event.isEmpty) {
//        yield DetailPageTextFieldInput();
//      } else {
//        yield DetailPageTextFieldNotInput();
//      }
//    }
//  }
}
