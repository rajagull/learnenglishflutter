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

class _CandidateResponse {
  final List<String> keywords;
  final String replyEnglish;
  final String replyUrdu;
  final List<QuickReplySuggestion> suggestions;

  const _CandidateResponse({
    required this.keywords,
    required this.replyEnglish,
    required this.replyUrdu,
    required this.suggestions,
  });
}

class AiTutorService {
  AiTutorService._internal();
  static final AiTutorService instance = AiTutorService._internal();

  final Set<String> _askedReplies = <String>{};

  void resetSession() {
    _askedReplies.clear();
  }

  AiCoachReply getInitialGreeting(String topic) {
    _askedReplies.clear();
    switch (topic) {
      case 'Job Interview Practice':
        return const AiCoachReply(
          replyEnglish:
              'Welcome to your mock job interview! Please introduce yourself and tell me what role or field you are applying for.',
          replyUrdu:
              'ملازمت کے انٹرویو کی مشق میں خوش آمدید! براہ کرم اپنا تعارف کروائیں اور بتائیں کہ آپ کس شعبے یا ملازمت کے لیے درخواست دے رہے ہیں۔',
          suggestions: [
            QuickReplySuggestion(
              english: 'My name is Ali and I am applying for a software developer position.',
              urdu: 'میرا نام علی ہے اور میں سافٹ ویئر ڈویلپر کی پوسٹ کے لیے اپلائی کر رہا ہوں۔',
            ),
            QuickReplySuggestion(
              english: 'I have three years of experience in sales and customer service.',
              urdu: 'مجھے سیلز اور کسٹمر سروس میں تین سال کا تجربہ ہے۔',
            ),
          ],
        );
      case 'Airport & Travel Check-in':
        return const AiCoachReply(
          replyEnglish:
              'Good morning! Welcome to the international check-in counter. Where are you flying today, and what is the purpose of your trip?',
          replyUrdu:
              'صبح بخیر! انٹرنیشنل چیک ان کاؤنٹر پر خوش آمدید۔ آج آپ کہاں سفر کر رہے ہیں اور آپ کے سفر کا مقصد کیا ہے؟',
          suggestions: [
            QuickReplySuggestion(
              english: 'I am flying to Dubai for a business conference.',
              urdu: 'میں ایک بزنس کانفرنس کے لیے دبئی جا رہا ہوں۔',
            ),
            QuickReplySuggestion(
              english: 'I am traveling to London to visit my family on vacation.',
              urdu: 'میں چھٹیوں میں اپنے خاندان سے ملنے لندن جا رہا ہوں۔',
            ),
          ],
        );
      case 'Restaurant & Ordering Food':
        return const AiCoachReply(
          replyEnglish:
              'Welcome to Royal Grill Restaurant! What kind of food are you in the mood for today — spicy Pakistani food, grilled steak, or pasta?',
          replyUrdu:
              'رائل گرل ریسٹورنٹ میں خوش آمدید! آج آپ کیا کھانا پسند کریں گے — مصالحہ دار کھانا، گرلڈ اسٹیک یا پاستا؟',
          suggestions: [
            QuickReplySuggestion(
              english: 'I would like to order grilled chicken steak with mashed potatoes.',
              urdu: 'میں میشڈ آلو کے ساتھ گرلڈ چکن اسٹیک آرڈر کرنا چاہوں گا۔',
            ),
            QuickReplySuggestion(
              english: 'What is your most popular spicy dish on the menu today?',
              urdu: 'آج آپ کے مینو میں سب سے مشہور مصالحہ دار ڈش کون سی ہے؟',
            ),
          ],
        );
      case 'Pronunciation & Fluency Drill':
        return const AiCoachReply(
          replyEnglish:
              'Let\'s practice clear English pronunciation and speaking flow! Tell me in one or two sentences about your favorite hobby or daily routine.',
          replyUrdu:
              'آئیے واضح انگریزی تلفظ اور روانی کی مشق کریں! مجھے ایک یا دو جملوں میں اپنے پسندیدہ مشغلے یا روزمرہ معمول کے بارے میں بتائیں۔',
          suggestions: [
            QuickReplySuggestion(
              english: 'Every morning I wake up early, go for a walk, and read the news in English.',
              urdu: 'ہر صبح میں جلدی اٹھتا ہوں، سیر کے لیے جاتا ہوں اور انگریزی میں خبریں پڑھتا ہوں۔',
            ),
            QuickReplySuggestion(
              english: 'My favorite hobby is playing cricket with my friends on weekends.',
              urdu: 'میرا پسندیدہ مشغلہ ویک اینڈ پر اپنے دوستوں کے ساتھ کرکٹ کھیلنا ہے۔',
            ),
          ],
        );
      default:
        return const AiCoachReply(
          replyEnglish:
              'Hi there! I am Emma, your AI English Speaking Coach. Tell me, how is your day going and what have you been doing today?',
          replyUrdu:
              'اسلام علیکم! میں ایما ہوں، آپ کی اے آئی انگلش کوچ۔ بتائیے آج آپ کا دن کیسا گزر رہا ہے اور آج آپ نے کیا کیا؟',
          suggestions: [
            QuickReplySuggestion(
              english: 'My day is going great! I was busy with my work and now I am practicing English.',
              urdu: 'میرا دن بہت اچھا گزر رہا ہے! میں اپنے کام میں مصروف تھا اور اب انگریزی کی مشق کر رہا ہوں۔',
            ),
            QuickReplySuggestion(
              english: 'Today I spent time with my family and cooked a nice meal.',
              urdu: 'آج میں نے اپنے خاندان کے ساتھ وقت گزارا اور اچھا کھانا بنایا۔',
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

    // 1. Try fast 3-line Cloud AI response first (10s timeout)
    try {
      final cloudReply = await _callFastCloudAi(
        userText: cleaned,
        topic: topic,
        history: history,
        localGrammarHint: localGrammar,
      ).timeout(const Duration(seconds: 9));
      if (cloudReply != null && !_askedReplies.contains(cloudReply.replyEnglish)) {
        _askedReplies.add(cloudReply.replyEnglish);
        return cloudReply;
      }
    } catch (_) {
      // Fall back to input-driven contextual NLU engine
    }

    // 2. Input-driven NLU & Dynamic Questioning Engine (never repeats questions!)
    final reply = _generateDynamicContextualReply(
      userText: cleaned,
      topic: topic,
      grammarCorrection: localGrammar,
    );
    _askedReplies.add(reply.replyEnglish);
    return reply;
  }

  Future<AiCoachReply?> _callFastCloudAi({
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
          'content':
              'You are Emma, an English speaking coach on a live phone call (Topic: $topic). '
              'Directly react to the exact details in the user\'s message and ask a specific follow-up question about what they just said. '
              'Output exactly 3 lines separated by ||| (no markdown):\n'
              'English reply (1-2 sentences ending with a specific question about the user\'s input) ||| Urdu translation of your reply ||| One suggested English sentence the user could say next'
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
        'model': 'openai-fast',
        'reasoning_effort': 'low',
        'messages': messages,
        'temperature': 0.7,
      });

      request.add(utf8.encode(body));
      final response = await request.close();
      if (response.statusCode != 200) return null;

      final responseBody = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(responseBody);
      if (decoded is! Map ||
          decoded['choices'] is! List ||
          (decoded['choices'] as List).isEmpty) {
        return null;
      }

      final rawContent =
          decoded['choices'][0]['message']['content']?.toString().trim() ?? '';
      if (rawContent.isEmpty) return null;

      final parts = rawContent.split('|||').map((s) => s.trim()).toList();
      final replyEn = parts[0].replaceAll('\n', ' ').trim();
      if (replyEn.isEmpty) return null;

      final replyUr = parts.length > 1 && parts[1].isNotEmpty
          ? parts[1]
          : 'بہت خوب! اس بارے میں مجھے مزید تفصیل سے انگریزی میں بتائیں۔';
      final nextEn = parts.length > 2 && parts[2].isNotEmpty
          ? parts[2]
          : 'Actually, let me tell you more about why I enjoy that.';

      return AiCoachReply(
        replyEnglish: replyEn,
        replyUrdu: replyUr,
        grammarCorrection: localGrammarHint,
        suggestions: [
          QuickReplySuggestion(
            english: nextEn,
            urdu: 'آپ یہ جملہ بول کر جواب دے سکتے ہیں۔',
          ),
          const QuickReplySuggestion(
            english: 'That is a great question! Let me explain in detail.',
            urdu: 'یہ بہت اچھا سوال ہے! میں تفصیل سے بتاتا ہوں۔',
          ),
        ],
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
        'Grammar Correction: Say "I am going" or "I go" instead of "I am go".',
      ),
      MapEntry(
        RegExp(r'\bi goes\b'),
        'Grammar Correction: Use "I go" (not "I goes").',
      ),
      MapEntry(
        RegExp(r'\b(he|she|it) dont\b|\b(he|she|it) don' "'" r't\b'),
        'Grammar Correction: Use "doesn\'t" with he/she/it (e.g., "He doesn\'t").',
      ),
      MapEntry(
        RegExp(r'\b(he|she|it) have\b'),
        'Grammar Correction: Use "has" with he/she/it (e.g., "She has").',
      ),
      MapEntry(
        RegExp(r'\byesterday i go\b'),
        'Grammar Correction: For past actions, use past tense: "Yesterday I went".',
      ),
      MapEntry(
        RegExp(r'\bi did went\b|\bi did came\b|\bi did saw\b'),
        'Grammar Correction: After "did", use the base verb ("I did go" or simply "I went").',
      ),
      MapEntry(
        RegExp(r'\bmore better\b'),
        'Grammar Correction: Say "much better" or simply "better" (not "more better").',
      ),
      MapEntry(
        RegExp(r'\bdiscuss about\b'),
        'Grammar Correction: Use "discuss" directly without "about".',
      ),
      MapEntry(
        RegExp(r'\bi am agree\b'),
        'Grammar Correction: Say "I agree" (not "I am agree").',
      ),
      MapEntry(
        RegExp(r'\bi have (\d+) years\b'),
        'Grammar Correction: For age, say "I am ... years old" (or for experience: "I have ... years of experience").',
      ),
    ];

    for (final rule in rules) {
      if (rule.key.hasMatch(lower)) {
        return rule.value;
      }
    }

    final wordCount = text.split(RegExp(r'\s+')).length;
    if (wordCount >= 6) {
      return '✓ Well-formed sentence! ($wordCount words spoken clearly)';
    } else {
      return 'Fluency Tip: Try adding "because..." or "so..." to make your sentence longer!';
    }
  }

  AiCoachReply _generateDynamicContextualReply({
    required String userText,
    required String topic,
    required String? grammarCorrection,
  }) {
    final lower = userText.toLowerCase().trim();
    final keyPhrase = _extractUserKeySubject(userText);

    // 1. Check if the user asked a direct question to the AI Coach
    if (_isUserQuestion(lower)) {
      final qReply = _answerUserQuestion(userText, lower, grammarCorrection);
      if (qReply != null && !_askedReplies.contains(qReply.replyEnglish)) {
        return qReply;
      }
    }

    // 2. Match rich keyword knowledge base across daily life, work, food, study, family, travel, hobbies, feelings, etc.
    final candidates = _buildKnowledgeBase(userText, keyPhrase);
    for (final candidate in candidates) {
      final matches = candidate.keywords.any(
        (kw) => RegExp('\\b${RegExp.escape(kw)}', caseSensitive: false)
            .hasMatch(lower),
      );
      if (matches && !_askedReplies.contains(candidate.replyEnglish)) {
        return AiCoachReply(
          replyEnglish: candidate.replyEnglish,
          replyUrdu: candidate.replyUrdu,
          grammarCorrection: grammarCorrection,
          suggestions: candidate.suggestions,
        );
      }
    }

    // 3. Dynamic Sentence-Reflection Question Generator (analyzes user's exact words and builds a unique follow-up question!)
    return _buildReflectiveFollowUp(
      userText: userText,
      keyPhrase: keyPhrase,
      topic: topic,
      grammarCorrection: grammarCorrection,
    );
  }

  bool _isUserQuestion(String lower) {
    return lower.endsWith('?') ||
        lower.startsWith('what ') ||
        lower.startsWith('how ') ||
        lower.startsWith('why ') ||
        lower.startsWith('where ') ||
        lower.startsWith('when ') ||
        lower.startsWith('who ') ||
        lower.startsWith('can you ') ||
        lower.startsWith('do you ') ||
        lower.startsWith('are you ') ||
        lower.contains('how are you') ||
        lower.contains('what about you') ||
        lower.contains('and you');
  }

  AiCoachReply? _answerUserQuestion(
    String rawText,
    String lower,
    String? grammarCorrection,
  ) {
    if (lower.contains('how are you') ||
        lower.contains('how are u') ||
        lower.contains('how do you do')) {
      return AiCoachReply(
        replyEnglish:
            'I am doing wonderfully, thank you for asking! What is the most interesting thing you have done today?',
        replyUrdu:
            'میں بالکل ٹھیک ہوں، پوچھنے کا شکریہ! آج آپ نے سب سے دلچسپ کام کون سا کیا ہے؟',
        grammarCorrection: grammarCorrection,
        suggestions: const [
          QuickReplySuggestion(
            english: 'Today I worked on an exciting project and learned new English words.',
            urdu: 'آج میں نے ایک دلچسپ پراجیکٹ پر کام کیا اور انگریزی کے نئے الفاظ سیکھے۔',
          ),
          QuickReplySuggestion(
            english: 'I met an old friend today and we had tea together.',
            urdu: 'آج میں اپنے ایک پرانے دوست سے ملا اور ہم نے اکٹھے چائے پی۔',
          ),
        ],
      );
    }

    if (lower.contains('your name') || lower.contains('who are you')) {
      return AiCoachReply(
        replyEnglish:
            'I am Emma, your AI English Speaking Coach! What is your name, and which city are you calling from?',
        replyUrdu:
            'میں ایما ہوں، آپ کی اے آئی انگلش کوچ! آپ کا نام کیا ہے اور آپ کس شہر سے بات کر رہے ہیں؟',
        grammarCorrection: grammarCorrection,
        suggestions: const [
          QuickReplySuggestion(
            english: 'My name is Ahmed and I am calling from Lahore.',
            urdu: 'میرا نام احمد ہے اور میں لاہور سے بات کر رہا ہوں۔',
          ),
          QuickReplySuggestion(
            english: 'I live in Karachi and I am practicing English with you.',
            urdu: 'میں کراچی میں رہتا ہوں اور آپ کے ساتھ انگریزی کی مشق کر رہا ہوں۔',
          ),
        ],
      );
    }

    if (lower.contains('improve') ||
        lower.contains('learn english') ||
        lower.contains('speak english') ||
        lower.contains('fluent')) {
      return AiCoachReply(
        replyEnglish:
            'To speak fluent English fast, practice thinking in English and speaking out loud for 10 minutes daily. Which situation do you need English for the most — your job, studies, or travel?',
        replyUrdu:
            'تیزی سے روانی کے ساتھ انگریزی بولنے کے لیے روزانہ دس منٹ انگریزی میں سوچنے اور بولنے کی مشق کریں۔ آپ کو انگریزی کی سب سے زیادہ ضرورت کس چیز کے لیے ہے — ملازمت، تعلیم یا سفر؟',
        grammarCorrection: grammarCorrection,
        suggestions: const [
          QuickReplySuggestion(
            english: 'I need fluent English mainly for my job and professional meetings.',
            urdu: 'مجھے روانی سے انگریزی کی ضرورت بنیادی طور پر اپنی ملازمت اور دفتری میٹنگز کے لیے ہے۔',
          ),
          QuickReplySuggestion(
            english: 'I want to go abroad for higher studies and pass my interview.',
            urdu: 'میں اعلیٰ تعلیم کے لیے بیرون ملک جانا چاہتا ہوں اور اپنا انٹرویو پاس کرنا چاہتا ہوں۔',
          ),
        ],
      );
    }

    if (lower.contains('what about you') || lower.contains('and you')) {
      return AiCoachReply(
        replyEnglish:
            'As an AI coach, my favorite thing is having conversations like this with you! Tell me, what is something new you would love to learn this year?',
        replyUrdu:
            'ایک اے آئی کوچ کے طور پر، مجھے آپ کے ساتھ ایسی بات چیت کرنا سب سے زیادہ پسند ہے! بتائیے اس سال آپ کون سی نئی چیز سیکھنا چاہیں گے؟',
        grammarCorrection: grammarCorrection,
        suggestions: const [
          QuickReplySuggestion(
            english: 'This year I want to master public speaking and mobile app development.',
            urdu: 'اس سال میں پبلک اسپیکنگ اور موبائل ایپ ڈویلپمنٹ میں مہارت حاصل کرنا چاہتا ہوں۔',
          ),
          QuickReplySuggestion(
            english: 'I want to improve my English vocabulary and communication skills.',
            urdu: 'میں اپنے انگریزی ذخیرہ الفاظ اور بات چیت کی مہارت کو بہتر بنانا چاہتا ہوں۔',
          ),
        ],
      );
    }

    final cleanedTopic = _extractUserKeySubject(rawText);
    return AiCoachReply(
      replyEnglish:
          'That is a very thoughtful question about $cleanedTopic! In my view, consistency and clear communication make the biggest difference. What made you curious about $cleanedTopic today?',
      replyUrdu:
          'یہ بہت اچھا سوال ہے! میرے خیال میں مستقل مزاجی اور واضح بات چیت سب سے اہم ہے۔ آج آپ کے ذہن میں اس بارے میں سوال کیسے آیا؟',
      grammarCorrection: grammarCorrection,
      suggestions: [
        QuickReplySuggestion(
          english: 'I was thinking about $cleanedTopic because it is useful in daily life.',
          urdu: 'میں اس بارے میں اس لیے سوچ رہا تھا کیونکہ یہ روزمرہ زندگی میں مفید ہے۔',
        ),
        const QuickReplySuggestion(
          english: 'I wanted to hear your perspective and practice asking questions in English.',
          urdu: 'میں آپ کی رائے جاننا چاہتا تھا اور انگریزی میں سوالات پوچھنے کی مشق کرنا چاہتا تھا۔',
        ),
      ],
    );
  }

  List<_CandidateResponse> _buildKnowledgeBase(String rawText, String keyPhrase) {
    return [
      // Work / Job / Software / Office / Business
      _CandidateResponse(
        keywords: [
          'work',
          'working',
          'job',
          'office',
          'software',
          'developer',
          'engineer',
          'business',
          'company',
          'project',
          'coding',
          'app'
        ],
        replyEnglish:
            'Working on $keyPhrase sounds really rewarding! What is the most interesting or challenging part of your work right now?',
        replyUrdu:
            'آپ کے کام کے بارے میں سن کر بہت اچھا لگا! اس وقت آپ کے کام کا سب سے دلچسپ یا مشکل حصہ کون سا ہے؟',
        suggestions: const [
          QuickReplySuggestion(
            english: 'The most interesting part is solving complex problems and building new features.',
            urdu: 'سب سے دلچسپ حصہ پیچیدہ مسائل کو حل کرنا اور نئے فیچرز بنانا ہے۔',
          ),
          QuickReplySuggestion(
            english: 'Managing deadlines and communicating with clients is the biggest challenge.',
            urdu: 'وقت پر کام مکمل کرنا اور کلائنٹس سے بات چیت کرنا سب سے بڑا چیلنج ہے۔',
          ),
        ],
      ),
      _CandidateResponse(
        keywords: [
          'deadline',
          'client',
          'problem',
          'feature',
          'team',
          'manager',
          'meeting',
          'salary',
          'career'
        ],
        replyEnglish:
            'Handling $keyPhrase definitely takes skill and patience! How do you usually stay organized when work gets busy?',
        replyUrdu:
            'اس کام کو سنبھالنے کے لیے واقعی مہارت اور صبر کی ضرورت ہوتی ہے! جب کام زیادہ ہو تو آپ خود کو کیسے منظم رکھتے ہیں؟',
        suggestions: const [
          QuickReplySuggestion(
            english: 'I make a daily to-do list every morning and focus on one task at a time.',
            urdu: 'میں ہر صبح اپنے کاموں کی فہرست بناتا ہوں اور ایک وقت میں ایک کام پر توجہ دیتا ہوں۔',
          ),
          QuickReplySuggestion(
            english: 'I prioritize urgent tasks first and take short breaks to stay fresh.',
            urdu: 'میں ضروری کاموں کو پہلے ترجیح دیتا ہوں اور تازہ دم رہنے کے لیے مختصر وقفہ لیتا ہوں۔',
          ),
        ],
      ),

      // Food / Cooking / Restaurant / Tea / Coffee / Biryani
      _CandidateResponse(
        keywords: [
          'eat',
          'ate',
          'eating',
          'cook',
          'cooked',
          'cooking',
          'food',
          'biryani',
          'chicken',
          'dinner',
          'lunch',
          'breakfast',
          'tea',
          'coffee',
          'restaurant',
          'meal',
          'pizza',
          'rice'
        ],
        replyEnglish:
            'Talking about $keyPhrase is making me hungry! Do you prefer cooking at home, or do you like trying new restaurants with family and friends?',
        replyUrdu:
            'کھانے کا ذکر سن کر ہی منہ میں پانی آ گیا! کیا آپ گھر کا بنا ہوا کھانا زیادہ پسند کرتے ہیں یا دوستوں اور خاندان کے ساتھ نئے ریسٹورنٹ جانا؟',
        suggestions: const [
          QuickReplySuggestion(
            english: 'I prefer homemade food because it is healthier and tastes much better.',
            urdu: 'مجھے گھر کا کھانا زیادہ پسند ہے کیونکہ یہ صحت بخش اور زیادہ مزیدار ہوتا ہے۔',
          ),
          QuickReplySuggestion(
            english: 'On weekends, I love going out to restaurants with my friends.',
            urdu: 'ویک اینڈ پر مجھے اپنے دوستوں کے ساتھ باہر ریسٹورنٹ جانا بہت پسند ہے۔',
          ),
        ],
      ),

      // Study / University / School / Exam / Student / College / Book
      _CandidateResponse(
        keywords: [
          'study',
          'studying',
          'studied',
          'student',
          'university',
          'college',
          'school',
          'exam',
          'class',
          'degree',
          'graduate',
          'book',
          'reading',
          'read'
        ],
        replyEnglish:
            'Focusing on $keyPhrase is a great investment in your future! Which subject or topic do you enjoy studying the most, and why?',
        replyUrdu:
            'تعلیم اور مطالعے پر توجہ دینا آپ کے مستقبل کے لیے بہترین ہے! آپ کو کون سا مضمون یا موضوع پڑھنا سب سے زیادہ پسند ہے اور کیوں؟',
        suggestions: const [
          QuickReplySuggestion(
            english: 'I really enjoy computer science and technology because it is practical.',
            urdu: 'مجھے کمپیوٹر سائنس اور ٹیکنالوجی بہت پسند ہے کیونکہ یہ عملی میدان ہے۔',
          ),
          QuickReplySuggestion(
            english: 'I like reading about history, business, and self-improvement.',
            urdu: 'مجھے تاریخ، کاروبار اور خود کو بہتر بنانے کے بارے میں پڑھنا پسند ہے۔',
          ),
        ],
      ),

      // Sports / Cricket / Gym / Walk / Exercise / Game / Movie
      _CandidateResponse(
        keywords: [
          'cricket',
          'football',
          'sport',
          'game',
          'play',
          'playing',
          'played',
          'gym',
          'walk',
          'exercise',
          'workout',
          'movie',
          'watch',
          'watched',
          'music'
        ],
        replyEnglish:
            'It is awesome that you make time for $keyPhrase! How often do you do that during the week, and who joins you?',
        replyUrdu:
            'یہ بہت اچھی بات ہے کہ آپ اس مشغلے کے لیے وقت نکالتے ہیں! آپ ہفتے میں کتنی بار یہ کرتے ہیں اور آپ کے ساتھ کون ہوتا ہے؟',
        suggestions: const [
          QuickReplySuggestion(
            english: 'I usually do it every weekend with my close friends.',
            urdu: 'میں عام طور پر ہر ویک اینڈ پر اپنے قریبی دوستوں کے ساتھ یہ کرتا ہوں۔',
          ),
          QuickReplySuggestion(
            english: 'I try to make time for it for at least thirty minutes every evening.',
            urdu: 'میں ہر شام کم از کم تیس منٹ اس کے لیے نکالنے کی کوشش کرتا ہوں۔',
          ),
        ],
      ),

      // Family / Friends / Home / Parents / Kids
      _CandidateResponse(
        keywords: [
          'family',
          'friend',
          'friends',
          'mother',
          'father',
          'brother',
          'sister',
          'parents',
          'wife',
          'husband',
          'children',
          'kids',
          'home',
          'house'
        ],
        replyEnglish:
            'Spending quality time with $keyPhrase is so important! What do you and your family or friends usually like talking about or doing together?',
        replyUrdu:
            'اپنے پیاروں کے ساتھ اچھا وقت گزارنا بہت اہم ہے! آپ اپنے خاندان یا دوستوں کے ساتھ مل کر عام طور پر کیا کرنا یا کس موضوع پر بات کرنا پسند کرتے ہیں؟',
        suggestions: const [
          QuickReplySuggestion(
            english: 'We love having evening tea together and sharing stories about our day.',
            urdu: 'ہمیں شام کی چائے اکٹھے پینا اور اپنے دن کی باتیں شیئر کرنا پسند ہے۔',
          ),
          QuickReplySuggestion(
            english: 'We often plan weekend dinners or go to the park together.',
            urdu: 'ہم اکثر ویک اینڈ ڈنر کا پروگرام بناتے ہیں یا اکٹھے پارک جاتے ہیں۔',
          ),
        ],
      ),

      // Cities / Travel / Countries / Airport / Flight / Trip
      _CandidateResponse(
        keywords: [
          'lahore',
          'karachi',
          'islamabad',
          'rawalpindi',
          'peshawar',
          'multan',
          'faisalabad',
          'pakistan',
          'london',
          'dubai',
          'uk',
          'usa',
          'canada',
          'travel',
          'trip',
          'flight',
          'airport',
          'passport',
          'visit',
          'city',
          'country'
        ],
        replyEnglish:
            'You mentioned $keyPhrase — that sounds fascinating! What do you like most about that place, or where are you planning to travel next?',
        replyUrdu:
            'آپ نے جس جگہ یا سفر کا ذکر کیا وہ بہت دلچسپ ہے! آپ کو اس جگہ کی کون سی بات سب سے زیادہ پسند ہے، یا آپ اگلا سفر کہاں کرنے کا ارادہ رکھتے ہیں؟',
        suggestions: const [
          QuickReplySuggestion(
            english: 'I love the food, lively culture, and friendly people there.',
            urdu: 'مجھے وہاں کے کھانے،زندہ دل ثقافت اور ملنسار لوگ بہت پسند ہیں۔',
          ),
          QuickReplySuggestion(
            english: 'Next, I am planning a trip to the northern areas in the summer.',
            urdu: 'اس کے بعد میں گرمیوں میں شمالی علاقہ جات کی سیر کا ارادہ رکھتا ہوں۔',
          ),
        ],
      ),

      // Greeting / Feeling / Day Status
      _CandidateResponse(
        keywords: [
          'good',
          'great',
          'fine',
          'well',
          'happy',
          'tired',
          'busy',
          'relaxed',
          'morning',
          'evening',
          'hello',
          'hi',
          'salam',
          'assalam'
        ],
        replyEnglish:
            'Glad to hear from you! Since you said "$rawText", tell me what is the main thing you are focusing on today or this week?',
        replyUrdu:
            'آپ کی بات سن کر خوشی ہوئی! مجھے بتائیے کہ آج یا اس ہفتے آپ کی سب سے زیادہ توجہ کس کام پر ہے؟',
        suggestions: const [
          QuickReplySuggestion(
            english: 'This week I am focusing on finishing my work tasks and practicing English daily.',
            urdu: 'اس ہفتے میری توجہ اپنے دفتری کام مکمل کرنے اور روزانہ انگریزی کی مشق کرنے پر ہے۔',
          ),
          QuickReplySuggestion(
            english: 'Today I am taking things easy and organizing my schedule for tomorrow.',
            urdu: 'آج میں آرام سے کام کر رہا ہوں اور کل کے لیے اپنا شیڈول ترتیب دے رہا ہوں۔',
          ),
        ],
      ),
    ];
  }

  String _extractUserKeySubject(String userText) {
    final cleaned = userText
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim();
    if (cleaned.isEmpty) return 'that topic';

    final stopWords = <String>{
      'i',
      'am',
      'is',
      'are',
      'was',
      'were',
      'have',
      'has',
      'had',
      'do',
      'does',
      'did',
      'will',
      'would',
      'can',
      'could',
      'should',
      'a',
      'an',
      'the',
      'to',
      'in',
      'on',
      'at',
      'for',
      'with',
      'about',
      'of',
      'and',
      'or',
      'but',
      'so',
      'very',
      'really',
      'today',
      'yesterday',
      'tomorrow',
      'now',
      'just',
      'my',
      'your',
      'our',
      'their',
      'me',
      'you',
      'we',
      'they',
      'he',
      'she',
      'it',
      'this',
      'that',
      'want',
      'like',
      'love',
      'going',
      'went',
      'yes',
      'no',
      'please',
      'thank',
      'thanks',
    };

    final words = cleaned
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2 && !stopWords.contains(w.toLowerCase()))
        .toList();

    if (words.isEmpty) {
      return cleaned.split(RegExp(r'\s+')).take(3).join(' ');
    }
    if (words.length == 1) {
      return words.first.toLowerCase();
    }
    return words.take(3).join(' ').toLowerCase();
  }

  AiCoachReply _buildReflectiveFollowUp({
    required String userText,
    required String keyPhrase,
    required String topic,
    required String? grammarCorrection,
  }) {
    final templates = <AiCoachReply>[
      AiCoachReply(
        replyEnglish:
            'You mentioned "$keyPhrase" — that is really interesting! Can you tell me a bit more about why "$keyPhrase" is important to you?',
        replyUrdu:
            'آپ نے "$keyPhrase" کا ذکر کیا جو بہت دلچسپ ہے! کیا آپ مجھے مزید بتا سکتے ہیں کہ یہ آپ کے لیے کیوں اہم ہے؟',
        grammarCorrection: grammarCorrection,
        suggestions: [
          QuickReplySuggestion(
            english: 'It is important to me because it helps me grow and learn new things.',
            urdu: 'یہ میرے لیے اس لیے اہم ہے کیونکہ اس سے مجھے آگے بڑھنے اور نئی چیزیں سیکھنے میں مدد ملتی ہے۔',
          ),
          QuickReplySuggestion(
            english: 'Actually, I started getting interested in $keyPhrase recently.',
            urdu: 'دراصل، مجھے حال ہی میں اس میں دلچسپی پیدا ہوئی ہے۔',
          ),
        ],
      ),
      AiCoachReply(
        replyEnglish:
            'I liked how you expressed "$userText"! What happened after that, or what do you plan to do next regarding $keyPhrase?',
        replyUrdu:
            'آپ نے بہت اچھے انداز میں اپنی بات کہی! اس کے بعد کیا ہوا، یا اس حوالے سے آپ کا اگلا ارادہ کیا ہے؟',
        grammarCorrection: grammarCorrection,
        suggestions: [
          QuickReplySuggestion(
            english: 'Next, I plan to spend more time improving my skills in this area.',
            urdu: 'اس کے بعد میرا ارادہ ہے کہ میں اس شعبے میں اپنی مہارت بڑھانے پر مزید وقت لگاؤں۔',
          ),
          const QuickReplySuggestion(
            english: 'After that, everything went smoothly and I felt very confident.',
            urdu: 'اس کے بعد سب کچھ بہت اچھا رہا اور مجھے کافی خود اعتمادی محسوس ہوئی۔',
          ),
        ],
      ),
      AiCoachReply(
        replyEnglish:
            'That is a great point about $keyPhrase! If a friend asked for your advice on $keyPhrase, what would you tell them?',
        replyUrdu:
            'آپ نے "$keyPhrase" کے بارے میں بہت اچھی بات کہی! اگر کوئی دوست آپ سے اس بارے میں مشورہ مانگے تو آپ اسے کیا کہیں گے؟',
        grammarCorrection: grammarCorrection,
        suggestions: [
          QuickReplySuggestion(
            english: 'I would advise them to stay consistent and practice every single day.',
            urdu: 'میں انہیں مشورہ دوں گا کہ مستقل مزاج رہیں اور ہر روز مشق کریں۔',
          ),
          const QuickReplySuggestion(
            english: 'I would tell them to start step by step and never give up.',
            urdu: 'میں ان سے کہوں گا کہ قدم بہ قدم شروعات کریں اور کبھی ہمت نہ ہاریں۔',
          ),
        ],
      ),
      AiCoachReply(
        replyEnglish:
            'Thanks for sharing that about $keyPhrase! How did that experience make you feel, and what did you learn from it?',
        replyUrdu:
            'یہ بات شیئر کرنے کا شکریہ! اس تجربے سے آپ کو کیسا محسوس ہوا اور آپ نے اس سے کیا سیکھا؟',
        grammarCorrection: grammarCorrection,
        suggestions: const [
          QuickReplySuggestion(
            english: 'It made me feel really happy and taught me the value of patience.',
            urdu: 'اس سے مجھے بہت خوشی ہوئی اور مجھے صبر کی اہمیت کا احساس ہوا۔',
          ),
          QuickReplySuggestion(
            english: 'I learned that good preparation always leads to better results.',
            urdu: 'میں نے سیکھا کہ اچھی تیاری ہمیشہ بہتر نتائج دیتی ہے۔',
          ),
        ],
      ),
    ];

    for (final t in templates) {
      if (!_askedReplies.contains(t.replyEnglish)) {
        return t;
      }
    }

    // Guaranteed unique fallback incorporating exact user input
    return AiCoachReply(
      replyEnglish:
          'You said "$userText" — great English practice! Could you give me one specific example of $keyPhrase from your own life?',
      replyUrdu:
          'بہت اچھی مشق! کیا آپ اپنی زندگی سے اس کی کوئی ایک خاص مثال انگریزی میں دے سکتے ہیں؟',
      grammarCorrection: grammarCorrection,
      suggestions: [
        QuickReplySuggestion(
          english: 'For example, last week I experienced $keyPhrase firsthand.',
          urdu: 'مثال کے طور پر، پچھلے ہفتے میں نے خود اس کا تجربہ کیا۔',
        ),
      ],
    );
  }
}
