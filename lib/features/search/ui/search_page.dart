/// File: lib/features/search/ui/search_page.dart
/// Purpose: Station search screen with map/list toggle
/// Belongs To: search feature
/// Route: /userSearch
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../presentation/bloc/filter_cubit.dart';
import '../presentation/bloc/map_bloc.dart';
import '../presentation/bloc/search_bloc.dart';
import '../presentation/pages/search_stations_page.dart';

/// Search page for finding charging stations.
/// Wraps SearchStationsPage with BLoC providers.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SearchBloc>(),
          ),
        BlocProvider(
          create: (context) => sl<MapBloc>(),
      ),
        BlocProvider(
          create: (context) => sl<FilterCubit>(),
        ),
      ],
      child: const SearchStationsPage(),
    );
  }
}
