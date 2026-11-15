import 'package:flutter/material.dart';
import '../../../core/services/share_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/premium_scaffold.dart';
import '../../../core/widgets/speak_button.dart';

class DailyPhrase {
  final String category;
  final String english;
  final String urdu;
  final String roman;

  const DailyPhrase({
    required this.category,
    required this.english,
    required this.urdu,
    required this.roman,
  });
}

class PhrasesScreen extends StatefulWidget {
  const PhrasesScreen({super.key});

  @override
  State<PhrasesScreen> createState() => _PhrasesScreenState();
}

class _PhrasesScreenState extends State<PhrasesScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Greetings & Politeness',
    'Directions & Travel',
    'Shopping & Dining',
    'Emergencies',
    'Workplace & Career',
  ];

  final List<DailyPhrase> _allPhrases = const [
    DailyPhrase(
      category: 'Greetings & Politeness',
      english: 'How have you been lately?',
      urdu: 'آج کل آپ کا کیا حال ہے؟',
      roman: 'Aaj kal aap ka kya haal hai?',
    ),
    DailyPhrase(
      category: 'Greetings & Politeness',
      english: 'I really appreciate your assistance.',
      urdu: 'میں آپ کی مدد کی دل سے قدر کرتا ہوں۔',
      roman: 'Main aap ki madad ki dil se qadar karta hun.',
    ),
    DailyPhrase(
      category: 'Greetings & Politeness',
      english: 'Could you please repeat that more slowly?',
      urdu: 'کیا آپ براہ کرم اسے ذرا آہستہ دہرا سکتے ہیں؟',
      roman: 'Kya aap barah-e-karam isay zara aahista dohra saktay hain?',
    ),
    DailyPhrase(
      category: 'Directions & Travel',
      english: 'Could you tell me how to get to the nearest station?',
      urdu: 'کیا آپ مجھے قریبی اسٹیشن جانے کا راستہ بتا سکتے ہیں؟',
      roman: 'Kya aap mujhay qareebi station janay ka rasta bata saktay hain?',
    ),
    DailyPhrase(
      category: 'Directions & Travel',
      english: 'Is it within walking distance?',
      urdu: 'کیا یہ پیدل جانے کی دوری پر ہے؟',
      roman: 'Kya yeh pedal janay ki doori par hai?',
    ),
    DailyPhrase(
      category: 'Directions & Travel',
      english: 'Where can I buy a ticket for the express train?',
      urdu: 'تیز رفتار ٹرین کا ٹکٹ کہاں سے مل سکتا ہے؟',
      roman: 'Tez raftar train ka ticket kahan se mil sakta hai?',
    ),
    DailyPhrase(
      category: 'Shopping & Dining',
      english: 'May I see the menu, please?',
      urdu: 'کیا میں مینو کارڈ دیکھ سکتا ہوں؟',
      roman: 'Kya main menu card dekh sakta hun?',
    ),
    DailyPhrase(
      category: 'Shopping & Dining',
      english: 'How much does this item cost in total?',
      urdu: 'اس چیز کی کل قیمت کتنی ہے؟',
      roman: 'Is cheez ki kul qeemat kitni hai?',
    ),
    DailyPhrase(
      category: 'Shopping & Dining',
      english: 'Could you please bring us the bill?',
      urdu: 'کیا آپ براہ کرم بل لا سکتے ہیں؟',
      roman: 'Kya aap barah-e-karam bill laa saktay hain?',
    ),
    DailyPhrase(
      category: 'Emergencies',
      english: 'Please call an ambulance immediately!',
      urdu: 'براہ مہربانی فوراً ایمبولینس بلائیں!',
      roman: 'Barah-e-mehrbani foran ambulance bulayein!',
    ),
    DailyPhrase(
      category: 'Emergencies',
      english: 'I have lost my passport and luggage.',
      urdu: 'میرا پاسپورٹ اور سامان گم ہو گیا ہے۔',
      roman: 'Mera passport aur samaan ghum ho gaya hai.',
    ),
    DailyPhrase(
      category: 'Workplace & Career',
      english: 'Let us schedule a follow-up meeting tomorrow.',
      urdu: 'آئیے کل ایک اور میٹنگ کا وقت طے کرتے ہیں۔',
      roman: 'Aaiye kal aik aur meeting ka waqt tay kartay hain.',
    ),
    DailyPhrase(
      category: 'Workplace & Career',
      english: 'I look forward to collaborating with you.',
      urdu: 'مجھے آپ کے ساتھ کام کرنے کا انتظار رہے گا۔',
      roman: 'Mujhay aap ke sath kaam karnay ka intezaar rahay ga.',
    ),
  ];

  List<DailyPhrase> get _filteredPhrases {
    if (_selectedCategory == 'All') return _allPhrases;
    return _allPhrases.where((p) => p.category == _selectedCategory).toList();
  }

  void _sharePhrase(DailyPhrase phrase) {
    ShareHelper.shareText(
      'Phrase: ${phrase.english}\nUrdu: ${phrase.urdu}\n(${phrase.roman})\n\nLearn English with Learn English App!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Essential Everyday Phrases',
      urduTitle: 'اہم ترین روزمرہ انگریزی جملے اور بول چال',
      badgeText: 'Daily Use',
      gradient: AppColors.phrasesGradient,
      headerBottom: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((cat) {
            final isSelected = cat == _selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withAlpha(60),
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? AppColors.sky : Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: _filteredPhrases.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final phrase = _filteredPhrases[index];
          return GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sky.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        phrase.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.sky,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SpeakButton(
                      text: phrase.english,
                      size: 18,
                      color: AppColors.sky,
                      backgroundColor: AppColors.sky.withAlpha(22),
                    ),
                    const SizedBox(width: 6),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => _sharePhrase(phrase),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.share_outlined,
                            size: 18,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  phrase.english,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  phrase.urdu,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.urduGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phrase.roman,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
