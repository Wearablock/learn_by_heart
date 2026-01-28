import '../../features/card/data/repositories/card_repository.dart';

class SeedService {
  static final _repository = CardRepository();

  static const _sampleCards = [
    {
      'content':
          'The only way to do great work is to love what you do. If you haven\'t found it yet, keep looking. Don\'t settle.',
      'hint': 'Steve Jobs - Stanford Commencement Speech (2005)',
    },
    {
      'content': '죽는 날까지 하늘을 우러러 한 점 부끄럼이 없기를, 잎새에 이는 바람에도 나는 괴로워했다.',
      'hint': '윤동주 - 서시',
    },
    {
      'content': '吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当がつかぬ。',
      'hint': '夏目漱石 - 吾輩は猫である',
    },
    {
      'content': 'Die Grenzen meiner Sprache bedeuten die Grenzen meiner Welt.',
      'hint': 'Wittgenstein - 내 언어의 한계는 내 세계의 한계를 의미한다',
    },
    {
      'content':
          'On ne voit bien qu\'avec le cœur. L\'essentiel est invisible pour les yeux.',
      'hint': 'Saint-Exupéry - Le Petit Prince',
    },
  ];

  static Future<void> seedIfEmpty() async {
    final count = await _repository.count();
    if (count > 0) return;

    for (final card in _sampleCards) {
      await _repository.create(
        content: card['content']!,
        hint: card['hint'],
      );
    }
  }
}
