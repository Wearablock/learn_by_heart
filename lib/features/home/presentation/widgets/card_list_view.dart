import 'package:flutter/material.dart';
import '../../../card/data/models/memory_card.dart';
import 'card_item.dart';

class CardListView extends StatelessWidget {
  final List<MemoryCard> cards;
  final Function(MemoryCard)? onCardTap;
  final Function(MemoryCard)? onCardEdit;
  final Function(MemoryCard)? onCardDelete;

  const CardListView({
    super.key,
    required this.cards,
    this.onCardTap,
    this.onCardEdit,
    this.onCardDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cards.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final card = cards[index];
        return CardItem(
          card: card,
          onTap: () => onCardTap?.call(card),
          onEdit: () => onCardEdit?.call(card),
          onDelete: () => onCardDelete?.call(card),
        );
      },
    );
  }
}
