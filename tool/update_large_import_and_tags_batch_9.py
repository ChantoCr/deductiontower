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
        ('young', 'young'),
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
        'importNotes': 'High-throughput approved batch staging for broader character coverage.',
        'image': None,
    }


characters = [
    {'mal_id': 970001, 'name': 'Iruka Umino', 'anime_mal_id': 20, 'tags': ['mentor', 'hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Iruka'},
    {'mal_id': 970002, 'name': 'Asuma Sarutobi', 'anime_mal_id': 20, 'tags': ['mentor', 'hero', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Asuma'},
    {'mal_id': 970003, 'name': 'Kurenai Yuhi', 'anime_mal_id': 20, 'tags': ['mentor', 'hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kurenai'},
    {'mal_id': 970004, 'name': 'Choji Akimichi', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'strong'], 'difficulty': 'easy', 'alias': 'Choji'},
    {'mal_id': 970005, 'name': 'Ino Yamanaka', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'strategist', 'super_powers'], 'difficulty': 'easy', 'alias': 'Ino'},
    {'mal_id': 970006, 'name': 'Tenten', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'uses_sword'], 'difficulty': 'easy', 'alias': 'Tenten'},
    {'mal_id': 970007, 'name': 'Shino Aburame', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'stoic', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shino'},
    {'mal_id': 970008, 'name': 'Yamato Tenzo', 'anime_mal_id': 20, 'tags': ['mentor', 'hero', 'water_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yamato'},
    {'mal_id': 970009, 'name': 'Danzo Shimura', 'anime_mal_id': 20, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Danzo'},
    {'mal_id': 970010, 'name': 'Suigetsu Hozuki', 'anime_mal_id': 20, 'tags': ['rival', 'water_user', 'uses_sword', 'super_powers'], 'difficulty': 'medium', 'alias': 'Suigetsu'},
    {'mal_id': 970011, 'name': 'Tony Tony Chopper', 'anime_mal_id': 21, 'tags': ['hero', 'young', 'non_human', 'has_transformation'], 'difficulty': 'easy', 'alias': 'Chopper'},
    {'mal_id': 970012, 'name': 'Carrot', 'anime_mal_id': 21, 'tags': ['hero', 'young', 'non_human', 'fast'], 'difficulty': 'easy', 'alias': 'Carrot'},
    {'mal_id': 970013, 'name': 'Bon Clay', 'anime_mal_id': 21, 'tags': ['hero', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Bon Clay'},
    {'mal_id': 970014, 'name': 'Bartolomeo', 'anime_mal_id': 21, 'tags': ['hero', 'super_powers'], 'difficulty': 'medium', 'alias': 'Bartolomeo'},
    {'mal_id': 970015, 'name': 'Marco', 'anime_mal_id': 21, 'tags': ['hero', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Marco'},
    {'mal_id': 970016, 'name': 'Kaido', 'anime_mal_id': 21, 'tags': ['villain', 'has_transformation', 'non_human', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Kaido'},
    {'mal_id': 970017, 'name': 'Big Mom', 'anime_mal_id': 21, 'tags': ['villain', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Big Mom'},
    {'mal_id': 970018, 'name': 'Dracule Mihawk', 'anime_mal_id': 21, 'tags': ['uses_sword', 'strong', 'stoic'], 'difficulty': 'hard', 'alias': 'Mihawk'},
    {'mal_id': 970019, 'name': 'Perona', 'anime_mal_id': 21, 'tags': ['villain', 'pink_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Perona'},
    {'mal_id': 970020, 'name': 'X Drake', 'anime_mal_id': 21, 'tags': ['hero', 'has_transformation', 'strong'], 'difficulty': 'medium', 'alias': 'Drake'},
    {'mal_id': 970021, 'name': 'Yachiru Kusajishi', 'anime_mal_id': 269, 'tags': ['pink_hair', 'young', 'hero'], 'difficulty': 'easy', 'alias': 'Yachiru'},
    {'mal_id': 970022, 'name': 'Ikkaku Madarame', 'anime_mal_id': 269, 'tags': ['hero', 'strong', 'uses_sword'], 'difficulty': 'medium', 'alias': 'Ikkaku'},
    {'mal_id': 970023, 'name': 'Yumichika Ayasegawa', 'anime_mal_id': 269, 'tags': ['hero', 'uses_sword', 'strategist'], 'difficulty': 'medium', 'alias': 'Yumichika'},
    {'mal_id': 970024, 'name': 'Izuru Kira', 'anime_mal_id': 269, 'tags': ['hero', 'uses_sword', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Kira'},
    {'mal_id': 970025, 'name': 'Momo Hinamori', 'anime_mal_id': 269, 'tags': ['hero', 'young', 'has_tragic_past', 'super_powers'], 'difficulty': 'easy', 'alias': 'Momo'},
    {'mal_id': 970026, 'name': 'Shunsui Kyoraku', 'anime_mal_id': 269, 'tags': ['mentor', 'uses_sword', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Shunsui'},
    {'mal_id': 970027, 'name': 'Jushiro Ukitake', 'anime_mal_id': 269, 'tags': ['white_hair', 'mentor', 'hero', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ukitake'},
    {'mal_id': 970028, 'name': 'Lisa Yadomaru', 'anime_mal_id': 269, 'tags': ['hero', 'uses_sword', 'super_powers'], 'difficulty': 'medium', 'alias': 'Lisa'},
    {'mal_id': 970029, 'name': 'Hiyori Sarugaki', 'anime_mal_id': 269, 'tags': ['hero', 'young', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hiyori'},
    {'mal_id': 970030, 'name': 'Rose Otoribashi', 'anime_mal_id': 269, 'tags': ['hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Rose'},
    {'mal_id': 970031, 'name': 'Bardock', 'anime_mal_id': 223, 'tags': ['hero', 'has_tragic_past', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Bardock'},
    {'mal_id': 970032, 'name': 'Raditz', 'anime_mal_id': 223, 'tags': ['villain', 'alien', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Raditz'},
    {'mal_id': 970033, 'name': 'Nappa', 'anime_mal_id': 223, 'tags': ['villain', 'muscular', 'strong', 'alien'], 'difficulty': 'medium', 'alias': 'Nappa'},
    {'mal_id': 970034, 'name': 'Gotenks', 'anime_mal_id': 223, 'tags': ['young', 'hero', 'has_transformation', 'super_powers', 'super_saiyan'], 'difficulty': 'easy', 'alias': 'Gotenks'},
    {'mal_id': 970035, 'name': 'Kale', 'anime_mal_id': 223, 'tags': ['hero', 'has_transformation', 'strong', 'super_powers', 'super_saiyan'], 'difficulty': 'medium', 'alias': 'Kale'},
    {'mal_id': 970036, 'name': 'Caulifla', 'anime_mal_id': 223, 'tags': ['hero', 'has_transformation', 'strong', 'super_powers', 'super_saiyan'], 'difficulty': 'medium', 'alias': 'Caulifla'},
    {'mal_id': 970037, 'name': 'Kefla', 'anime_mal_id': 223, 'tags': ['hero', 'has_transformation', 'strong', 'super_powers', 'super_saiyan'], 'difficulty': 'hard', 'alias': 'Kefla'},
    {'mal_id': 970038, 'name': 'Vados', 'anime_mal_id': 223, 'tags': ['mentor', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Vados'},
    {'mal_id': 970039, 'name': 'Toppo', 'anime_mal_id': 223, 'tags': ['hero', 'strong', 'muscular', 'super_powers'], 'difficulty': 'medium', 'alias': 'Toppo'},
    {'mal_id': 970040, 'name': 'Zamasu', 'anime_mal_id': 223, 'tags': ['villain', 'strategist', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Zamasu'},
    {'mal_id': 970041, 'name': 'Denki Kaminari', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'lightning_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'Kaminari'},
    {'mal_id': 970042, 'name': 'Mina Ashido', 'anime_mal_id': 31964, 'tags': ['pink_hair', 'hero', 'young', 'super_powers'], 'difficulty': 'easy', 'alias': 'Mina'},
    {'mal_id': 970043, 'name': 'Kyoka Jiro', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'super_powers'], 'difficulty': 'easy', 'alias': 'Jiro'},
    {'mal_id': 970044, 'name': 'Hitoshi Shinso', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shinso'},
    {'mal_id': 970045, 'name': 'Present Mic', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'super_powers'], 'difficulty': 'medium', 'alias': 'Present Mic'},
    {'mal_id': 970046, 'name': 'Best Jeanist', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Jeanist'},
    {'mal_id': 970047, 'name': 'Lady Nagant', 'anime_mal_id': 31964, 'tags': ['gun_user', 'villain', 'strong'], 'difficulty': 'hard', 'alias': 'Nagant'},
    {'mal_id': 970048, 'name': 'Overhaul', 'anime_mal_id': 31964, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Overhaul'},
    {'mal_id': 970049, 'name': 'Fat Gum', 'anime_mal_id': 31964, 'tags': ['hero', 'strong', 'muscular'], 'difficulty': 'easy', 'alias': 'Fat Gum'},
    {'mal_id': 970050, 'name': 'Mt. Lady', 'anime_mal_id': 31964, 'tags': ['hero', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mt. Lady'},
    {'mal_id': 970051, 'name': 'Utahime Iori', 'anime_mal_id': 40748, 'tags': ['mentor', 'hero', 'strategist'], 'difficulty': 'medium', 'alias': 'Utahime'},
    {'mal_id': 970052, 'name': 'Shoko Ieiri', 'anime_mal_id': 40748, 'tags': ['mentor', 'hero', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shoko'},
    {'mal_id': 970053, 'name': 'Kokichi Muta', 'anime_mal_id': 40748, 'tags': ['has_tragic_past', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mechamaru'},
    {'mal_id': 970054, 'name': 'Hanami', 'anime_mal_id': 40748, 'tags': ['villain', 'non_human', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Hanami'},
    {'mal_id': 970055, 'name': 'Dagon', 'anime_mal_id': 40748, 'tags': ['villain', 'non_human', 'water_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Dagon'},
    {'mal_id': 970056, 'name': 'Choso', 'anime_mal_id': 40748, 'tags': ['rival', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Choso'},
    {'mal_id': 970057, 'name': 'Naobito Zenin', 'anime_mal_id': 40748, 'tags': ['mentor', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Naobito'},
    {'mal_id': 970058, 'name': 'Mai Zenin', 'anime_mal_id': 40748, 'tags': ['young', 'gun_user', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Mai'},
    {'mal_id': 970059, 'name': 'Kirara Hoshi', 'anime_mal_id': 40748, 'tags': ['hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kirara'},
    {'mal_id': 970060, 'name': 'Hajime Kashimo', 'anime_mal_id': 40748, 'tags': ['rival', 'strong', 'lightning_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Kashimo'},
    {'mal_id': 970061, 'name': 'Mimosa Vermillion', 'anime_mal_id': 34572, 'tags': ['hero', 'young', 'magic_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'Mimosa'},
    {'mal_id': 970062, 'name': 'Charlotte Roselei', 'anime_mal_id': 34572, 'tags': ['mentor', 'hero', 'magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Charlotte'},
    {'mal_id': 970063, 'name': 'Jack the Ripper', 'anime_mal_id': 34572, 'tags': ['uses_sword', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Jack'},
    {'mal_id': 970064, 'name': 'Rill Boismortier', 'anime_mal_id': 34572, 'tags': ['young', 'magic_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'Rill'},
    {'mal_id': 970065, 'name': 'Dorothy Unsworth', 'anime_mal_id': 34572, 'tags': ['magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Dorothy'},
    {'mal_id': 970066, 'name': 'Gauche Adlai', 'anime_mal_id': 34572, 'tags': ['hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gauche'},
    {'mal_id': 970067, 'name': 'Henry Legolant', 'anime_mal_id': 34572, 'tags': ['hero', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Henry'},
    {'mal_id': 970068, 'name': 'Langris Vaude', 'anime_mal_id': 34572, 'tags': ['rival', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Langris'},
    {'mal_id': 970069, 'name': 'Sally', 'anime_mal_id': 34572, 'tags': ['villain', 'strategist', 'magic_user'], 'difficulty': 'medium', 'alias': 'Sally'},
    {'mal_id': 970070, 'name': 'Vetto', 'anime_mal_id': 34572, 'tags': ['villain', 'strong', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Vetto'},
    {'mal_id': 970071, 'name': 'Palm Siberia', 'anime_mal_id': 11061, 'tags': ['has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Palm'},
    {'mal_id': 970072, 'name': 'Shoot McMahon', 'anime_mal_id': 11061, 'tags': ['hero', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shoot'},
    {'mal_id': 970073, 'name': 'Morel Mackernasey', 'anime_mal_id': 11061, 'tags': ['mentor', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Morel'},
    {'mal_id': 970074, 'name': 'Knov', 'anime_mal_id': 11061, 'tags': ['hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Knov'},
    {'mal_id': 970075, 'name': 'Razor', 'anime_mal_id': 11061, 'tags': ['strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Razor'},
    {'mal_id': 970076, 'name': 'Komugi', 'anime_mal_id': 11061, 'tags': ['young', 'strategist'], 'difficulty': 'easy', 'alias': 'Komugi'},
    {'mal_id': 970077, 'name': 'Zeno Zoldyck', 'anime_mal_id': 11061, 'tags': ['mentor', 'assassin', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Zeno'},
    {'mal_id': 970078, 'name': 'Silva Zoldyck', 'anime_mal_id': 11061, 'tags': ['assassin', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Silva'},
    {'mal_id': 970079, 'name': 'Canary', 'anime_mal_id': 11061, 'tags': ['young', 'assassin', 'strong'], 'difficulty': 'medium', 'alias': 'Canary'},
    {'mal_id': 970080, 'name': 'Alluka Zoldyck', 'anime_mal_id': 11061, 'tags': ['young', 'super_powers'], 'difficulty': 'medium', 'alias': 'Alluka'},
    {'mal_id': 970081, 'name': 'Connie Springer', 'anime_mal_id': 16498, 'tags': ['hero', 'young'], 'difficulty': 'easy', 'alias': 'Connie'},
    {'mal_id': 970082, 'name': 'Ymir', 'anime_mal_id': 16498, 'tags': ['hero', 'has_tragic_past', 'has_transformation'], 'difficulty': 'medium', 'alias': 'Ymir'},
    {'mal_id': 970083, 'name': 'Pieck Finger', 'anime_mal_id': 16498, 'tags': ['strategist', 'has_transformation'], 'difficulty': 'medium', 'alias': 'Pieck'},
    {'mal_id': 970084, 'name': 'Porco Galliard', 'anime_mal_id': 16498, 'tags': ['rival', 'has_transformation', 'strong'], 'difficulty': 'medium', 'alias': 'Porco'},
    {'mal_id': 970085, 'name': 'Falco Grice', 'anime_mal_id': 16498, 'tags': ['young', 'hero', 'has_transformation'], 'difficulty': 'easy', 'alias': 'Falco'},
    {'mal_id': 970086, 'name': 'Gabi Braun', 'anime_mal_id': 16498, 'tags': ['young', 'rival', 'gun_user'], 'difficulty': 'easy', 'alias': 'Gabi'},
    {'mal_id': 970087, 'name': 'Onyankopon', 'anime_mal_id': 16498, 'tags': ['hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Onyankopon'},
    {'mal_id': 970088, 'name': 'Nicolo', 'anime_mal_id': 16498, 'tags': ['hero'], 'difficulty': 'easy', 'alias': 'Nicolo'},
    {'mal_id': 970089, 'name': 'Floch Forster', 'anime_mal_id': 16498, 'tags': ['villain', 'strategist'], 'difficulty': 'medium', 'alias': 'Floch'},
    {'mal_id': 970090, 'name': 'Petra Ral', 'anime_mal_id': 16498, 'tags': ['hero', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Petra'},
    {'mal_id': 970091, 'name': 'Father', 'anime_mal_id': 5114, 'tags': ['villain', 'non_human', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Father'},
    {'mal_id': 970092, 'name': 'Pride', 'anime_mal_id': 5114, 'tags': ['villain', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Pride'},
    {'mal_id': 970093, 'name': 'Lust', 'anime_mal_id': 5114, 'tags': ['villain', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Lust'},
    {'mal_id': 970094, 'name': 'Gluttony', 'anime_mal_id': 5114, 'tags': ['villain', 'non_human', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gluttony'},
    {'mal_id': 970095, 'name': 'Sloth', 'anime_mal_id': 5114, 'tags': ['villain', 'non_human', 'strong'], 'difficulty': 'medium', 'alias': 'Sloth'},
    {'mal_id': 970096, 'name': 'King Bradley', 'anime_mal_id': 5114, 'tags': ['villain', 'uses_sword', 'strategist', 'strong'], 'difficulty': 'hard', 'alias': 'Bradley'},
    {'mal_id': 970097, 'name': 'May Chang', 'anime_mal_id': 5114, 'tags': ['young', 'hero', 'magic_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'May'},
    {'mal_id': 970098, 'name': 'Lan Fan', 'anime_mal_id': 5114, 'tags': ['hero', 'assassin', 'fast'], 'difficulty': 'medium', 'alias': 'Lan Fan'},
    {'mal_id': 970099, 'name': 'Izumi Curtis', 'anime_mal_id': 5114, 'tags': ['mentor', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Izumi'},
    {'mal_id': 970100, 'name': 'Basque Grand', 'anime_mal_id': 5114, 'tags': ['villain', 'muscular', 'super_powers'], 'difficulty': 'medium', 'alias': 'Basque'},
]

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 32000 + index * 560
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
        'notes': 'Approved in high-throughput staging mode for broader catalog expansion.',
    }
write_json(approval_path, list(approval_by_id.values()))

print(f'updated ninth large import batch with {len(characters)} high-throughput staged characters')
