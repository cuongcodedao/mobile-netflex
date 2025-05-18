import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/module/home/bloc/my_list_state.dart';

class MyListCubit extends Cubit<MyListState> {
  MyListCubit() : super(MyListInitial());

  Future<void> loadMyList() async {
    emit(MyListLoading());
  }
}
