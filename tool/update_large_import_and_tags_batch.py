import json
from pathlib import Path

root = Path('assets/data')
imports = root / 'imports'

new_tags = [
    {'id': 'hero', 'label': 'Hero', 'type': 'role', 'difficulty': 'easy'},
    {'id': 'rival', 'label': 'Rival', 'type': 'role', 'difficulty': 'medium'},
    {'id': 'mentor', 'label': 'Mentor', 'type': 'role', 'difficulty': 'medium'},
    {'id': 'young', 'label': 'Young', 'type': 'status', 'difficulty': 'easy'},
    {'id': 'strong', 'label': 'Strong', 'type': 'power', 'difficulty': 'easy'},
    {'id': 'fast', 'label': 'Fast', 'type': 'power', 'difficulty': 'easy'},
    {'id': 'muscular', 'label': 'Muscular', 'type': 'appearance', 'difficulty': 'easy'},
    {'id': 'super_powers', 'label': 'Super Powers', 'type': 'power', 'difficulty': 'easy'},
    {'id': 'super_saiyan', 'label': 'Super Saiyan', 'type': 'power', 'difficulty': 'hard'},
    {'id': 'fire_user', 'label': 'Uses Fire', 'type': 'power', 'difficulty': 'medium'},
    {'id': 'ice_user', 'label': 'Uses Ice', 'type': 'power', 'difficulty': 'medium'},
    {'id': 'demon', 'label': 'Demon', 'type': 'origin', 'difficulty': 'medium'},
    {'id': 'alien', 'label': 'Alien', 'type': 'origin', 'difficulty': 'medium'},
    {'id': 'martial_artist', 'label': 'Martial Artist', 'type': 'role', 'difficulty': 'medium'},
    {'id': 'strategist', 'label': 'Strategist', 'type': 'personality', 'difficulty': 'medium'},
    {'id': 'stoic', 'label': 'Stoic', 'type': 'personality', 'difficulty': 'medium'},
    {'id': 'magic_user', 'label': 'Magic User', 'type': 'power', 'difficulty': 'medium'},
]

character_batch = [
    {
        'mal_id': 85,
        'name': 'Kakashi Hatake',
        'name_kanji': 'はたけカカシ',
        'nicknames': ['Copy Ninja Kakashi'],
        'favorites': 45500,
        'about': 'A white-haired mentor known for speed, strategy, and powerful techniques.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/kakashi.jpg',
        'url': 'https://myanimelist.net/character/85/Kakashi_Hatake',
    },
    {
        'mal_id': 14,
        'name': 'Itachi Uchiha',
        'name_kanji': 'うちはイタチ',
        'nicknames': ['Itachi'],
        'favorites': 48300,
        'about': 'A black-haired rival and strategist with a tragic past and overwhelming powers.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/itachi.jpg',
        'url': 'https://myanimelist.net/character/14/Itachi_Uchiha',
    },
    {
        'mal_id': 164471,
        'name': 'Satoru Gojo',
        'name_kanji': '五条悟',
        'nicknames': ['Gojo'],
        'favorites': 68800,
        'about': 'A white-haired mentor famed for speed, strength, and overwhelming super powers.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/gojo.jpg',
        'url': 'https://myanimelist.net/character/164471/Satoru_Gojo',
    },
    {
        'mal_id': 11,
        'name': 'Edward Elric',
        'name_kanji': 'エドワード・エルリック',
        'nicknames': ['Ed'],
        'favorites': 53400,
        'about': 'A young lead character with strong abilities, a tragic past, and alchemy-like powers.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/edward.jpg',
        'url': 'https://myanimelist.net/character/11/Edward_Elric',
    },
    {
        'mal_id': 12,
        'name': 'Roy Mustang',
        'name_kanji': 'ロイ・マスタング',
        'nicknames': ['Flame Alchemist'],
        'favorites': 29100,
        'about': 'A black-haired strategist who uses fire and carries himself like a future hero.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/roy.jpg',
        'url': 'https://myanimelist.net/character/12/Roy_Mustang',
    },
    {
        'mal_id': 117909,
        'name': 'All Might',
        'name_kanji': 'オールマイト',
        'nicknames': ['Symbol of Peace'],
        'favorites': 41200,
        'about': 'A muscular hero, mentor, and super-powered fighter known for immense strength and speed.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/all_might.jpg',
        'url': 'https://myanimelist.net/character/117909/All_Might',
    },
    {
        'mal_id': 117911,
        'name': 'Shoto Todoroki',
        'name_kanji': '轟焦凍',
        'nicknames': ['Shoto'],
        'favorites': 51800,
        'about': 'A young hero who uses both fire and ice and is marked by a painful family past.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/shoto.jpg',
        'url': 'https://myanimelist.net/character/117911/Shoto_Todoroki',
    },
    {
        'mal_id': 87275,
        'name': 'Ken Kaneki',
        'name_kanji': '金木研',
        'nicknames': ['Kaneki'],
        'favorites': 47250,
        'about': 'A black-haired young man with transformation states, non-human traits, speed, and a tragic past.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/kaneki.jpg',
        'url': 'https://myanimelist.net/character/87275/Ken_Kaneki',
    },
    {
        'mal_id': 158,
        'name': 'Inuyasha',
        'name_kanji': '犬夜叉',
        'nicknames': ['Half-Demon'],
        'favorites': 22300,
        'about': 'A white-haired sword fighter with demon blood, strength, speed, and a tragic history.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/inuyasha.jpg',
        'url': 'https://myanimelist.net/character/158/Inuyasha',
    },
    {
        'mal_id': 40881,
        'name': 'Mikasa Ackerman',
        'name_kanji': 'ミカサ・アッカーマン',
        'nicknames': ['Mikasa'],
        'favorites': 39100,
        'about': 'A black-haired hero known for speed, strength, stoic resolve, and a tragic past.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/mikasa.jpg',
        'url': 'https://myanimelist.net/character/40881/Mikasa_Ackerman',
    },
]

anime_batch = [
    {
        'mal_id': 40748,
        'title': 'Jujutsu Kaisen',
        'title_english': 'Jujutsu Kaisen',
        'title_japanese': '呪術廻戦',
        'url': 'https://myanimelist.net/anime/40748/Jujutsu_Kaisen',
    },
    {
        'mal_id': 5114,
        'title': 'Fullmetal Alchemist: Brotherhood',
        'title_english': 'Fullmetal Alchemist: Brotherhood',
        'title_japanese': '鋼の錬金術師 FULLMETAL ALCHEMIST',
        'url': 'https://myanimelist.net/anime/5114/Fullmetal_Alchemist__Brotherhood',
    },
    {
        'mal_id': 31964,
        'title': 'Boku no Hero Academia',
        'title_english': 'My Hero Academia',
        'title_japanese': '僕のヒーローアカデミア',
        'url': 'https://myanimelist.net/anime/31964/Boku_no_Hero_Academia',
    },
    {
        'mal_id': 22319,
        'title': 'Tokyo Ghoul',
        'title_english': 'Tokyo Ghoul',
        'title_japanese': '東京喰種トーキョーグール',
        'url': 'https://myanimelist.net/anime/22319/Tokyo_Ghoul',
    },
    {
        'mal_id': 249,
        'title': 'InuYasha',
        'title_english': 'Inuyasha',
        'title_japanese': '犬夜叉',
        'url': 'https://myanimelist.net/anime/249/InuYasha',
    },
]

enrichment_updates = {
    '13': {'tags': ['black_hair', 'uses_sword', 'has_tragic_past', 'rival', 'fast', 'super_powers', 'young']},
    '45627': {'tags': ['black_hair', 'uses_sword', 'has_tragic_past', 'fast', 'strong', 'stoic', 'hero']},
    '5': {'tags': ['protagonist', 'has_transformation', 'hero', 'strong', 'fast', 'super_powers', 'young']},
    '3202': {'tags': ['protagonist', 'uses_sword', 'has_transformation', 'strong', 'fast', 'super_powers', 'young']},
    '465': {'tags': ['black_hair', 'villain', 'has_transformation', 'non_human', 'strong', 'fast', 'muscular', 'super_powers', 'super_saiyan', 'alien', 'martial_artist', 'rival']},
    '2547': {'tags': ['villain', 'has_transformation', 'non_human', 'strong', 'fast', 'super_powers', 'alien']},
    '17': {'tags': ['protagonist', 'has_tragic_past', 'hero', 'young', 'fast', 'super_powers']},
    '62': {'tags': ['uses_sword', 'has_tragic_past', 'strong', 'fast', 'muscular']},
    '423': {'tags': ['protagonist', 'has_transformation', 'non_human', 'hero', 'strong', 'fast', 'muscular', 'super_powers', 'super_saiyan', 'alien', 'martial_artist']},
    '40882': {'tags': ['protagonist', 'has_transformation', 'has_tragic_past', 'young', 'strong', 'fast', 'super_powers']},
    '14492': {'tags': ['black_hair', 'villain', 'has_tragic_past', 'strong', 'fast', 'super_powers', 'strategist']},
    '349': {'tags': ['black_hair', 'villain', 'has_transformation', 'strong', 'super_powers', 'strategist']},
    '146715': {'tags': ['black_hair', 'protagonist', 'has_tragic_past', 'uses_sword', 'young', 'hero', 'fast']},
    '146975': {'tags': ['black_hair', 'non_human', 'has_transformation', 'has_tragic_past', 'young', 'strong', 'fast', 'demon']},
    '85': {
        'series': '',
        'animeMalId': 20,
        'tags': ['white_hair', 'mentor', 'strong', 'fast', 'strategist', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Copy Ninja Kakashi'],
        'sourceReference': 'https://myanimelist.net/character/85/Kakashi_Hatake',
        'importNotes': 'Expanded mentor and strategy batch import.',
        'image': None,
    },
    '14': {
        'series': '',
        'animeMalId': 20,
        'tags': ['black_hair', 'rival', 'has_tragic_past', 'strategist', 'super_powers', 'fast'],
        'difficulty': 'hard',
        'aliases': ['Itachi'],
        'sourceReference': 'https://myanimelist.net/character/14/Itachi_Uchiha',
        'importNotes': 'Expanded tragic strategist batch import.',
        'image': None,
    },
    '164471': {
        'series': '',
        'animeMalId': 40748,
        'tags': ['white_hair', 'mentor', 'strong', 'fast', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Gojo'],
        'sourceReference': 'https://myanimelist.net/character/164471/Satoru_Gojo',
        'importNotes': 'Expanded mentor and power batch import.',
        'image': None,
    },
    '11': {
        'series': '',
        'animeMalId': 5114,
        'tags': ['protagonist', 'young', 'strong', 'fast', 'super_powers', 'has_tragic_past'],
        'difficulty': 'easy',
        'aliases': ['Ed'],
        'sourceReference': 'https://myanimelist.net/character/11/Edward_Elric',
        'importNotes': 'Expanded young protagonist batch import.',
        'image': None,
    },
    '12': {
        'series': '',
        'animeMalId': 5114,
        'tags': ['black_hair', 'hero', 'strategist', 'fire_user', 'super_powers'],
        'difficulty': 'medium',
        'aliases': ['Flame Alchemist'],
        'sourceReference': 'https://myanimelist.net/character/12/Roy_Mustang',
        'importNotes': 'Expanded fire strategist batch import.',
        'image': None,
    },
    '117909': {
        'series': '',
        'animeMalId': 31964,
        'tags': ['hero', 'mentor', 'strong', 'fast', 'muscular', 'super_powers'],
        'difficulty': 'easy',
        'aliases': ['Symbol of Peace'],
        'sourceReference': 'https://myanimelist.net/character/117909/All_Might',
        'importNotes': 'Expanded hero mentor batch import.',
        'image': None,
    },
    '117911': {
        'series': '',
        'animeMalId': 31964,
        'tags': ['hero', 'young', 'fire_user', 'ice_user', 'has_tragic_past', 'strong'],
        'difficulty': 'medium',
        'aliases': ['Shoto'],
        'sourceReference': 'https://myanimelist.net/character/117911/Shoto_Todoroki',
        'importNotes': 'Expanded dual-element batch import.',
        'image': None,
    },
    '87275': {
        'series': '',
        'animeMalId': 22319,
        'tags': ['black_hair', 'young', 'has_transformation', 'non_human', 'has_tragic_past', 'fast', 'strong'],
        'difficulty': 'medium',
        'aliases': ['Kaneki'],
        'sourceReference': 'https://myanimelist.net/character/87275/Ken_Kaneki',
        'importNotes': 'Expanded transformation tragedy batch import.',
        'image': None,
    },
    '158': {
        'series': '',
        'animeMalId': 249,
        'tags': ['white_hair', 'uses_sword', 'demon', 'strong', 'fast', 'has_tragic_past'],
        'difficulty': 'medium',
        'aliases': ['Half-Demon'],
        'sourceReference': 'https://myanimelist.net/character/158/Inuyasha',
        'importNotes': 'Expanded demon sword batch import.',
        'image': None,
    },
    '40881': {
        'series': '',
        'animeMalId': 16498,
        'tags': ['black_hair', 'hero', 'strong', 'fast', 'stoic', 'has_tragic_past'],
        'difficulty': 'medium',
        'aliases': ['Mikasa'],
        'sourceReference': 'https://myanimelist.net/character/40881/Mikasa_Ackerman',
        'importNotes': 'Expanded stoic hero batch import.',
        'image': None,
    },
}

approval_batch = [
    {'malId': 85, 'transformedId': 'kakashi_hatake', 'approvalStatus': 'approved', 'notes': 'Approved for runtime mentor strategy coverage.'},
    {'malId': 14, 'transformedId': 'itachi_uchiha', 'approvalStatus': 'approved', 'notes': 'Approved for runtime rival strategist coverage.'},
    {'malId': 164471, 'transformedId': 'satoru_gojo', 'approvalStatus': 'approved', 'notes': 'Approved for runtime power and mentor coverage.'},
    {'malId': 11, 'transformedId': 'edward_elric', 'approvalStatus': 'approved', 'notes': 'Approved for runtime young protagonist coverage.'},
    {'malId': 12, 'transformedId': 'roy_mustang', 'approvalStatus': 'approved', 'notes': 'Approved for runtime fire strategist coverage.'},
    {'malId': 117909, 'transformedId': 'all_might', 'approvalStatus': 'approved', 'notes': 'Approved for runtime hero mentor coverage.'},
    {'malId': 117911, 'transformedId': 'shoto_todoroki', 'approvalStatus': 'approved', 'notes': 'Approved for runtime elemental hero coverage.'},
    {'malId': 87275, 'transformedId': 'ken_kaneki', 'approvalStatus': 'approved', 'notes': 'Approved for runtime transformation tragedy coverage.'},
    {'malId': 158, 'transformedId': 'inuyasha', 'approvalStatus': 'approved', 'notes': 'Approved for runtime demon sword coverage.'},
    {'malId': 40881, 'transformedId': 'mikasa_ackerman', 'approvalStatus': 'approved', 'notes': 'Approved for runtime stoic hero coverage.'},
]

original_character_tag_updates = {
    'shadow_ninja': ['black_hair', 'uses_sword', 'has_tragic_past', 'fast', 'strategist'],
    'solar_fighter': ['protagonist', 'has_transformation', 'hero', 'strong', 'fast', 'super_powers'],
    'crimson_emperor': ['villain', 'has_transformation', 'non_human', 'strong', 'super_powers'],
    'white_blade_master': ['white_hair', 'uses_sword', 'mentor', 'strategist'],
    'void_beast': ['villain', 'non_human', 'has_transformation', 'strong'],
    'ember_ronin': ['black_hair', 'uses_sword', 'protagonist', 'hero', 'young', 'fast'],
    'lunar_oracle': ['white_hair', 'protagonist', 'has_tragic_past', 'super_powers'],
    'iron_revenant': ['villain', 'black_hair', 'has_transformation', 'strong'],
    'storm_samurai': ['black_hair', 'uses_sword', 'protagonist', 'hero', 'fast'],
    'eclipse_dragon': ['villain', 'non_human', 'has_transformation', 'strong', 'super_powers'],
    'blaze_guardian': ['protagonist', 'has_transformation', 'black_hair', 'hero', 'super_powers', 'strong'],
    'abyss_duelist': ['villain', 'uses_sword', 'black_hair', 'rival', 'fast'],
}


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
for key, value in enrichment_updates.items():
    current = enrichment.get(key, {})
    current.update(value)
    enrichment[key] = current
ordered_enrichment = {key: enrichment[key] for key in sorted(enrichment, key=lambda item: int(item))}
write_json(enrichment_path, ordered_enrichment)

approval_path = imports / 'characters_import_approval.json'
approvals = load_json(approval_path)
approval_by_id = {item['transformedId']: item for item in approvals}
for item in approval_batch:
    approval_by_id[item['transformedId']] = item
write_json(approval_path, list(approval_by_id.values()))

runtime_path = root / 'characters.json'
runtime_characters = load_json(runtime_path)
for character in runtime_characters:
    if character['id'] in original_character_tag_updates:
        character['tags'] = original_character_tag_updates[character['id']]
write_json(runtime_path, runtime_characters)

print('updated tags, source data, enrichments, approvals, anime sample, and original runtime tags')
