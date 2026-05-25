import json
from pathlib import Path

root = Path('assets/data')
imports = root / 'imports'


def load_json(path: Path):
    return json.loads(path.read_text(encoding='utf-8'))


def write_json(path: Path, data):
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


new_tags = [
    {'id': 'pink_hair', 'label': 'Pink Hair', 'type': 'appearance', 'difficulty': 'easy'},
    {'id': 'water_user', 'label': 'Uses Water', 'type': 'power', 'difficulty': 'medium'},
]

character_batch = [
    {
        'mal_id': 73970,
        'name': 'Saitama',
        'name_kanji': 'サイタマ',
        'nicknames': ['Caped Baldy'],
        'favorites': 52540,
        'about': 'A laid-back protagonist hero with absurd strength, incredible speed, and overwhelming power.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/saitama.jpg',
        'url': 'https://myanimelist.net/character/73970/Saitama',
    },
    {
        'mal_id': 94441,
        'name': 'Tatsumaki',
        'name_kanji': 'タツマキ',
        'nicknames': ['Tornado of Terror'],
        'favorites': 30980,
        'about': 'A feared hero with immense psychic powers, extreme speed, and destructive force.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/tatsumaki.jpg',
        'url': 'https://myanimelist.net/character/94441/Tatsumaki',
    },
    {
        'mal_id': 46496,
        'name': 'Armin Arlert',
        'name_kanji': 'アルミン・アルレルト',
        'nicknames': ['Armin'],
        'favorites': 22710,
        'about': 'A blond-haired young hero marked by tragedy and exceptional strategy.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/armin.jpg',
        'url': 'https://myanimelist.net/character/46496/Armin_Arlert',
    },
    {
        'mal_id': 66,
        'name': 'Jiraiya',
        'name_kanji': '自来也',
        'nicknames': ['Pervy Sage'],
        'favorites': 30010,
        'about': 'A white-haired mentor with great strength, famous techniques, and heroic resolve.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/jiraiya.jpg',
        'url': 'https://myanimelist.net/character/66/Jiraiya',
    },
    {
        'mal_id': 145,
        'name': 'Sakura Haruno',
        'name_kanji': '春野サクラ',
        'nicknames': ['Sakura'],
        'favorites': 17540,
        'about': 'A pink-haired young hero known for immense strength and advanced healing-like powers.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/sakura.jpg',
        'url': 'https://myanimelist.net/character/145/Sakura_Haruno',
    },
    {
        'mal_id': 142725,
        'name': 'Yuno',
        'name_kanji': 'ユノ',
        'nicknames': ['Yuno'],
        'favorites': 18620,
        'about': 'A rival hero with immense speed, magical power, and calm determination.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/yuno.jpg',
        'url': 'https://myanimelist.net/character/142725/Yuno',
    },
    {
        'mal_id': 142730,
        'name': 'Noelle Silva',
        'name_kanji': 'ノエル・シルヴァ',
        'nicknames': ['Noelle'],
        'favorites': 21340,
        'about': 'A young hero who commands powerful water magic and grows into formidable strength.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/noelle.jpg',
        'url': 'https://myanimelist.net/character/142730/Noelle_Silva',
    },
    {
        'mal_id': 256,
        'name': 'Byakuya Kuchiki',
        'name_kanji': '朽木白哉',
        'nicknames': ['Byakuya'],
        'favorites': 21420,
        'about': 'A black-haired stoic sword fighter with overwhelming speed, power, and noble bearing.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/byakuya.jpg',
        'url': 'https://myanimelist.net/character/256/Byakuya_Kuchiki',
    },
    {
        'mal_id': 84,
        'name': 'Rukia Kuchiki',
        'name_kanji': '朽木ルキア',
        'nicknames': ['Rukia'],
        'favorites': 25750,
        'about': 'A black-haired sword fighter with tragic experiences and strong supernatural abilities.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/rukia.jpg',
        'url': 'https://myanimelist.net/character/84/Rukia_Kuchiki',
    },
    {
        'mal_id': 54285,
        'name': 'Meruem',
        'name_kanji': 'メルエム',
        'nicknames': ['Meruem'],
        'favorites': 31990,
        'about': 'A terrifying non-human villain with extreme speed, strategic brilliance, and enormous power.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/meruem.jpg',
        'url': 'https://myanimelist.net/character/54285/Meruem',
    },
    {
        'mal_id': 27637,
        'name': 'Chrollo Lucilfer',
        'name_kanji': 'クロロ＝ルシルフル',
        'nicknames': ['Chrollo'],
        'favorites': 28010,
        'about': 'A black-haired villainous strategist with dangerous powers and commanding presence.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/chrollo.jpg',
        'url': 'https://myanimelist.net/character/27637/Chrollo_Lucilfer',
    },
    {
        'mal_id': 170735,
        'name': 'Makima',
        'name_kanji': 'マキマ',
        'nicknames': ['Makima'],
        'favorites': 47620,
        'about': 'A manipulative villain with chilling strategy and frightening supernatural power.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/makima.jpg',
        'url': 'https://myanimelist.net/character/170735/Makima',
    },
    {
        'mal_id': 170736,
        'name': 'Power',
        'name_kanji': 'パワー',
        'nicknames': ['Power'],
        'favorites': 38950,
        'about': 'A pink-haired non-human fighter with explosive strength and wild supernatural abilities.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/power.jpg',
        'url': 'https://myanimelist.net/character/170736/Power',
    },
    {
        'mal_id': 1901,
        'name': 'Obito Uchiha',
        'name_kanji': 'うちはオビト',
        'nicknames': ['Tobi'],
        'favorites': 26430,
        'about': 'A black-haired villain shaped by tragedy who changes forms and controls events from the shadows.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/obito.jpg',
        'url': 'https://myanimelist.net/character/1901/Obito_Uchiha',
    },
    {
        'mal_id': 72,
        'name': 'Minato Namikaze',
        'name_kanji': '波風ミナト',
        'nicknames': ['Yellow Flash'],
        'favorites': 28650,
        'about': 'A blond-haired mentor hero famed for legendary speed, strength, and powerful techniques.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/minato.jpg',
        'url': 'https://myanimelist.net/character/72/Minato_Namikaze',
    },
    {
        'mal_id': 2406,
        'name': 'Rock Lee',
        'name_kanji': 'ロック・リー',
        'nicknames': ['Lee'],
        'favorites': 15520,
        'about': 'A young hero martial artist with fierce speed, strength, and relentless effort.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/rock_lee.jpg',
        'url': 'https://myanimelist.net/character/2406/Rock_Lee',
    },
    {
        'mal_id': 65607,
        'name': 'Koro-sensei',
        'name_kanji': '殺せんせー',
        'nicknames': ['Korosensei'],
        'favorites': 31440,
        'about': 'A non-human mentor with absurd speed, great power, and surprising warmth.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/korosensei.jpg',
        'url': 'https://myanimelist.net/character/65607/Koro-sensei',
    },
    {
        'mal_id': 109931,
        'name': 'Reigen Arataka',
        'name_kanji': '霊幻新隆',
        'nicknames': ['Reigen'],
        'favorites': 35240,
        'about': 'A mentor figure known for fast thinking, strategy, and deceptive confidence.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/reigen.jpg',
        'url': 'https://myanimelist.net/character/109931/Reigen_Arataka',
    },
    {
        'mal_id': 3268,
        'name': 'Kenpachi Zaraki',
        'name_kanji': '更木剣八',
        'nicknames': ['Kenpachi'],
        'favorites': 22130,
        'about': 'A brutal sword fighter with monstrous strength, speed, and battle hunger.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/kenpachi.jpg',
        'url': 'https://myanimelist.net/character/3268/Kenpachi_Zaraki',
    },
    {
        'mal_id': 129500,
        'name': 'Tomura Shigaraki',
        'name_kanji': '死柄木弔',
        'nicknames': ['Shigaraki'],
        'favorites': 24820,
        'about': 'A villain scarred by tragedy who evolves into a terrifying super-powered destroyer.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/shigaraki.jpg',
        'url': 'https://myanimelist.net/character/129500/Tomura_Shigaraki',
    },
]

anime_batch = [
    {
        'mal_id': 24833,
        'title': 'Ansatsu Kyoushitsu',
        'title_english': 'Assassination Classroom',
        'title_japanese': '暗殺教室',
        'url': 'https://myanimelist.net/anime/24833/Ansatsu_Kyoushitsu',
    },
]

enrichment_batch = {
    '73970': {
        'series': '',
        'animeMalId': 30276,
        'tags': ['protagonist', 'hero', 'strong', 'fast', 'super_powers'],
        'difficulty': 'easy',
        'aliases': ['Caped Baldy'],
        'sourceReference': 'https://myanimelist.net/character/73970/Saitama',
        'importNotes': 'Large approved batch staging for powerhouse protagonist coverage.',
        'image': None,
    },
    '94441': {
        'series': '',
        'animeMalId': 30276,
        'tags': ['hero', 'psychic', 'strong', 'fast', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Tornado of Terror'],
        'sourceReference': 'https://myanimelist.net/character/94441/Tatsumaki',
        'importNotes': 'Large approved batch staging for psychic hero coverage.',
        'image': None,
    },
    '46496': {
        'series': '',
        'animeMalId': 16498,
        'tags': ['blond_hair', 'strategist', 'hero', 'young', 'has_tragic_past'],
        'difficulty': 'medium',
        'aliases': ['Armin'],
        'sourceReference': 'https://myanimelist.net/character/46496/Armin_Arlert',
        'importNotes': 'Large approved batch staging for blond strategist coverage.',
        'image': None,
    },
    '66': {
        'series': '',
        'animeMalId': 20,
        'tags': ['white_hair', 'mentor', 'hero', 'strong', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Pervy Sage'],
        'sourceReference': 'https://myanimelist.net/character/66/Jiraiya',
        'importNotes': 'Large approved batch staging for mentor hero coverage.',
        'image': None,
    },
    '145': {
        'series': '',
        'animeMalId': 20,
        'tags': ['pink_hair', 'hero', 'young', 'strong', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Sakura'],
        'sourceReference': 'https://myanimelist.net/character/145/Sakura_Haruno',
        'importNotes': 'Large approved batch staging for pink-hair hero coverage.',
        'image': None,
    },
    '142725': {
        'series': '',
        'animeMalId': 34572,
        'tags': ['rival', 'hero', 'young', 'fast', 'strong', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Yuno'],
        'sourceReference': 'https://myanimelist.net/character/142725/Yuno',
        'importNotes': 'Large approved batch staging for rival magic hero coverage.',
        'image': None,
    },
    '142730': {
        'series': '',
        'animeMalId': 34572,
        'tags': ['hero', 'young', 'water_user', 'strong', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Noelle'],
        'sourceReference': 'https://myanimelist.net/character/142730/Noelle_Silva',
        'importNotes': 'Large approved batch staging for water magic hero coverage.',
        'image': None,
    },
    '256': {
        'series': '',
        'animeMalId': 269,
        'tags': ['black_hair', 'uses_sword', 'stoic', 'strong', 'fast', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Byakuya'],
        'sourceReference': 'https://myanimelist.net/character/256/Byakuya_Kuchiki',
        'importNotes': 'Large approved batch staging for stoic sword fighter coverage.',
        'image': None,
    },
    '84': {
        'series': '',
        'animeMalId': 269,
        'tags': ['black_hair', 'uses_sword', 'hero', 'has_tragic_past', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Rukia'],
        'sourceReference': 'https://myanimelist.net/character/84/Rukia_Kuchiki',
        'importNotes': 'Large approved batch staging for tragic sword hero coverage.',
        'image': None,
    },
    '54285': {
        'series': '',
        'animeMalId': 11061,
        'tags': ['villain', 'non_human', 'strong', 'fast', 'strategist', 'super_powers'],
        'difficulty': 'hard',
        'aliases': ['Meruem'],
        'sourceReference': 'https://myanimelist.net/character/54285/Meruem',
        'importNotes': 'Large approved batch staging for non-human mastermind villain coverage.',
        'image': None,
    },
    '27637': {
        'series': '',
        'animeMalId': 11061,
        'tags': ['black_hair', 'villain', 'strategist', 'strong', 'super_powers'],
        'difficulty': 'hard',
        'aliases': ['Chrollo'],
        'sourceReference': 'https://myanimelist.net/character/27637/Chrollo_Lucilfer',
        'importNotes': 'Large approved batch staging for strategist villain coverage.',
        'image': None,
    },
    '170735': {
        'series': '',
        'animeMalId': 44511,
        'tags': ['villain', 'strategist', 'super_powers'],
        'difficulty': 'hard',
        'aliases': ['Makima'],
        'sourceReference': 'https://myanimelist.net/character/170735/Makima',
        'importNotes': 'Large approved batch staging for manipulative villain coverage.',
        'image': None,
    },
    '170736': {
        'series': '',
        'animeMalId': 44511,
        'tags': ['pink_hair', 'non_human', 'strong', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Power'],
        'sourceReference': 'https://myanimelist.net/character/170736/Power',
        'importNotes': 'Large approved batch staging for pink-hair non-human coverage.',
        'image': None,
    },
    '1901': {
        'series': '',
        'animeMalId': 20,
        'tags': ['black_hair', 'villain', 'has_tragic_past', 'has_transformation', 'strategist', 'super_powers'],
        'difficulty': 'hard',
        'aliases': ['Tobi'],
        'sourceReference': 'https://myanimelist.net/character/1901/Obito_Uchiha',
        'importNotes': 'Large approved batch staging for tragic transformation villain coverage.',
        'image': None,
    },
    '72': {
        'series': '',
        'animeMalId': 20,
        'tags': ['blond_hair', 'mentor', 'hero', 'fast', 'strong', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Yellow Flash'],
        'sourceReference': 'https://myanimelist.net/character/72/Minato_Namikaze',
        'importNotes': 'Large approved batch staging for fast mentor hero coverage.',
        'image': None,
    },
    '2406': {
        'series': '',
        'animeMalId': 20,
        'tags': ['hero', 'young', 'strong', 'fast', 'martial_artist'],
        'difficulty': 'easy',
        'aliases': ['Lee'],
        'sourceReference': 'https://myanimelist.net/character/2406/Rock_Lee',
        'importNotes': 'Large approved batch staging for martial artist hero coverage.',
        'image': None,
    },
    '65607': {
        'series': '',
        'animeMalId': 24833,
        'tags': ['non_human', 'mentor', 'strong', 'fast', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Korosensei'],
        'sourceReference': 'https://myanimelist.net/character/65607/Koro-sensei',
        'importNotes': 'Large approved batch staging for non-human mentor coverage.',
        'image': None,
    },
    '109931': {
        'series': '',
        'animeMalId': 32182,
        'tags': ['mentor', 'strategist'],
        'difficulty': 'medium',
        'aliases': ['Reigen'],
        'sourceReference': 'https://myanimelist.net/character/109931/Reigen_Arataka',
        'importNotes': 'Large approved batch staging for mentor strategist coverage.',
        'image': None,
    },
    '3268': {
        'series': '',
        'animeMalId': 269,
        'tags': ['uses_sword', 'strong', 'fast'],
        'difficulty': 'medium',
        'aliases': ['Kenpachi'],
        'sourceReference': 'https://myanimelist.net/character/3268/Kenpachi_Zaraki',
        'importNotes': 'Large approved batch staging for brute sword-fighter coverage.',
        'image': None,
    },
    '129500': {
        'series': '',
        'animeMalId': 31964,
        'tags': ['villain', 'has_tragic_past', 'has_transformation', 'strong', 'super_powers'],
        'difficulty': 'hard',
        'aliases': ['Shigaraki'],
        'sourceReference': 'https://myanimelist.net/character/129500/Tomura_Shigaraki',
        'importNotes': 'Large approved batch staging for tragic transformation villain coverage.',
        'image': None,
    },
}

approval_batch = [
    {'malId': 73970, 'transformedId': 'saitama', 'approvalStatus': 'approved', 'notes': 'Approved for staged powerhouse protagonist coverage.'},
    {'malId': 94441, 'transformedId': 'tatsumaki', 'approvalStatus': 'approved', 'notes': 'Approved for staged psychic hero coverage.'},
    {'malId': 46496, 'transformedId': 'armin_arlert', 'approvalStatus': 'approved', 'notes': 'Approved for staged blond strategist coverage.'},
    {'malId': 66, 'transformedId': 'jiraiya', 'approvalStatus': 'approved', 'notes': 'Approved for staged mentor hero coverage.'},
    {'malId': 145, 'transformedId': 'sakura_haruno', 'approvalStatus': 'approved', 'notes': 'Approved for staged pink-hair hero coverage.'},
    {'malId': 142725, 'transformedId': 'yuno', 'approvalStatus': 'approved', 'notes': 'Approved for staged rival magic hero coverage.'},
    {'malId': 142730, 'transformedId': 'noelle_silva', 'approvalStatus': 'approved', 'notes': 'Approved for staged water magic hero coverage.'},
    {'malId': 256, 'transformedId': 'byakuya_kuchiki', 'approvalStatus': 'approved', 'notes': 'Approved for staged stoic sword fighter coverage.'},
    {'malId': 84, 'transformedId': 'rukia_kuchiki', 'approvalStatus': 'approved', 'notes': 'Approved for staged tragic sword hero coverage.'},
    {'malId': 54285, 'transformedId': 'meruem', 'approvalStatus': 'approved', 'notes': 'Approved for staged non-human mastermind villain coverage.'},
    {'malId': 27637, 'transformedId': 'chrollo_lucilfer', 'approvalStatus': 'approved', 'notes': 'Approved for staged strategist villain coverage.'},
    {'malId': 170735, 'transformedId': 'makima', 'approvalStatus': 'approved', 'notes': 'Approved for staged manipulative villain coverage.'},
    {'malId': 170736, 'transformedId': 'power', 'approvalStatus': 'approved', 'notes': 'Approved for staged pink-hair non-human coverage.'},
    {'malId': 1901, 'transformedId': 'obito_uchiha', 'approvalStatus': 'approved', 'notes': 'Approved for staged tragic transformation villain coverage.'},
    {'malId': 72, 'transformedId': 'minato_namikaze', 'approvalStatus': 'approved', 'notes': 'Approved for staged fast mentor hero coverage.'},
    {'malId': 2406, 'transformedId': 'rock_lee', 'approvalStatus': 'approved', 'notes': 'Approved for staged martial artist hero coverage.'},
    {'malId': 65607, 'transformedId': 'koro_sensei', 'approvalStatus': 'approved', 'notes': 'Approved for staged non-human mentor coverage.'},
    {'malId': 109931, 'transformedId': 'reigen_arataka', 'approvalStatus': 'approved', 'notes': 'Approved for staged mentor strategist coverage.'},
    {'malId': 3268, 'transformedId': 'kenpachi_zaraki', 'approvalStatus': 'approved', 'notes': 'Approved for staged brute sword fighter coverage.'},
    {'malId': 129500, 'transformedId': 'tomura_shigaraki', 'approvalStatus': 'approved', 'notes': 'Approved for staged tragic transformation villain coverage.'},
]


tags_path = root / 'tags.json'
tags = load_json(tags_path)
existing_tag_ids = {tag['id'] for tag in tags}
for tag in new_tags:
    if tag['id'] not in existing_tag_ids:
        tags.append(tag)
write_json(tags_path, tags)

anime_path = imports / 'mal_jikan_anime_sample.json'
anime = load_json(anime_path)
existing_anime_ids = {item['mal_id'] for item in anime}
for item in anime_batch:
    if item['mal_id'] not in existing_anime_ids:
        anime.append(item)
write_json(anime_path, anime)

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for item in character_batch:
    if item['mal_id'] not in existing_source_ids:
        source.append(item)
write_json(source_path, source)

enrichment_path = imports / 'mal_jikan_character_enrichment_preview.json'
enrichment = load_json(enrichment_path)
for key, value in enrichment_batch.items():
    enrichment[key] = value
ordered_enrichment = {key: enrichment[key] for key in sorted(enrichment, key=lambda item: int(item))}
write_json(enrichment_path, ordered_enrichment)

approval_path = imports / 'characters_import_approval.json'
approvals = load_json(approval_path)
approval_by_id = {item['transformedId']: item for item in approvals}
for item in approval_batch:
    approval_by_id[item['transformedId']] = item
write_json(approval_path, list(approval_by_id.values()))

print('updated fourth large import batch with more approved characters and tags')
