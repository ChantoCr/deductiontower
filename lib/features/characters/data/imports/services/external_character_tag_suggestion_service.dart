class ExternalCharacterTagSuggestionService {
  const ExternalCharacterTagSuggestionService();

  static final Map<String, _TagSuggestionRule> _rules = {
    'black_hair': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bblack\s+hair(?:ed)?\b'),
        RegExp(r'\bblack-haired\b'),
        RegExp(r'\bdark-haired\b'),
        RegExp(r'\bjet-black\s+hair\b'),
      ],
      negativePatterns: [
        RegExp(r'\bdark\s+past\b'),
        RegExp(r'\bdark\s+personality\b'),
      ],
    ),
    'white_hair': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bwhite\s+hair(?:ed)?\b'),
        RegExp(r'\bwhite-haired\b'),
        RegExp(r'\bsilver-haired\b'),
      ],
    ),
    'protagonist': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\blead\s+character\b'),
        RegExp(r'\bmain\s+character\b'),
        RegExp(r'\bmain\s+hero\b'),
        RegExp(r'\bmain\s+lead\b'),
        RegExp(r'\bprotagonist\b'),
      ],
      negativePatterns: [
        RegExp(r'\bsupporting\s+character\b'),
        RegExp(r'\bside\s+character\b'),
      ],
    ),
    'hero': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bhero\b'),
        RegExp(r'\bheroic\b'),
        RegExp(r'\bsavior\b'),
        RegExp(r'\bsymbol\s+of\s+peace\b'),
      ],
    ),
    'villain': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bvillain\b'),
        RegExp(r'\bantagonist\b'),
        RegExp(r'\btyrant\b'),
        RegExp(r'\bevil\s+ruler\b'),
      ],
      negativePatterns: [
        RegExp(r'\bformer\s+villain\b'),
      ],
    ),
    'rival': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\brival\b'),
        RegExp(r'\brivalry\b'),
      ],
    ),
    'mentor': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bmentor\b'),
        RegExp(r'\bteacher\b'),
        RegExp(r'\bmaster\b'),
      ],
      negativePatterns: [
        RegExp(r'\bheadmaster\b'),
      ],
    ),
    'uses_sword': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bsword(?:-based)?\b'),
        RegExp(r'\bswordsmanship\b'),
        RegExp(r'\bwields?\s+(?:a\s+)?sword\b'),
        RegExp(r'\bkatana\b'),
        RegExp(r'\bbladed\s+combat\b'),
        RegExp(r'\bsword\s+fighter\b'),
      ],
    ),
    'young': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\byoung\b'),
        RegExp(r'\bboy\b'),
        RegExp(r'\bgirl\b'),
        RegExp(r'\bchild\b'),
        RegExp(r'\bkid\b'),
        RegExp(r'\bteen(?:ager)?\b'),
      ],
      negativePatterns: [
        RegExp(r'\byoungest\b'),
      ],
    ),
    'strong': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bstrong\b'),
        RegExp(r'\bimmense\s+strength\b'),
        RegExp(r'\boverwhelming\s+strength\b'),
        RegExp(r'\bpowerful\b'),
      ],
    ),
    'fast': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bfast\b'),
        RegExp(r'\bspeed\b'),
        RegExp(r'\bswift\b'),
        RegExp(r'\bquick\b'),
      ],
      negativePatterns: [
        RegExp(r'\bfast\s+friend\b'),
      ],
    ),
    'muscular': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bmuscular\b'),
        RegExp(r'\bpowerful\s+build\b'),
      ],
    ),
    'super_powers': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bsuper\s+powers?\b'),
        RegExp(r'\bspecial\s+powers?\b'),
        RegExp(r'\boverwhelming\s+powers?\b'),
        RegExp(r'\bpowerful\s+techniques\b'),
        RegExp(r'\balchemy-like\s+powers\b'),
      ],
    ),
    'has_transformation': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\btransformation(?:s|-like)?\b'),
        RegExp(r'\btransforms?\b'),
        RegExp(r'\bmultiple\s+forms\b'),
        RegExp(r'\bdifferent\s+forms\b'),
        RegExp(r'\balternate\s+forms?\b'),
        RegExp(r'\bpower\s+states?\b'),
        RegExp(r'\btransformation\s+states\b'),
      ],
      negativePatterns: [
        RegExp(r'\bform\s+of\b'),
        RegExp(r'\bforms?\s+of\s+leadership\b'),
      ],
    ),
    'super_saiyan': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bsuper\s+saiyan\b'),
      ],
    ),
    'fire_user': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\buses?\s+fire\b'),
        RegExp(r'\bfire\b'),
        RegExp(r'\bflame\b'),
      ],
      negativePatterns: [
        RegExp(r'\bfirebrand\b'),
      ],
    ),
    'ice_user': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\buses?\s+ice\b'),
        RegExp(r'\bice\b'),
        RegExp(r'\bfrost\b'),
      ],
    ),
    'non_human': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bnon-human\b'),
        RegExp(r'\bnot\s+human\b'),
        RegExp(r'\balien\b'),
        RegExp(r'\bextraterrestrial\b'),
        RegExp(r'\bsaiyan\b'),
        RegExp(r'\bandroid\b'),
        RegExp(r'\bdemon\s+blood\b'),
      ],
      negativePatterns: [
        RegExp(r'\bacts\s+inhuman\b'),
      ],
    ),
    'demon': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bdemon\b'),
        RegExp(r'\bhalf-demon\b'),
      ],
    ),
    'alien': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\balien\b'),
        RegExp(r'\bextraterrestrial\b'),
      ],
    ),
    'martial_artist': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bmartial\s+artist\b'),
        RegExp(r'\bmartial\s+arts\b'),
        RegExp(r'\bfighter\b'),
      ],
      negativePatterns: [
        RegExp(r'\bfirefighter\b'),
      ],
    ),
    'has_tragic_past': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\btragic\s+past\b'),
        RegExp(r'\btragic\s+backstory\b'),
        RegExp(r'\bpainful\s+past\b'),
        RegExp(r'\btraumatic\s+past\b'),
        RegExp(r'\btragic\s+history\b'),
        RegExp(r'\bsevere\s+personal\s+history\b'),
        RegExp(r'\bhaunted\s+by\s+loss\b'),
      ],
      negativePatterns: [
        RegExp(r'\btragic\s+ending\b'),
      ],
    ),
    'strategist': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bstrateg(?:y|ist)\b'),
        RegExp(r'\bmaster\s+tactician\b'),
        RegExp(r'\bmanipulates\s+events\b'),
      ],
    ),
    'stoic': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bstoic\b'),
        RegExp(r'\bcalm\s+resolve\b'),
      ],
    ),
    'magic_user': _TagSuggestionRule(
      positivePatterns: [
        RegExp(r'\bmagic\b'),
        RegExp(r'\bsorcerer\b'),
        RegExp(r'\bcurses?\b'),
      ],
    ),
  };

  List<String> suggestTags({
    required String? about,
    required Set<String> allowedTagIds,
    Set<String> excludedTagIds = const {},
  }) {
    final normalizedAbout = about?.toLowerCase().trim();
    if (normalizedAbout == null || normalizedAbout.isEmpty) {
      return const [];
    }

    final suggestions = <String>[];

    for (final entry in _rules.entries) {
      final tagId = entry.key;
      if (!allowedTagIds.contains(tagId) || excludedTagIds.contains(tagId)) {
        continue;
      }

      if (entry.value.matches(normalizedAbout)) {
        suggestions.add(tagId);
      }
    }

    return suggestions;
  }
}

class _TagSuggestionRule {
  const _TagSuggestionRule({
    required this.positivePatterns,
    this.negativePatterns = const [],
  });

  final List<RegExp> positivePatterns;
  final List<RegExp> negativePatterns;

  bool matches(String about) {
    final hasNegativeMatch = negativePatterns.any((pattern) => pattern.hasMatch(about));
    if (hasNegativeMatch) {
      return false;
    }

    return positivePatterns.any((pattern) => pattern.hasMatch(about));
  }
}
