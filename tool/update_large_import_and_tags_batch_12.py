import json
import re
from pathlib import Path

root = Path('assets/data')
imports = root / 'imports'


def load_json(path: Path):
    return json.loads(path.read_text(encoding='utf-8'))


def write_json(path: Path, data):
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


def slugify(value: str) -> str:
    return re.sub(r'_+', '_', re.sub(r'[^a-z0-9]+', '_', value.lower())).strip('_')


def url_name(value: str) -> str:
    return re.sub(r'_+', '_', re.sub(r'[^A-Za-z0-9]+', '_', value)).strip('_')


def build_about(name: str, tags: list[str]) -> str:
    descriptors = []
    for tag, text in [
        ('black_hair', 'black-haired'),
        ('white_hair', 'white-haired'),
        ('blond_hair', 'blond-haired'),
        ('pink_hair', 'pink-haired'),
        ('brown_hair', 'brown-haired'),
        ('red_hair', 'red-haired'),
        ('blue_hair', 'blue-haired'),
        ('green_hair', 'green-haired'),
        ('purple_hair', 'purple-haired'),
        ('young', 'young'),
        ('student', 'student'),
        ('stoic', 'stoic'),
        ('non_human', 'non-human'),
        ('cyborg', 'cyborg'),
    ]:
        if tag in tags:
            descriptors.append(text)

    roles = []
    for tag, text in [
        ('protagonist', 'protagonist'),
        ('hero', 'hero'),
        ('villain', 'villain'),
        ('mentor', 'mentor'),
        ('rival', 'rival'),
        ('leader', 'leader'),
        ('assassin', 'assassin'),
        ('strategist', 'strategist'),
        ('martial_artist', 'martial artist'),
    ]:
        if tag in tags:
            roles.append(text)

    abilities = []
    for tag, text in [
        ('uses_sword', 'sword combat'),
        ('gun_user', 'gunfighting'),
        ('has_transformation', 'transformation powers'),
        ('psychic', 'psychic power'),
        ('fire_user', 'fire techniques'),
        ('ice_user', 'ice techniques'),
        ('lightning_user', 'lightning techniques'),
        ('water_user', 'water techniques'),
        ('magic_user', 'magic'),
        ('super_powers', 'supernatural abilities'),
        ('strong', 'great strength'),
        ('fast', 'extreme speed'),
        ('has_tragic_past', 'a tragic past'),
        ('demon', 'demonic power'),
        ('alien', 'alien power'),
    ]:
        if tag in tags:
            abilities.append(text)

    intro_parts = descriptors + (roles[:2] if roles else ['fighter'])
    intro = ' '.join(intro_parts).strip() or 'fighter'

    if abilities:
        if len(abilities) == 1:
            ability_text = abilities[0]
        else:
            ability_text = ', '.join(abilities[:-1]) + ', and ' + abilities[-1]
        return f'{name} is a {intro} known for {ability_text}.'

    return f'{name} is a {intro}.'


def build_character_entry(mal_id: int, name: str, tags: list[str], favorites: int, alias: str | None):
    slug = slugify(name)
    return {
        'mal_id': mal_id,
        'name': name,
        'name_kanji': None,
        'nicknames': [alias] if alias else [],
        'favorites': favorites,
        'about': build_about(name, tags),
        'main_picture': f'https://cdn.myanimelist.net/images/characters/sample/{slug}.jpg',
        'url': f'https://myanimelist.net/character/{mal_id}/{url_name(name)}',
    }


def build_enrichment_entry(mal_id: int, anime_mal_id: int, tags: list[str], difficulty: str, alias: str | None, name: str):
    return {
        'series': '',
        'animeMalId': anime_mal_id,
        'tags': tags,
        'difficulty': difficulty,
        'aliases': [alias] if alias else [],
        'sourceReference': f'https://myanimelist.net/character/{mal_id}/{url_name(name)}',
        'importNotes': 'High-throughput approved batch staging with richer reviewed tags.',
        'image': None,
    }


tag_definition = {
    'id': 'purple_hair',
    'label': 'Purple Hair',
    'type': 'appearance',
    'difficulty': 'easy',
}

characters = [
    {'mal_id': 991001, 'name': 'Anko Mitarashi', 'anime_mal_id': 20, 'tags': ['hero', 'purple_hair', 'strategist', 'super_powers', 'strong'], 'difficulty': 'medium', 'alias': 'Anko'},
    {'mal_id': 991002, 'name': 'Konohamaru Sarutobi', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'student', 'brown_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Konohamaru'},
    {'mal_id': 991003, 'name': 'Yugito Nii', 'anime_mal_id': 20, 'tags': ['hero', 'black_hair', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yugito'},
    {'mal_id': 991004, 'name': 'Fuu', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'green_hair', 'has_transformation', 'super_powers', 'fast'], 'difficulty': 'medium', 'alias': 'Fuu'},
    {'mal_id': 991005, 'name': 'Utakata', 'anime_mal_id': 20, 'tags': ['hero', 'blue_hair', 'water_user', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Utakata'},
    {'mal_id': 991006, 'name': 'Darui', 'anime_mal_id': 20, 'tags': ['hero', 'black_hair', 'lightning_user', 'strategist', 'strong'], 'difficulty': 'medium', 'alias': 'Darui'},
    {'mal_id': 991007, 'name': 'Samui', 'anime_mal_id': 20, 'tags': ['hero', 'blond_hair', 'strategist', 'strong'], 'difficulty': 'easy', 'alias': 'Samui'},
    {'mal_id': 991008, 'name': 'Mabui', 'anime_mal_id': 20, 'tags': ['hero', 'black_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Mabui'},
    {'mal_id': 991009, 'name': 'Pakura', 'anime_mal_id': 20, 'tags': ['hero', 'red_hair', 'fire_user', 'has_tragic_past', 'strong'], 'difficulty': 'medium', 'alias': 'Pakura'},
    {'mal_id': 991010, 'name': 'Guren', 'anime_mal_id': 20, 'tags': ['hero', 'purple_hair', 'strategist', 'super_powers', 'strong'], 'difficulty': 'medium', 'alias': 'Guren'},
    {'mal_id': 991011, 'name': 'Jewelry Bonney', 'anime_mal_id': 21, 'tags': ['rival', 'pink_hair', 'young', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Bonney'},
    {'mal_id': 991012, 'name': 'Urouge', 'anime_mal_id': 21, 'tags': ['rival', 'muscular', 'strong', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Urouge'},
    {'mal_id': 991013, 'name': 'Scratchmen Apoo', 'anime_mal_id': 21, 'tags': ['villain', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Apoo'},
    {'mal_id': 991014, 'name': 'Vista', 'anime_mal_id': 21, 'tags': ['hero', 'uses_sword', 'leader', 'strong'], 'difficulty': 'medium', 'alias': 'Vista'},
    {'mal_id': 991015, 'name': 'Pell', 'anime_mal_id': 21, 'tags': ['hero', 'has_transformation', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Pell'},
    {'mal_id': 991016, 'name': 'Rebecca', 'anime_mal_id': 21, 'tags': ['hero', 'young', 'pink_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Rebecca'},
    {'mal_id': 991017, 'name': 'Viola', 'anime_mal_id': 21, 'tags': ['hero', 'purple_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Viola'},
    {'mal_id': 991018, 'name': 'Pica', 'anime_mal_id': 21, 'tags': ['villain', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Pica'},
    {'mal_id': 991019, 'name': 'Senor Pink', 'anime_mal_id': 21, 'tags': ['villain', 'pink_hair', 'strong', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Senor Pink'},
    {'mal_id': 991020, 'name': 'Charlotte Cracker', 'anime_mal_id': 21, 'tags': ['villain', 'blond_hair', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Cracker'},
    {'mal_id': 991021, 'name': 'Nanao Ise', 'anime_mal_id': 269, 'tags': ['hero', 'black_hair', 'strategist', 'leader'], 'difficulty': 'medium', 'alias': 'Nanao'},
    {'mal_id': 991022, 'name': 'Hanatarou Yamada', 'anime_mal_id': 269, 'tags': ['hero', 'brown_hair', 'young', 'strategist'], 'difficulty': 'easy', 'alias': 'Hanatarou'},
    {'mal_id': 991023, 'name': 'Apache', 'anime_mal_id': 269, 'tags': ['villain', 'blond_hair', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Apache'},
    {'mal_id': 991024, 'name': 'Mila Rose', 'anime_mal_id': 269, 'tags': ['villain', 'pink_hair', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mila Rose'},
    {'mal_id': 991025, 'name': 'Sun-Sun', 'anime_mal_id': 269, 'tags': ['villain', 'green_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Sun-Sun'},
    {'mal_id': 991026, 'name': 'Gremmy Thoumeaux', 'anime_mal_id': 269, 'tags': ['villain', 'blond_hair', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Gremmy'},
    {'mal_id': 991027, 'name': 'Jugram Haschwalth', 'anime_mal_id': 269, 'tags': ['villain', 'blond_hair', 'strategist', 'strong'], 'difficulty': 'hard', 'alias': 'Jugram'},
    {'mal_id': 991028, 'name': 'Gerard Valkyrie', 'anime_mal_id': 269, 'tags': ['villain', 'red_hair', 'leader', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Gerard'},
    {'mal_id': 991029, 'name': 'Pernida Parnkgjas', 'anime_mal_id': 269, 'tags': ['villain', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Pernida'},
    {'mal_id': 991030, 'name': 'Lille Barro', 'anime_mal_id': 269, 'tags': ['villain', 'black_hair', 'gun_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Lille'},
    {'mal_id': 991031, 'name': 'Yajirobe', 'anime_mal_id': 223, 'tags': ['hero', 'black_hair', 'martial_artist', 'strong'], 'difficulty': 'easy', 'alias': 'Yajirobe'},
    {'mal_id': 991032, 'name': 'Chi-Chi', 'anime_mal_id': 223, 'tags': ['hero', 'black_hair', 'martial_artist', 'strong'], 'difficulty': 'easy', 'alias': 'Chi-Chi'},
    {'mal_id': 991033, 'name': 'Launch', 'anime_mal_id': 223, 'tags': ['hero', 'blue_hair', 'gun_user', 'has_transformation'], 'difficulty': 'medium', 'alias': 'Launch'},
    {'mal_id': 991034, 'name': 'Supreme Kai', 'anime_mal_id': 223, 'tags': ['hero', 'white_hair', 'strategist', 'leader', 'non_human', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shin'},
    {'mal_id': 991035, 'name': 'Kibito', 'anime_mal_id': 223, 'tags': ['hero', 'white_hair', 'strong', 'super_powers', 'non_human'], 'difficulty': 'medium', 'alias': 'Kibito'},
    {'mal_id': 991036, 'name': 'Old Kai', 'anime_mal_id': 223, 'tags': ['mentor', 'white_hair', 'strategist', 'super_powers', 'non_human'], 'difficulty': 'medium', 'alias': 'Old Kai'},
    {'mal_id': 991037, 'name': 'Babidi', 'anime_mal_id': 223, 'tags': ['villain', 'strategist', 'super_powers', 'non_human'], 'difficulty': 'medium', 'alias': 'Babidi'},
    {'mal_id': 991038, 'name': 'Garlic Jr.', 'anime_mal_id': 223, 'tags': ['villain', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Garlic Jr.'},
    {'mal_id': 991039, 'name': 'Cooler', 'anime_mal_id': 223, 'tags': ['villain', 'has_transformation', 'alien', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Cooler'},
    {'mal_id': 991040, 'name': 'Janemba', 'anime_mal_id': 223, 'tags': ['villain', 'demon', 'has_transformation', 'super_powers', 'non_human'], 'difficulty': 'hard', 'alias': 'Janemba'},
    {'mal_id': 991041, 'name': 'Mashirao Ojiro', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'martial_artist', 'strong'], 'difficulty': 'easy', 'alias': 'Ojiro'},
    {'mal_id': 991042, 'name': 'Toru Hagakure', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'fast', 'super_powers'], 'difficulty': 'easy', 'alias': 'Toru'},
    {'mal_id': 991043, 'name': 'Minoru Mineta', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'purple_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Mineta'},
    {'mal_id': 991044, 'name': 'Neito Monoma', 'anime_mal_id': 31964, 'tags': ['rival', 'young', 'student', 'blond_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Monoma'},
    {'mal_id': 991045, 'name': 'Itsuka Kendo', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'brown_hair', 'strong', 'super_powers'], 'difficulty': 'easy', 'alias': 'Kendo'},
    {'mal_id': 991046, 'name': 'Tetsutetsu Tetsutetsu', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'muscular', 'strong', 'super_powers'], 'difficulty': 'easy', 'alias': 'Tetsutetsu'},
    {'mal_id': 991047, 'name': 'Midnight', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'purple_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Midnight'},
    {'mal_id': 991048, 'name': 'Edgeshot', 'anime_mal_id': 31964, 'tags': ['hero', 'black_hair', 'fast', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Edgeshot'},
    {'mal_id': 991049, 'name': 'Mirko', 'anime_mal_id': 31964, 'tags': ['hero', 'white_hair', 'non_human', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Mirko'},
    {'mal_id': 991050, 'name': 'Gran Torino', 'anime_mal_id': 31964, 'tags': ['mentor', 'strategist', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gran Torino'},
    {'mal_id': 991051, 'name': 'Yuki Tsukumo', 'anime_mal_id': 40748, 'tags': ['mentor', 'hero', 'blond_hair', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Yuki'},
    {'mal_id': 991052, 'name': 'Shiu Kong', 'anime_mal_id': 40748, 'tags': ['villain', 'strategist', 'gun_user', 'black_hair'], 'difficulty': 'medium', 'alias': 'Shiu'},
    {'mal_id': 991053, 'name': 'Takako Uro', 'anime_mal_id': 40748, 'tags': ['villain', 'white_hair', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Uro'},
    {'mal_id': 991054, 'name': 'Ryu Ishigori', 'anime_mal_id': 40748, 'tags': ['rival', 'white_hair', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ryu'},
    {'mal_id': 991055, 'name': 'Hiromi Higuruma', 'anime_mal_id': 40748, 'tags': ['rival', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Higuruma'},
    {'mal_id': 991056, 'name': 'Naoya Zenin', 'anime_mal_id': 40748, 'tags': ['villain', 'blond_hair', 'fast', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Naoya'},
    {'mal_id': 991057, 'name': 'Reggie Star', 'anime_mal_id': 40748, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Reggie'},
    {'mal_id': 991058, 'name': 'Hana Kurusu', 'anime_mal_id': 40748, 'tags': ['hero', 'young', 'blond_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hana'},
    {'mal_id': 991059, 'name': 'Miguel', 'anime_mal_id': 40748, 'tags': ['rival', 'strong', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Miguel'},
    {'mal_id': 991060, 'name': 'Manami Suda', 'anime_mal_id': 40748, 'tags': ['villain', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Manami'},
    {'mal_id': 991061, 'name': 'Grey', 'anime_mal_id': 34572, 'tags': ['hero', 'brown_hair', 'has_transformation', 'super_powers'], 'difficulty': 'easy', 'alias': 'Grey'},
    {'mal_id': 991062, 'name': 'Revchi Salik', 'anime_mal_id': 34572, 'tags': ['villain', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Revchi'},
    {'mal_id': 991063, 'name': 'Valtos', 'anime_mal_id': 34572, 'tags': ['villain', 'purple_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Valtos'},
    {'mal_id': 991064, 'name': 'Fanzell Kruger', 'anime_mal_id': 34572, 'tags': ['mentor', 'uses_sword', 'strong', 'strategist'], 'difficulty': 'medium', 'alias': 'Fanzell'},
    {'mal_id': 991065, 'name': 'Dominante Code', 'anime_mal_id': 34572, 'tags': ['villain', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Dominante'},
    {'mal_id': 991066, 'name': 'Letoile Becquerel', 'anime_mal_id': 34572, 'tags': ['hero', 'brown_hair', 'strategist', 'magic_user'], 'difficulty': 'medium', 'alias': 'Letoile'},
    {'mal_id': 991067, 'name': 'Fragil Tormenta', 'anime_mal_id': 34572, 'tags': ['hero', 'blue_hair', 'young', 'magic_user'], 'difficulty': 'easy', 'alias': 'Fragil'},
    {'mal_id': 991068, 'name': 'Svenkin Gatard', 'anime_mal_id': 34572, 'tags': ['villain', 'muscular', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Svenkin'},
    {'mal_id': 991069, 'name': 'Vanica Zogratis', 'anime_mal_id': 34572, 'tags': ['villain', 'purple_hair', 'strong', 'super_powers', 'has_transformation'], 'difficulty': 'hard', 'alias': 'Vanica'},
    {'mal_id': 991070, 'name': 'Gadjah', 'anime_mal_id': 34572, 'tags': ['hero', 'mentor', 'lightning_user', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gadjah'},
    {'mal_id': 991071, 'name': 'Baise', 'anime_mal_id': 11061, 'tags': ['hero', 'blond_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Baise'},
    {'mal_id': 991072, 'name': 'Shizuku Murasaki', 'anime_mal_id': 11061, 'tags': ['villain', 'purple_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shizuku'},
    {'mal_id': 991073, 'name': 'Binolt', 'anime_mal_id': 11061, 'tags': ['villain', 'brown_hair', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Binolt'},
    {'mal_id': 991074, 'name': 'Abengane', 'anime_mal_id': 11061, 'tags': ['hero', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Abengane'},
    {'mal_id': 991075, 'name': 'Cheadle Yorkshire', 'anime_mal_id': 11061, 'tags': ['mentor', 'strategist', 'blond_hair', 'leader'], 'difficulty': 'medium', 'alias': 'Cheadle'},
    {'mal_id': 991076, 'name': 'Pariston Hill', 'anime_mal_id': 11061, 'tags': ['villain', 'strategist', 'blond_hair', 'leader'], 'difficulty': 'hard', 'alias': 'Pariston'},
    {'mal_id': 991077, 'name': 'Zushi', 'anime_mal_id': 11061, 'tags': ['hero', 'young', 'student', 'martial_artist', 'strong'], 'difficulty': 'easy', 'alias': 'Zushi'},
    {'mal_id': 991078, 'name': 'Basho', 'anime_mal_id': 11061, 'tags': ['hero', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Basho'},
    {'mal_id': 991079, 'name': 'Leol', 'anime_mal_id': 11061, 'tags': ['villain', 'non_human', 'leader', 'super_powers'], 'difficulty': 'medium', 'alias': 'Leol'},
    {'mal_id': 991080, 'name': 'Zazan', 'anime_mal_id': 11061, 'tags': ['villain', 'non_human', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Zazan'},
    {'mal_id': 991081, 'name': 'Nanaba', 'anime_mal_id': 16498, 'tags': ['hero', 'blond_hair', 'strong', 'fast'], 'difficulty': 'easy', 'alias': 'Nanaba'},
    {'mal_id': 991082, 'name': 'Gelgar', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Gelgar'},
    {'mal_id': 991083, 'name': 'Miche Zacharius', 'anime_mal_id': 16498, 'tags': ['mentor', 'hero', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Miche'},
    {'mal_id': 991084, 'name': 'Oluo Bozado', 'anime_mal_id': 16498, 'tags': ['hero', 'black_hair', 'fast'], 'difficulty': 'easy', 'alias': 'Oluo'},
    {'mal_id': 991085, 'name': 'Eld Jinn', 'anime_mal_id': 16498, 'tags': ['hero', 'black_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Eld'},
    {'mal_id': 991086, 'name': 'Gunther Schultz', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'fast'], 'difficulty': 'easy', 'alias': 'Gunther'},
    {'mal_id': 991087, 'name': 'Nifa', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'gun_user'], 'difficulty': 'easy', 'alias': 'Nifa'},
    {'mal_id': 991088, 'name': 'Hitch Dreyse', 'anime_mal_id': 16498, 'tags': ['hero', 'blond_hair', 'young', 'strategist'], 'difficulty': 'easy', 'alias': 'Hitch'},
    {'mal_id': 991089, 'name': 'Carla Yeager', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Carla'},
    {'mal_id': 991090, 'name': 'Hannes', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'has_tragic_past', 'strategist'], 'difficulty': 'easy', 'alias': 'Hannes'},
    {'mal_id': 991091, 'name': 'Denny Brosh', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'gun_user'], 'difficulty': 'easy', 'alias': 'Denny'},
    {'mal_id': 991092, 'name': 'Paninya', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'cyborg', 'fast'], 'difficulty': 'easy', 'alias': 'Paninya'},
    {'mal_id': 991093, 'name': 'Yoki', 'anime_mal_id': 5114, 'tags': ['villain', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Yoki'},
    {'mal_id': 991094, 'name': 'Isaac McDougal', 'anime_mal_id': 5114, 'tags': ['villain', 'water_user', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Isaac'},
    {'mal_id': 991095, 'name': 'Gracia Hughes', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Gracia'},
    {'mal_id': 991096, 'name': 'Selim Bradley', 'anime_mal_id': 5114, 'tags': ['villain', 'young', 'blond_hair', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Selim'},
    {'mal_id': 991097, 'name': 'Kain Fuery', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'gun_user', 'strategist'], 'difficulty': 'easy', 'alias': 'Fuery'},
    {'mal_id': 991098, 'name': 'Vato Falman', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'strategist', 'gun_user'], 'difficulty': 'easy', 'alias': 'Falman'},
    {'mal_id': 991099, 'name': 'Heymans Breda', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'gun_user'], 'difficulty': 'easy', 'alias': 'Breda'},
    {'mal_id': 991100, 'name': 'Jean Havoc', 'anime_mal_id': 5114, 'tags': ['hero', 'blond_hair', 'gun_user', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Havoc'},
]

tags_path = root / 'tags.json'
tags = load_json(tags_path)
existing_tag_ids = {tag['id'] for tag in tags}
if tag_definition['id'] not in existing_tag_ids:
    tags.append(tag_definition)
    write_json(tags_path, tags)

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 38000 + index * 510
    source.append(
        build_character_entry(
            mal_id=character['mal_id'],
            name=character['name'],
            tags=character['tags'],
            favorites=favorites,
            alias=character['alias'],
        )
    )
write_json(source_path, source)

enrichment_path = imports / 'mal_jikan_character_enrichment_preview.json'
enrichment = load_json(enrichment_path)
for character in characters:
    enrichment[str(character['mal_id'])] = build_enrichment_entry(
        mal_id=character['mal_id'],
        anime_mal_id=character['anime_mal_id'],
        tags=character['tags'],
        difficulty=character['difficulty'],
        alias=character['alias'],
        name=character['name'],
    )
ordered_enrichment = {key: enrichment[key] for key in sorted(enrichment, key=lambda item: int(item))}
write_json(enrichment_path, ordered_enrichment)

approval_path = imports / 'characters_import_approval.json'
approvals = load_json(approval_path)
approval_by_id = {item['transformedId']: item for item in approvals}
for character in characters:
    transformed_id = slugify(character['name'])
    approval_by_id[transformed_id] = {
        'malId': character['mal_id'],
        'transformedId': transformed_id,
        'approvalStatus': 'approved',
        'notes': 'Approved in high-throughput staging mode with richer reviewed tags.',
    }
write_json(approval_path, list(approval_by_id.values()))

print(f'updated twelfth large import batch with {len(characters)} high-throughput staged characters')
