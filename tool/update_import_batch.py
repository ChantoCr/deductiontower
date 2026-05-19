import json
from pathlib import Path

base = Path('assets/data/imports')

new_characters = [
    {
        'mal_id': 17,
        'name': 'Naruto Uzumaki',
        'name_kanji': 'うずまきナルト',
        'nicknames': ['Number One Hyperactive Knucklehead Ninja'],
        'favorites': 61234,
        'about': 'A lead character driven by a painful past and relentless resolve.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/naruto.jpg',
        'url': 'https://myanimelist.net/character/17/Naruto_Uzumaki',
    },
    {
        'mal_id': 62,
        'name': 'Roronoa Zoro',
        'name_kanji': 'ロロノア・ゾロ',
        'nicknames': ['Pirate Hunter'],
        'favorites': 44120,
        'about': 'A swordsman famed for swordsmanship, bladed combat, and a severe personal history.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/zoro.jpg',
        'url': 'https://myanimelist.net/character/62/Roronoa_Zoro',
    },
    {
        'mal_id': 423,
        'name': 'Goku',
        'name_kanji': '孫悟空',
        'nicknames': ['Kakarot'],
        'favorites': 95840,
        'about': 'A Saiyan lead character with multiple transformations and alien heritage.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/goku.jpg',
        'url': 'https://myanimelist.net/character/423/Goku',
    },
    {
        'mal_id': 40882,
        'name': 'Eren Yeager',
        'name_kanji': 'エレン・イェーガー',
        'nicknames': ['Eren Jaeger'],
        'favorites': 60315,
        'about': 'A main character haunted by loss who gains multiple transformation forms.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/eren.jpg',
        'url': 'https://myanimelist.net/character/40882/Eren_Yeager',
    },
    {
        'mal_id': 14492,
        'name': 'Madara Uchiha',
        'name_kanji': 'うちはマダラ',
        'nicknames': ['Ghost of the Uchiha'],
        'favorites': 28754,
        'about': 'A black-haired antagonist with a tragic history and overwhelming presence.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/madara.jpg',
        'url': 'https://myanimelist.net/character/14492/Madara_Uchiha',
    },
    {
        'mal_id': 349,
        'name': 'Sousuke Aizen',
        'name_kanji': '藍染惣右介',
        'nicknames': ['Aizen'],
        'favorites': 33110,
        'about': 'A black-haired villain who transforms and manipulates events from the shadows.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/aizen.jpg',
        'url': 'https://myanimelist.net/character/349/Sousuke_Aizen',
    },
    {
        'mal_id': 146715,
        'name': 'Tanjiro Kamado',
        'name_kanji': '竈門炭治郎',
        'nicknames': ['Tanjiro'],
        'favorites': 51890,
        'about': 'A black-haired lead character marked by a traumatic past.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/tanjiro.jpg',
        'url': 'https://myanimelist.net/character/146715/Tanjiro_Kamado',
    },
    {
        'mal_id': 146975,
        'name': 'Nezuko Kamado',
        'name_kanji': '竈門禰豆子',
        'nicknames': ['Nezuko'],
        'favorites': 47220,
        'about': 'A black-haired non-human girl with transformation-like states and a tragic past.',
        'main_picture': 'https://cdn.myanimelist.net/images/characters/sample/nezuko.jpg',
        'url': 'https://myanimelist.net/character/146975/Nezuko_Kamado',
    },
]

new_enrichments = {
    '17': {
        'series': '',
        'animeMalId': 20,
        'tags': ['protagonist', 'has_tragic_past'],
        'difficulty': 'easy',
        'aliases': ['Naruto'],
        'sourceReference': 'https://myanimelist.net/character/17/Naruto_Uzumaki',
        'importNotes': 'Approved batch import for protagonist and tragic-past overlap.',
        'image': None,
    },
    '62': {
        'series': '',
        'animeMalId': 21,
        'tags': ['uses_sword', 'has_tragic_past'],
        'difficulty': 'medium',
        'aliases': ['Pirate Hunter Zoro'],
        'sourceReference': 'https://myanimelist.net/character/62/Roronoa_Zoro',
        'importNotes': 'Approved batch import for sword-heavy roster expansion.',
        'image': None,
    },
    '423': {
        'series': '',
        'animeMalId': 223,
        'tags': ['protagonist', 'has_transformation', 'non_human'],
        'difficulty': 'easy',
        'aliases': ['Kakarot'],
        'sourceReference': 'https://myanimelist.net/character/423/Goku',
        'importNotes': 'Approved batch import for protagonist transformation coverage.',
        'image': None,
    },
    '40882': {
        'series': '',
        'animeMalId': 16498,
        'tags': ['protagonist', 'has_transformation', 'has_tragic_past'],
        'difficulty': 'medium',
        'aliases': ['Eren Jaeger'],
        'sourceReference': 'https://myanimelist.net/character/40882/Eren_Yeager',
        'importNotes': 'Approved batch import for tragic transformation overlap.',
        'image': None,
    },
    '14492': {
        'series': '',
        'animeMalId': 20,
        'tags': ['black_hair', 'villain', 'has_tragic_past'],
        'difficulty': 'hard',
        'aliases': ['Ghost of the Uchiha'],
        'sourceReference': 'https://myanimelist.net/character/14492/Madara_Uchiha',
        'importNotes': 'Approved batch import for villain and black-hair overlap.',
        'image': None,
    },
    '349': {
        'series': '',
        'animeMalId': 269,
        'tags': ['black_hair', 'villain', 'has_transformation'],
        'difficulty': 'hard',
        'aliases': ['Aizen'],
        'sourceReference': 'https://myanimelist.net/character/349/Sousuke_Aizen',
        'importNotes': 'Approved batch import for villain transformation overlap.',
        'image': None,
    },
    '146715': {
        'series': '',
        'animeMalId': 38000,
        'tags': ['black_hair', 'protagonist', 'has_tragic_past'],
        'difficulty': 'easy',
        'aliases': ['Tanjiro'],
        'sourceReference': 'https://myanimelist.net/character/146715/Tanjiro_Kamado',
        'importNotes': 'Approved batch import for protagonist tragic-past overlap.',
        'image': None,
    },
    '146975': {
        'series': '',
        'animeMalId': 38000,
        'tags': ['black_hair', 'non_human', 'has_transformation', 'has_tragic_past'],
        'difficulty': 'medium',
        'aliases': ['Nezuko'],
        'sourceReference': 'https://myanimelist.net/character/146975/Nezuko_Kamado',
        'importNotes': 'Approved batch import for non-human tragic transformation overlap.',
        'image': None,
    },
}

new_approvals = [
    {
        'malId': 17,
        'transformedId': 'naruto_uzumaki',
        'approvalStatus': 'approved',
        'notes': 'Approved for runtime protagonist and tragic-past coverage.',
    },
    {
        'malId': 62,
        'transformedId': 'roronoa_zoro',
        'approvalStatus': 'approved',
        'notes': 'Approved for runtime sword and tragic-past coverage.',
    },
    {
        'malId': 423,
        'transformedId': 'goku',
        'approvalStatus': 'approved',
        'notes': 'Approved for runtime protagonist, transformation, and non-human coverage.',
    },
    {
        'malId': 40882,
        'transformedId': 'eren_yeager',
        'approvalStatus': 'approved',
        'notes': 'Approved for runtime tragic transformation coverage.',
    },
    {
        'malId': 14492,
        'transformedId': 'madara_uchiha',
        'approvalStatus': 'approved',
        'notes': 'Approved for runtime villain and black-hair coverage.',
    },
    {
        'malId': 349,
        'transformedId': 'sousuke_aizen',
        'approvalStatus': 'approved',
        'notes': 'Approved for runtime villain transformation coverage.',
    },
    {
        'malId': 146715,
        'transformedId': 'tanjiro_kamado',
        'approvalStatus': 'approved',
        'notes': 'Approved for runtime protagonist tragic-past coverage.',
    },
    {
        'malId': 146975,
        'transformedId': 'nezuko_kamado',
        'approvalStatus': 'approved',
        'notes': 'Approved for runtime non-human transformation coverage.',
    },
]

new_anime = {
    38000: {
        'mal_id': 38000,
        'title': 'Kimetsu no Yaiba',
        'title_english': 'Demon Slayer: Kimetsu no Yaiba',
        'title_japanese': '鬼滅の刃',
        'url': 'https://myanimelist.net/anime/38000/Kimetsu_no_Yaiba',
    },
}

for filename, extra in [
    ('mal_jikan_characters_sample.json', new_characters),
    ('characters_import_approval.json', new_approvals),
]:
    path = base / filename
    data = json.loads(path.read_text(encoding='utf-8'))
    existing_ids = {item['mal_id'] if 'mal_id' in item else item['transformedId'] for item in data}
    for item in extra:
        key = item['mal_id'] if 'mal_id' in item else item['transformedId']
        if key not in existing_ids:
            data.append(item)
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')

path = base / 'mal_jikan_character_enrichment_preview.json'
data = json.loads(path.read_text(encoding='utf-8'))
for key, value in new_enrichments.items():
    data[key] = value
ordered = {key: data[key] for key in sorted(data, key=lambda item: int(item))}
path.write_text(json.dumps(ordered, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')

path = base / 'mal_jikan_anime_sample.json'
data = json.loads(path.read_text(encoding='utf-8'))
existing = {item['mal_id'] for item in data}
for key, value in new_anime.items():
    if key not in existing:
        data.append(value)
path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')

print('updated import source/anime/enrichment/approval assets with next character batch')
