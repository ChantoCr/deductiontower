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


characters = [
    {'mal_id': 992001, 'name': 'Karin', 'anime_mal_id': 20, 'tags': ['hero', 'red_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Karin'},
    {'mal_id': 992002, 'name': 'Jugo', 'anime_mal_id': 20, 'tags': ['rival', 'has_transformation', 'strong', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Jugo'},
    {'mal_id': 992003, 'name': 'Tayuya', 'anime_mal_id': 20, 'tags': ['villain', 'red_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Tayuya'},
    {'mal_id': 992004, 'name': 'Kidomaru', 'anime_mal_id': 20, 'tags': ['villain', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kidomaru'},
    {'mal_id': 992005, 'name': 'Sakon and Ukon', 'anime_mal_id': 20, 'tags': ['villain', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Sakon/Ukon'},
    {'mal_id': 992006, 'name': 'Chojuro', 'anime_mal_id': 20, 'tags': ['hero', 'blue_hair', 'uses_sword', 'leader', 'super_powers'], 'difficulty': 'medium', 'alias': 'Chojuro'},
    {'mal_id': 992007, 'name': 'Kurotsuchi', 'anime_mal_id': 20, 'tags': ['hero', 'brown_hair', 'leader', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kurotsuchi'},
    {'mal_id': 992008, 'name': 'Mifune', 'anime_mal_id': 20, 'tags': ['hero', 'leader', 'uses_sword', 'strong', 'stoic'], 'difficulty': 'medium', 'alias': 'Mifune'},
    {'mal_id': 992009, 'name': 'Torune Aburame', 'anime_mal_id': 20, 'tags': ['villain', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Torune'},
    {'mal_id': 992010, 'name': 'Fu Yamanaka', 'anime_mal_id': 20, 'tags': ['villain', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Fu'},
    {'mal_id': 992011, 'name': 'Caribou', 'anime_mal_id': 21, 'tags': ['villain', 'black_hair', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Caribou'},
    {'mal_id': 992012, 'name': 'Bellamy', 'anime_mal_id': 21, 'tags': ['rival', 'blond_hair', 'strong', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Bellamy'},
    {'mal_id': 992013, 'name': 'Caesar Clown', 'anime_mal_id': 21, 'tags': ['villain', 'strategist', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Caesar'},
    {'mal_id': 992014, 'name': 'Vergo', 'anime_mal_id': 21, 'tags': ['villain', 'black_hair', 'strong', 'strategist'], 'difficulty': 'medium', 'alias': 'Vergo'},
    {'mal_id': 992015, 'name': 'Diamante', 'anime_mal_id': 21, 'tags': ['villain', 'leader', 'super_powers', 'strong'], 'difficulty': 'medium', 'alias': 'Diamante'},
    {'mal_id': 992016, 'name': 'Charlotte Smoothie', 'anime_mal_id': 21, 'tags': ['villain', 'blond_hair', 'leader', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Smoothie'},
    {'mal_id': 992017, 'name': 'Charlotte Pudding', 'anime_mal_id': 21, 'tags': ['hero', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Pudding'},
    {'mal_id': 992018, 'name': 'Charlotte Brulee', 'anime_mal_id': 21, 'tags': ['villain', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Brulee'},
    {'mal_id': 992019, 'name': 'Hody Jones', 'anime_mal_id': 21, 'tags': ['villain', 'non_human', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hody'},
    {'mal_id': 992020, 'name': 'King the Wildfire', 'anime_mal_id': 21, 'tags': ['villain', 'black_hair', 'has_transformation', 'fire_user', 'strong'], 'difficulty': 'hard', 'alias': 'King'},
    {'mal_id': 992021, 'name': 'Shinji Hirako', 'anime_mal_id': 269, 'tags': ['mentor', 'hero', 'blond_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shinji'},
    {'mal_id': 992022, 'name': 'Sado Yasutora', 'anime_mal_id': 269, 'tags': ['hero', 'brown_hair', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Chad'},
    {'mal_id': 992023, 'name': 'Hachigen Ushoda', 'anime_mal_id': 269, 'tags': ['hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hachi'},
    {'mal_id': 992024, 'name': 'Love Aikawa', 'anime_mal_id': 269, 'tags': ['hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Love'},
    {'mal_id': 992025, 'name': 'Mashiro Kuna', 'anime_mal_id': 269, 'tags': ['hero', 'young', 'pink_hair', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mashiro'},
    {'mal_id': 992026, 'name': 'Isane Kotetsu', 'anime_mal_id': 269, 'tags': ['hero', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'easy', 'alias': 'Isane'},
    {'mal_id': 992027, 'name': 'Giselle Gewelle', 'anime_mal_id': 269, 'tags': ['villain', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Giselle'},
    {'mal_id': 992028, 'name': 'Meninas McAllon', 'anime_mal_id': 269, 'tags': ['villain', 'blond_hair', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Meninas'},
    {'mal_id': 992029, 'name': 'Liltotto Lamperd', 'anime_mal_id': 269, 'tags': ['villain', 'brown_hair', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Liltotto'},
    {'mal_id': 992030, 'name': 'Quilge Opie', 'anime_mal_id': 269, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Quilge'},
    {'mal_id': 992031, 'name': 'Android 16', 'anime_mal_id': 223, 'tags': ['hero', 'cyborg', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Android 16'},
    {'mal_id': 992032, 'name': 'Android 19', 'anime_mal_id': 223, 'tags': ['villain', 'cyborg', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Android 19'},
    {'mal_id': 992033, 'name': 'Dr. Gero', 'anime_mal_id': 223, 'tags': ['villain', 'cyborg', 'strategist', 'leader'], 'difficulty': 'hard', 'alias': 'Dr. Gero'},
    {'mal_id': 992034, 'name': 'King Piccolo', 'anime_mal_id': 223, 'tags': ['villain', 'leader', 'strong', 'super_powers', 'non_human'], 'difficulty': 'hard', 'alias': 'King Piccolo'},
    {'mal_id': 992035, 'name': 'Puar', 'anime_mal_id': 223, 'tags': ['hero', 'non_human', 'has_transformation'], 'difficulty': 'easy', 'alias': 'Puar'},
    {'mal_id': 992036, 'name': 'Oolong', 'anime_mal_id': 223, 'tags': ['hero', 'non_human', 'has_transformation'], 'difficulty': 'easy', 'alias': 'Oolong'},
    {'mal_id': 992037, 'name': 'Mr. Satan', 'anime_mal_id': 223, 'tags': ['hero', 'martial_artist', 'strong', 'leader'], 'difficulty': 'easy', 'alias': 'Hercule'},
    {'mal_id': 992038, 'name': 'Pan', 'anime_mal_id': 223, 'tags': ['hero', 'young', 'black_hair', 'strong', 'super_powers'], 'difficulty': 'easy', 'alias': 'Pan'},
    {'mal_id': 992039, 'name': 'Frost', 'anime_mal_id': 223, 'tags': ['villain', 'alien', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Frost'},
    {'mal_id': 992040, 'name': 'Champa', 'anime_mal_id': 223, 'tags': ['villain', 'non_human', 'leader', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Champa'},
    {'mal_id': 992041, 'name': 'Mei Hatsume', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'pink_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Mei'},
    {'mal_id': 992042, 'name': 'Ectoplasm', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ectoplasm'},
    {'mal_id': 992043, 'name': 'Cementoss', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Cementoss'},
    {'mal_id': 992044, 'name': 'Hound Dog', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'non_human', 'strong'], 'difficulty': 'medium', 'alias': 'Hound Dog'},
    {'mal_id': 992045, 'name': 'Recovery Girl', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Recovery Girl'},
    {'mal_id': 992046, 'name': 'Kamui Woods', 'anime_mal_id': 31964, 'tags': ['hero', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kamui Woods'},
    {'mal_id': 992047, 'name': 'Gang Orca', 'anime_mal_id': 31964, 'tags': ['hero', 'non_human', 'leader', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gang Orca'},
    {'mal_id': 992048, 'name': 'Snipe', 'anime_mal_id': 31964, 'tags': ['hero', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Snipe'},
    {'mal_id': 992049, 'name': 'Ms. Joke', 'anime_mal_id': 31964, 'tags': ['hero', 'green_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ms. Joke'},
    {'mal_id': 992050, 'name': 'Mandalay', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mandalay'},
    {'mal_id': 992051, 'name': 'Jiro Awasaka', 'anime_mal_id': 40748, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Awasaka'},
    {'mal_id': 992052, 'name': 'Eso', 'anime_mal_id': 40748, 'tags': ['villain', 'non_human', 'super_powers', 'strong'], 'difficulty': 'medium', 'alias': 'Eso'},
    {'mal_id': 992053, 'name': 'Kechizu', 'anime_mal_id': 40748, 'tags': ['villain', 'non_human', 'super_powers', 'strong'], 'difficulty': 'medium', 'alias': 'Kechizu'},
    {'mal_id': 992054, 'name': 'Iori Hazenoki', 'anime_mal_id': 40748, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hazenoki'},
    {'mal_id': 992055, 'name': 'Charles Bernard', 'anime_mal_id': 40748, 'tags': ['rival', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Charles'},
    {'mal_id': 992056, 'name': 'Amai Rin', 'anime_mal_id': 40748, 'tags': ['hero', 'young', 'brown_hair'], 'difficulty': 'easy', 'alias': 'Amai'},
    {'mal_id': 992057, 'name': 'Daido Hagane', 'anime_mal_id': 40748, 'tags': ['rival', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Daido'},
    {'mal_id': 992058, 'name': 'Miyo Rokujushi', 'anime_mal_id': 40748, 'tags': ['rival', 'martial_artist', 'strong'], 'difficulty': 'medium', 'alias': 'Miyo'},
    {'mal_id': 992059, 'name': 'Chizuru Hari', 'anime_mal_id': 40748, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hari'},
    {'mal_id': 992060, 'name': 'Ogami', 'anime_mal_id': 40748, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ogami'},
    {'mal_id': 992061, 'name': 'Gueldre Poizot', 'anime_mal_id': 34572, 'tags': ['villain', 'blond_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gueldre'},
    {'mal_id': 992062, 'name': 'Marx Francois', 'anime_mal_id': 34572, 'tags': ['hero', 'purple_hair', 'strategist', 'magic_user'], 'difficulty': 'medium', 'alias': 'Marx'},
    {'mal_id': 992063, 'name': 'Damnatio Kira', 'anime_mal_id': 34572, 'tags': ['villain', 'blond_hair', 'leader', 'strategist', 'magic_user'], 'difficulty': 'hard', 'alias': 'Damnatio'},
    {'mal_id': 992064, 'name': 'Catherine', 'anime_mal_id': 34572, 'tags': ['villain', 'black_hair', 'magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Catherine'},
    {'mal_id': 992065, 'name': 'Heath Grice', 'anime_mal_id': 34572, 'tags': ['villain', 'white_hair', 'ice_user', 'magic_user'], 'difficulty': 'medium', 'alias': 'Heath'},
    {'mal_id': 992066, 'name': 'Digit Taliss', 'anime_mal_id': 34572, 'tags': ['villain', 'brown_hair', 'strategist', 'magic_user'], 'difficulty': 'medium', 'alias': 'Digit'},
    {'mal_id': 992067, 'name': 'Mariella', 'anime_mal_id': 34572, 'tags': ['hero', 'brown_hair', 'magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mariella'},
    {'mal_id': 992068, 'name': 'Broccos', 'anime_mal_id': 34572, 'tags': ['villain', 'strong', 'muscular'], 'difficulty': 'easy', 'alias': 'Broccos'},
    {'mal_id': 992069, 'name': 'Droit', 'anime_mal_id': 34572, 'tags': ['villain', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Droit'},
    {'mal_id': 992070, 'name': 'Morris Libardirt', 'anime_mal_id': 34572, 'tags': ['villain', 'white_hair', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Morris'},
    {'mal_id': 992071, 'name': 'Zepile', 'anime_mal_id': 11061, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Zepile'},
    {'mal_id': 992072, 'name': 'Goreinu', 'anime_mal_id': 11061, 'tags': ['hero', 'black_hair', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Goreinu'},
    {'mal_id': 992073, 'name': 'Squala', 'anime_mal_id': 11061, 'tags': ['hero', 'brown_hair', 'gun_user', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Squala'},
    {'mal_id': 992074, 'name': 'Neon Nostrade', 'anime_mal_id': 11061, 'tags': ['hero', 'pink_hair', 'young', 'super_powers'], 'difficulty': 'medium', 'alias': 'Neon'},
    {'mal_id': 992075, 'name': 'Dalzollene', 'anime_mal_id': 11061, 'tags': ['hero', 'black_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Dalzollene'},
    {'mal_id': 992076, 'name': 'Gotoh', 'anime_mal_id': 11061, 'tags': ['hero', 'white_hair', 'strategist', 'strong'], 'difficulty': 'medium', 'alias': 'Gotoh'},
    {'mal_id': 992077, 'name': 'Cheetu', 'anime_mal_id': 11061, 'tags': ['villain', 'non_human', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Cheetu'},
    {'mal_id': 992078, 'name': 'Flutter', 'anime_mal_id': 11061, 'tags': ['villain', 'non_human', 'super_powers'], 'difficulty': 'medium', 'alias': 'Flutter'},
    {'mal_id': 992079, 'name': 'Bloster', 'anime_mal_id': 11061, 'tags': ['villain', 'non_human', 'strong'], 'difficulty': 'medium', 'alias': 'Bloster'},
    {'mal_id': 992080, 'name': 'Rammot', 'anime_mal_id': 11061, 'tags': ['villain', 'non_human', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Rammot'},
    {'mal_id': 992081, 'name': 'Moblit Berner', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Moblit'},
    {'mal_id': 992082, 'name': 'Kitz Woermann', 'anime_mal_id': 16498, 'tags': ['villain', 'brown_hair', 'leader'], 'difficulty': 'easy', 'alias': 'Kitz'},
    {'mal_id': 992083, 'name': 'Nile Dawk', 'anime_mal_id': 16498, 'tags': ['hero', 'black_hair', 'leader', 'strategist'], 'difficulty': 'medium', 'alias': 'Nile'},
    {'mal_id': 992084, 'name': 'Marlowe Freudenberg', 'anime_mal_id': 16498, 'tags': ['hero', 'blond_hair', 'has_tragic_past', 'strategist'], 'difficulty': 'medium', 'alias': 'Marlowe'},
    {'mal_id': 992085, 'name': 'Boris Feulner', 'anime_mal_id': 16498, 'tags': ['villain', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Boris'},
    {'mal_id': 992086, 'name': 'Louise', 'anime_mal_id': 16498, 'tags': ['villain', 'brown_hair', 'young'], 'difficulty': 'easy', 'alias': 'Louise'},
    {'mal_id': 992087, 'name': 'Tom Ksaver', 'anime_mal_id': 16498, 'tags': ['mentor', 'hero', 'blond_hair', 'has_tragic_past', 'strategist'], 'difficulty': 'medium', 'alias': 'Ksaver'},
    {'mal_id': 992088, 'name': 'Dina Fritz', 'anime_mal_id': 16498, 'tags': ['villain', 'blond_hair', 'has_transformation', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Dina'},
    {'mal_id': 992089, 'name': 'Rod Reiss', 'anime_mal_id': 16498, 'tags': ['villain', 'leader', 'has_transformation', 'strategist'], 'difficulty': 'medium', 'alias': 'Rod'},
    {'mal_id': 992090, 'name': 'Frieda Reiss', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Frieda'},
    {'mal_id': 992091, 'name': 'Sheska', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Sheska'},
    {'mal_id': 992092, 'name': 'Tim Marcoh', 'anime_mal_id': 5114, 'tags': ['mentor', 'hero', 'has_tragic_past', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Marcoh'},
    {'mal_id': 992093, 'name': 'Bido', 'anime_mal_id': 5114, 'tags': ['villain', 'non_human', 'strong'], 'difficulty': 'medium', 'alias': 'Bido'},
    {'mal_id': 992094, 'name': 'Dolcetto', 'anime_mal_id': 5114, 'tags': ['villain', 'brown_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Dolcetto'},
    {'mal_id': 992095, 'name': 'Martel', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Martel'},
    {'mal_id': 992096, 'name': 'Roa', 'anime_mal_id': 5114, 'tags': ['villain', 'brown_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Roa'},
    {'mal_id': 992097, 'name': 'Rebecca Catalina', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Rebecca'},
    {'mal_id': 992098, 'name': 'Psiren', 'anime_mal_id': 5114, 'tags': ['villain', 'purple_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Psiren'},
    {'mal_id': 992099, 'name': 'Rosalie', 'anime_mal_id': 5114, 'tags': ['hero', 'blond_hair', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Rosalie'},
    {'mal_id': 992100, 'name': 'Madame Christmas', 'anime_mal_id': 5114, 'tags': ['mentor', 'strategist', 'leader'], 'difficulty': 'medium', 'alias': 'Madame Christmas'},
]

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 40000 + index * 505
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

print(f'updated thirteenth large import batch with {len(characters)} high-throughput staged characters')
