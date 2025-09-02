import 'package:flutter/foundation.dart';

class DuasRepository {
  DuasRepository._();
  static final DuasRepository instance = DuasRepository._();

  /// Converts Arabic text to Indo-Pakistani font style
  /// Automatically converts Western numerals to Eastern Arabic numerals
  /// and ensures proper formatting for Quran-style text
  static String convertToIndoPakFont(String arabicText) {
    if (arabicText.isEmpty) return arabicText;
    
    String converted = arabicText;
    
    // Convert Western numerals to Eastern Arabic numerals
    converted = converted.replaceAll('0', '٠');
    converted = converted.replaceAll('1', '١');
    converted = converted.replaceAll('2', '٢');
    converted = converted.replaceAll('3', '٣');
    converted = converted.replaceAll('4', '٤');
    converted = converted.replaceAll('5', '٥');
    converted = converted.replaceAll('6', '٦');
    converted = converted.replaceAll('7', '٧');
    converted = converted.replaceAll('8', '٨');
    converted = converted.replaceAll('9', '٩');
    
    // Ensure proper spacing around verse numbers in brackets
    converted = converted.replaceAll('﴿', ' ﴿');
    converted = converted.replaceAll('﴾', '﴾ ');
    
    // Clean up any double spaces
    converted = converted.replaceAll('  ', ' ');
    
    return converted.trim();
  }

  /// Helper method to add a new dua with automatic Indo-Pakistani font conversion
  void addDuaToCategoryWithFormatting(String categoryName, Map<String, dynamic> dua) {
    // Convert Arabic text to Indo-Pakistani font if it exists
    if (dua['arabic'] != null && dua['arabic'] is String) {
      dua['arabic'] = convertToIndoPakFont(dua['arabic'] as String);
    }
    
    // Add the formatted dua to the category
    addDuaToCategory(categoryName, dua);
  }

  /// Test method to verify Indo-Pakistani font conversion
  static void testIndoPakFontConversion() {
    print('Testing Indo-Pakistani font conversion...');
    
    // Test Western numerals conversion
    String test1 = convertToIndoPakFont('بِسْمِ اللَّهِ 1:1');
    print('Test 1: بِسْمِ اللَّهِ 1:1 → $test1');
    
    // Test verse numbers in brackets
    String test2 = convertToIndoPakFont('الْحَمْدُ لِلَّهِ ﴿1﴾');
    print('Test 2: الْحَمْدُ لِلَّهِ ﴿1﴾ → $test2');
    
    // Test multiple numerals
    String test3 = convertToIndoPakFont('آية 255 من سورة البقرة');
    print('Test 3: آية 255 من سورة البقرة → $test3');
    
    print('Font conversion test completed!');
  }

  // Source of truth: categories with duas
  final List<Map<String, dynamic>> _categories = [
    {
      "id": 1,
      "name": "Morning Adhkar",
      "description": "Supplications to recite after Fajr prayer",
      "duas": [
        {
          "id": 1,
          "title": "Surah Al-Fatihah",
          "arabic": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿١﴾ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ﴿٢﴾ الرَّحْمَٰنِ الرَّحِيمِ ﴿٣﴾ مَالِكِ يَوْمِ الدِّينِ ﴿٤﴾ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ﴿٥﴾ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ﴿٦﴾ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ ﴿٧﴾",
          "transliteration": "Bismillāhir-raḥmānir-raḥīm. Al-ḥamdu lillāhi rabbil-ʿālamīn. Ar-raḥmānir-raḥīm. Māliki yawmid-dīn. Iyyāka naʿbudu wa iyyāka nastaʿīn. Ihdinaṣ-ṣirāṭal-mustaqīm. Ṣirāṭallaḏīna anʿamta ʿalaihim ghayril-maghḍūbi ʿalaihim wa laḍ-ḍāllīn.",
          "translation": "In the name of Allah, the Entirely Merciful, the Especially Merciful. [All] praise is [due] to Allah, Lord of the worlds. The Entirely Merciful, the Especially Merciful. Sovereign of the Day of Recompense. It is You we worship and You we ask for help. Guide us to the straight path. The path of those upon whom You have bestowed favour, not of those who have evoked [Your] anger or of those who are astray.",
          "reference": "Al-Fatihah 1:1-7 | Sahih Muslim 395",
          "benefits": "Greatest Surah of the Qur'an; essential part of every Salah; cure and protection.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 2,
          "title": "Al-Baqarah 2:1-5",
          "arabic": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿ ﴾ \n الم ﴿١﴾ ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ ﴿٢﴾ الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ ﴿٣﴾ وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ ﴿٤﴾ أُو۟لَٰٓئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ ۖ وَأُو۟لَٰٓئِكَ هُمُ ٱلْمُفْلِحُونَ ﴿٥﴾",
          "transliteration": "Bismillāhir-raḥmānir-raḥīm. 2:1 Alif Lām Mīm. 2:2 Dhālika al-kitābu lā rayba fīh, hudan lil-muttaqīn. 2:3 Alladhīna yu'minūna bil-ghaybi wa yuqīmūnaṣ-ṣalāta wa mimmā razaqnāhum yunfiqūn. 2:4 Wa alladhīna yu'minūna bimā unzila ilayka wa mā unzila min qablika wa bil-ākhirati hum yūqinūn. 2:5 Ūlāʾika ʿalā hudan min rabbihim wa ūlāʾika humu al-muf'liḥūn.",
          "translation": "In the name of Allah, the Entirely Merciful, the Especially Merciful. 2:1 Alif-Lam-Mim. 2:2 This is the Book about which there is no doubt, a guidance for those conscious of Allah. 2:3 Who believe in the unseen, establish prayer, and spend out of what We have provided for them. 2:4 And who believe in what has been revealed to you, [O Muhammad], and what was revealed before you, and of the Hereafter they are certain [in faith]. 2:5 It is they who are upon guidance from their Lord, and it is they who will be successful.",
          "reference": "Al-Baqarah 2:1-5 | Sahih International | Ad-Darimi",
          "benefits": "Protection from Shayṭān at night; safety for one's family; beneficial for ruqyah and guarding an empty home.",
          "times": 1,
          "category": "Morning Adhkar"
        },


        {
          "id": 3,
          "title": "Ayat al-Kursi",
          "arabic": "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ",
          "transliteration": "Allāhu lā ilāha illā huwa al-ḥayyu al-qayyūm, lā ta'khudhuhu sinatun wa lā nawm, lahu mā fī as-samāwāti wa mā fī al-arḍ, man dhā alladhī yashfaʿu ʿindahu illā bi-idhnihi, yaʿlamu mā bayna aydīhim wa mā khalfahum, wa lā yuḥīṭūna bishay'in min ʿilmihi illā bimā shā'a, wasiʿa kursiyyuhu as-samāwāti wa al-arḍ, wa lā ya'ūduhu ḥifẓuhumā, wa huwa al-ʿaliyyu al-ʿaẓīm.",
          "translation": "Allah! There is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is [presently] before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.",
          "reference": "Al-Baqarah 2:255",
          "benefits": "Greatest verse in the Qur'an; protection from Shayṭān when recited before sleeping; protection and blessing throughout the day.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 4,
          "title": "Al-Baqarah 2:256",
          "arabic": "لَا إِكْرَاهَ فِي الدِّينِ ۖ قَد تَّبَيَّنَ الرُّشْدُ مِنَ الْغَيِّ ۗ فَمَن يَكْفُرْ بِالطَّاغُوتِ وَيُؤْمِن بِاللَّهِ فَقَدِ اسْتَمْسَكَ بِالْعُرْوَةِ الْوُثْقَىٰ لَا انفِصَامَ لَهَا ۗ وَاللَّهُ سَمِيعٌ عَلِيمٌ",
          "transliteration": "2:256 Lā ikrāha fī ad-dīn; qad tabayyana ar-rushdu mina al-ghayy; fa-man yakfur biṭ-ṭāghūti wa yu'min billāhi faqad is'tamsaka bil-ʿurwati al-wuth'qā lan fiṣāma lahā; wallāhu samīʿun ʿalīm.",
          "translation": "There shall be no compulsion in [acceptance of] the religion. The right course has become clear from the wrong. So whoever disbelieves in Taghut and believes in Allah has grasped the most trustworthy handhold with no break in it. And Allah is Hearing and Knowing.",
          "reference": "Al-Baqarah 2:256 | Sahih International | Ad-Darimi",
          "benefits": "Protection from Shayṭān at night; safety for one's family; beneficial for ruqyah and guarding an empty home.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 5,
          "title": "Al-Baqarah 2:257",
          "arabic": "اللَّهُ وَلِيُّ الَّذِينَ آمَنُوا۟ يُخْرِجُهُم مِّنَ ٱلظُّلُمَـٰتِ إِلَى ٱلنُّورِ ۖ وَٱلَّذِينَ كَفَرُوٓا۟ أَوْلِيَآؤُهُمُ ٱلطَّـٰغُوتُ يُخْرِجُونَهُم مِّنَ ٱلنُّورِ إِلَى ٱلظُّلُمَـٰتِ ۗ أُو۟لَـٰٓئِكَ أَصْحَـٰبُ ٱلنَّارِ ۖ هُمْ فِيهَا خَـٰلِدُونَ",
          "transliteration": "2:257 Allaahu waliyyul lazeena aa'manoo yukh'rijuhum minaz-zulumaati ilan noor; wal'lazee na-kafaroo awliyaa uo'humut taa'ghootu yukh'rijoo-nahum minan noori ilaz-zulumaat; ulaa'ika as'haabun naari hum fee'haa khaa'lidoon.",
          "translation": "Allah is the ally of those who believe. He brings them out from darknesses into the light. And those who disbelieve – their allies are Taghut. They take them out of the light into darknesses. Those are the companions of the Fire; they will abide eternally therein.",
          "reference": "Al-Baqarah 2:257 | Sahih International | Ad-Darimi",
          "benefits": "Protection from Shayṭān; safety for one's family; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 6,
          "title": "Al-Baqarah 2:284",
          "arabic": "لِلَّهِ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ وَإِن تُبْدُوا مَا فِي أَنفُسِكُمْ أَوْ تُخْفُوهُ يُحَاسِبْكُم بِهِ اللَّهُ ۖ فَيَغْفِرُ لِمَن يَشَاءُ وَيُعَذِّبُ مَن يَشَاءُ ۗ وَاللَّهُ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ ﴿٢٨٤﴾",
          "transliteration": "2:284 Lillaahi maa fis-samaawaati wa-maa fil ard; Wa in'tubdoo maa feee an'fusikum aw tukh-foohu yuhaa-sibkum bihil-laa; Fayagh'firuli maiya-shaa'u wa yu'azzibu maiya-shaa; Wallaahu aa'laa kulli shai in qadeer.",
          "translation": "To Allah belongs whatever is in the heavens and whatever is in the earth. Whether you show what is within yourselves or conceal it, Allah will bring you to account for it. Then He will forgive whom He wills and punish whom He wills, and Allah is over all things competent.",
          "reference": "Al-Baqarah 2:284 | Sahih International | Ad-Darimi",
          "benefits": "Protection from Shayṭān; safety for one's family; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 7,
          "title": "Al-Baqarah 2:285",
          "arabic": "آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ ۗ كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ ۗ وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ ﴿٢٨٥﴾",
          "transliteration": "2:285 Aa'manar-rasoolu bimaa un'zila ilaihi mir-Rabbihee walmu'minoon; Kul'lun aa'mana billaahi wa malaa'ikathihee wa kutubhihee wa rusulihee, Laa nufar'riqu baina ahadim-mir-rusulih; Wa qaaloo sami'naa wa aata'naa; Ghufra-naka rabbana wa ilaikal maser.",
          "translation": "The Messenger has believed in what was revealed to him from his Lord, and [so have] the believers. All of them have believed in Allah and His angels and His books and His messengers, [saying], We make no distinction between any of His messengers. And they say, We hear and we obey. [We seek] Your forgiveness, our Lord, and to You is the [final] destination.",
          "reference": "Al-Baqarah 2:285 | Sahih International | Al Bukhari 4723 | Sahih Muslim 807",
          "benefits": "Reciting the last two verses of Al-Baqarah (v285 and v286) at night suffices for protection and blessings; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 8,
          "title": "Al-Baqarah 2:286",
          "arabic": "لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ ۗ رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا ۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ أَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ ﴿٢٨٦﴾",
          "transliteration": "2:286 Laa yukalliful-laahu nafsan illaa wus'ahaa; Lahaa maa kasabat wa aa'laihaa mak-tasabat; Rabbana laa tu'aakhiznaa in'naa-seenaa aw-akhtaa'naa; Rabbana wa laa tahmil-alainaa isran kamaa hamaltahoo alal-lazeena min qablinaa; Rabbana wa laa tuham-milnaa maa laa taa'qata lanaa bih; Wa'fu annaa waghfir lanaa war'hamnaa; Anta mawlana fansur-naa alal qawmil kaafireen.",
          "translation": "Allah does not charge a soul except [with that within] its capacity. It will have [the consequence of] what [good] it has gained, and it will bear [the consequence of] what [evil] it has earned. Our Lord, do not impose blame upon us if we have forgotten or erred. Our Lord, and lay not upon us a burden like that which You laid upon those before us. Our Lord, and burden us not with that which we have no ability to bear. And pardon us; and forgive us; and have mercy upon us. You are our protector, so give us victory over the disbelieving people.",
          "reference": "Al-Baqarah 2:286 | Sahih International | Al Bukhari 4723 | Sahih Muslim 807",
          "benefits": "Reciting the last two verses of Al-Baqarah (v285 and v286) at night suffices for protection and blessings; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 9,
          "title": "Surah Al-Ikhlas",
          "arabic": "قُلْ هُوَ اللَّهُ أَحَدٌ ﴿١﴾ اللَّهُ الصَّمَدُ ﴿٢﴾ لَمْ يَلِدْ وَلَمْ يُولَدْ ﴿٣﴾ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ ﴿٤﴾",
          "transliteration": "112:1 Qul hu'wallaa-hu ahad.\n112:2 Allah hus-samad.\n112:3 Lam yalid wa-lam yoou'lad.\n112:4 Wa lam'ya kul-lahu kufu'wan ahad.",
          "translation": "112:1 Say, He is Allah, [who is] One.\n112:2 Allah, the Eternal Refuge.\n112:3 He neither begets nor is born.\n112:4 Nor is there to Him any equivalent.",
          "reference": "Al-Ikhlas | Abu Dawood 2/86 | An Nasai 3/68 | Al Albani | Sahih Timithi 2/8 | Sahih International",
          "benefits": "Protection from Shayṭān; safety for one's family; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home.",
          "times": 3,
          "category": "Morning Adhkar"
        },

        {
          "id": 10,
          "title": "Surah Al-Falaq",
          "arabic": "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ﴿١﴾ مِن شَرِّ مَا خَلَقَ ﴿٢﴾ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ﴿٣﴾ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ﴿٤﴾ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ ﴿٥﴾",
          "transliteration": "113:1 Qul a'uzoo-bi rabbil-falaq.\n113:2 Min sharri ma khalaq.\n113:3 Wa min sharri gha'siqin iza waqab.\n113:4 Wa min shar'rin naf'faa saati'fil uqad.\n113:5 Wa min shar'ri haa'sidin iza hasad.",
          "translation": "113:1 Say, I seek refuge in the Lord of daybreak.\n113:2 From the evil of that which He created.\n113:3 And from the evil of darkness when it settles.\n113:4 And from the evil of the blowers in knots.\n113:5 And from the evil of an envier when he envies.",
          "reference": "Al-Falaq | Abu Dawood 2/86 | An Nasai 3/68 | Al Albani | Sahih Timithi 2/8 | Sahih International",
          "benefits": "Protection from evil and envy; safety for one's family; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home. Recommended to recite 3 times at dawn and dusk.",
          "times": 3,
          "category": "Morning Adhkar"
        },

        {
          "id": 11,
          "title": "Surah Al-Nās",
          "arabic": "قُلْ أَعُوذُ بِرَبِّ النَّاسِ ﴿١﴾ مَلِكِ النَّاسِ ﴿٢﴾ إِلَٰهِ النَّاسِ ﴿٣﴾ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ﴿٤﴾ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ﴿٥﴾ مِنَ الْجِنَّةِ وَالنَّاسِ ﴿٦﴾",
          "transliteration": "114:1 Qul a'uzu-bi rab'binn naas.\n114:2 Malik'inn naas.\n114:3 Ilaa hin'naas.\n114:4 Min shar'ril waas-wa-asil khan'naas.\n114:5 Al lazee yu'was wi'su fee sudoo-rin naas.\n114:6 Minal jin'nati wan naas.",
          "translation": "114:1 Say, I seek refuge in the Lord of mankind.\n114:2 He is the Sovereign of mankind.\n114:3 The God of mankind.\n114:4 From the evil of the retreating whisperer.\n114:5 Who whispers [evil] into the breasts of mankind.\n114:6 From among the jinn and mankind.",
          "reference": "Al-Nās | Abu Dawood 2/86 | An Nasai 3/68 | Al Albani | Sahih Timithi 2/8 | Sahih International",
          "benefits": "Protection from evil whispers and envy; safety for one's family; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home. Recommended to recite 3 times at dawn and dusk.",
          "times": 3,
          "category": "Morning Adhkar"
        },

        {
          "id": 12,
          "title": "Morning & Evening Dua",
          "arabic": "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ ، لَا إِلٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيْكَ لَهُ ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيْرٌ ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِيْ هٰذَا الْيَوْمِ وَخَيْرَ مَا بَعْدَهُ ، وَأَعُوْذُ بِكَ مِنْ شَرِّ مَا فِيْهِ وَشَرِّ مَا بَعْدَهُ ، رَبِّ أَعُوْذُ بِكَ مِنَ الْكَسَلِ وَسُوْءِ الْكِبَرِ ، رَبِّ أَعُوْذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ.",
          "transliteration": "Asbahna wa-asbahal mulku lillah;\nWal-hamdu lillah;\nLa ilaha illal-lah;\nWah-da'hoo la-sharee kalah;\nLahul-mulku wa'lahul-hamd;\nYuh-ee wa yu'meeto wa'huwa ala kulli shayin qadeer;\nRabbi ass-aaluka khay'ra mafee haa-zaal yaw'm;\nWa-khayra ma ba'daha;\nWa- aa'ozu-bika min sharri ma fee haa-zaal yaw'm;\nWa sharri ma ba'daha;\nRabbi aa'ozu-bika minal-kasali, wa-soo-il kibar;\nRabbi aa'ozubika min aa'zaa-bin fin'nari wa aa'zaa-bin fil'qabr.",
          "translation": "We have reached the morning and at this very time unto Allah belongs all sovereignty, and all praise is for Allah.\nNone has the right to be worshiped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.\nMy Lord, I ask You for the good of this day and the good of what follows it and I take refuge in You from the evil of this day and the evil of what follows it.\nMy Lord, I take refuge in You from laziness and senility.\nMy Lord, I take refuge in You from torment in the Fire and punishment in the grave.",
          "reference": "Sahih Muslim 4/2088 and 2723 | At-Trimidhi 3390 | Sahih Muslim 2723 | At-Trimidhi 2699",
          "benefits": "Reciting this dua morning and evening brings protection from evil, laziness, senility, torment in the grave, and the Fire. Recommended anytime or during Tashahhud.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 13,
          "title": "Subhan Allah wa bihamdihi",
          "arabic": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ",
          "transliteration": "Subhan Allah wa bihamdihi, subhan Allah al-azeem",
          "translation": "Glory is to Allah and praise is to Him, glory is to Allah the Magnificent.",
          "reference": "Bukhari & Muslim",
          "benefits": "Forgiveness of sins",
          "times": 100,
          "category": "Morning Adhkar",
        },

        {
          "id": 14,
          "title": "Allahumma bika asbahna",
          "arabic": "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ.",
          "transliteration": "Allahumma bika asbahna; Wa'bika amsaina; Wa'bika nahya; Wa'bika namooth; Wa'ilay'kaal nushoor.",
          "translation": "O Allah, by Your leave we have reached the morning and by Your leave we have reached the evening, by Your leave we live and die and unto You is our return.",
          "reference": "Abu Dawood 5068 | At-Tirmidhi 3391 | Ibn Majah 3868 | An-Nisai 10323",
          "benefits": "Abu Hurairah (RA) said: The Messenger ﷺ taught his companions to recite this Dua in the morning and evening. It is also recommended for Tashahhud and can be recited at any time.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 15,
          "title": "Allahumma ma asbahah bee'min",
          "arabic": "اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.",
          "transliteration": "Allahumma ma asbahah bee'min nia'mah; Aw'bee a'haa-deem min khal'qik; Fa'minka wah-dhaka la-sharee kalak; Fa-lakal hamdu wa-lakash shukr.",
          "translation": "O Allah, what blessing I or any of Your creation have risen upon, is from You alone, without partner, so for You is all praise and unto You all thanks.",
          "reference": "Abu Dawood 4/324",
          "benefits": "The Prophet ﷺ said: \"Whoever recites this in the morning has indeed offered his day's thanks and whoever says this in the evening has indeed offered his night's thanks\". Allah says in the Quran (14:7): \"Indeed if you are grateful and give thanks, surely, definitely I will increase you; but if you are ungrateful, then know that my punishment is indeed most severe\".",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 16,
          "title": "Asbaḥtu uthnī ʿalayka",
          "arabic": "أَصْبَحْتُ أُثْنِي عَلَيْكَ حَمْدًا، وَأَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللَّهُ",
          "transliteration": "Asbaḥtu uthnī ʿalayka ḥamdan, wa ashhadu an lā ilāha illallāh",
          "translation": "I have entered the morning praising You with all praise, and I bear witness that there is no god but Allah.",
          "reference": "Sunan Abī Dāwūd (no. 5078) | graded ḥasan by Imām al-Albānī | Hisn al-Muslim",
          "benefits": "Abu Hurairah رضي الله عنه narrated that the Prophet ﷺ said: When one reaches the morning, he should say this three times. If he reaches the evening, he should say the same. Narrated by Nasaa`i in al-Kubraa (10406) and in 'Amal ul-Yawmi wal-Laylah (571). Classed as Hasan by Muqbil ibn Hadi al-Waadi'i.",
          "times": 3,
          "category": "Morning Adhkar"
        },

        {
          "id": 17,
          "title": "Radeetu billahi Rabbah",
          "arabic": "رَضِيتُ باللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِيناً، وَبِمُحَمَّدٍ صَلَى اللَّهُ عَلِيهِ وَسَلَّمَ نَبِيَّاً",
          "transliteration": "Radeetu billahi Rabbah; Wa'bil-islami dee'nah; Wa'bee Muhammadin sal-lallahu alai'hi wa'sallama nabiy'ya wa rasulaah.",
          "translation": "I have accepted Allah as my Lord; and Islam as my way of life; and Muhammad ﷺ as Allah's Prophet and the Messenger.",
          "reference": "Abu Dawood 4/318 | Imam Ahmed 18967 | An-Nasai",
          "benefits": "Prophet ﷺ said: Anyone who recites this Dua in the morning and evening will have it incumbent upon Allah to make him content on the Day of Resurrection.",
          "times": 3,
          "category": "Morning Adhkar"
        },

        {
          "id": 18,
          "title": "Allahumma innee as-aalukal aaf'wa",
          "arabic": "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي، وَدُنْيَايَ، وَأَهْلِي، وَمَالِي، اللَّهُمَّ اسْتُرْ عَوْرَاتِي، وَآمِنْ رَوْعَاتِي، اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِيَ.",
          "transliteration": "Allahumma innee as-aalukal aaf'wa wal-aa'fiyah; Fid-dunya wal-akhirah; Allahumma innee as'alukal aa'fwa wal-aa'fiyah; Fee dee'nee wa'dunya-ya; Wa'ahlee wama-lee; Allah hummas-tur aaw-ra'tee; Wa aa'mir raw-aa'tee; Wah fiz'nee min bai'nee ya-dai'yaa; Wa-min khal'fee; Wa'aai ya'mee-nee; Wa'aai shee'malee, Wa-min faw'qee; Wa'aa-oozubi aa'zaa-matika aan oogh-tala min tahtee.",
          "translation": "O Allah, I ask You for pardon and well-being in this life and the next. O Allah, I ask You for pardon and well-being in my religious and worldly affairs, and my family and my wealth. O Allah, veil my weaknesses and set at ease my dismay, and preserve me from the front and from behind and on my right and on my left and from above, and I take refuge with You lest I be swallowed up by the earth.",
          "reference": "Ibn Majah 2/323 | Abu Dawood 5074",
          "benefits": "The Messenger ﷺ never failed to recite this Dua in the morning and evening; provides comprehensive protection and well-being for oneself, family, and wealth.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 19,
          "title": "SubhanAllahi wa-bihamdih",
          "arabic": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ .",
          "transliteration": "SubhanAllahi wa-bihamdih; Aa'dada khal'qi; Wa'rida nafsih; Wa'zinata aa'rshih; Wa'midada kalimatih.",
          "translation": "How perfect Allah is; and I praise Him by the number of His creation and His pleasure, and by the weight of His throne, and the ink of His words.",
          "reference": "Sahih Muslim 4/2090 | Riyad-us-Saliheen 1433 | Sahih Muslim 2726",
          "benefits": "Highly meritorious and rewarding; full of Praise and Glorification of Allah; reciting it three times outweighs much other speech in reward.",
          "times": 3,
          "category": "Morning Adhkar"
        },
        
        {
          "id": 20,
          "title": "Bismillah hil'lazee la yadur'oo",
          "arabic": "بِسْمِ اللّٰهِ الَّذِيْ لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ ، وَهُوَ السَّمِيْعُ الْعَلِيْمُ.",
          "transliteration": "Bismillah hil'lazee la yadur'oo ma'aas-mihi shai-oon fil-ardi wa'laa fis-samaa; Wa'hu'waas samee'ool aa'leem.",
          "translation": "In the name of Allah with whose name nothing is harmed on earth nor in the heavens and He is The All-Seeing, The All-Knowing.",
          "reference": "Abu Dawood 4/323 | At-Trimithi 5/465 | Abu Dawood 5088",
          "benefits": "Reciting this Dua three times ensures nothing will harm the reciter; protection from sudden afflictions until morning or evening depending on recitation time.",
          "times": 3,
          "category": "Morning Adhkar"
        },

        {
          "id": 21,
          "title": "Allāhumma innī aʿūdhu bika",
          "arabic": "اَللّٰهُمَّ إِنِّيْ أَعُوْذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ ، وَأَعُوْذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ، وَأَعُوْذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ ، وَأَعُوْذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ وَقَهْرِ الرِّجَالِ.",
          "transliteration": "Allāhumma innī aʿūdhu bika min-l-hammi wa-l-ḥazan, wa aʿūdhu bika min-l-ʿajzi wa-l-kasal, wa aʿūdhu bika min-l-jubni wa-l-bukhl, wa aʿūdhu bika min ghalabati-d-dayni wa qahri-r-rijāl.",
          "translation": "O Allah, I seek Your protection from anxiety and grief. I seek Your protection from inability and laziness. I seek Your protection from cowardice and miserliness, and I seek Your protection from being overcome by debt and being overpowered by men.",
          "reference": "Sunan Abi Dawud 1555",
          "benefits": "Reciting this Dua in the morning and evening removes worries, settles debts, and provides protection from anxiety, grief, inability, laziness, cowardice, miserliness, and oppression by men.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 22,
          "title": "Aa'oozu-bi kalima-tillah",
          "arabic": "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
          "transliteration": "Aa'oozu-bi kalima-tillah heet-taam'mati min sharri ma khalaq.",
          "translation": "I seek protection in the perfect words of Allah from every evil that He has created.",
          "reference": "Imam Ahmed 2/290 | Sahih Muslim 2708, 2709",
          "benefits": "Reciting this Dua while stopping on a journey protects from harm; recitation in the evening protects from scorpion stings and other evils until the next movement.",
          "times": 3,
          "category": "Morning Adhkar"
        },
        
        {
          "id": 23,
          "title": "Allahumma aa'limal-ghaybi",
          "arabic": "اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّماوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءاً أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ",
          "transliteration": "Allahumma aa'limal-ghaybi wash-shahadah; Fati'ras samawati wal'ard; Rabba kulli shay'in wa'ma leekah; Ash'hadu al'laa ilaha illa anth; Aa'ozu-bika min shar'ri nafsee; Wa'min shar'rish shay'tani wa-shirki; Wa'an aq-tarifa ala nafsee soo'an aw aa'joor-rahoo ila Muslim.",
          "translation": "O Allah, knower of the unseen and the seen, creator of the heavens and the earth, Lord and sovereign of all things, I bear witness that none has the right to be worshipped except You. I take refuge in You from the evil of my soul and from the evil and shirk of the devil, and from committing wrong against my soul or bringing such upon another Muslim.",
          "reference": "At-Thirmidi 3/142 | Al-Da'waat 3392",
          "benefits": "Reciting this Dua in the morning, evening, and before sleeping offers protection from the evil of oneself and Shayṭān, and prevents committing harm to oneself or other Muslims.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 24,
          "title": "Ya Hayyu Ya Qayyum",
          "arabic": "يَاحَيُّ، يَا قَيُّومُ، بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.",
          "transliteration": "Ya hayyu ya qay'yum; Bi-rah'matika asta'gis; As'lih li sha'ni kullah; Wa'la takil'ni ila nafsi tarfata ayn.",
          "translation": "O Ever Living, O Self-Subsisting and Supporter of all, by Your mercy I seek assistance. Rectify for me all of my affairs and do not leave me to myself, even for the blink of an eye.",
          "reference": "Sahih Targhib wa Tarhib 1/273 | An-Nasai | Al-Mustadrak Al-Haakim V1 p.509 | Imaam Haakim | Imaam Dhahabi",
          "benefits": "Prophet ﷺ advised Fatima (RA) to recite this in the morning and evening. Anas ibn Malik (RA) reported this practice. Abdullah ibn Mas'ood (RA) narrated that whenever the Prophet ﷺ faced worry or concern, he recited this dua.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 25,
          "title": "Subḥāna-llāhi wa bi ḥamdih",
          "arabic": "سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ ، عَدَدَ خَلْقِهِ ، وَرِضَا نَفْسِهِ ، وَزِنَةَ عَرْشِهِ ، وَمِدَادَ كَلِمَاتِهِ",
          "transliteration": "Subḥāna-llāhi wa bi ḥamdih, ʿadada khalqih, wa riḍā nafsih, wa zinata ʿarshih, wa midāda kalimātih",
          "translation": "Allah is free from imperfection and all praise is due to Him, (in ways) as numerous as all He has created, (as vast) as His pleasure, (as limitless) as the weight of His Throne, and (as endless) as the ink of His words.",
          "reference": "Muslim 2140, Abū Dāwūd 1503",
          "benefits": "Reciting this Dua is highly meritorious and rewarding. The Prophet ﷺ stated that reciting it three times outweighs everything else said that day in the scales of reward.",
          "times": 3,
          "category": "Morning Adhkar"
        },
        
        {
          "id": 26,
          "title": "Sayyidul Istighfar",
          "arabic": "اللَّهُمَّ أَنْتَ رَبِّي لَّا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ.",
          "transliteration": "Allahumma anta rabbee la ilaha illa anta, khalaqtanee wa ana 'abduka, wa ana 'ala 'ahdika wa wa'dika mas'tata't, a'oodhu bika min sharri ma sana't, aboo'u laka bini'matika 'alayya, wa aboo'u bidhanbee, faghfir lee, fa-innahu la yaghfiru-dh-dhunooba illa ant.",
          "translation": "O Allah, You are my Lord, none has the right to be worshipped except You. You created me and I am Your servant, and I abide to Your covenant and promise as best I can. I seek refuge in You from the evil of what I have done. I acknowledge Your favour upon me and I acknowledge my sin, so forgive me, for verily none can forgive sins except You.",
          "reference": "Al-Bukhari 7/150 | Al-Da'waat 6306",
          "benefits": "The Prophet ﷺ said: Whoever says this Dua during the day with firm belief and dies before evening will be among the people of Paradise. Whoever says it at night with firm belief and dies before morning will be among the people of Paradise.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 27,
          "title": "Allahumma innee asbah'at",
          "arabic": "اللَّهُمَّ إِنِّي أَصْبَحْتُ أُشْهِدُكَ وَأُشْهِدُ حَمَلَةَ عَرْشِكَ، وَمَلَائِكَتَكَ وَجَمِيعَ خَلْقِكَ، أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيكَ لَكَ، وَأَنَّ مُحَمَّداً عَبْدُكَ وَرَسُولُكَ",
          "transliteration": "Allahumma innee asbah'at, osh'hiduka wa-oshhidu hamalata aar'shik, wa'malaa ikatak, wa-jamee'aa khalqik, ann'naka antal-lahu, la ilaha illa ant, wah'daka laa sharee kalak, wa'anna Muhammadan aabdu'ka wa'rasooluk.",
          "translation": "O Allah, verily I have reached the morning and call on You, the bearers of Your throne, Your angels, and all of Your creation to witness that You are Allah, none has the right to be worshipped except You, alone, without partner, and that Muhammad ﷺ is Your servant and Messenger.",
          "reference": "Abu Dawood 4/317 | Abu Dawood 41/505",
          "benefits": "The Prophet ﷺ said: Whoever recites this Dua in the morning or evening, Allah will free portions of them from Hell according to the number of times it is recited (once: a quarter, twice: half, thrice: three-fourths, four times: full emancipation).",
          "times": 4,
          "category": "Morning Adhkar"
        },

        {
          "id": 28,
          "title": "Allahumma aa'fi-nee fee bada'nee",
          "arabic": "اللَّهُمَّ عَافِـني فِي بَدَنِي، اللَّهُمَّ عَافِـنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إلاَّ أَنْتَ. اللَّهُمَّ إِنِّي أَعُوذُبِكَ مِنَ الْكُفْر، وَالفَقْرِ، وَأَعُوذُبِكَ مِنْ عَذَابِ الْقَبْرِ ، لَا إلَهَ إلاَّ أَنْتَ.",
          "transliteration": "Allahumma aa'fi-nee fee bada'nee; Allahumma aa'fi-nee fee sam'ee; Allahumma aa'fi-nee fee basa'ree; La ilaha illa-ant; Allahumma innee aa'oozu-bika minal-kufri wal-faqr; Wa'aa'oo-zu-bika min aa'zaa-bil-qabr; La ilaha illa-ant.",
          "translation": "O Allah, grant my body health, O Allah, grant my hearing health, O Allah, grant my sight health. None has the right to be worshipped except You, O Allah, I take refuge with You from disbelief and poverty, and I take refuge with You from the punishment of the grave. None has the right to be worshipped except You.",
          "reference": "Abu Dawood 4/324 | Abu Dawood 5049",
          "benefits": "Reciting this Dua thrice every morning and evening brings health for body, hearing, and sight, and protection from disbelief, poverty, and the punishment of the grave, as practiced by Abu Bakrah r.a following the Prophet ﷺ.",
          "times": 3,
          "category": "Morning Adhkar"
        },

        {
          "id": 29,
          "title": "Hasbiya Allah",
          "arabic": "حَسْبِيَ اللَّهُ لَآ إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ",
          "transliteration": "Hasbi-yallahu la ilaha illa huwa aa'layhi tawak-kalth; Wa'huwa rabbul aar'shil aa'zeem.",
          "translation": "Allah is sufficient for me, none has the right to be worshipped except Him, upon Him I rely and He is Lord of the exalted throne.",
          "reference": "Abu Dawood 4/321 | 5081",
          "benefits": "Reciting this Dua seven times in the morning and evening brings sufficiency and reliance upon Allah against all matters, as narrated by Abu'd-Darda r.a.",
          "times": 7,
          "category": "Morning Adhkar"
        },

        {
          "id": 30,
          "title": "Asbahna wa-asbahal mulku lillahi",
          "arabic": "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ ، اَللّٰهُمَّ إِنِّيْ أَسْأَلُكَ خَيْرَ هٰذَا الْيَوْمِ ، فَتْحَهُ وَنَصْرَهُ وَنُوْرَهُ وَبَرَكَتَهُ وَهُدَاهُ ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِيْهِ وَشَرِّ مَا بَعْدَهُ",
          "transliteration": "Asbahna wa-asbahal mulku lillahi, rabbil aa'la-meen; Allahumma innee as-aluka khayra ha'zal-yawm; Fath'hahoo wa nas'rahoo; Wa noo'rahoo, wa baraka'tahoo, wa hudah; Wa aa'oozu-bika min shar-ri'ma feeh; Wa shar-ri'ma baa'dah.",
          "translation": "We have reached the morning and at this very time all sovereignty belongs to Allah, Lord of the worlds. O Allah, I ask You for the good of this day, its triumphs and its victories, its light & its blessings and its guidance, and I take refuge in You from the evil of this day and the evil that follows it.",
          "reference": "Abu Dawood 4/322 | 5084",
          "benefits": "Reciting this Dua in the morning seeks all goodness of the day and protection from its evils, as instructed by the Prophet ﷺ.",
          "times": 1,
          "category": "Morning Adhkar"
        },

        {
          "id": 31,
          "title": "Laa ilaaha illallaahu wahdahu laa sha'ree kalah",
          "arabic": "لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَىْءٍ قَدِيرٌ",
          "transliteration": "Laa ilaaha illallaahu wahdahu laa sha'ree kalah; Lahul-mulku wa lahul-hamd; Wa'huwa aa'laa kulli shay'in qadeer.",
          "translation": "None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise, and He is over all things omnipotent.",
          "reference": "Sahih Muslim 4/2071 | Al Bukhari 6040 | Abu Dawood 5077",
          "benefits": "Reciting this 100 times earns rewards equivalent to freeing ten slaves; 100 good deeds are recorded, 100 sins removed, protection from Shaytaan for the day, and it is a shield until night.",
          "times": 100,
          "category": "Morning Adhkar"
        },
        
        {
          "id": 32,
          "title": "SubhanAllahi wa bi'hamdih",
          "arabic": "سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ",
          "transliteration": "SubhanAllahi wa bi'hamdih",
          "translation": "All Glory is to Allah and all praise to Him, glorified is Allah the Great.",
          "reference": "Al Bukhari 6405 | Sahih Muslim 4/2071 | Al-Bukhari 6040 vol.8 75/414 | Sahih Muslim 2692",
          "benefits": "These words are light on the tongue, heavy on the Scale, and beloved to Allah. Reciting them 100 times a day forgives all sins, and morning and evening recitation ensures no one will have better deeds on the Day of Resurrection except those who do the same or more.",
          "times": 100,
          "category": "Morning Adhkar"
        },

        {
          "id": 33,
          "title": "Astaghfiru-l-llāha wa atūbu ilayh",
          "arabic": "أَسْتَغْفِرُ اللّٰهَ وَأَتُوْبُ إِلَيْهِ",
          "transliteration": "Astaghfiru-l-llāha wa atūbu ilayh",
          "translation": "I seek Allah's forgiveness and turn to Him in repentance.",
          "reference": "Sahih Muslim 2702b | Hisn al-Muslim 96",
          "benefits": "The Prophet ﷺ recommended seeking repentance from Allah a hundred times daily. Regular recitation purifies the soul and brings one closer to Allah through sincere repentance.",
          "times": 100,
          "category": "Morning Adhkar"
        },

        {
          "id": 34,
          "title": "Allāhumma ṣalli ʿalā Muḥammad",
          "arabic": "اَللّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَّعَلَىٰ اٰلِ مُحَمَّدٍ ، كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيْمَ وَعَلَىٰ اٰلِ إِبْرَاهِيْمَ ، إِنَّكَ حَمِيْدٌ مَّجِيْدٌ ، اَللّٰهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَّعَلَىٰ اٰلِ مُحَمَّدٍ ، كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيْمَ وَعَلَىٰ اٰلِ إِبْرَاهِيْمَ ، إِنَّكَ حَمِيْدٌ مَّجِيْدٌ",
          "transliteration": "Allāhumma ṣalli ʿalā Muḥammad wa ʿalā āli Muḥammad, kamā ṣallayta ʿalā Ibrāhīma wa ʿalā āli Ibrāhīm, innaka Ḥamīdu-m-Majīd, Allāhumma bārik ʿalā Muḥammad, wa ʿalā āli Muḥammad, kamā bārakta ʿalā Ibrāhīma wa ʿalā āli Ibrāhīm, innaka Ḥamīdu-m-Majīd",
          "translation": "O Allah, honour and have mercy upon Muhammad and the family of Muhammad as You have honoured and had mercy upon Ibrāhīm and the family of Ibrāhīm. Indeed, You are the Most Praiseworthy, the Most Glorious. O Allah, bless Muhammad and the family of Muhammad as You have blessed Ibrāhīm and the family of Ibrāhīm. Indeed, You are the Most Praiseworthy, the Most Glorious.",
          "reference": "Al-Tabarani in Al-Targhib wa Al-Tarhīb 1/261 | Sahih al-Bukhari 6357",
          "benefits": "The Prophet ﷺ said that whoever sends Salawat on him ten times in the morning and ten times in the evening will be encompassed by his intercession.",
          "times": 10,
          "category": "Morning Adhkar"
        },
      ]
    },


    {
      "id": 2,
      "name": "Evening Adhkar",
      "description": "Supplications to recite after Maghrib prayer",
      "duas": [
        {
          "id": 35,
          "title": "Surah Al-Fatihah",
          "arabic": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿١﴾ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ﴿٢﴾ الرَّحْمَٰنِ الرَّحِيمِ ﴿٣﴾ مَالِكِ يَوْمِ الدِّينِ ﴿٤﴾ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ﴿٥﴾ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ﴿٦﴾ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ ﴿٧﴾",
          "transliteration": "Bismillāhir-raḥmānir-raḥīm. Al-ḥamdu lillāhi rabbil-ʿālamīn. Ar-raḥmānir-raḥīm. Māliki yawmid-dīn. Iyyāka naʿbudu wa iyyāka nastaʿīn. Ihdinaṣ-ṣirāṭal-mustaqīm. Ṣirāṭallaḏīna anʿamta ʿalaihim ghayril-maghḍūbi ʿalaihim wa laḍ-ḍāllīn.",
          "translation": "In the name of Allah, the Entirely Merciful, the Especially Merciful. [All] praise is [due] to Allah, Lord of the worlds. The Entirely Merciful, the Especially Merciful. Sovereign of the Day of Recompense. It is You we worship and You we ask for help. Guide us to the straight path. The path of those upon whom You have bestowed favour, not of those who have evoked [Your] anger or of those who are astray.",
          "reference": "Al-Fatihah 1:1-7 | Sahih Muslim 395",
          "benefits": "Greatest Surah of the Qur'an; essential part of every Salah; cure and protection.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 36,
          "title": "Al-Baqarah 2:1-5",
          "arabic": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ الم ﴿١﴾ ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ ﴿٢﴾ الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ ﴿٣﴾ وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ ﴿٤﴾ أُو۟لَٰٓئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ ۖ وَأُو۟لَٰٓئِكَ هُمُ ٱلْمُفْلِحُونَ ﴿٥﴾",
          "transliteration": "Bismillāhir-raḥmānir-raḥīm. 2:1 Alif Lām Mīm. 2:2 Dhālika al-kitābu lā rayba fīh, hudan lil-muttaqīn. 2:3 Alladhīna yu'minūna bil-ghaybi wa yuqīmūnaṣ-ṣalāta wa mimmā razaqnāhum yunfiqūn. 2:4 Wa alladhīna yu'minūna bimā unzila ilayka wa mā unzila min qablika wa bil-ākhirati hum yūqinūn. 2:5 Ūlāʾika ʿalā hudan min rabbihim wa ūlāʾika humu al-muf'liḥūn.",
          "translation": "In the name of Allah, the Entirely Merciful, the Especially Merciful. 2:1 Alif-Lam-Mim. 2:2 This is the Book about which there is no doubt, a guidance for those conscious of Allah. 2:3 Who believe in the unseen, establish prayer, and spend out of what We have provided for them. 2:4 And who believe in what has been revealed to you, [O Muhammad], and what was revealed before you, and of the Hereafter they are certain [in faith]. 2:5 It is they who are upon guidance from their Lord, and it is they who will be successful.",
          "reference": "Al-Baqarah 2:1-5 | Sahih International | Ad-Darimi",
          "benefits": "Protection from Shayṭān at night; safety for one's family; beneficial for ruqyah and guarding an empty home.",
          "times": 1,
          "category": "Evening Adhkar"
        },


        {
          "id": 37,
          "title": "Ayat al-Kursi",
          "arabic": "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ",
          "transliteration": "Allāhu lā ilāha illā huwa al-ḥayyu al-qayyūm, lā ta'khudhuhu sinatun wa lā nawm, lahu mā fī as-samāwāti wa mā fī al-arḍ, man dhā alladhī yashfaʿu ʿindahu illā bi-idhnihi, yaʿlamu mā bayna aydīhim wa mā khalfahum, wa lā yuḥīṭūna bishay'in min ʿilmihi illā bimā shā'a, wasiʿa kursiyyuhu as-samāwāti wa al-arḍ, wa lā ya'ūduhu ḥifẓuhumā, wa huwa al-ʿaliyyu al-ʿaẓīm.",
          "translation": "Allah! There is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is [presently] before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.",
          "reference": "Al-Baqarah 2:255",
          "benefits": "Greatest verse in the Qur'an; protection from Shayṭān when recited before sleeping; protection and blessing throughout the day.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 38,
          "title": "Al-Baqarah 2:256",
          "arabic": "لَا إِكْرَاهَ فِي الدِّينِ ۖ قَد تَّبَيَّنَ الرُّشْدُ مِنَ الْغَيِّ ۗ فَمَن يَكْفُرْ بِالطَّاغُوتِ وَيُؤْمِن بِاللَّهِ فَقَدِ اسْتَمْسَكَ بِالْعُرْوَةِ الْوُثْقَىٰ لَا انفِصَامَ لَهَا ۗ وَاللَّهُ سَمِيعٌ عَلِيمٌ",
          "transliteration": "2:256 Lā ikrāha fī ad-dīn; qad tabayyana ar-rushdu mina al-ghayy; fa-man yakfur biṭ-ṭāghūti wa yu'min billāhi faqad is'tamsaka bil-ʿurwati al-wuth'qā lan fiṣāma lahā; wallāhu samīʿun ʿalīm.",
          "translation": "There shall be no compulsion in [acceptance of] the religion. The right course has become clear from the wrong. So whoever disbelieves in Taghut and believes in Allah has grasped the most trustworthy handhold with no break in it. And Allah is Hearing and Knowing.",
          "reference": "Al-Baqarah 2:256 | Sahih International | Ad-Darimi",
          "benefits": "Protection from Shayṭān at night; safety for one's family; beneficial for ruqyah and guarding an empty home.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 39,
          "title": "Al-Baqarah 2:257",
          "arabic": "اللَّهُ وَلِيُّ الَّذِينَ آمَنُوا۟ يُخْرِجُهُم مِّنَ ٱلظُّلُمَـٰتِ إِلَى ٱلنُّورِ ۖ وَٱلَّذِينَ كَفَرُوٓا۟ أَوْلِيَآؤُهُمُ ٱلطَّـٰغُوتُ يُخْرِجُونَهُم مِّنَ ٱلنُّورِ إِلَى ٱلظُّلُمَـٰتِ ۗ أُو۟لَـٰٓئِكَ أَصْحَـٰبُ ٱلنَّارِ ۖ هُمْ فِيهَا خَـٰلِدُونَ",
          "transliteration": "2:257 Allaahu waliyyul lazeena aa'manoo yukh'rijuhum minaz-zulumaati ilan noor; wal'lazee na-kafaroo awliyaa uo'humut taa'ghootu yukh'rijoo-nahum minan noori ilaz-zulumaat; ulaa'ika as'haabun naari hum fee'haa khaa'lidoon.",
          "translation": "Allah is the ally of those who believe. He brings them out from darknesses into the light. And those who disbelieve – their allies are Taghut. They take them out of the light into darknesses. Those are the companions of the Fire; they will abide eternally therein.",
          "reference": "Al-Baqarah 2:257 | Sahih International | Ad-Darimi",
          "benefits": "Protection from Shayṭān; safety for one's family; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 40,
          "title": "Al-Baqarah 2:284",
          "arabic": "لِلَّهِ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ وَإِن تُبْدُوا مَا فِي أَنفُسِكُمْ أَوْ تُخْفُوهُ يُحَاسِبْكُم بِهِ اللَّهُ ۖ فَيَغْفِرُ لِمَن يَشَاءُ وَيُعَذِّبُ مَن يَشَاءُ ۗ وَاللَّهُ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ ﴿٢٨٤﴾",
          "transliteration": "2:284 Lillaahi maa fis-samaawaati wa-maa fil ard; Wa in'tubdoo maa feee an'fusikum aw tukh-foohu yuhaa-sibkum bihil-laa; Fayagh'firuli maiya-shaa'u wa yu'azzibu maiya-shaa; Wallaahu aa'laa kulli shai in qadeer.",
          "translation": "To Allah belongs whatever is in the heavens and whatever is in the earth. Whether you show what is within yourselves or conceal it, Allah will bring you to account for it. Then He will forgive whom He wills and punish whom He wills, and Allah is over all things competent.",
          "reference": "Al-Baqarah 2:284 | Sahih International | Ad-Darimi",
          "benefits": "Protection from Shayṭān; safety for one's family; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 41,
          "title": "Al-Baqarah 2:285",
          "arabic": "آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ ۗ كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ ۗ وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ ﴿٢٨٥﴾",
          "transliteration": "2:285 Aa'manar-rasoolu bimaa un'zila ilaihi mir-Rabbihee walmu'minoon; Kul'lun aa'mana billaahi wa malaa'ikathihee wa kutubhihee wa rusulihee, Laa nufar'riqu baina ahadim-mir-rusulih; Wa qaaloo sami'naa wa aata'naa; Ghufra-naka rabbana wa ilaikal maser.",
          "translation": "The Messenger has believed in what was revealed to him from his Lord, and [so have] the believers. All of them have believed in Allah and His angels and His books and His messengers, [saying], We make no distinction between any of His messengers. And they say, We hear and we obey. [We seek] Your forgiveness, our Lord, and to You is the [final] destination.",
          "reference": "Al-Baqarah 2:285 | Sahih International | Al Bukhari 4723 | Sahih Muslim 807",
          "benefits": "Reciting the last two verses of Al-Baqarah (v285 and v286) at night suffices for protection and blessings; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 42,
          "title": "Al-Baqarah 2:286",
          "arabic": "لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ ۗ رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا ۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ أَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ ﴿٢٨٦﴾",
          "transliteration": "2:286 Laa yukalliful-laahu nafsan illaa wus'ahaa; Lahaa maa kasabat wa aa'laihaa mak-tasabat; Rabbana laa tu'aakhiznaa in'naa-seenaa aw-akhtaa'naa; Rabbana wa laa tahmil-alainaa isran kamaa hamaltahoo alal-lazeena min qablinaa; Rabbana wa laa tuham-milnaa maa laa taa'qata lanaa bih; Wa'fu annaa waghfir lanaa war'hamnaa; Anta mawlana fansur-naa alal qawmil kaafireen.",
          "translation": "Allah does not charge a soul except [with that within] its capacity. It will have [the consequence of] what [good] it has gained, and it will bear [the consequence of] what [evil] it has earned. Our Lord, do not impose blame upon us if we have forgotten or erred. Our Lord, and lay not upon us a burden like that which You laid upon those before us. Our Lord, and burden us not with that which we have no ability to bear. And pardon us; and forgive us; and have mercy upon us. You are our protector, so give us victory over the disbelieving people.",
          "reference": "Al-Baqarah 2:286 | Sahih International | Al Bukhari 4723 | Sahih Muslim 807",
          "benefits": "Reciting the last two verses of Al-Baqarah (v285 and v286) at night suffices for protection and blessings; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 43,
          "title": "Surah Al-Ikhlas",
          "arabic": "قُلْ هُوَ اللَّهُ أَحَدٌ ﴿١﴾ اللَّهُ الصَّمَدُ ﴿٢﴾ لَمْ يَلِدْ وَلَمْ يُولَدْ ﴿٣﴾ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ ﴿٤﴾",
          "transliteration": "112:1 Qul hu'wallaa-hu ahad.\n112:2 Allah hus-samad.\n112:3 Lam yalid wa-lam yoou'lad.\n112:4 Wa lam'ya kul-lahu kufu'wan ahad.",
          "translation": "112:1 Say, He is Allah, [who is] One.\n112:2 Allah, the Eternal Refuge.\n112:3 He neither begets nor is born.\n112:4 Nor is there to Him any equivalent.",
          "reference": "Al-Ikhlas | Abu Dawood 2/86 | An Nasai 3/68 | Al Albani | Sahih Timithi 2/8 | Sahih International",
          "benefits": "Protection from Shayṭān; safety for one's family; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home.",
          "times": 3,
          "category": "Evening Adhkar"
        },

        {
          "id": 44,
          "title": "Surah Al-Falaq",
          "arabic": "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ﴿١﴾ مِن شَرِّ مَا خَلَقَ ﴿٢﴾ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ﴿٣﴾ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ﴿٤﴾ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ ﴿٥﴾",
          "transliteration": "113:1 Qul a'uzoo-bi rabbil-falaq.\n113:2 Min sharri ma khalaq.\n113:3 Wa min sharri gha'siqin iza waqab.\n113:4 Wa min shar'rin naf'faa saati'fil uqad.\n113:5 Wa min shar'ri haa'sidin iza hasad.",
          "translation": "113:1 Say, I seek refuge in the Lord of daybreak.\n113:2 From the evil of that which He created.\n113:3 And from the evil of darkness when it settles.\n113:4 And from the evil of the blowers in knots.\n113:5 And from the evil of an envier when he envies.",
          "reference": "Al-Falaq | Abu Dawood 2/86 | An Nasai 3/68 | Al Albani | Sahih Timithi 2/8 | Sahih International",
          "benefits": "Protection from evil and envy; safety for one's family; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home. Recommended to recite 3 times at dawn and dusk.",
          "times": 3,
          "category": "Evening Adhkar"
        },

        {
          "id": 45,
          "title": "Surah Al-Nās",
          "arabic": "قُلْ أَعُوذُ بِرَبِّ النَّاسِ ﴿١﴾ مَلِكِ النَّاسِ ﴿٢﴾ إِلَٰهِ النَّاسِ ﴿٣﴾ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ﴿٤﴾ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ﴿٥﴾ مِنَ الْجِنَّةِ وَالنَّاسِ ﴿٦﴾",
          "transliteration": "114:1 Qul a'uzu-bi rab'binn naas.\n114:2 Malik'inn naas.\n114:3 Ilaa hin'naas.\n114:4 Min shar'ril waas-wa-asil khan'naas.\n114:5 Al lazee yu'was wi'su fee sudoo-rin naas.\n114:6 Minal jin'nati wan naas.",
          "translation": "114:1 Say, I seek refuge in the Lord of mankind.\n114:2 He is the Sovereign of mankind.\n114:3 The God of mankind.\n114:4 From the evil of the retreating whisperer.\n114:5 Who whispers [evil] into the breasts of mankind.\n114:6 From among the jinn and mankind.",
          "reference": "Al-Nās | Abu Dawood 2/86 | An Nasai 3/68 | Al Albani | Sahih Timithi 2/8 | Sahih International",
          "benefits": "Protection from evil whispers and envy; safety for one's family; beneficial for ruqyah, before sleeping, when sick, against evil eye, and guarding an empty home. Recommended to recite 3 times at dawn and dusk.",
          "times": 3,
          "category": "Morning Adhkar"
        },

        {
          "id": 46,
          "title": "Amsaina wa-amsal mulku lillah",
          "arabic": "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلّٰهِ وَالْحَمْدُ لِلّٰهِ ، لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيْرٌ ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِيْ هٰذِهِ اللَّيْلَةِ وَخَيْرَ مَا بَعْدَهَا ، وَأَعُوْذُ بِكَ مِنْ شَرِّ مَا فِيْهِ وَشَرِّ مَا بَعْدَهَا ، رَبِّ أَعُوْذُ بِكَ مِنَ الْكَسَلِ وَسُوْءِ الْكِبَرِ ، رَبِّ أَعُوْذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ",
          "transliteration": "Amsaina wa-amsal mulku lillah; Wal-hamdu lillah; La ilaha illal-lah; Wah-da'hoo la-sharee kalah; Lahul-mulku wa'lahul-hamd; Yuh-ee wa yu'meeto wa'huwa ala kulli shayin qadeer; Rabbi ass-aaluka khay'ra mafee haa-zee'hil lai'lah; Wa-khayra ma ba'daha; Wa- aa'ozu-bika min sharri ma fee haa-zee'hil lai'lah; Wa sharri ma ba'daha; Rabbi aa'ozu-bika minal-kasali, wa-soo-il kibar; Rabbi aa'ozubika min aa'zaa-bin fin'nari wa aa'zaa-bin fil'qabr.",
          "translation": "We have reached the evening and at this very time unto Allah belongs all sovereignty, and all praise is for Allah. None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent. My Lord, I ask You for the good of this night and the good of what follows it and I take refuge in You from the evil of this night and the evil of what follows it. My Lord, I take refuge in You from laziness and senility. My Lord, I take refuge in You from torment in the Fire and punishment in the grave.",
          "reference": "Sahih Muslim 4/2088, 2723 | At-Trimidhi 3390",
          "benefits": "Reciting this Dua in the evening and morning provides protection from the evils of the night and day, safeguards against laziness, senility, punishment in the Fire, and the grave. It is a practice taught and followed by the Prophet ﷺ.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 47,
          "title": "Aamsaina ala fitratil-islam",
          "arabic": "أَمْسَيْنَا عَلَىٰ فِطْرَةِ الْإِسْلَامِ ، وَعَلَىٰ كَلِمَةِ الْإِخْلَاصِ ، وَعَلَىٰ دِيْنِ نَبِيِّنَا مُحَمَّدٍ ، وَعَلَىٰ مِلَّةِ أَبِيْنَا إِبْرَاهِيْمَ حَنِيْفًا مُّسْلِمًا وَّمَا كَانَ مِنَ الْمُشْرِكِيْنَ",
          "transliteration": "Aamsaina ala fitratil-islam; Wa'ala kalimatil-ikhlas; Wa'ala deeni nabi'yyina Muhammadin sallalla-hu alai'hi wasallam; Wa'ala millati abeena Ibrahima hanee'faan muslimah; Waama kana minal-mushrikeen.",
          "translation": "We have reached the evening upon the fitrah of Al-Islam, and the word of pure faith, and upon the religion of our Prophet Muhammad and the religion of our forefather Ibrahim, who was a Muslim and of true faith and was not of those who associate others with Allah.",
          "reference": "Imam Ahmad 15367 | Sahih Al-Jami 4674 | Al-Maa'idah 5:3",
          "benefits": "Reciting this Dua affirms one's adherence to the pure religion of Islam as practiced by Prophet Muhammad ﷺ and his companions, avoiding innovations (Bid'ah) and following the authentic path of faith.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 48,
          "title": "Allahumma bika amsaina",
          "arabic": "اَللّٰهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوْتُ وَإِلَيْكَ الْمَصِيْرُ",
          "transliteration": "Allahumma bika amsaina; Wa'bika asbahna; Wa'bika nahya; Wa'bika namooth; Wa'ilay'kaal maser.",
          "translation": "O Allah, by Your leave we have reached the evening and by Your leave we have reached the morning, by Your leave we live and die and unto You is our return.",
          "reference": "Abu Dawood 5068 | At-Tirmidhi 3391 | Ibn Majah 3868 | An-Nisai 10323",
          "benefits": "Reciting this Dua morning and evening acknowledges Allah's control over life, death, and all affairs, reinforcing reliance on Him and awareness of the return to Him.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 49,
          "title": "Allahumma ma aamsa bee'min nia'mah",
          "arabic": "اَللّٰهُمَّ مَا أَمْسَىٰ بِيْ مِنْ نِّعْمَةٍ أَوْ بِأَحَدٍ مِّنْ خَلْقِكَ ، فَمِنْكَ وَحْدَكَ لَا شَرِيْكَ لَكَ ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ",
          "transliteration": "Allahumma ma aamsa bee'min nia'mah; Aw'bee a'haa-deem min khal'qik; Fa'minka wah-dhaka la-sharee kalak; Fa-lakal hamdu wa-lakash shukr.",
          "translation": "O Allah, what blessing I or any of Your creation have risen upon, is from You alone, without partner, so for You is all praise and unto You all thanks.",
          "reference": "Abu Dawood 4/324 | Quran 14:7",
          "benefits": "Reciting this Dua in the morning expresses gratitude for the day and in the evening expresses gratitude for the night, fulfilling Allah's command to be thankful for His blessings.",
          "times": 2,
          "category": "Evening Adhkar"
        },

        {
          "id": 50,
          "title": "Amsaytu Uthni 'Alayka Hamdan",
          "arabic": "أَمْسَيْتُ أُثْنِيْ عَلَيْكَ حَمْدًا ، وَأَشْهَدُ أَنْ لَّا إِلٰهَ إِلَّا اللّٰهُ",
          "transliteration": "Amsaytu uthnī ʿalayka ḥamdā, wa ash-hadu al-lā ilāha illāl-llāh.",
          "translation": "I have entered the evening praising You, and I bear witness that there is no god worthy of worship but Allah.",
          "reference": "Nasā’ī in Sunan al-Kubrā 10406",
          "benefits": "Abū Hurayrah (raḍiy Allāhu ‘anhu) narrated that the Messenger of Allah ﷺ said: “When one of you enters the morning, they should say [the above] three times. And when they enter the evening, they should say the same.”",
          "times": 3,
          "category": "Evening Adhkar"
        },

        {
          "id": 51,
          "title": "Radeetu billahi Rabbah",
          "arabic": "رَضِيتُ باللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِيناً، وَبِمُحَمَّدٍ صَلَى اللَّهُ عَلِيهِ وَسَلَّمَ نَبِيَّاً",
          "transliteration": "Radeetu billahi Rabbah; Wa'bil-islami dee'nah; Wa'bee Muhammadin sal-lallahu alai'hi wa'sallama nabiy'ya wa rasulaah.",
          "translation": "I have accepted Allah as my Lord; and Islam as my way of life; and Muhammad ﷺ as Allah's Prophet and the Messenger.",
          "reference": "Abu Dawood 4/318 | Imam Ahmed 18967 | An-Nasai",
          "benefits": "Prophet ﷺ said: Anyone who recites this Dua in the morning and evening will have it incumbent upon Allah to make him content on the Day of Resurrection.",
          "times": 3,
          "category": "Evening Adhkar"
        },

        {
          "id": 52,
          "title": "Allahumma innee as-aalukal aaf'wa",
          "arabic": "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي، وَدُنْيَايَ، وَأَهْلِي، وَمَالِي، اللَّهُمَّ اسْتُرْ عَوْرَاتِي، وَآمِنْ رَوْعَاتِي، اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِيَ.",
          "transliteration": "Allahumma innee as-aalukal aaf'wa wal-aa'fiyah; Fid-dunya wal-akhirah; Allahumma innee as'alukal aa'fwa wal-aa'fiyah; Fee dee'nee wa'dunya-ya; Wa'ahlee wama-lee; Allah hummas-tur aaw-ra'tee; Wa aa'mir raw-aa'tee; Wah fiz'nee min bai'nee ya-dai'yaa; Wa-min khal'fee; Wa'aai ya'mee-nee; Wa'aai shee'malee, Wa-min faw'qee; Wa'aa-oozubi aa'zaa-matika aan oogh-tala min tahtee.",
          "translation": "O Allah, I ask You for pardon and well-being in this life and the next. O Allah, I ask You for pardon and well-being in my religious and worldly affairs, and my family and my wealth. O Allah, veil my weaknesses and set at ease my dismay, and preserve me from the front and from behind and on my right and on my left and from above, and I take refuge with You lest I be swallowed up by the earth.",
          "reference": "Ibn Majah 2/323 | Abu Dawood 5074",
          "benefits": "The Messenger ﷺ never failed to recite this Dua in the morning and evening; provides comprehensive protection and well-being for oneself, family, and wealth.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 53,
          "title": "SubhanAllahi wa-bihamdih",
          "arabic": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ .",
          "transliteration": "SubhanAllahi wa-bihamdih; Aa'dada khal'qi; Wa'rida nafsih; Wa'zinata aa'rshih; Wa'midada kalimatih.",
          "translation": "How perfect Allah is; and I praise Him by the number of His creation and His pleasure, and by the weight of His throne, and the ink of His words.",
          "reference": "Sahih Muslim 4/2090 | Riyad-us-Saliheen 1433 | Sahih Muslim 2726",
          "benefits": "Highly meritorious and rewarding; full of Praise and Glorification of Allah; reciting it three times outweighs much other speech in reward.",
          "times": 3,
          "category": "Evening Adhkar"
        },
        
        {
          "id": 54,
          "title": "Bismillah hil'lazee la yadur'oo",
          "arabic": "بِسْمِ اللّٰهِ الَّذِيْ لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ ، وَهُوَ السَّمِيْعُ الْعَلِيْمُ.",
          "transliteration": "Bismillah hil'lazee la yadur'oo ma'aas-mihi shai-oon fil-ardi wa'laa fis-samaa; Wa'hu'waas samee'ool aa'leem.",
          "translation": "In the name of Allah with whose name nothing is harmed on earth nor in the heavens and He is The All-Seeing, The All-Knowing.",
          "reference": "Abu Dawood 4/323 | At-Trimithi 5/465 | Abu Dawood 5088",
          "benefits": "Reciting this Dua three times ensures nothing will harm the reciter; protection from sudden afflictions until morning or evening depending on recitation time.",
          "times": 3,
          "category": "Evening Adhkar"
        },

        {
          "id": 55,
          "title": "Allāhumma innī aʿūdhu bika",
          "arabic": "اَللّٰهُمَّ إِنِّيْ أَعُوْذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ ، وَأَعُوْذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ، وَأَعُوْذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ ، وَأَعُوْذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ وَقَهْرِ الرِّجَالِ.",
          "transliteration": "Allāhumma innī aʿūdhu bika min-l-hammi wa-l-ḥazan, wa aʿūdhu bika min-l-ʿajzi wa-l-kasal, wa aʿūdhu bika min-l-jubni wa-l-bukhl, wa aʿūdhu bika min ghalabati-d-dayni wa qahri-r-rijāl.",
          "translation": "O Allah, I seek Your protection from anxiety and grief. I seek Your protection from inability and laziness. I seek Your protection from cowardice and miserliness, and I seek Your protection from being overcome by debt and being overpowered by men.",
          "reference": "Sunan Abi Dawud 1555",
          "benefits": "Reciting this Dua in the morning and evening removes worries, settles debts, and provides protection from anxiety, grief, inability, laziness, cowardice, miserliness, and oppression by men.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 56,
          "title": "Aa'oozu-bi kalima-tillah",
          "arabic": "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
          "transliteration": "Aa'oozu-bi kalima-tillah heet-taam'mati min sharri ma khalaq.",
          "translation": "I seek protection in the perfect words of Allah from every evil that He has created.",
          "reference": "Imam Ahmed 2/290 | Sahih Muslim 2708, 2709",
          "benefits": "Reciting this Dua while stopping on a journey protects from harm; recitation in the evening protects from scorpion stings and other evils until the next movement.",
          "times": 3,
          "category": "Evening Adhkar"
        },

        {
          "id": 57,
          "title": "Allahumma aa'limal-ghaybi",
          "arabic": "اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّماوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءاً أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ",
          "transliteration": "Allahumma aa'limal-ghaybi wash-shahadah; Fati'ras samawati wal'ard; Rabba kulli shay'in wa'ma leekah; Ash'hadu al'laa ilaha illa anth; Aa'ozu-bika min shar'ri nafsee; Wa'min shar'rish shay'tani wa-shirki; Wa'an aq-tarifa ala nafsee soo'an aw aa'joor-rahoo ila Muslim.",
          "translation": "O Allah, knower of the unseen and the seen, creator of the heavens and the earth, Lord and sovereign of all things, I bear witness that none has the right to be worshipped except You. I take refuge in You from the evil of my soul and from the evil and shirk of the devil, and from committing wrong against my soul or bringing such upon another Muslim.",
          "reference": "At-Thirmidi 3/142 | Al-Da'waat 3392",
          "benefits": "Reciting this Dua in the morning, evening, and before sleeping offers protection from the evil of oneself and Shayṭān, and prevents committing harm to oneself or other Muslims.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 58,
          "title": "Ya Hayyu Ya Qayyum",
          "arabic": "يَاحَيُّ، يَا قَيُّومُ، بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.",
          "transliteration": "Ya hayyu ya qay'yum; Bi-rah'matika asta'gis; As'lih li sha'ni kullah; Wa'la takil'ni ila nafsi tarfata ayn.",
          "translation": "O Ever Living, O Self-Subsisting and Supporter of all, by Your mercy I seek assistance. Rectify for me all of my affairs and do not leave me to myself, even for the blink of an eye.",
          "reference": "Sahih Targhib wa Tarhib 1/273 | An-Nasai | Al-Mustadrak Al-Haakim V1 p.509 | Imaam Haakim | Imaam Dhahabi",
          "benefits": "Prophet ﷺ advised Fatima (RA) to recite this in the morning and evening. Anas ibn Malik (RA) reported this practice. Abdullah ibn Mas'ood (RA) narrated that whenever the Prophet ﷺ faced worry or concern, he recited this dua.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 59,
          "title": "Subḥāna-llāhi wa bi ḥamdih",
          "arabic": "سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ ، عَدَدَ خَلْقِهِ ، وَرِضَا نَفْسِهِ ، وَزِنَةَ عَرْشِهِ ، وَمِدَادَ كَلِمَاتِهِ",
          "transliteration": "Subḥāna-llāhi wa bi ḥamdih, ʿadada khalqih, wa riḍā nafsih, wa zinata ʿarshih, wa midāda kalimātih",
          "translation": "Allah is free from imperfection and all praise is due to Him, (in ways) as numerous as all He has created, (as vast) as His pleasure, (as limitless) as the weight of His Throne, and (as endless) as the ink of His words.",
          "reference": "Muslim 2140, Abū Dāwūd 1503",
          "benefits": "Reciting this Dua is highly meritorious and rewarding. The Prophet ﷺ stated that reciting it three times outweighs everything else said that day in the scales of reward.",
          "times": 3,
          "category": "Evening Adhkar"
        },
        
        {
          "id": 60,
          "title": "Sayyidul Istighfar",
          "arabic": "اللَّهُمَّ أَنْتَ رَبِّي لَّا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ.",
          "transliteration": "Allahumma anta rabbee la ilaha illa anta, khalaqtanee wa ana 'abduka, wa ana 'ala 'ahdika wa wa'dika mas'tata't, a'oodhu bika min sharri ma sana't, aboo'u laka bini'matika 'alayya, wa aboo'u bidhanbee, faghfir lee, fa-innahu la yaghfiru-dh-dhunooba illa ant.",
          "translation": "O Allah, You are my Lord, none has the right to be worshipped except You. You created me and I am Your servant, and I abide to Your covenant and promise as best I can. I seek refuge in You from the evil of what I have done. I acknowledge Your favour upon me and I acknowledge my sin, so forgive me, for verily none can forgive sins except You.",
          "reference": "Al-Bukhari 7/150 | Al-Da'waat 6306",
          "benefits": "The Prophet ﷺ said: Whoever says this Dua during the day with firm belief and dies before evening will be among the people of Paradise. Whoever says it at night with firm belief and dies before morning will be among the people of Paradise.",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 61,
          "title": "Allāhumma Inni Amsaytu Ush-hiduka",
          "arabic": "اَللّٰهُمَّ إِنِّيْ أَمْسَيْتُ أُشْهِدُكَ وَأُشْهِدُ حَمَلَةَ عَرْشِكَ وَمَلَائِكَتَكَ وَجَمِيْعَ خَلْقِكَ ، أَنَّكَ أَنْتَ اللّٰهُ لَا إِلٰهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيْكَ لَكَ ، وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُوْلُكَ.",
          "transliteration": "Allāhumma innī amsaytu ush-hiduka, wa ush-hidu ḥamlata ʿarshika, wa malā’ikatika, wa jamī’a khalqika, annaka Anta-llāhu lā ilāha illā Anta waḥdak, lā sharīka lak, wa an-na Muḥammadan ʿabduka wa rasūluk.",
          "translation": "O Allah, I have entered the evening, and I call upon You, the bearers of Your Throne, Your angels and all creation, to bear witness that surely You are Allah. There is no god worthy of worship except You Alone. You have no partners, and that Muḥammad ﷺ is Your slave and Your Messenger.",
          "reference": "Abū Dāwūd 5069, 5078",
          "benefits": "Anas b. Mālik (raḍiy Allāhu ʿanhu) narrates that the Messenger of Allah ﷺ said: “Whosoever reads [the above] in the morning or evening once, Allah frees a quarter of him from the Hell-fire. If he reads it twice, Allah frees half of him from the Hell-fire. If he reads it thrice, Allah frees three-quarters of him from the Hell-fire. And if he reads it four times, Allah (completely) frees him from the Hell-fire.” Also, “Whoever says the above in the morning, Allah will forgive the sins he commits in that day; and whoever says it in the evening, Allah will forgive the sins he commits in that night.”",
          "times": 4,
          "category": "Evening Adhkar"
        },

        {
          "id": 62,
          "title": "Allahumma aa'fi-nee fee bada'nee",
          "arabic": "اللَّهُمَّ عَافِـني فِي بَدَنِي، اللَّهُمَّ عَافِـنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إلاَّ أَنْتَ. اللَّهُمَّ إِنِّي أَعُوذُبِكَ مِنَ الْكُفْر، وَالفَقْرِ، وَأَعُوذُبِكَ مِنْ عَذَابِ الْقَبْرِ ، لَا إلَهَ إلاَّ أَنْتَ.",
          "transliteration": "Allahumma aa'fi-nee fee bada'nee; Allahumma aa'fi-nee fee sam'ee; Allahumma aa'fi-nee fee basa'ree; La ilaha illa-ant; Allahumma innee aa'oozu-bika minal-kufri wal-faqr; Wa'aa'oo-zu-bika min aa'zaa-bil-qabr; La ilaha illa-ant.",
          "translation": "O Allah, grant my body health, O Allah, grant my hearing health, O Allah, grant my sight health. None has the right to be worshipped except You, O Allah, I take refuge with You from disbelief and poverty, and I take refuge with You from the punishment of the grave. None has the right to be worshipped except You.",
          "reference": "Abu Dawood 4/324 | Abu Dawood 5049",
          "benefits": "Reciting this Dua thrice every morning and evening brings health for body, hearing, and sight, and protection from disbelief, poverty, and the punishment of the grave, as practiced by Abu Bakrah r.a following the Prophet ﷺ.",
          "times": 3,
          "category": "Morning Adhkar"
        },

        {
          "id": 63,
          "title": "Hasbiya Allah",
          "arabic": "حَسْبِيَ اللَّهُ لَآ إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ",
          "transliteration": "Hasbi-yallahu la ilaha illa huwa aa'layhi tawak-kalth; Wa'huwa rabbul aar'shil aa'zeem.",
          "translation": "Allah is sufficient for me, none has the right to be worshipped except Him, upon Him I rely and He is Lord of the exalted throne.",
          "reference": "Abu Dawood 4/321 | 5081",
          "benefits": "Reciting this Dua seven times in the morning and evening brings sufficiency and reliance upon Allah against all matters, as narrated by Abu'd-Darda r.a.",
          "times": 7,
          "category": "Morning Adhkar"
        },

        {
          "id": 64,
          "title": "Amsayna wa Amsa-l-Mulku Li-llāhi",
          "arabic": "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ ، اَللّٰهُمَّ إِنِّيْ أَسْأَلُكَ خَيْرَ هـٰذِهِ اللَّيْلَةِ ، فَتْحَهَا وَنَصْرَهَا وَنُوْرَهَا وَبَرَكَتَهَا وَهُدَاهَا ، وَأَعُوْذُ بِكَ مِنْ شَرِّ مَا فِيْهَا وَشَرِّ مَا بَعْدَهَا.",
          "transliteration": "Amsaynā wa amsa-l-mulku li-llāhi Rabbi-l-ʿālamīn, Allāhumma innī as’aluka khayra hādhihi-l-laylah, fatḥahā wa naṣrahā wa nūrahā wa barakatahā wa hudāhā, wa aʿūdhu bika min sharri mā fīhā wa sharri mā baʿdahā.",
          "translation": "We have entered the evening and at this very time the whole kingdom belongs to Allah, Lord of the Worlds. O Allah, I ask You for the goodness of this day/night: its victory, its help, its light, and its blessings and guidance. I seek Your protection from the evil that is in it and from the evil that follows it.",
          "reference": "Abū Dāwūd 5084",
          "benefits": "Abū Mālik al-Ashʿarī (raḍiy Allāhu ʿanhu) narrates that the Messenger of Allah ﷺ said: “When one of you enters the morning, they should say [the above]; and when they reach the evening, they should say the same.”",
          "times": 1,
          "category": "Evening Adhkar"
        },

        {
          "id": 65,
          "title": "Laa ilaaha illallaahu wahdahu laa sha'ree kalah",
          "arabic": "لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَىْءٍ قَدِيرٌ",
          "transliteration": "Laa ilaaha illallaahu wahdahu laa sha'ree kalah; Lahul-mulku wa lahul-hamd; Wa'huwa aa'laa kulli shay'in qadeer.",
          "translation": "None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise, and He is over all things omnipotent.",
          "reference": "Sahih Muslim 4/2071 | Al Bukhari 6040 | Abu Dawood 5077",
          "benefits": "Reciting this 100 times earns rewards equivalent to freeing ten slaves; 100 good deeds are recorded, 100 sins removed, protection from Shaytaan for the day, and it is a shield until night.",
          "times": 100,
          "category": "Evening Adhkar"
        },
        
        {
          "id": 66,
          "title": "SubhanAllahi wa bi'hamdih",
          "arabic": "سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ",
          "transliteration": "SubhanAllahi wa bi'hamdih",
          "translation": "All Glory is to Allah and all praise to Him, glorified is Allah the Great.",
          "reference": "Al Bukhari 6405 | Sahih Muslim 4/2071 | Al-Bukhari 6040 vol.8 75/414 | Sahih Muslim 2692",
          "benefits": "These words are light on the tongue, heavy on the Scale, and beloved to Allah. Reciting them 100 times a day forgives all sins, and morning and evening recitation ensures no one will have better deeds on the Day of Resurrection except those who do the same or more.",
          "times": 100,
          "category": "Evening Adhkar"
        },

        {
          "id": 67,
          "title": "Astaghfiru-l-llāha wa atūbu ilayh",
          "arabic": "أَسْتَغْفِرُ اللّٰهَ وَأَتُوْبُ إِلَيْهِ",
          "transliteration": "Astaghfiru-l-llāha wa atūbu ilayh",
          "translation": "I seek Allah's forgiveness and turn to Him in repentance.",
          "reference": "Sahih Muslim 2702b | Hisn al-Muslim 96",
          "benefits": "The Prophet ﷺ recommended seeking repentance from Allah a hundred times daily. Regular recitation purifies the soul and brings one closer to Allah through sincere repentance.",
          "times": 100,
          "category": "Evening Adhkar"
        },

        {
          "id": 68,
          "title": "Allāhumma ṣalli ʿalā Muḥammad",
          "arabic": "اَللّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَّعَلَىٰ اٰلِ مُحَمَّدٍ ، كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيْمَ وَعَلَىٰ اٰلِ إِبْرَاهِيْمَ ، إِنَّكَ حَمِيْدٌ مَّجِيْدٌ ، اَللّٰهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَّعَلَىٰ اٰلِ مُحَمَّدٍ ، كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيْمَ وَعَلَىٰ اٰلِ إِبْرَاهِيْمَ ، إِنَّكَ حَمِيْدٌ مَّجِيْدٌ",
          "transliteration": "Allāhumma ṣalli ʿalā Muḥammad wa ʿalā āli Muḥammad, kamā ṣallayta ʿalā Ibrāhīma wa ʿalā āli Ibrāhīm, innaka Ḥamīdu-m-Majīd, Allāhumma bārik ʿalā Muḥammad, wa ʿalā āli Muḥammad, kamā bārakta ʿalā Ibrāhīma wa ʿalā āli Ibrāhīm, innaka Ḥamīdu-m-Majīd",
          "translation": "O Allah, honour and have mercy upon Muhammad and the family of Muhammad as You have honoured and had mercy upon Ibrāhīm and the family of Ibrāhīm. Indeed, You are the Most Praiseworthy, the Most Glorious. O Allah, bless Muhammad and the family of Muhammad as You have blessed Ibrāhīm and the family of Ibrāhīm. Indeed, You are the Most Praiseworthy, the Most Glorious.",
          "reference": "Al-Tabarani in Al-Targhib wa Al-Tarhīb 1/261 | Sahih al-Bukhari 6357",
          "benefits": "The Prophet ﷺ said that whoever sends Salawat on him ten times in the morning and ten times in the evening will be encompassed by his intercession.",
          "times": 10,
          "category": "Evening Adhkar"
        },

      ]
    },
    {
      "id": 3,
      "name": "Daily Supplications",
      "description": "Essential duas for daily activities",
      "duas": [
        {
          "id": 69,
          "title": "Upon Going to Sleep",
          "arabic": "اللَّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا",
          "transliteration": "Allahumma bismika amootu wa ahya",
          "translation": "O Allah in Your name, I die and I live.",
          "reference": "Sahih Muslim 4/2083 | Fateh Al Bari 11/113",
          "benefits": "Protection during sleep; seeking Allah's protection when entering the state of sleep which is like a small death; helps maintain consciousness of Allah even in unconscious states.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 70,
          "title": "Wake Up From Sleep",
          "arabic": "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
          "transliteration": "Alhamdulillahilladhi ahyana ba'da ma amatana wa ilayhin-nushoor",
          "translation": "All praise be to Allah, who gave us life after death (sleep is a form of death) and to Him will we be raised and returned.",
          "reference": "Sahih Muslim 4/2083 | Fateh Al Bari 11/113",
          "benefits": "Gratitude to Allah for returning life after sleep; reminder of the resurrection on Day of Judgment; acknowledgment of Allah's power over life and death; helps start the day with thankfulness and consciousness of Allah.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 71,
          "title": "Entering the Toilet",
          "arabic": "بِسْمِ اللَّهِ ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبْثِ وَالْخَبَائِثِ",
          "transliteration": "Bismillahi, Allahumma inni a'udhu bika minal khubuthi wal khaba'ith",
          "translation": "In the name of Allah. O Allah I seek refuge in You from the male female evil and Jinn's.",
          "reference": "Al Bhukari 1/45 | Sahih Muslim 1/283",
          "benefits": "Protection from evil jinn and harmful creatures in unclean places; seeking Allah's refuge before entering impure areas; helps maintain spiritual cleanliness even in physically unclean environments; recommended practice for entering bathrooms and toilets.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 72,
          "title": "Leaving the Toilet",
          "arabic": "غُفْرَانَكَ ، أَلْحَمْدُ لِلَّهِ الَّذِي أَذْهَبَ عَنِّي الْأَذَى وَعَافَانِي",
          "transliteration": "Ghufranak, alhamdulillahilladhi adh-haba anni al-adha wa 'afani",
          "translation": "O Allah, I seek forgiveness and pardon from You, All Praise be to Allah, who removed the difficulty from me and gave me ease (relief).",
          "reference": "Abu Dawood | Ibn Majah | At-Tirmidhi",
          "benefits": "Expression of gratitude to Allah for relief and ease; seeking forgiveness for any shortcomings; acknowledgment of Allah's mercy in providing comfort; helps maintain consciousness of Allah's blessings in daily activities.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 73,
          "title": "Start of Wudu",
          "arabic": "بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ",
          "transliteration": "Bismillahir-rahmanir-raheem",
          "translation": "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
          "reference": "Abu Dawood | Ibn Majah | Imam Ahmed",
          "benefits": "Beginning purification with Allah's name; seeking His mercy and blessings for the act of worship; helps maintain focus and intention during wudu; recommended practice before any act of worship.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 74,
          "title": "Completion of Wudu",
          "arabic": "أَشْهَدُ أَن لَّا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدَاً عَبْدَهُ وَرَسُولَهُ",
          "transliteration": "Ash-hadu an la ilaha illallahu wahdahu la shareeka lahu wa ash-hadu anna Muhammadan 'abduhu wa rasooluh",
          "translation": "I testify that there is no one worthy of worship besides Allah. He is all by Himself and has no partner and I testify that Muhammad is Allah's messenger (Rasool).",
          "reference": "Sahih Muslim 1/209",
          "benefits": "Declaration of faith after purification; reminder of the core beliefs of Islam; can be recited as dhikr throughout the day; helps maintain consciousness of Allah and His messenger; recommended for daily remembrance.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 75,
          "title": "Entering the Masjid",
          "arabic": "بِسْمِ اللهِ ، وَالصَّلَاةُ وَالسَّلَامُ عَلَى رَسُولِ اللَّهِ ، اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
          "transliteration": "Bismillahi, was-salaatu was-salaamu 'ala rasoolillah, Allahumma aftah lee abwaaba rahmatik",
          "translation": "In the Name of Allah, and peace and blessings be upon the Messenger of Allah, O Allah, open the doors of mercy.",
          "reference": "Abu Dawood | Ibn As Sunan 888 | Al Albani",
          "benefits": "Seeking Allah's mercy when entering His house; sending blessings upon the Prophet ﷺ; helps prepare the heart for worship; recommended practice before entering any masjid.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 76,
          "title": "Leaving the Masjid",
          "arabic": "بِسْمِ اللَّهِ، وَالصَّلَاةُ وَالسَّلَامُ عَلَى رَسُولِ اللَّهِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ",
          "transliteration": "Bismillahi, was-salaatu was-salaamu 'ala rasoolillah, Allahumma inni as'aluka min fadlik",
          "translation": "In the Name of Allah, and peace and blessings be upon the Messenger of Allah. O Allah, I ask for Your favour, O Allah, verily I seek from You, Your bounty.",
          "reference": "Abu Dawood | Sahee Al Jaami 4591",
          "benefits": "Seeking Allah's bounty and blessings when leaving His house; sending blessings upon the Prophet ﷺ; helps maintain connection with Allah after worship; recommended practice when leaving any masjid.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 77,
          "title": "Before the Meals",
          "arabic": "بِسْمِ اللَّهِ",
          "transliteration": "Bismillah",
          "translation": "In the name of Allah.",
          "reference": "Abu Dawood 3/437 | At-Tirmidhi 4/288",
          "benefits": "Seeking Allah's blessings before eating; helps prevent harm from food; recommended before starting any activity; simple yet powerful reminder of Allah's presence in daily activities.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 78,
          "title": "Forgetting to Recite Bismillah",
          "arabic": "بِسْمِ اللَّهِ فِي أَوَّلِهِ وَ آخِرِهِ",
          "transliteration": "Bismillahi fee awwalihi wa aakhirih",
          "translation": "In the name of Allah in the beginning and end.",
          "reference": "Abu Dawood 3/437 | At-Tirmidhi 4/288",
          "benefits": "Making up for forgetting to say Bismillah at the start; seeking Allah's blessings for the entire activity; recommended when one forgets to begin with Allah's name; helps maintain consciousness of Allah throughout activities.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 79,
          "title": "After Meals - Dua 1",
          "arabic": "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيْهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ",
          "transliteration": "Alhamdulillahilladhi at'amani haadha wa razaqanihi min ghayri hawlin minni wa la quwwah",
          "translation": "Praise is to Allah Who has given me this food, and sustained me with it though I was unable to do it and powerless.",
          "reference": "At-Tirmidhi 3/159 | Abu Dawud | Ibn Majah",
          "benefits": "Expression of gratitude to Allah for providing sustenance; acknowledgment of complete dependence on Allah; helps develop humility and thankfulness; recommended after every meal.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 80,
          "title": "After Meals - Dua 2",
          "arabic": "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ",
          "transliteration": "Alhamdulillahilladhi at'amana wa saqana wa ja'alana muslimeen",
          "translation": "All praise belongs to Allah, who fed us and quenched our thirst and made us Muslims.",
          "reference": "Ibn Majah 3283 | Abi Dawud 3850 | At-Tirmidhi 3457",
          "benefits": "Comprehensive gratitude for food, drink, and faith; acknowledgment of Allah's blessings in both physical and spiritual sustenance; helps maintain consciousness of Allah's favors; recommended after meals.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 81,
          "title": "After Meals - Dua 3",
          "arabic": "اللَّهُمَّ بَارِكْ لَنَا فِيْهِ وَأَطْعِمْنَا خَيْرًا مِنْهُ",
          "transliteration": "Allahumma baarik lana feehi wa at'imna khayran minhu",
          "translation": "O Allah, You grant us blessings in it and grant us better than it.",
          "reference": "At-Tirmidhi 5/506",
          "benefits": "Seeking Allah's blessings in the food consumed; asking for better sustenance in the future; helps develop contentment and hope; recommended after meals to increase barakah.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 82,
          "title": "Dua Before Salam",
          "arabic": "اللَّهُمَّ إِنِّي أَعُوْذُبِكَ مِنْ عَذَابِ الْقَبْرِ ، وَمِنْ عَذَابِ جَهَنَّمَ، وَمِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ، وَمِنْ شَرِّ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ",
          "transliteration": "Allahumma inni a'oodhu bika min 'adhaabil-qabri, wa min 'adhaabi jahannam, wa min fitnatil-mahyaa wal-mamaat, wa min sharri fitnatil-maseehid-dajjaal",
          "translation": "O Allah, I seek refuge in You from the punishment of the grave, and from the punishment of Hell-fire, and from the trials of life and death, and from the evil of the trial of the False Messiah.",
          "reference": "Al-Bukhari 2/102 | Muslim 1/412",
          "benefits": "Comprehensive protection from major trials and punishments; seeking refuge from grave punishment, hellfire, life and death trials, and the Dajjal; recommended during tashahhud and before salam; helps maintain awareness of the hereafter.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 83,
          "title": "When Leaving Home",
          "arabic": "بِسْمِ اللَّهِ ، تَوَكَّلْتُ عَلَى اللَّهِ ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
          "transliteration": "Bismillahi, tawakkaltu 'alallahi, wa la hawla wa la quwwata illa billah",
          "translation": "I depart with Allah's name, relying on Him. It is Allah who saves us from sins with His guidance (the ability to do so).",
          "reference": "Sahih Muslim 1/209",
          "benefits": "Seeking Allah's protection when leaving home; placing complete trust in Allah; can be used when leaving any vehicle or place; helps maintain reliance on Allah throughout daily activities; recommended for all departures.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 84,
          "title": "When Entering Home",
          "arabic": "بِسْمِ اللَّهِ وَلَجْنَا ، وَ بِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَ كَلْنَا",
          "transliteration": "Bismillahi wa lajna, wa bismillahi kharajna, wa 'ala rabbina tawakkalna",
          "translation": "In the Name of Allah we enter, in the Name of Allah we leave and upon our Lord we depend. Then say: \"As-Salaamu Alaykum\" to those present.",
          "reference": "At-Tirmidhi 5/490 | Abu Dawood 4/325",
          "benefits": "Seeking Allah's protection when entering home; placing trust in Allah for safety; greeting family members with peace; helps maintain consciousness of Allah's presence in the home; recommended practice when entering any dwelling.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 85,
          "title": "On Journey",
          "arabic": "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ",
          "transliteration": "Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrineen, wa inna ila rabbina lamunqaliboon",
          "translation": "Allah is pure, He has given control and without His power we would not have any control without doubt we are to return to him.",
          "reference": "Abu Dawood 3/34 | At-Tirmidhi 5/501 | 3/156",
          "benefits": "Acknowledgment of Allah's power over all means of transportation; gratitude for His blessings in providing ease of travel; reminder of our return to Allah; can be used for any journey including car, bus, train, plane, etc.; helps maintain humility and thankfulness during travel.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 86,
          "title": "Return From Journey",
          "arabic": "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ، آيبُونَ تَابِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ",
          "transliteration": "Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrineen, wa inna ila rabbina lamunqaliboon, a'iboona ta'iboona 'abidoona li rabbina hamidoon",
          "translation": "Allah is pure, He has given control and without His power we would not have any control without doubt we are to return to him, we return, repent, worship and praise our Lord.",
          "reference": "Abu Dawood 3/34 | At-Tirmidhi 5/501 | 3/156",
          "benefits": "Complete gratitude for safe return from journey; expression of repentance and worship; acknowledgment of Allah's protection during travel; helps maintain consciousness of Allah's mercy and blessings; recommended practice when returning from any journey.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 87,
          "title": "When Sneezing",
          "arabic": "الْحَمْدُ لِلَّهِ",
          "transliteration": "Alhamdulillah",
          "translation": "All praise is for Allah.",
          "reference": "Al Bhukari 7/125",
          "benefits": "Expression of gratitude to Allah for the natural act of sneezing; acknowledgment of Allah's control over all bodily functions; can be used to thank Allah for all activities and blessings; helps develop constant awareness of Allah's favors; recommended for all activities to maintain thankfulness.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 88,
          "title": "Hearing Someone Sneeze",
          "arabic": "يَرْحَمْكَ الله",
          "transliteration": "Yarhamukallah",
          "translation": "May Allah have mercy on you.",
          "reference": "Al Bhukari 7/125",
          "benefits": "Praying for Allah's mercy upon the one who sneezed; fulfilling the sunnah of responding to a sneeze; strengthening bonds of brotherhood and care; helps develop empathy and concern for others; recommended response when someone sneezes and says Alhamdulillah.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 89,
          "title": "Sneezers Replies Back",
          "arabic": "يَهْدِيكُمُ اللَّهُ وَيُصْلِحُ بَالَكُمْ",
          "transliteration": "Yahdeekumullahu wa yuslihu baalakum",
          "translation": "May Allah guide you and rectify your condition.",
          "reference": "Al Bhukari 7/125",
          "benefits": "Responding to the prayer of mercy with a prayer for guidance; completing the etiquette of sneezing; seeking Allah's guidance and rectification for others; helps maintain proper Islamic manners; recommended response when someone says Yarhamukallah.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 90,
          "title": "Entering the Market",
          "arabic": "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ، وَهُوَ حَيٌّ لَا يَمُوتُ، بِيَدِهِ الْخُيْرُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٍ",
          "transliteration": "La ilaha illallahu wahdahu la shareeka lahu, lahul mulku wa lahul hamd, yuhyee wa yumeet, wa huwa hayyun la yamoot, bi yadihil khayr, wa huwa 'ala kulli shay'in qadeer",
          "translation": "None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise. He gives life and causes death, and He is living and does not die. In His hand is all good and He is over all things, omnipotent.",
          "reference": "At-Tirmidhi 5/291 | Al Hakim 1/538 | Ibn Majah 2/21",
          "benefits": "Declaration of Allah's oneness and power when entering busy places; protection from worldly distractions and materialism; reminder of Allah's control over life and death; helps maintain focus on Allah in commercial environments; recommended when entering markets, malls, or busy public places.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 91,
          "title": "Having Relation With Wife",
          "arabic": "بِسْمِ اللهِ ، اللَّهُمَّ جَنِّبْنَا الشَّيْطَانَ، وَجَنِّبِ الشَّيْطَانَ مَا رَزَقْتَنَا",
          "transliteration": "Bismillah, Allahumma jannibnash shaytana, wa jannibish shaytana ma razaqtana",
          "translation": "In the Name of Allah, O Allah! Keep us away from Satan and keep Satan away from what You have bestowed upon us. And if Allah has ordained a child for them, Satan will never harm him.",
          "reference": "Abu Dawood 2/248 | Ibn Majah 1/617",
          "benefits": "Seeking Allah's protection from Shaytan during intimate relations; asking for Allah's blessings on the marital relationship; protection for any child that may result from the union; helps maintain spiritual consciousness in marital life; recommended practice for married couples.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 92,
          "title": "After Adhaan",
          "arabic": "اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ ، وَالصَّلَاةِ الْقَائِمَةِ ، آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ ، وَابْعَثْهُ مَقَامَاً مَحْمُودَ الَّذِي وَعَدْتَهُ، إِنَّكَ لَا تُخْلِفُ الْمِيعَادَ",
          "transliteration": "Allahumma rabba hadhihid da'watit taammah, was-salaatil qaa'imah, aati Muhammadanil waseelata wal fadheelah, wab'athhu maqaamam mahmoodanil ladhi wa'adtah, innaka la tukhliful mee'aad",
          "translation": "Oh Allah! Lord of this perfect call and this prayer to be established, grant Muhammad Al-wasilah (a high and special place in Jannah) and Al-fadheelah (a rank above the rest of creation) and raise him to a praised platform which you have promised him.",
          "reference": "Al Bhukari 1/152",
          "benefits": "Praying for the Prophet ﷺ's high status in Paradise; seeking his intercession; responding to the call to prayer with this special dua; helps develop love for the Prophet ﷺ; recommended practice after every adhaan; strengthens connection with the Prophet ﷺ.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 93,
          "title": "Dua for Janaza",
          "arabic": "اللَّهُمَّ اغْفِرْ لِحَيِّنَا وَمَيِّتِنَا ، وَشَاهِدِنَا وَغَائِبِنَا، وَصَغِيرِنَا وَكَبِيرِنَا، وَذَكَرِنَا وَأُنْثَانَا اللَّهُمَّ مَنْ أَحْيَيْتَهُ مِنَّا فَأَحْيِهِ عَلَى الْإِسْلَامِ، وَمَنْ تَوَفَّيْتَهُ مِنَّا فَتَوَفَّهُ عَلَى الْإِيمَانِ ، اللَّهُمَّ لَا تَحْرِمْنَا أَجْرَهُ، وَلَا تُضِلَّنَا بَعْدَهُ",
          "transliteration": "Allahummaghfir li hayyina wa mayyitina, wa shaahidina wa ghaa'ibina, wa sagheerina wa kabeerina, wa dhakarina wa unthaana. Allahumma man ahyaytahu minna fa ahyihi 'alal Islam, wa man tawaffaytahu minna fa tawaffahu 'alal eemaan. Allahumma la tahrimna ajrahu, wa la tudillana ba'dah",
          "translation": "O Allah, forgive our living and our dead, those present and those absent, our young and our old, our males and our females. O Allah, whom amongst us You keep alive, then let such a life be upon Islam, and whom amongst us You take unto Yourself, then let such a death be upon faith. O Allah, do not deprive us of his reward and do not let us stray after him.",
          "reference": "Ibn Majah 1/480 | Imam Ahmed 2/268",
          "benefits": "Comprehensive prayer for forgiveness for all Muslims; seeking Allah's mercy for the living and dead; praying for steadfastness in faith; asking for protection from going astray after losing a loved one; helps develop compassion and concern for the entire Muslim community; recommended during funeral prayers.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 94,
          "title": "Subhan Allah wa bihamdihi",
          "arabic": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ",
          "transliteration": "Subhanallahi wa bihamdihi, subhanallahil 'adheem",
          "translation": "How perfect Allah is and I praise Him. How perfect Allah is, The Supreme.",
          "reference": "Al Bhukari 4/2071",
          "benefits": "Glorification and praise of Allah; purification of the heart (Qalb); highly recommended dhikr for all times; helps maintain constant remembrance of Allah; light on the tongue but heavy on the scales; recommended for continuous recitation throughout the day.",
          "times": 100,
          "category": "Daily Supplications"
        },

        {
          "id": 95,
          "title": "Allahumma innaka 'afuwwun",
          "arabic": "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
          "transliteration": "Allahumma innaka 'afuwwun tuhibbul 'afwa fa'fu 'anni",
          "translation": "O Allah You are The One Who pardons greatly, and loves to pardon, so pardon me.",
          "reference": "At-Tirmidhi 9/201 | 1195",
          "benefits": "Seeking Allah's forgiveness and pardon; especially recommended during Ramadan; can be recited as dhikr throughout the day; helps develop humility and repentance; acknowledgment of Allah's love for forgiveness; recommended for continuous recitation.",
          "times": 100,
          "category": "Daily Supplications"
        },

        {
          "id": 96,
          "title": "La hawla wa la quwwata",
          "arabic": "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
          "transliteration": "La hawla wa la quwwata illa billah",
          "translation": "There is no might nor power except with Allah.",
          "reference": "Al Bhukari | Sahih Muslim 4/2076",
          "benefits": "Acknowledgment of complete dependence on Allah; seeking Allah's help and power; recommended dhikr for all times; helps develop reliance on Allah; protection from arrogance and self-reliance; recommended for continuous recitation throughout the day.",
          "times": 100,
          "category": "Daily Supplications"
        },

        {
          "id": 97,
          "title": "Subhan Allah, Alhamdulillah, La ilaha illallah, Allahu Akbar",
          "arabic": "سُبْحَانَ اللَّهِ ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ",
          "transliteration": "Subhanallah, walhamdulillah, wa la ilaha illallah, wallahu akbar",
          "translation": "Glory be to Allah, All Praise is for Allah, There is No God but Allah, Allah is the Greatest.",
          "reference": "Sahih Muslim 3/1685 | 4/2072",
          "benefits": "Comprehensive dhikr combining glorification, praise, declaration of faith, and magnification of Allah; purification of the heart (Qalb); highly recommended for all times; helps maintain constant remembrance of Allah; recommended for continuous recitation throughout the day.",
          "times": 100,
          "category": "Daily Supplications"
        },

        {
          "id": 98,
          "title": "One in Distress",
          "arabic": "لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ ، إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
          "transliteration": "La ilaha illa anta subhanak, inni kuntu minaz-zalimeen",
          "translation": "None has the right to be worshipped except you. How perfect you are, verily I was among the wrong doers.",
          "reference": "Sura An Anbiyah 21:87",
          "benefits": "Dua of Prophet Yunus (AS) when in distress; seeking Allah's help in difficult situations; acknowledgment of one's shortcomings; can be recited as dhikr throughout the day; helps develop humility and reliance on Allah; recommended for all times of difficulty.",
          "times": 100,
          "category": "Daily Supplications"
        },

        {
          "id": 99,
          "title": "Leaving All Affair to Allah",
          "arabic": "حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ",
          "transliteration": "Hasbunallahu wa ni'mal wakeel",
          "translation": "Allah (Alone) is Sufficient for us, and He is the Best Disposer of affairs (for us).",
          "reference": "Quran 3:173 | Al Bhukari 5/172",
          "benefits": "Complete trust in Allah's management of affairs; acknowledgment of Allah's sufficiency; can be recited as dhikr throughout the day; helps develop complete reliance on Allah; recommended for all situations requiring trust in Allah.",
          "times": 100,
          "category": "Daily Supplications"
        },

        {
          "id": 100,
          "title": "Protection from Hellfire",
          "arabic": "اللَّهُمَّ أَجِرْنِي مِنَ النَّارِ",
          "transliteration": "Allahumma ajirni minan naar",
          "translation": "O Allah, save me from the fire.",
          "reference": "Abu Dawood 5079",
          "benefits": "Seeking protection from the punishment of Hellfire; can be recited during dua, sujood, ruku, tashahhud, fajr, and maghrib; helps maintain awareness of the hereafter; recommended for regular recitation to seek Allah's protection.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 101,
          "title": "Fear of Shirk",
          "arabic": "اللَّهُمَّ إِنِّي أَعُوْذُبِكَ أَنْ أُشْرِكَ بِكَ شَيْئاً أَعْلَمُ ، وَأَسْتَغْفِرُكَ لِمَا لَا أَعْلَمُ",
          "transliteration": "Allahumma inni a'oodhu bika an ushrika bika shay'an a'lam, wa astaghfiruka lima la a'lam",
          "translation": "O Allah we seek refuge in You from associating anything with You knowingly, and we seek Your forgiveness for what we do unknowingly.",
          "reference": "Imam Ahmed 4/403",
          "benefits": "Seeking protection from shirk (associating partners with Allah); asking forgiveness for unknown sins; can be recited during dua, tashahhud, and adhkar; helps maintain pure monotheism; recommended for regular recitation to protect from shirk.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 102,
          "title": "Placing Children Under Allah's Protection",
          "arabic": "أُعِيذُ كُمَا بِكَلِمَاتِ اللَّهِ التَّامَّاتِ ، مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ ، وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ",
          "transliteration": "U'eedhu kumaa bi kalimaatillahit taammah, min kulli shaytaanin wa haammah, wa min kulli 'aynin laammah",
          "translation": "I seek protection for you in the Perfect Words of Allah from every devil and every beast, and from every envious blameworthy eye.",
          "reference": "Al Bukhari 4/119",
          "benefits": "Seeking Allah's protection for children from evil; protection from evil eye and harmful creatures; can be used for ruqyah and general dua; helps protect children from spiritual and physical harm; recommended practice for parents.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 103,
          "title": "Dua for the Parents - Part 1",
          "arabic": "رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْ مَ يَقُوْمُ الْحِسَابُ",
          "transliteration": "Rabbana-ghfir lee wa li waalidayya wa lil mu'mineena yawma yaqoomul hisaab",
          "translation": "Our Lord! Forgive me and my parents, and (all) the believers on the Day when the reckoning will be established.",
          "reference": "Quran 14:41",
          "benefits": "Seeking forgiveness for oneself and parents; praying for all believers; can be recited during dua and tashahhud; helps develop concern for parents and the Muslim community; recommended for regular recitation.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 104,
          "title": "Dua for the Parents - Part 2",
          "arabic": "رَبِّ ارْحَمْهُمَا كَمَا رَ بَّيْنِي صَغِيرًا",
          "transliteration": "Rabbi-rhamhuma kama rabbayani sagheera",
          "translation": "My Lord! Have mercy on them both as they did care for me when I was young.",
          "reference": "Quran 17:24",
          "benefits": "Praying for Allah's mercy on parents; acknowledging their care and upbringing; can be recited during sujood and ruku; helps develop gratitude and love for parents; recommended for regular recitation.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 105,
          "title": "When Breaking Fast",
          "arabic": "ذَهَبَ الظَّمَأُ ، وَابْتَلَتِ الْعُرُوقُ ، وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ",
          "transliteration": "Dhahabaz-zama'u, wabtalatil 'urooqu, wa thabatal ajru inshaa Allah",
          "translation": "The thirst has quenched and left wetness and with the will of Allah, reward is proven (certain).",
          "reference": "Abu Dawood 2/306 | Al Albani | Sahih Al Jami | As Saghir 4/209",
          "benefits": "Expression of gratitude for completing the fast; acknowledgment of Allah's reward for fasting; helps maintain consciousness of Allah's blessings; recommended practice when breaking fast during Ramadan or voluntary fasting.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 106,
          "title": "When Visiting Sick",
          "arabic": "لَا بَأْسَ طَهُورُ إِنْ شَاءَ اللَّهُ",
          "transliteration": "La ba'sa tahoorun inshaa Allah",
          "translation": "Do not worry, it will be a purification (for you) Allah willing.",
          "reference": "Al Bukhari | Al Asqalani Fath Al Bari 10/118",
          "benefits": "Comforting the sick person; reminding them that illness can be a means of purification; helps develop empathy and care for others; recommended practice when visiting sick people; helps maintain positive outlook during illness.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 107,
          "title": "For Good Health",
          "arabic": "أَسْأَلُ اللَّهَ الْعَظِيمَ ، رَبَّ الْعَرْشِ الْعَظِيمِ، أَنْ يَشْفِيَكَ",
          "transliteration": "As'alullaha al-'adheem, rabbal 'arshil 'adheem, an yashfiyak",
          "translation": "I ask Almighty Allah, Lord of the Magnificent Throne, to make you well.",
          "reference": "At-Tirmidhi 2/210 | Abu Dawood | Al Albani | Sahih Al Jami | As Saghir 5/180",
          "benefits": "Praying for the sick person's recovery; seeking Allah's healing through His magnificent attributes; should be recited 7 times; helps develop concern for others' well-being; recommended practice when visiting or praying for the sick.",
          "times": 7,
          "category": "Daily Supplications"
        },

        {
          "id": 108,
          "title": "Cure of Any Illness",
          "arabic": "أَذْهِبِ الْبَأْسَ رَبَّ النَّاسِ، وَاشْفِ أَنْتَ الشَّافِي، لَا شِفَاءَ إِلَّا شِفَاؤُكَ، شِفَاءُ لَا يُغَادِرُ سَقَمَاً",
          "transliteration": "Adh-hibil ba'sa rabban-naas, washfi antash-shaafi, la shifaa'a illa shifaa'uk, shifaa'an la yughaadiru saqama",
          "translation": "O Lord of the people, remove this pain and cure it, You are the one who cures and there is no one besides You who can cure, grant such a cure that no illness remains.",
          "reference": "Al Bukhari | Sahih Muslim",
          "benefits": "Comprehensive dua for healing; acknowledging Allah as the only true healer; can be recited during dua and tashahhud; helps develop complete reliance on Allah for healing; recommended for all types of illnesses.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 109,
          "title": "Visiting the Graves",
          "arabic": "السَّلَامُ عَلَيْكُمْ أَهْلَ الدِّيَارِ مِنَ الْمُؤْمِنِينَ وَالْمُسْلِمِينَ، وَإِنَّا إِنْ شَاءَ اللَّهُ بِكُمْ لَاحِقُونَ، نَسْأَلُ اللَّهَ لَنَا وَلَكُمُ الْعَافِيَةَ",
          "transliteration": "Assalaamu 'alaykum ahlad-diyaari minal mu'mineena wal muslimeen, wa innaa inshaa Allahu bikum laahiqoon, nas'alullaha lanaa wa lakumul 'aafiyah",
          "translation": "Peace be upon you, people of this abode, from among the believers and those who are Muslims, and we, by the Will of Allah, shall be joining you. I ask Allah to grant us and you strength.",
          "reference": "Sahih Muslim 2/671 | Ibn Majah 1/494",
          "benefits": "Greeting the deceased Muslims; reminder of the temporary nature of this world; seeking Allah's well-being for oneself and the deceased; helps develop awareness of the hereafter; recommended practice when visiting graves.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 110,
          "title": "Any Difficult Affairs",
          "arabic": "اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلاً، وَأَنْتَ تَجْعَلُ الْحَزَنَ إِذَا شِئْتَ سَهْلاً",
          "transliteration": "Allahumma la sahla illa ma ja'altahu sahla, wa anta taj'alul hazana idha shi'ta sahla",
          "translation": "O Allah, there is no ease except in that which You have made easy, and You make the difficulty, if You wish, easy.",
          "reference": "Mishkat | Ibn Hibban 327 | Ibn As Sunni 351",
          "benefits": "Seeking Allah's help in difficult situations; acknowledging Allah's power to make things easy; can be used for all troublesome affairs, exams, and tests; helps develop reliance on Allah during challenges; recommended for any difficult situation.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 111,
          "title": "Salatul Istikhara",
          "arabic": "اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ وَ تَعْلَمُ وَلَا أَعْلَمُ وَأَنْتَ عَلَامُ الْغُيُوبِ اللَّهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هَذَا الْأَمْرَ \n(Mention the matter by name)\n خَيْرٌ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي فَاقْدُرْهُ لِي وَيَسِّرْهُ لِي ثُمَّ بَارِكْ لِي فِيْهِ وَ إِنْ كُنْتَ تَعْلَمُ أَنَّ هَذَا الْأَمْرَ شَرٌّ فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي فَاصْرِفْهُ عَنِّي وَاصْرِفْنِي عَنْهُ وَاقْدُرْ لِي الْخَيْرَ حَيْثُ كَانَ ثُمَّ ارْضِنِي بِهِ",
          "transliteration": "Allahumma inni astakheeruka bi 'ilmik, wa astaqdiruka bi qudratik, wa as'aluka min fadlikal 'adheem, fa innaka taqdiru wa la aqdir, wa ta'lamu wa la a'lam, wa anta 'allaamul ghuyoob. Allahumma in kunta ta'lamu anna haadhal amra khayrun lee fee deenee wa ma'aashee wa 'aaqibati amree, faqdurhu lee wa yassirhu lee thumma baarik lee feehi. Wa in kunta ta'lamu anna haadhal amra sharrun lee fee deenee wa ma'aashee wa 'aaqibati amree, fasrifhu 'annee wasrifnee 'anhu waqdur liyal khayra haythu kaana thumma ardini bihi",
          "translation": "O Allah, I seek Your guidance (in making a choice) by virtue of Your knowledge, and I seek ability by virtue of Your power, and I ask You of Your great bounty. You have power, I have none. And You know, I know not. You are the Knower of hidden things. O Allah, if in Your knowledge, this matter (Then it should be mentioned by name) is good for me both in this world and in the Hereafter (or in my religion, my livelihood and my affairs) then ordain it for me, make it easy for me, and bless it for me. And if in Your knowledge it is bad for me and for my religion, my livelihood and my affairs (or for me both in this world and the next) then turn me away from it (and turn it away from me) and ordain for me the good wherever it may be and make me pleased with it.",
          "reference": "Al Bhukari 7/162",
          "benefits": "Seeking Allah's guidance in making important decisions; complete submission to Allah's knowledge and wisdom; asking for Allah's help in choosing what is best for one's religion, livelihood, and affairs; helps develop trust in Allah's planning; recommended before making any important decision or choice.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 112,
          "title": "Dua Qunoot 1",
          "arabic": "اللَّهُمَّ اهْدِنَا فِيمَنْ هَدَيْتَ، وَعَافِنَا فِيمَنْ عَافَيْتَ، وَتَوَلَّنَا فِيمَنْ تَوَلَّيْتَ وَبَارِكْ لَنَا فِيمَا أَعْطَيْتَ، وَقِنَا شَرَّ مَا قَضَيْتَ، إِنَّكَ تَقْضِي وَلَا يُقْضَى عَلَيْكَ، إِنَّهُ لَا يَذِلُّ مَنْ وَأَلَيْتَ، وَلَا يَعِزُّ مَنْ عَادَيْتَ، تَبَارَكْتَ رَبَّنَا وَتَعَالَيْتَ",
          "transliteration": "Allahummahdina feeman hadayt, wa 'aafina feeman 'aafayt, wa tawallana feeman tawallayt, wa baarik lana feema a'tayt, wa qina sharra ma qadayt, innaka taqdee wa la yuqdaa 'alayk, innahu la yadhillu man waalayt, wa la ya'izzu man 'aadayt, tabaarakta rabbana wa ta'aalayt",
          "translation": "O Allaah, guide us among those whom You have guided, pardon us among those whom You have pardoned, turn to us in friendship among those on whom You have turned in friendship, and bless us in what You have bestowed, and save us from the evil of what You have decreed. For verily You decree and none can influence You; and he is not humiliated whom You have befriended, nor is he honoured who is Your enemy. Blessed are You, O Lord, and Exalted.",
          "reference": "Abu Dawood 1425 | At-Tirmidhi 464 | An-Nasa'i 1746",
          "benefits": "Comprehensive prayer for guidance, pardon, friendship, blessings, and protection; acknowledgment of Allah's complete control over all affairs; seeking Allah's favor and protection from His decree; helps develop complete reliance on Allah; recommended for witr salah and general dua.",
          "times": 1,
          "category": "Daily Supplications"
        },

        {
          "id": 113,
          "title": "Dua Qunoot 2",
          "arabic": "اللَّهُمَّ إِنَّا نَسْتَعِينُكَ، وَنَسْتَغْفِرُكَ ، وَنُؤْمِنُ بِكَ، وَنَتَوَكَّلُ عَلَيْكَ، وَنُثْنِي عَلَيْكَ الْخَيْرَ، وَنَشْكُرُكَ ، وَلَا نَكْفُرُكَ، وَنَخْلَعُ، وَنَتْرُكُ مَن يَفْجُرُكَ، اللَّهُمَّ إِيَّاكَ نَعْبُدُ، وَلَكَ نُصَلّى، وَنَسْجُدُ وَإِلَيْكَ نَسْعَى، وَنَحْفِدُ وَنَرْجُو رَحْمَتَكَ وَنَخْشَى عَذَابَكَ إِنَّ عَذَابَكَ بِالْكُفَّارِ مُلْحِقُ",
          "transliteration": "Allahumma inna nasta'eenuk, wa nastaghfiruk, wa nu'minu bika, wa natawakkalu 'alayk, wa nuthnee 'alaykal khayr, wa nashkuruk, wa la nakfuruk, wa nakhla'u wa natruku man yafjuruk. Allahumma iyyaaka na'bud, wa laka nusallee, wa nasjudu wa ilayka nas'aa, wa nahfidu wa narjoo rahmatak, wa nakhshaa 'adhaabak, inna 'adhaabak bil kuffaari mulhiq",
          "translation": "O Allah! We beg help from You alone; ask forgiveness from You alone, and turn towards You and praise You for all the good things and are grateful to You and are not ungrateful to You and we part and break off with all those who are disobedient to you. O Allah! You alone do we worship and pray exclusively to You and bow before You alone and we hasten eagerly towards You and we fear Your severe punishment and hope for Your Mercy as your severe punishment is surely to be meted out to the unbelievers.",
          "reference": "Al-bayhaqi 2/210",
          "benefits": "Comprehensive declaration of faith and worship; seeking Allah's help and forgiveness; expressing gratitude and avoiding ingratitude; disassociating from those who disobey Allah; acknowledging Allah as the only one worthy of worship; recommended for witr salah and general dua.",
          "times": 1,
          "category": "Daily Supplications"
        },

        
      ]
    },
    {
      "id": 4,
      "name": "Duas Before Sleep",
      "description": "Protective duas to recite before sleeping",
      "duas": [
        {
          "id": 32,
          "title": "Before sleeping",
          "arabic": "بِسْمِ اللَّهِ أَمُوتُ وَأَحْيَا",
          "transliteration": "Bismillahi amutu wa ahya",
          "translation": "In the name of Allah, I die and I live",
          "reference": "Hadith",
          "benefits": "Protection during sleep",
          "times": 1,
          "category": "Duas Before Sleep",
        },
        {
          "id": 33,
          "title": "Ayat al-Kursi before sleep",
          "arabic": "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...",
          "transliteration": "Allahu la ilaha illa huwa al-hayyu al-qayyum...",
          "translation": "Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence...",
          "reference": "Qur'an 2:255",
          "benefits": "Protection from Shaytan until morning",
          "times": 1,
          "category": "Duas Before Sleep",
        },
      ]
    },
    {
      "id": 5,
      "name": "Ruquiya",
      "description": "Healing duas and protection from evil",
      "duas": [
        {
          "id": 34,
          "title": "Protection from evil eye",
          "arabic": "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ...",
          "transliteration": "A'udhu bi kalimatillahit-tammat...",
          "translation": "I seek refuge in the perfect words of Allah...",
          "reference": "Muslim",
          "benefits": "Protection from evil eye and harm",
          "times": 3,
          "category": "Ruquiya",
        },
        {
          "id": 35,
          "title": "Healing dua",
          "arabic": "بِسْمِ اللَّهِ أَرْقِيكَ...",
          "transliteration": "Bismillahi arqik...",
          "translation": "In the name of Allah I perform ruqyah for you...",
          "reference": "Muslim",
          "benefits": "Healing and protection from illness",
          "times": 1,
          "category": "Ruquiya",
        },
      ]
    },
    {
      "id": 6,
      "name": "All Dua",
      "description": "Various duas for different occasions",
      "duas": [
        {
          "id": 36,
          "title": "Qaza prayer intention",
          "arabic": "نَوَيْتُ صَلَاةَ...",
          "transliteration": "Nawaitu salata...",
          "translation": "I intend to pray...",
          "reference": "Fiqh",
          "benefits": "Proper intention for missed prayers",
          "times": 1,
          "category": "All Dua",
        },
        {
          "id": 37,
          "title": "Seeking forgiveness for missed prayers",
          "arabic": "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْمَغْفِرَةَ...",
          "transliteration": "Allahumma inni as'alukal maghfirah...",
          "translation": "O Allah, I ask You for forgiveness...",
          "reference": "Hadith",
          "benefits": "Forgiveness for missed obligations",
          "times": 1,
          "category": "All Dua",
        },
      ]
    },
    {
      "id": 7,
      "name": "Hajj & Umrah",
      "description": "Sacred duas for pilgrimage",
      "duas": [
        {
          "id": 38,
          "title": "Talbiyah",
          "arabic": "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ...",
          "transliteration": "Labbaik Allahumma labbaik...",
          "translation": "Here I am, O Allah, here I am...",
          "reference": "Qur'an & Hadith",
          "benefits": "Essential for Hajj and Umrah",
          "times": 1,
          "category": "Hajj & Umrah",
        },
        {
          "id": 39,
          "title": "Dua at Arafat",
          "arabic": "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ...",
          "transliteration": "La ilaha illallah wahdahu...",
          "translation": "There is no deity except Allah alone...",
          "reference": "Hadith",
          "benefits": "Greatest day of Hajj",
          "times": 1,
          "category": "Hajj & Umrah",
        },
      ]
    },
  ];

  List<Map<String, dynamic>> getCategories() => List.unmodifiable(_categories);

  List<Map<String, dynamic>> getDuasForCategory(String categoryName) {
    final match = _categories.firstWhere(
      (c) => (c['name'] as String).toLowerCase() == categoryName.toLowerCase(),
      orElse: () => {},
    );
    final list = (match['duas'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    return List.unmodifiable(list);
  }

  Map<String, dynamic>? getDuaById(int id) {
    for (final cat in _categories) {
      final duas = (cat['duas'] as List).cast<Map<String, dynamic>>();
      for (final d in duas) {
        if (d['id'] == id) return Map<String, dynamic>.from(d);
      }
    }
    return null;
  }

  // Helper to add more duas programmatically if needed
  void addDuaToCategory(String categoryName, Map<String, dynamic> dua) {
    final idx = _categories.indexWhere(
      (c) => (c['name'] as String).toLowerCase() == categoryName.toLowerCase(),
    );
    if (idx == -1) return;
    final list = (_categories[idx]['duas'] as List).cast<Map<String, dynamic>>();
    list.add(dua);
  }
} 