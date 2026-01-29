import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/providers/card_provider.dart';
import '../../data/models/memory_card.dart';
import '../../data/repositories/card_repository.dart';

class CardEditorPage extends StatefulWidget {
  final String? cardId;

  const CardEditorPage({super.key, this.cardId});

  @override
  State<CardEditorPage> createState() => _CardEditorPageState();
}

class _CardEditorPageState extends State<CardEditorPage> {
  final _contentController = TextEditingController();
  final _hintController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _repository = CardRepository();

  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasChanges = false;
  MemoryCard? _originalCard;
  String? _error;
  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoading = false;

  bool get isEditMode => widget.cardId != null;

  bool get _canSave {
    if (_isSaving) return false;
    final content = _contentController.text.trim();
    if (content.isEmpty) return false;
    if (isEditMode && !_hasChanges) return false;
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _loadCard();
    } else {
      // Load rewarded ad for new card creation
      _loadRewardedAd();
    }
    _contentController.addListener(_onContentChanged);
    _hintController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _hintController.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  Future<void> _loadRewardedAd() async {
    if (_isRewardedAdLoading) return;
    _isRewardedAdLoading = true;

    await RewardedAd.load(
      adUnitId: AdService.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoading = false;
          debugPrint('Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isRewardedAdLoading = false;
          debugPrint('Rewarded ad failed to load: ${error.message}');
        },
      ),
    );
  }

  void _onContentChanged() {
    final hasChanges = isEditMode
        ? (_contentController.text != _originalCard?.content ||
            _hintController.text != (_originalCard?.hint ?? ''))
        : _contentController.text.isNotEmpty;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  Future<void> _loadCard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final card = await _repository.getById(widget.cardId!);
      if (card != null) {
        _originalCard = card;
        _contentController.text = card.content;
        _hintController.text = card.hint ?? '';
      } else {
        _error = 'Card not found';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) return;

    // For new cards, show rewarded ad before saving
    if (!isEditMode && _rewardedAd != null) {
      _showRewardedAdAndSave();
    } else {
      await _performSave();
    }
  }

  void _showRewardedAdAndSave() {
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _performSave();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        debugPrint('Rewarded ad failed to show: ${error.message}');
        _performSave();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
      },
    );
  }

  Future<void> _performSave() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final content = _contentController.text.trim();
      final hint = _hintController.text.trim();
      final provider = context.read<CardProvider>();

      if (isEditMode) {
        await provider.updateCard(
          id: widget.cardId!,
          content: content,
          hint: hint.isEmpty ? null : hint,
        );
      } else {
        await provider.addCard(
          content,
          hint: hint.isEmpty ? null : hint,
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _deleteCard() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteCard),
        content: Text(l10n.deleteCardConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final provider = context.read<CardProvider>();

    try {
      await provider.deleteCard(widget.cardId!);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.discardChanges),
        content: Text(l10n.discardChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.keepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.discard),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final navigator = Navigator.of(context);

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? l10n.editCard : l10n.addCard),
          actions: [
            TextButton(
              onPressed: _canSave ? _saveCard : null,
              child: _isSaving
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : Text(l10n.save),
            ),
          ],
        ),
        body: _buildBody(l10n, theme),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n, ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadCard,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _contentController,
              maxLines: 8,
              maxLength: 5000,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                labelText: l10n.cardContent,
                hintText: l10n.cardContentHint,
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.cardContentRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _hintController,
              maxLines: 2,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: l10n.cardHint,
                hintText: l10n.cardHintPlaceholder,
                alignLabelWithHint: true,
              ),
            ),
            if (isEditMode) ...[
              const SizedBox(height: 48),
              OutlinedButton.icon(
                onPressed: _deleteCard,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.deleteCard),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
