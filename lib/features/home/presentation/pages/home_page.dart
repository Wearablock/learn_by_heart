import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../card/presentation/pages/card_editor_page.dart';
import '../providers/card_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/card_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
      ),
      body: Consumer<CardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => provider.loadCards(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.isEmpty) {
            return EmptyState(
              onAddCard: () => _navigateToAddCard(context),
            );
          }

          return CardListView(
            cards: provider.cards,
            onCardTap: (card) => _navigateToEditCard(context, card.id),
            onCardDelete: (card) => provider.deleteCard(card.id),
          );
        },
      ),
      floatingActionButton: Consumer<CardProvider>(
        builder: (context, provider, child) {
          if (provider.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: () => _navigateToAddCard(context),
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  void _navigateToAddCard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CardEditorPage(),
      ),
    );
  }

  void _navigateToEditCard(BuildContext context, String cardId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CardEditorPage(cardId: cardId),
      ),
    );
  }
}
