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
        'importNotes': 'High-throughput approved batch staging with richer reviewed tag coverage.',
        'image': None,
    }


characters = [
    {'mal_id': 990001, 'name': 'Kiba Inuzuka', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'student', 'brown_hair', 'fast'], 'difficulty': 'easy', 'alias': 'Kiba'},
    {'mal_id': 990002, 'name': 'Kushina Uzumaki', 'anime_mal_id': 20, 'tags': ['hero', 'mentor', 'red_hair', 'has_tragic_past', 'strong'], 'difficulty': 'medium', 'alias': 'Kushina'},
    {'mal_id': 990003, 'name': 'Shisui Uchiha', 'anime_mal_id': 20, 'tags': ['hero', 'black_hair', 'fast', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shisui'},
    {'mal_id': 990004, 'name': 'Kimimaro', 'anime_mal_id': 20, 'tags': ['villain', 'white_hair', 'has_tragic_past', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Kimimaro'},
    {'mal_id': 990005, 'name': 'Chiyo', 'anime_mal_id': 20, 'tags': ['mentor', 'hero', 'strategist', 'brown_hair', 'leader'], 'difficulty': 'medium', 'alias': 'Lady Chiyo'},
    {'mal_id': 990006, 'name': 'Karui', 'anime_mal_id': 20, 'tags': ['hero', 'brown_hair', 'strong', 'student'], 'difficulty': 'easy', 'alias': 'Karui'},
    {'mal_id': 990007, 'name': 'Omoi', 'anime_mal_id': 20, 'tags': ['hero', 'black_hair', 'stoic', 'student', 'strategist'], 'difficulty': 'easy', 'alias': 'Omoi'},
    {'mal_id': 990008, 'name': 'Ebisu', 'anime_mal_id': 20, 'tags': ['mentor', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Ebisu'},
    {'mal_id': 990009, 'name': 'Hanzo', 'anime_mal_id': 20, 'tags': ['villain', 'leader', 'assassin', 'strong'], 'difficulty': 'medium', 'alias': 'Hanzo'},
    {'mal_id': 990010, 'name': 'Ao', 'anime_mal_id': 20, 'tags': ['hero', 'black_hair', 'strategist', 'leader'], 'difficulty': 'medium', 'alias': 'Ao'},
    {'mal_id': 990011, 'name': 'Killer', 'anime_mal_id': 21, 'tags': ['rival', 'blond_hair', 'fast', 'uses_sword'], 'difficulty': 'medium', 'alias': 'Massacre Soldier'},
    {'mal_id': 990012, 'name': 'Basil Hawkins', 'anime_mal_id': 21, 'tags': ['villain', 'blond_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hawkins'},
    {'mal_id': 990013, 'name': 'Capone Bege', 'anime_mal_id': 21, 'tags': ['villain', 'leader', 'strategist', 'gun_user'], 'difficulty': 'medium', 'alias': 'Bege'},
    {'mal_id': 990014, 'name': 'Cavendish', 'anime_mal_id': 21, 'tags': ['rival', 'blond_hair', 'uses_sword', 'fast'], 'difficulty': 'medium', 'alias': 'Cavendish'},
    {'mal_id': 990015, 'name': 'Boa Sandersonia', 'anime_mal_id': 21, 'tags': ['villain', 'black_hair', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Sandersonia'},
    {'mal_id': 990016, 'name': 'Monet', 'anime_mal_id': 21, 'tags': ['villain', 'has_transformation', 'non_human', 'strategist'], 'difficulty': 'medium', 'alias': 'Monet'},
    {'mal_id': 990017, 'name': 'Shirahoshi', 'anime_mal_id': 21, 'tags': ['hero', 'pink_hair', 'young', 'non_human'], 'difficulty': 'easy', 'alias': 'Shirahoshi'},
    {'mal_id': 990018, 'name': 'Kyros', 'anime_mal_id': 21, 'tags': ['hero', 'uses_sword', 'has_tragic_past', 'strong'], 'difficulty': 'medium', 'alias': 'Kyros'},
    {'mal_id': 990019, 'name': 'Baby 5', 'anime_mal_id': 21, 'tags': ['villain', 'gun_user', 'has_transformation', 'red_hair'], 'difficulty': 'medium', 'alias': 'Baby 5'},
    {'mal_id': 990020, 'name': 'Queen', 'anime_mal_id': 21, 'tags': ['villain', 'leader', 'muscular', 'cyborg', 'strong'], 'difficulty': 'hard', 'alias': 'Queen'},
    {'mal_id': 990021, 'name': 'Rangiku Matsumoto', 'anime_mal_id': 269, 'tags': ['hero', 'blond_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Rangiku'},
    {'mal_id': 990022, 'name': 'Nemu Kurotsuchi', 'anime_mal_id': 269, 'tags': ['hero', 'young', 'brown_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Nemu'},
    {'mal_id': 990023, 'name': 'Kensei Muguruma', 'anime_mal_id': 269, 'tags': ['mentor', 'hero', 'leader', 'strong'], 'difficulty': 'medium', 'alias': 'Kensei'},
    {'mal_id': 990024, 'name': 'Iba Tetsuzaemon', 'anime_mal_id': 269, 'tags': ['hero', 'black_hair', 'leader', 'strong'], 'difficulty': 'medium', 'alias': 'Iba'},
    {'mal_id': 990025, 'name': 'Bambietta Basterbine', 'anime_mal_id': 269, 'tags': ['villain', 'blond_hair', 'super_powers', 'strong'], 'difficulty': 'hard', 'alias': 'Bambietta'},
    {'mal_id': 990026, 'name': 'Bazz-B', 'anime_mal_id': 269, 'tags': ['villain', 'red_hair', 'fire_user', 'strong'], 'difficulty': 'hard', 'alias': 'Bazz-B'},
    {'mal_id': 990027, 'name': 'As Nodt', 'anime_mal_id': 269, 'tags': ['villain', 'brown_hair', 'super_powers', 'has_tragic_past'], 'difficulty': 'hard', 'alias': 'As Nodt'},
    {'mal_id': 990028, 'name': 'Candice Catnipp', 'anime_mal_id': 269, 'tags': ['villain', 'blond_hair', 'lightning_user', 'fast'], 'difficulty': 'medium', 'alias': 'Candice'},
    {'mal_id': 990029, 'name': 'Mask De Masculine', 'anime_mal_id': 269, 'tags': ['villain', 'muscular', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mask'},
    {'mal_id': 990030, 'name': 'Askin Nakk Le Vaar', 'anime_mal_id': 269, 'tags': ['villain', 'blond_hair', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Askin'},
    {'mal_id': 990031, 'name': 'Turles', 'anime_mal_id': 223, 'tags': ['villain', 'black_hair', 'alien', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Turles'},
    {'mal_id': 990032, 'name': 'Zarbon', 'anime_mal_id': 223, 'tags': ['villain', 'has_transformation', 'alien', 'strong'], 'difficulty': 'medium', 'alias': 'Zarbon'},
    {'mal_id': 990033, 'name': 'Dodoria', 'anime_mal_id': 223, 'tags': ['villain', 'pink_hair', 'alien', 'strong'], 'difficulty': 'medium', 'alias': 'Dodoria'},
    {'mal_id': 990034, 'name': 'Captain Ginyu', 'anime_mal_id': 223, 'tags': ['villain', 'leader', 'alien', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ginyu'},
    {'mal_id': 990035, 'name': 'Burter', 'anime_mal_id': 223, 'tags': ['villain', 'alien', 'fast', 'strong'], 'difficulty': 'medium', 'alias': 'Burter'},
    {'mal_id': 990036, 'name': 'Jeice', 'anime_mal_id': 223, 'tags': ['villain', 'red_hair', 'alien', 'fast'], 'difficulty': 'medium', 'alias': 'Jeice'},
    {'mal_id': 990037, 'name': 'Recoome', 'anime_mal_id': 223, 'tags': ['villain', 'muscular', 'alien', 'strong'], 'difficulty': 'medium', 'alias': 'Recoome'},
    {'mal_id': 990038, 'name': 'Guldo', 'anime_mal_id': 223, 'tags': ['villain', 'alien', 'psychic', 'super_powers'], 'difficulty': 'medium', 'alias': 'Guldo'},
    {'mal_id': 990039, 'name': 'Dabura', 'anime_mal_id': 223, 'tags': ['villain', 'demon', 'uses_sword', 'super_powers'], 'difficulty': 'hard', 'alias': 'Dabura'},
    {'mal_id': 990040, 'name': 'King Cold', 'anime_mal_id': 223, 'tags': ['villain', 'leader', 'alien', 'strong'], 'difficulty': 'hard', 'alias': 'King Cold'},
    {'mal_id': 990041, 'name': 'Hanta Sero', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'black_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Sero'},
    {'mal_id': 990042, 'name': 'Mezo Shoji', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'has_transformation', 'strong'], 'difficulty': 'easy', 'alias': 'Shoji'},
    {'mal_id': 990043, 'name': 'Rikido Sato', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'strong'], 'difficulty': 'easy', 'alias': 'Sato'},
    {'mal_id': 990044, 'name': 'Yuga Aoyama', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'blond_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Aoyama'},
    {'mal_id': 990045, 'name': 'Koji Koda', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'brown_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Koda'},
    {'mal_id': 990046, 'name': 'Camie Utsushimi', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'blond_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Camie'},
    {'mal_id': 990047, 'name': 'Inasa Yoarashi', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'brown_hair', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Inasa'},
    {'mal_id': 990048, 'name': 'Ryukyu', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'leader', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ryukyu'},
    {'mal_id': 990049, 'name': 'Sir Nighteye', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'strategist', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Nighteye'},
    {'mal_id': 990050, 'name': 'Juzo Honenuki', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'brown_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Juzo'},
    {'mal_id': 990051, 'name': 'Kiyotaka Ijichi', 'anime_mal_id': 40748, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Ijichi'},
    {'mal_id': 990052, 'name': 'Akari Nitta', 'anime_mal_id': 40748, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Akari'},
    {'mal_id': 990053, 'name': 'Takuma Ino', 'anime_mal_id': 40748, 'tags': ['hero', 'black_hair', 'student', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ino'},
    {'mal_id': 990054, 'name': 'Atsuya Kusakabe', 'anime_mal_id': 40748, 'tags': ['mentor', 'brown_hair', 'uses_sword', 'strategist'], 'difficulty': 'medium', 'alias': 'Kusakabe'},
    {'mal_id': 990055, 'name': 'Ui Ui', 'anime_mal_id': 40748, 'tags': ['hero', 'young', 'student', 'black_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Ui Ui'},
    {'mal_id': 990056, 'name': 'Larue', 'anime_mal_id': 40748, 'tags': ['villain', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Larue'},
    {'mal_id': 990057, 'name': 'Uraume', 'anime_mal_id': 40748, 'tags': ['villain', 'white_hair', 'ice_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Uraume'},
    {'mal_id': 990058, 'name': 'Junpei Yoshino', 'anime_mal_id': 40748, 'tags': ['has_tragic_past', 'young', 'student', 'black_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Junpei'},
    {'mal_id': 990059, 'name': 'Haruta Shigemo', 'anime_mal_id': 40748, 'tags': ['villain', 'blond_hair', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Haruta'},
    {'mal_id': 990060, 'name': 'Riko Amanai', 'anime_mal_id': 40748, 'tags': ['hero', 'young', 'student', 'brown_hair'], 'difficulty': 'easy', 'alias': 'Riko'},
    {'mal_id': 990061, 'name': 'Klaus Lunettes', 'anime_mal_id': 34572, 'tags': ['hero', 'young', 'student', 'brown_hair', 'magic_user'], 'difficulty': 'easy', 'alias': 'Klaus'},
    {'mal_id': 990062, 'name': 'Sol Marron', 'anime_mal_id': 34572, 'tags': ['hero', 'young', 'student', 'brown_hair', 'magic_user'], 'difficulty': 'easy', 'alias': 'Sol'},
    {'mal_id': 990063, 'name': 'Nebra Silva', 'anime_mal_id': 34572, 'tags': ['hero', 'young', 'brown_hair', 'magic_user'], 'difficulty': 'easy', 'alias': 'Nebra'},
    {'mal_id': 990064, 'name': 'Kirsch Vermillion', 'anime_mal_id': 34572, 'tags': ['hero', 'leader', 'blond_hair', 'magic_user'], 'difficulty': 'medium', 'alias': 'Kirsch'},
    {'mal_id': 990065, 'name': 'Fana', 'anime_mal_id': 34572, 'tags': ['villain', 'white_hair', 'fire_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Fana'},
    {'mal_id': 990066, 'name': 'Ladros', 'anime_mal_id': 34572, 'tags': ['villain', 'brown_hair', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ladros'},
    {'mal_id': 990067, 'name': 'Mars', 'anime_mal_id': 34572, 'tags': ['rival', 'brown_hair', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mars'},
    {'mal_id': 990068, 'name': 'Rades Spirito', 'anime_mal_id': 34572, 'tags': ['villain', 'black_hair', 'strategist', 'magic_user'], 'difficulty': 'medium', 'alias': 'Rades'},
    {'mal_id': 990069, 'name': 'Zenon Zogratis', 'anime_mal_id': 34572, 'tags': ['villain', 'black_hair', 'leader', 'super_powers'], 'difficulty': 'hard', 'alias': 'Zenon'},
    {'mal_id': 990070, 'name': 'Dante Zogratis', 'anime_mal_id': 34572, 'tags': ['villain', 'black_hair', 'leader', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Dante'},
    {'mal_id': 990071, 'name': 'Satotz', 'anime_mal_id': 11061, 'tags': ['hero', 'black_hair', 'fast', 'strategist'], 'difficulty': 'easy', 'alias': 'Satotz'},
    {'mal_id': 990072, 'name': 'Melody', 'anime_mal_id': 11061, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Melody'},
    {'mal_id': 990073, 'name': 'Ponzu', 'anime_mal_id': 11061, 'tags': ['hero', 'brown_hair', 'young'], 'difficulty': 'easy', 'alias': 'Ponzu'},
    {'mal_id': 990074, 'name': 'Pokkle', 'anime_mal_id': 11061, 'tags': ['hero', 'blond_hair', 'young'], 'difficulty': 'easy', 'alias': 'Pokkle'},
    {'mal_id': 990075, 'name': 'Welfin', 'anime_mal_id': 11061, 'tags': ['villain', 'brown_hair', 'non_human', 'strategist'], 'difficulty': 'medium', 'alias': 'Welfin'},
    {'mal_id': 990076, 'name': 'Ikalgo', 'anime_mal_id': 11061, 'tags': ['hero', 'non_human', 'super_powers', 'strategist'], 'difficulty': 'medium', 'alias': 'Ikalgo'},
    {'mal_id': 990077, 'name': 'Menthuthuyoupi', 'anime_mal_id': 11061, 'tags': ['villain', 'non_human', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Youpi'},
    {'mal_id': 990078, 'name': 'Kortopi', 'anime_mal_id': 11061, 'tags': ['villain', 'brown_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kortopi'},
    {'mal_id': 990079, 'name': 'Kalluto Zoldyck', 'anime_mal_id': 11061, 'tags': ['villain', 'young', 'black_hair', 'assassin'], 'difficulty': 'medium', 'alias': 'Kalluto'},
    {'mal_id': 990080, 'name': 'Tsezguerra', 'anime_mal_id': 11061, 'tags': ['hero', 'leader', 'strategist'], 'difficulty': 'easy', 'alias': 'Tsezguerra'},
    {'mal_id': 990081, 'name': 'Dot Pixis', 'anime_mal_id': 16498, 'tags': ['mentor', 'leader', 'strategist'], 'difficulty': 'medium', 'alias': 'Pixis'},
    {'mal_id': 990082, 'name': 'Theo Magath', 'anime_mal_id': 16498, 'tags': ['mentor', 'leader', 'strategist'], 'difficulty': 'medium', 'alias': 'Magath'},
    {'mal_id': 990083, 'name': 'Colt Grice', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Colt'},
    {'mal_id': 990084, 'name': 'Marcel Galliard', 'anime_mal_id': 16498, 'tags': ['hero', 'blond_hair', 'has_tragic_past', 'strong'], 'difficulty': 'medium', 'alias': 'Marcel'},
    {'mal_id': 990085, 'name': 'Rico Brzenska', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'leader'], 'difficulty': 'easy', 'alias': 'Rico'},
    {'mal_id': 990086, 'name': 'Yelena', 'anime_mal_id': 16498, 'tags': ['villain', 'blond_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Yelena'},
    {'mal_id': 990087, 'name': 'Furlan Church', 'anime_mal_id': 16498, 'tags': ['hero', 'black_hair', 'has_tragic_past', 'fast'], 'difficulty': 'medium', 'alias': 'Furlan'},
    {'mal_id': 990088, 'name': 'Isabel Magnolia', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'has_tragic_past', 'fast'], 'difficulty': 'medium', 'alias': 'Isabel'},
    {'mal_id': 990089, 'name': 'Mina Carolina', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'student'], 'difficulty': 'easy', 'alias': 'Mina'},
    {'mal_id': 990090, 'name': 'Dhalis Zachary', 'anime_mal_id': 16498, 'tags': ['villain', 'leader', 'strategist'], 'difficulty': 'medium', 'alias': 'Zachary'},
    {'mal_id': 990091, 'name': 'Maria Ross', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'gun_user', 'strategist'], 'difficulty': 'easy', 'alias': 'Maria'},
    {'mal_id': 990092, 'name': 'Maes Hughes', 'anime_mal_id': 5114, 'tags': ['mentor', 'hero', 'leader', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Hughes'},
    {'mal_id': 990093, 'name': 'Shou Tucker', 'anime_mal_id': 5114, 'tags': ['villain', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Shou Tucker'},
    {'mal_id': 990094, 'name': 'Barry the Chopper', 'anime_mal_id': 5114, 'tags': ['villain', 'non_human', 'has_transformation', 'strong'], 'difficulty': 'medium', 'alias': 'Barry'},
    {'mal_id': 990095, 'name': 'Buccaneer', 'anime_mal_id': 5114, 'tags': ['hero', 'red_hair', 'strong', 'uses_sword'], 'difficulty': 'medium', 'alias': 'Buccaneer'},
    {'mal_id': 990096, 'name': 'Miles', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Miles'},
    {'mal_id': 990097, 'name': 'Jerso', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Jerso'},
    {'mal_id': 990098, 'name': 'Zampano', 'anime_mal_id': 5114, 'tags': ['hero', 'brown_hair', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Zampano'},
    {'mal_id': 990099, 'name': 'Slicer Brother', 'anime_mal_id': 5114, 'tags': ['villain', 'uses_sword', 'non_human', 'strong'], 'difficulty': 'medium', 'alias': 'Slicer'},
    {'mal_id': 990100, 'name': 'Solf J. Kimblee', 'anime_mal_id': 5114, 'tags': ['villain', 'blond_hair', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Kimblee'},
]

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 36000 + index * 530
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

print(f'updated eleventh large import batch with {len(characters)} high-throughput staged characters')
