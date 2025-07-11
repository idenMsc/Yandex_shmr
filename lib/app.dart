import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/error/global_ui_bloc.dart';
import 'core/network/connection_status_bloc.dart';
import 'widgets/offline_indicator.dart';
import 'injection_container.dart';
// ... остальные импорты ...

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GlobalUiBloc>(create: (_) => sl<GlobalUiBloc>()),
        BlocProvider<ConnectionStatusBloc>(
            create: (_) => sl<ConnectionStatusBloc>()),
        // ... другие BlocProvider ...
      ],
      child: BlocListener<GlobalUiBloc, GlobalUiState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Ошибка'),
                content: Text(state.errorMessage!),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      context.read<GlobalUiBloc>().add(ClearError());
                    },
                    child: const Text('ОК'),
                  ),
                ],
              ),
            );
          }
        },
        child: Stack(
          children: [
            MaterialApp(
                // ... существующие параметры ...
                ),
            // Оффлайн индикатор поверх всего
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: OfflineIndicator(),
            ),
            // Глобальный лоадер
            BlocBuilder<GlobalUiBloc, GlobalUiState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
