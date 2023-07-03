import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit() : super(const CreateAccountState(isLoading: false));
}
