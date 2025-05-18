import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/module/home/bloc/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  Future<void> loadHistory() async {
    emit(HistoryLoading());
  }
}
