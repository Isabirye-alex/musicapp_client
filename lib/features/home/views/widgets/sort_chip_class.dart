import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';

class SortChipClass extends ConsumerWidget {
  const SortChipClass({super.key, required this.label, required this.order});
  final String label;
  final SongSortOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.read(homeViewmodelProvider.notifier).sortOrder;
    final isSelected = currentOrder == order;
    return FilterChip(label: Text(label), selected: isSelected, onSelected: (_){
      ref.watch(homeViewmodelProvider.notifier).changeSortOrder(order);
    },);
  }
}