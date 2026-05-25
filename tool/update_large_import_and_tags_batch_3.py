import json
from pathlib import Path

root = Path('assets/data')
imports = root / 'imports'

new_tags = [
    {'id': 'lightning_user', 'label': 'Uses Lightning', 'type': 'power', 'difficulty': 'medium'},
    {'id': 'assassin', 'label': 'Assassin', 'type': 'role', 'difficulty': 'medium'},
]

character_batch = [
    {
        'mal_id': 30,
        'name': 'Gon Freecss',
        'name_kanji': 'ゴン＝フリークス',
        'nicknames': ['Gon'],
        'favorites': 50210,
        'about': 'A young lead character with remarkable speed, strength, and heroic resolve.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/gon.jpg',
        'url': 'https://myanimelist.net/character/30/Gon_Freecss',
    },
    {
        'mal_id': 27,
        'name': 'Killua Zoldyck',
        'name_kanji': 'キルア＝ゾルディック',
        'nicknames': ['Killua'],
        'favorites': 61120,
        'about': 'A white-haired young assassin with lightning powers, blinding speed, and fierce strength.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/killua.jpg',
        'url': 'https://myanimelist.net/character/27/Killua_Zoldyck',
    },
    {
        'mal_id': 31,
        'name': 'Kurapika',
        'name_kanji': 'クラピカ',
        'nicknames': ['Kurapika'],
        'favorites': 35640,
        'about': 'A young strategist haunted by tragedy and driven by powerful abilities.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/kurapika.jpg',
        'url': 'https://myanimelist.net/character/31/Kurapika',
    },
    {
        'mal_id': 44,
        'name': 'Hisoka Morow',
        'name_kanji': 'ヒソカ＝モロウ',
        'nicknames': ['Hisoka'],
        'favorites': 47820,
        'about': 'A villainous magician-like fighter with speed, strategy, and a dangerous aura.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/hisoka.jpg',
        'url': 'https://myanimelist.net/character/44/Hisoka_Morow',
    },
    {
        'mal_id': 1,
        'name': 'Yusuke Urameshi',
        'name_kanji': '浦飯幽助',
        'nicknames': ['Yusuke'],
        'favorites': 24150,
        'about': 'A young lead fighter with super powers, strength, speed, and a rough heroic streak.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/yusuke.jpg',
        'url': 'https://myanimelist.net/character/1/Yusuke_Urameshi',
    },
    {
        'mal_id': 2,
        'name': 'Hiei',
        'name_kanji': '飛影',
        'nicknames': ['Hiei'],
        'favorites': 20330,
        'about': 'A black-haired rival with fire powers, speed, strength, and a dark presence.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/hiei.jpg',
        'url': 'https://myanimelist.net/character/2/Hiei',
    },
    {
        'mal_id': 117223,
        'name': 'Megumin',
        'name_kanji': 'めぐみん',
        'nicknames': ['Crimson Demon'],
        'favorites': 46380,
        'about': 'A young magic user obsessed with explosive super powers.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/megumin.jpg',
        'url': 'https://myanimelist.net/character/117223/Megumin',
    },
    {
        'mal_id': 131724,
        'name': 'Rimuru Tempest',
        'name_kanji': 'リムル＝テンペスト',
        'nicknames': ['Rimuru'],
        'favorites': 42210,
        'about': 'A non-human lead character with transformation powers, strategy, speed, and immense magic.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/rimuru.jpg',
        'url': 'https://myanimelist.net/character/131724/Rimuru_Tempest',
    },
    {
        'mal_id': 497,
        'name': 'Saber',
        'name_kanji': 'セイバー',
        'nicknames': ['Artoria'],
        'favorites': 38740,
        'about': 'A stoic heroic sword fighter with speed, strength, and noble resolve.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/saber.jpg',
        'url': 'https://myanimelist.net/character/497/Saber',
    },
    {
        'mal_id': 5189,
        'name': 'Natsu Dragneel',
        'name_kanji': 'ナツ・ドラグニル',
        'nicknames': ['Salamander'],
        'favorites': 33950,
        'about': 'A fiery lead character with strength, speed, heroic instincts, and destructive power.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/natsu.jpg',
        'url': 'https://myanimelist.net/character/5189/Natsu_Dragneel',
    },
]

anime_batch = [
    {
        'mal_id': 11061,
        'title': 'Hunter x Hunter (2011)',
        'title_english': 'Hunter x Hunter',
        'title_japanese': 'HUNTER×HUNTER',
        'url': 'https://myanimelist.net/anime/11061/Hunter_x_Hunter_2011',
    },
    {
        'mal_id': 392,
        'title': 'Yuu☆Yuu☆Hakusho',
        'title_english': 'Yu Yu Hakusho',
        'title_japanese': '幽☆遊☆白書',
        'url': 'https://myanimelist.net/anime/392/Yuu☆Yuu☆Hakusho',
    },
    {
        'mal_id': 30831,
        'title': 'Kono Subarashii Sekai ni Shukufuku wo!',
        'title_english': 'KonoSuba: God\'s Blessing on This Wonderful World!',
        'title_japanese': 'この素晴らしい世界に祝福を！',
        'url': 'https://myanimelist.net/anime/30831/Kono_Subarashii_Sekai_ni_Shukufuku_wo',
    },
    {
        'mal_id': 37430,
        'title': 'Tensei shitara Slime Datta Ken',
        'title_english': 'That Time I Got Reincarnated as a Slime',
        'title_japanese': '転生したらスライムだった件',
        'url': 'https://myanimelist.net/anime/37430/Tensei_shitara_Slime_Datta_Ken',
    },
    {
        'mal_id': 10087,
        'title': 'Fate/Zero',
        'title_english': 'Fate/Zero',
        'title_japanese': 'Fate/Zero',
        'url': 'https://myanimelist.net/anime/10087/Fate_Zero',
    },
    {
        'mal_id': 6702,
        'title': 'Fairy Tail',
        'title_english': 'Fairy Tail',
        'title_japanese': 'FAIRY TAIL',
        'url': 'https://myanimelist.net/anime/6702/Fairy_Tail',
    },
]

enrichment_batch = {
    '30': {
        'series': '',
        'animeMalId': 11061,
        'tags': ['protagonist', 'hero', 'young', 'strong', 'fast'],
        'difficulty': 'easy',
        'aliases': ['Gon'],
        'sourceReference': 'https://myanimelist.net/character/30/Gon_Freecss',
        'importNotes': 'Large-batch runtime import for young hero coverage.',
        'image': None,
    },
    '27': {
        'series': '',
        'animeMalId': 11061,
        'tags': ['white_hair', 'young', 'assassin', 'lightning_user', 'fast', 'strong', 'hero'],
        'difficulty': 'medium',
        'aliases': ['Killua'],
        'sourceReference': 'https://myanimelist.net/character/27/Killua_Zoldyck',
        'importNotes': 'Large-batch runtime import for lightning assassin coverage.',
        'image': None,
    },
    '31': {
        'series': '',
        'animeMalId': 11061,
        'tags': ['young', 'strategist', 'has_tragic_past', 'super_powers', 'hero'],
        'difficulty': 'medium',
        'aliases': ['Kurapika'],
        'sourceReference': 'https://myanimelist.net/character/31/Kurapika',
        'importNotes': 'Large-batch runtime import for strategist tragedy coverage.',
        'image': None,
    },
    '44': {
        'series': '',
        'animeMalId': 11061,
        'tags': ['villain', 'magic_user', 'fast', 'strategist'],
        'difficulty': 'hard',
        'aliases': ['Hisoka'],
        'sourceReference': 'https://myanimelist.net/character/44/Hisoka_Morow',
        'importNotes': 'Large-batch runtime import for villain magic coverage.',
        'image': None,
    },
    '1': {
        'series': '',
        'animeMalId': 392,
        'tags': ['protagonist', 'hero', 'young', 'strong', 'fast', 'super_powers'],
        'difficulty': 'easy',
        'aliases': ['Yusuke'],
        'sourceReference': 'https://myanimelist.net/character/1/Yusuke_Urameshi',
        'importNotes': 'Large-batch runtime import for classic spirit-fighter coverage.',
        'image': None,
    },
    '2': {
        'series': '',
        'animeMalId': 392,
        'tags': ['black_hair', 'rival', 'fire_user', 'fast', 'strong', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Hiei'],
        'sourceReference': 'https://myanimelist.net/character/2/Hiei',
        'importNotes': 'Large-batch runtime import for fire rival coverage.',
        'image': None,
    },
    '117223': {
        'series': '',
        'animeMalId': 30831,
        'tags': ['young', 'magic_user', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Crimson Demon'],
        'sourceReference': 'https://myanimelist.net/character/117223/Megumin',
        'importNotes': 'Large-batch runtime import for explosive magic coverage.',
        'image': None,
    },
    '131724': {
        'series': '',
        'animeMalId': 37430,
        'tags': ['protagonist', 'non_human', 'has_transformation', 'super_powers', 'strategist', 'fast'],
        'difficulty': 'medium',
        'aliases': ['Rimuru'],
        'sourceReference': 'https://myanimelist.net/character/131724/Rimuru_Tempest',
        'importNotes': 'Large-batch runtime import for non-human strategy coverage.',
        'image': None,
    },
    '497': {
        'series': '',
        'animeMalId': 10087,
        'tags': ['uses_sword', 'hero', 'stoic', 'strong', 'fast'],
        'difficulty': 'medium',
        'aliases': ['Artoria'],
        'sourceReference': 'https://myanimelist.net/character/497/Saber',
        'importNotes': 'Large-batch runtime import for stoic sword hero coverage.',
        'image': None,
    },
    '5189': {
        'series': '',
        'animeMalId': 6702,
        'tags': ['protagonist', 'hero', 'fire_user', 'strong', 'fast', 'super_powers'],
        'difficulty': 'easy',
        'aliases': ['Salamander'],
        'sourceReference': 'https://myanimelist.net/character/5189/Natsu_Dragneel',
        'importNotes': 'Large-batch runtime import for fire hero coverage.',
        'image': None,
    },
}

approval_batch = [
    {'malId': 30, 'transformedId': 'gon_freecss', 'approvalStatus': 'approved', 'notes': 'Approved for runtime young hero coverage.'},
    {'malId': 27, 'transformedId': 'killua_zoldyck', 'approvalStatus': 'approved', 'notes': 'Approved for runtime lightning assassin coverage.'},
    {'malId': 31, 'transformedId': 'kurapika', 'approvalStatus': 'approved', 'notes': 'Approved for runtime strategist tragedy coverage.'},
    {'malId': 44, 'transformedId': 'hisoka_morow', 'approvalStatus': 'approved', 'notes': 'Approved for runtime villain magic coverage.'},
    {'malId': 1, 'transformedId': 'yusuke_urameshi', 'approvalStatus': 'approved', 'notes': 'Approved for runtime classic protagonist coverage.'},
    {'malId': 2, 'transformedId': 'hiei', 'approvalStatus': 'approved', 'notes': 'Approved for runtime fire rival coverage.'},
    {'malId': 117223, 'transformedId': 'megumin', 'approvalStatus': 'approved', 'notes': 'Approved for runtime explosive magic coverage.'},
    {'malId': 131724, 'transformedId': 'rimuru_tempest', 'approvalStatus': 'approved', 'notes': 'Approved for runtime non-human strategy coverage.'},
    {'malId': 497, 'transformedId': 'saber', 'approvalStatus': 'approved', 'notes': 'Approved for runtime stoic sword hero coverage.'},
    {'malId': 5189, 'transformedId': 'natsu_dragneel', 'approvalStatus': 'approved', 'notes': 'Approved for runtime fire hero coverage.'},
]


def load_json(path: Path):
    return json.loads(path.read_text(encoding='utf-8'))


def write_json(path: Path, data):
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


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

print('updated third large import batch with new tags, enrichments, anime, and approvals')
