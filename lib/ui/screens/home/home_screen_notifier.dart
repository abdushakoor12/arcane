import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeScreenNotifierProvider =
    NotifierProvider<HomeScreenNotifier, HomeScreenState>(
        HomeScreenNotifier.new);

class HomeScreenNotifier extends Notifier<HomeScreenState> {
  @override
  HomeScreenState build() {
    return const HomeScreenState(expandedFolderIds: []);
  }

  void toggleFolder(String folderId) {
    state = state.copyWith(
        expandedFolderIds: state.expandedFolderIds.contains(folderId)
            ? state.expandedFolderIds.where((id) => id != folderId).toList()
            : [...state.expandedFolderIds, folderId]);
  }
}

class HomeScreenState {
  final List<String> expandedFolderIds;

  const HomeScreenState({required this.expandedFolderIds});

  HomeScreenState copyWith({List<String>? expandedFolderIds}) {
    return HomeScreenState(
        expandedFolderIds: expandedFolderIds ?? this.expandedFolderIds);
  }
}
