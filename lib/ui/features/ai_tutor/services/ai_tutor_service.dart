import 'dart:convert';
import 'dart:io';

class AiTurnMessage {
  final String role; // 'ai' or 'user'
  final String text;
  final String urdu;
  final String? grammarFeedback;
  final DateTime timestamp;

  AiTurnMessage({
    required this.role,
    required this.text,
    required this.urdu,
    this.grammarFeedback,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class QuickReplySuggestion {
  final String english;
  final String urdu;

  const QuickReplySuggestion({
    required this.english,
    required this.urdu,
  });
}

class AiCoachReply {
  final String replyEnglish;
  final String replyUrdu;
  final String? grammarCorrection;
  final List<QuickReplySuggestion> suggestions;

  const AiCoachReply({
    required this.replyEnglish,
    required this.replyUrdu,
    this.grammarCorrection,
    required this.suggestions,
  });
}

class AiTutorService {
  AiTutorService._internal();
  static final AiTutorService instance = AiTutorService._internal();

  int _topicTurnIndex = 0;

  void resetSession() {
    _topicTurnIndex = 0;
  }

  AiCoachReply getInitialGreeting(String topic) {
    _topicTurnIndex = 0;
    switch (topic) {
      case 'Job Interview Practice':
        return const AiCoachReply(
          replyEnglish:
              'Welcome to your mock job interview! Please introduce yourself and tell me about your background.',
          replyUrdu:
              'ملازمت کے انٹرویو کی مشق میں خوش آمدید! براہ کرم اپنا تعارف کروائیں اور اپنے پس منظر کے بارے میں بتائیں۔',
          suggestions: [
            QuickReplySuggestion(
              english: 'My name is Ali and I have two years of experience in software.',
              urdu: 'میرا نام علی ہے اور مجھے سافٹ ویئر میں دو سال کا تجربہ ہے۔',
            ),
            QuickReplySuggestion(
              english: 'I am a fresh graduate looking for my first opportunity.',
              urdu: 'میں ایک نیا گریجویٹ ہوں اور اپنے پہلے موقع کی تلاش میں ہوں۔',
            ),
          ],
        );
      case 'Airport & Travel Check-in':
        return const AiCoachReply(
          replyEnglish:
              'Good morning! Welcome to the international check-in counter. Where are you flying today, and may I see your passport?',
          replyUrdu:
              'صبح بخیر! انٹرنیشنل چیک ان کاؤنٹر پر خوش آمدید۔ آج آپ کہاں سفر کر رہے ہیں، اور کیا میں آپ کا پاسپورٹ دیکھ سکتا ہوں؟',
          suggestions: [
            QuickReplySuggestion(
              english: 'I am flying to London today. Here is my passport.',
              urdu: 'میں آج لندن جا رہا ہوں۔ یہ رہا میرا پاسپورٹ۔',
            ),
            QuickReplySuggestion(
              english: 'Can I please get a window seat on the flight?',
              urdu: 'کیا مجھے فلائٹ میں کھڑکی والی سیٹ مل سکتی ہے؟',
            ),
          ],
        );
      case 'Restaurant & Ordering Food':
        return const AiCoachReply(
          replyEnglish:
              'Welcome to Royal Grill Restaurant! Here is the menu. Would you like to start with a drink or order your main course?',
          replyUrdu:
              'رائل گرل ریسٹورنٹ میں خوش آمدید! یہ رہا مینو۔ کیا آپ پہلے کوئی مشروب لینا پسند کریں گے یا کھانا آرڈر کریں گے؟',
          suggestions: [
            QuickReplySuggestion(
              english: 'I would like to order grilled chicken with rice, please.',
              urdu: 'میں براہ کرم چاولوں کے ساتھ گرلڈ چکن آرڈر کرنا چاہوں گا۔',
            ),
            QuickReplySuggestion(
              english: 'Could you bring me a glass of fresh lemon water first?',
              urdu: 'کیا آپ پہلے میرے لیے تازہ لیموں پانی کا ایک گلاس لا سکتے ہیں؟',
            ),
          ],
        );
      case 'Pronunciation & Fluency Drill':
        return const AiCoachReply(
          replyEnglish:
              'Let\'s practice clear English pronunciation! Try saying: "She sells seashells by the seashore, and I speak English confidently every day."',
          replyUrdu:
              'آئیے واضح انگریزی تلفظ کی مشق کریں! یہ جملہ بولنے کی کوشش کریں یا کوئی بھی انگریزی جملہ بولیں۔',
          suggestions: [
            QuickReplySuggestion(
              english: 'I practice speaking English confidently every single day.',
              urdu: 'میں ہر روز خود اعتمادی کے ساتھ انگریزی بولنے کی مشق کرتا ہوں۔',
            ),
            QuickReplySuggestion(
              english: 'Could you help me improve my English accent and fluency?',
              urdu: 'کیا آپ میرا انگریزی لب و لہجہ اور روانی بہتر بنانے میں مدد کر سکتے ہیں؟',
            ),
          ],
        );
      default:
        return const AiCoachReply(
          replyEnglish:
              'Hi there! I am Emma, your AI English Speaking Coach. How is your day going so far?',
          replyUrdu:
              'اسلام علیکم! میں ایما ہوں، آپ کی اے آئی انگلش کوچ۔ آج آپ کا دن کیسا گزر رہا ہے؟',
          suggestions: [
            QuickReplySuggestion(
              english: 'My day is going really well, thank you! How are you?',
              urdu: 'میرا دن بہت اچھا گزر رہا ہے، شکریہ! آپ کیسی ہیں؟',
            ),
            QuickReplySuggestion(
              english: 'I want to practice speaking fluent English with you today.',
              urdu: 'میں آج آپ کے ساتھ روانی سے انگریزی بولنے کی مشق کرنا چاہتا ہوں۔',
            ),
          ],
        );
    }
  }

  Future<AiCoachReply> generateReply({
    required String userText,
    required String topic,
    required List<AiTurnMessage> history,
  }) async {
    final cleaned = userText.trim();
    final localGrammar = _analyzeGrammar(cleaned);

    // 1. Try cloud AI coach first with a fast timeout
    try {
      final cloudReply = await _callCloudAi(
        userText: cleaned,
        topic: topic,
        history: history,
        localGrammarHint: localGrammar,
      ).timeout(const Duration(seconds: 6));
      if (cloudReply != null) {
        return cloudReply;
      }
    } catch (_) {
      // Fall back seamlessly to smart on-device coach
    }

    // 2. Smart contextual on-device reply engine
    return _buildSmartLocalReply(
      userText: cleaned,
      topic: topic,
      grammarCorrection: localGrammar,
    );
  }

  Future<AiCoachReply?> _callCloudAi({
    required String userText,
    required String topic,
    required List<AiTurnMessage> history,
    required String? localGrammarHint,
  }) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 5);
    try {
      final uri = Uri.parse('https://text.pollinations.ai/openai');
      final request = await client.postUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      final recentHistory = history.length > 6
          ? history.sublist(history.length - 6)
          : history;

      final messages = <Map<String, String>>[
        {
          'role': 'system',
          'content': '''You are Emma, a warm, professional AI English Speaking Coach for Urdu/Hindi speakers.
Current conversation topic: "$topic".
Respond ONLY with valid JSON (no markdown fences) matching this exact schema:
{
  "replyEnglish": "Your natural, encouraging spoken reply in 1-2 short sentences + a follow-up question to keep the phone call flowing.",
  "replyUrdu": "Accurate Urdu translation of replyEnglish.",
  "grammarCorrection": "If the user made a grammar mistake, write: 'Better way to say it: \"<corrected sentence>\"'. If their grammar was correct, write: '✓ Great sentence structure!'",
  "suggestions": [
    {"english": "First natural reply the user can say next", "urdu": "Urdu translation"},
    {"english": "Second natural reply the user can say next", "urdu": "Urdu translation"}
  ]
}'''
        },
        for (final msg in recentHistory)
          {
            'role': msg.role == 'ai' ? 'assistant' : 'user',
            'content': msg.text,
          },
        {
          'role': 'user',
          'content': userText,
        },
      ];

      final body = jsonEncode({
        'model': 'openai',
        'messages': messages,
        'temperature': 0.7,
      });

      request.add(utf8.encode(body));
      final response = await request.close();
      if (response.statusCode != 200) return null;

      final responseBody = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(responseBody);
      String content = '';
      if (decoded is Map &&
          decoded['choices'] is List &&
          (decoded['choices'] as List).isNotEmpty) {
        content = decoded['choices'][0]['message']['content']?.toString() ?? '';
      } else {
        return null;
      }

      // Strip optional markdown code fences if present
      content = content
          .replaceAll(RegExp(r'^```json\s*'), '')
          .replaceAll(RegExp(r'^```\s*'), '')
          .replaceAll(RegExp(r'\s*```$'), '')
          .trim();

      final jsonMap = jsonDecode(content) as Map<String, dynamic>;
      final replyEn = (jsonMap['replyEnglish'] as String?)?.trim() ?? '';
      final replyUr = (jsonMap['replyUrdu'] as String?)?.trim() ?? '';
      final grammar =
          (jsonMap['grammarCorrection'] as String?)?.trim() ?? localGrammarHint;

      if (replyEn.isEmpty) return null;

      final List<QuickReplySuggestion> suggestions = [];
      if (jsonMap['suggestions'] is List) {
        for (final item in (jsonMap['suggestions'] as List)) {
          if (item is Map) {
            final en = (item['english'] as String?)?.trim() ?? '';
            final ur = (item['urdu'] as String?)?.trim() ?? '';
            if (en.isNotEmpty) {
              suggestions.add(QuickReplySuggestion(english: en, urdu: ur));
            }
          }
        }
      }

      return AiCoachReply(
        replyEnglish: replyEn,
        replyUrdu: replyUr.isNotEmpty
            ? replyUr
            : 'بہت خوب! اپنی بات جاری رکھیں اور مکمل جملے بولیں۔',
        grammarCorrection: grammar,
        suggestions: suggestions.isNotEmpty
            ? suggestions
            : _defaultSuggestionsForTopic(topic),
      );
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }

  String? _analyzeGrammar(String text) {
    final lower = text.toLowerCase().trim();
    if (lower.isEmpty) return null;

    final rules = <MapEntry<RegExp, String>>[
      MapEntry(
        RegExp(r'\bi am go\b'),
        'Grammar Tip: Say "I am going" or "I go" instead of "I am go".',
      ),
      MapEntry(
        RegExp(r'\bi goes\b'),
        'Grammar Tip: Use "I go" (not "I goes").',
      ),
      MapEntry(
        RegExp(r'\b(he|she|it) dont\b|\b(he|she|it) don' "'" r't\b'),
        'Grammar Tip: Use "doesn\'t" with he/she/it (e.g., "He doesn\'t").',
      ),
      MapEntry(
        RegExp(r'\b(he|she|it) have\b'),
        'Grammar Tip: Use "has" with he/she/it (e.g., "She has").',
      ),
      MapEntry(
        RegExp(r'\byesterday i go\b'),
        'Grammar Tip: For past actions, use past tense: "Yesterday I went".',
      ),
      MapEntry(
        RegExp(r'\bi did went\b|\bi did came\b|\bi did saw\b'),
        'Grammar Tip: After "did", always use the first form of the verb (e.g., "I did go" or simply "I went").',
      ),
      MapEntry(
        RegExp(r'\bmore better\b'),
        'Grammar Tip: Say "much better" or simply "better" (not "more better").',
      ),
      MapEntry(
        RegExp(r'\bdiscuss about\b'),
        'Grammar Tip: Use "discuss" directly without "about" (e.g., "Let\'s discuss this topic").',
      ),
      MapEntry(
        RegExp(r'\bi am agree\b'),
        'Grammar Tip: Say "I agree" (not "I am agree").',
      ),
      MapEntry(
        RegExp(r'\bmy name are\b'),
        'Grammar Tip: Say "My name is..." (singular).',
      ),
    ];

    for (final rule in rules) {
      if (rule.key.hasMatch(lower)) {
        return rule.value;
      }
    }

    final wordCount = text.split(RegExp(r'\s+')).length;
    if (wordCount >= 5) {
      return '✓ Clear sentence! Good fluency ($wordCount words spoken).';
    } else {
      return 'Tip: Try expanding your answer into a full sentence of 6+ words for better fluency.';
    }
  }

  AiCoachReply _buildSmartLocalReply({
    required String userText,
    required String topic,
    required String? grammarCorrection,
  }) {
    final lower = userText.toLowerCase();
    _topicTurnIndex++;

    // Direct conversational intents
    if (lower.contains('how are you') || lower.contains('how are u')) {
      return AiCoachReply(
        replyEnglish:
            'I am doing great, thank you for asking! I love helping you practice English. What did you do today?',
        replyUrdu:
            'میں بالکل ٹھیک ہوں، پوچھنے کا شکریہ! مجھے آپ کے ساتھ انگریزی کی مشق کر کے بہت خوشی ہو رہی ہے۔ آج آپ نے کیا کیا؟',
        grammarCorrection: grammarCorrection,
        suggestions: const [
          QuickReplySuggestion(
            english: 'Today I worked on my projects and studied English.',
            urdu: 'آج میں نے اپنے کام کیے اور انگریزی کا مطالعہ کیا۔',
          ),
          QuickReplySuggestion(
            english: 'I spent time with my family and had a relaxing day.',
            urdu: 'میں نے اپنے خاندان کے ساتھ وقت گزارا اور آرام دہ دن رہا۔',
          ),
        ],
      );
    }

    if (lower.contains('your name') || lower.contains('who are you')) {
      return AiCoachReply(
        replyEnglish:
            'My name is Emma, your personal AI English Speaking Coach! Tell me a little about yourself and your hobbies.',
        replyUrdu:
            'میرا نام ایما ہے، میں آپ کی ذاتی اے آئی انگلش کوچ ہوں! مجھے اپنے اور اپنے مشاغل کے بارے میں کچھ بتائیں۔',
        grammarCorrection: grammarCorrection,
        suggestions: const [
          QuickReplySuggestion(
            english: 'I enjoy reading books, watching cricket, and learning new skills.',
            urdu: 'مجھے کتابیں پڑھنا، کرکٹ دیکھنا اور نئی مہارتیں سیکھنا پسند ہے۔',
          ),
          QuickReplySuggestion(
            english: 'I want to improve my spoken English for my career.',
            urdu: 'میں اپنے کیریئر کے لیے اپنی بول چال کی انگریزی بہتر بنانا چاہتا ہوں۔',
          ),
        ],
      );
    }

    // Topic-specific multi-turn progressions
    switch (topic) {
      case 'Job Interview Practice':
        final turns = [
          const AiCoachReply(
            replyEnglish:
                'That is a strong introduction! Now, what do you consider your greatest strength at work?',
            replyUrdu:
                'یہ بہت اچھا تعارف ہے! اب بتائیے کہ آپ کام میں اپنی سب سے بڑی خوبی کس چیز کو سمجھتے ہیں؟',
            suggestions: [
              QuickReplySuggestion(
                english: 'My greatest strength is problem solving and working well in a team.',
                urdu: 'میری سب سے بڑی خوبی مسائل حل کرنا اور ٹیم کے ساتھ مل کر کام کرنا ہے۔',
              ),
              QuickReplySuggestion(
                english: 'I am a fast learner and always meet my deadlines.',
                urdu: 'میں جلدی سیکھنے والا انسان ہوں اور ہمیشہ وقت پر کام مکمل کرتا ہوں۔',
              ),
            ],
          ),
          const AiCoachReply(
            replyEnglish:
                'Impressive! Can you share an example of a challenge you faced and how you solved it?',
            replyUrdu:
                'شاندار! کیا آپ کسی مشکل چیلنج کی مثال دے سکتے ہیں جس کا آپ نے سامنا کیا اور اسے کیسے حل کیا؟',
            suggestions: [
              QuickReplySuggestion(
                english: 'Once we had a tight deadline, so I organized the tasks and finished on time.',
                urdu: 'ایک بار ہمارے پاس وقت کم تھا، تو میں نے کاموں کو منظم کیا اور وقت پر مکمل کر لیا۔',
              ),
              QuickReplySuggestion(
                english: 'I stayed calm under pressure and communicated clearly with my team.',
                urdu: 'میں دباؤ میں پرسکون رہا اور اپنی ٹیم کے ساتھ واضح بات چیت کی۔',
              ),
            ],
          ),
          const AiCoachReply(
            replyEnglish:
                'Excellent answer! Finally, where do you see yourself in the next five years?',
            replyUrdu:
                'بہترین جواب! آخر میں یہ بتائیے کہ اگلے پانچ سالوں میں آپ خود کو کہاں دیکھتے ہیں؟',
            suggestions: [
              QuickReplySuggestion(
                english: 'In five years, I see myself leading a team and growing with the company.',
                urdu: 'پانچ سالوں میں، میں خود کو ایک ٹیم کی قیادت کرتے اور کمپنی کے ساتھ آگے بڑھتے دیکھتا ہوں۔',
              ),
              QuickReplySuggestion(
                english: 'I want to become an expert in my field and take on bigger responsibilities.',
                urdu: 'میں اپنے شعبے میں ماہر بننا چاہتا ہوں اور بڑی ذمہ داریاں سنبھالنا چاہتا ہوں۔',
              ),
            ],
          ),
        ];
        final chosen = turns[(_topicTurnIndex - 1) % turns.length];
        return AiCoachReply(
          replyEnglish: chosen.replyEnglish,
          replyUrdu: chosen.replyUrdu,
          grammarCorrection: grammarCorrection,
          suggestions: chosen.suggestions,
        );

      case 'Airport & Travel Check-in':
        final turns = [
          const AiCoachReply(
            replyEnglish:
                'Thank you! How many bags are you checking in today, and do you have any carry-on luggage?',
            replyUrdu:
                'شکریہ! آج آپ کتنے بیگ چیک ان کروا رہے ہیں، اور کیا آپ کے پاس کوئی ہینڈ کیری سامان ہے؟',
            suggestions: [
              QuickReplySuggestion(
                english: 'I have one suitcase to check in and one small backpack with me.',
                urdu: 'میرے پاس چیک ان کے لیے ایک سوٹ کیس اور ساتھ لے جانے کے لیے ایک چھوٹا بیگ ہے۔',
              ),
              QuickReplySuggestion(
                english: 'I only have carry-on luggage today.',
                urdu: 'میرے پاس آج صرف ہینڈ کیری سامان ہے۔',
              ),
            ],
          ),
          const AiCoachReply(
            replyEnglish:
                'Perfect! Here is your boarding pass. Your flight boards at Gate B12 in forty minutes. Have a safe flight!',
            replyUrdu:
                'بہت خوب! یہ رہا آپ کا بورڈنگ پاس۔ آپ کی فلائٹ چالیس منٹ میں گیٹ بی 12 سے روانہ ہوگی۔ آپ کا سفر محفوظ رہے!',
            suggestions: [
              QuickReplySuggestion(
                english: 'Thank you very much! Which way is security and Gate B12?',
                urdu: 'بہت شکریہ! سیکیورٹی اور گیٹ بی 12 کس طرف ہے؟',
              ),
              QuickReplySuggestion(
                english: 'Is the flight on time today?',
                urdu: 'کیا آج فلائٹ وقت پر ہے؟',
              ),
            ],
          ),
        ];
        final chosen = turns[(_topicTurnIndex - 1) % turns.length];
        return AiCoachReply(
          replyEnglish: chosen.replyEnglish,
          replyUrdu: chosen.replyUrdu,
          grammarCorrection: grammarCorrection,
          suggestions: chosen.suggestions,
        );

      case 'Restaurant & Ordering Food':
        final turns = [
          const AiCoachReply(
            replyEnglish:
                'Great choice! How would you like that cooked, and would you like any salad or soup on the side?',
            replyUrdu:
                'بہترین انتخاب! آپ اسے کیسا پکا ہوا پسند کریں گے، اور کیا آپ ساتھ میں سلاد یا سوپ لینا چاہیں گے؟',
            suggestions: [
              QuickReplySuggestion(
                english: 'Medium spiced please, with a bowl of fresh green salad.',
                urdu: 'براہ کرم درمیانہ مصالحہ دار، تازہ سلاد کے ایک پیالے کے ساتھ۔',
              ),
              QuickReplySuggestion(
                english: 'Could I also get some garlic bread on the side?',
                urdu: 'کیا مجھے ساتھ میں کچھ گارلک بریڈ بھی مل سکتی ہے؟',
              ),
            ],
          ),
          const AiCoachReply(
            replyEnglish:
                'Certainly! Your order will be ready in fifteen minutes. Would you like anything for dessert afterwards?',
            replyUrdu:
                'بالکل! آپ کا آرڈر پندرہ منٹ میں تیار ہو جائے گا۔ کیا آپ کھانے کے بعد میٹھے میں کچھ لینا پسند کریں گے؟',
            suggestions: [
              QuickReplySuggestion(
                english: 'Yes, I would love a cup of coffee and chocolate cake later.',
                urdu: 'جی ہاں، میں بعد میں ایک کپ کافی اور چاکلیٹ کیک لینا پسند کروں گا۔',
              ),
              QuickReplySuggestion(
                english: 'No dessert for now, just bring the bill when we finish.',
                urdu: 'ابھی میٹھا نہیں، بس جب ہم کھانا ختم کریں تو بل لے آئیے گا۔',
              ),
            ],
          ),
        ];
        final chosen = turns[(_topicTurnIndex - 1) % turns.length];
        return AiCoachReply(
          replyEnglish: chosen.replyEnglish,
          replyUrdu: chosen.replyUrdu,
          grammarCorrection: grammarCorrection,
          suggestions: chosen.suggestions,
        );

      case 'Pronunciation & Fluency Drill':
        return AiCoachReply(
          replyEnglish:
              'You said: "$userText". Your pronunciation is getting clearer! Now try speaking this sentence smoothly: "Consistent daily practice is the secret to speaking fluent English."',
          replyUrdu:
              'آپ کا تلفظ مزید واضح ہو رہا ہے! اب یہ نیا جملہ روانی کے ساتھ بولنے کی کوشش کریں۔',
          grammarCorrection: grammarCorrection,
          suggestions: const [
            QuickReplySuggestion(
              english: 'Consistent daily practice is the secret to speaking fluent English.',
              urdu: 'روزانہ کی مسلسل مشق ہی روانی سے انگریزی بولنے کا راز ہے۔',
            ),
            QuickReplySuggestion(
              english: 'I am learning new English vocabulary and idioms every day.',
              urdu: 'میں ہر روز انگریزی کے نئے الفاظ اور محاورے سیکھ رہا ہوں۔',
            ),
          ],
        );

      default:
        final turns = [
          AiCoachReply(
            replyEnglish:
                'That sounds wonderful! Speaking of "$userText", what is your favorite thing to do in your free time?',
            replyUrdu:
                'یہ سن کر بہت اچھا لگا! ویسے فارغ وقت میں آپ کا پسندیدہ مشغلہ کیا ہے؟',
            grammarCorrection: grammarCorrection,
            suggestions: const [
              QuickReplySuggestion(
                english: 'In my free time, I like learning new technology and meeting friends.',
                urdu: 'اپنے فارغ وقت میں، مجھے نئی ٹیکنالوجی سیکھنا اور دوستوں سے ملنا پسند ہے۔',
              ),
              QuickReplySuggestion(
                english: 'I usually read books or go for an evening walk.',
                urdu: 'میں عام طور پر کتابیں پڑھتا ہوں یا شام کی سیر کے لیے جاتا ہوں۔',
              ),
            ],
          ),
          AiCoachReply(
            replyEnglish:
                'Nice! Why do you want to improve your English speaking skills, and what goal are you working toward?',
            replyUrdu:
                'بہت خوب! آپ اپنی انگریزی بول چال کیوں بہتر بنانا چاہتے ہیں اور آپ کا ہدف کیا ہے؟',
            grammarCorrection: grammarCorrection,
            suggestions: const [
              QuickReplySuggestion(
                english: 'I want to speak confidently in international meetings and interviews.',
                urdu: 'میں بین الاقوامی میٹنگز اور انٹرویوز میں خود اعتمادی سے بولنا چاہتا ہوں۔',
              ),
              QuickReplySuggestion(
                english: 'I want to travel abroad and communicate easily with everyone.',
                urdu: 'میں بیرون ملک سفر کرنا اور سب سے آسانی سے بات چیت کرنا چاہتا ہوں۔',
              ),
            ],
          ),
          AiCoachReply(
            replyEnglish:
                'That is a fantastic goal! If you could visit any country in the world, where would you go and why?',
            replyUrdu:
                'یہ ایک شاندار مقصد ہے! اگر آپ دنیا کے کسی بھی ملک کی سیر کر سکیں تو آپ کہاں جائیں گے اور کیوں؟',
            grammarCorrection: grammarCorrection,
            suggestions: const [
              QuickReplySuggestion(
                english: 'I would love to visit the United Kingdom to experience its history and culture.',
                urdu: 'میں برطانیہ جانا پسند کروں گا تاکہ وہاں کی تاریخ اور ثقافت دیکھ سکوں۔',
              ),
              QuickReplySuggestion(
                english: 'I would like to visit Turkey and Switzerland because of the beautiful scenery.',
                urdu: 'میں خوبصورت مناظر کی وجہ سے ترکی اور سوئٹزرلینڈ جانا چاہوں گا۔',
              ),
            ],
          ),
        ];
        return turns[(_topicTurnIndex - 1) % turns.length];
    }
  }

  List<QuickReplySuggestion> _defaultSuggestionsForTopic(String topic) {
    return getInitialGreeting(topic).suggestions;
  }
}
