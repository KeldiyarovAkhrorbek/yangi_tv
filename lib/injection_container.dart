import 'package:get_it/get_it.dart';
import 'package:yangi_tv_new/bloc/blocs/download/download_bloc.dart';
import 'package:yangi_tv_new/bloc/repos/mainrepository.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<DownloadBloc>(DownloadBloc(MainRepository()));
}
