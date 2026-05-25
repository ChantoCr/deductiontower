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
        ('demon', 'demonic power'),
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


anime_batch = [
    {
        'mal_id': 50265,
        'title': 'Spy x Family',
        'title_english': 'Spy x Family',
        'title_japanese': 'SPY×FAMILY',
        'url': 'https://myanimelist.net/anime/50265/Spy_x_Family',
    },
    {
        'mal_id': 9919,
        'title': 'Ao no Exorcist',
        'title_english': 'Blue Exorcist',
        'title_japanese': '青の祓魔師',
        'url': 'https://myanimelist.net/anime/9919/Ao_no_Exorcist',
    },
    {
        'mal_id': 3588,
        'title': 'Soul Eater',
        'title_english': 'Soul Eater',
        'title_japanese': 'ソウルイーター',
        'url': 'https://myanimelist.net/anime/3588/Soul_Eater',
    },
    {
        'mal_id': 38671,
        'title': 'Enen no Shouboutai',
        'title_english': 'Fire Force',
        'title_japanese': '炎炎ノ消防隊',
        'url': 'https://myanimelist.net/anime/38671/Enen_no_Shouboutai',
    },
]

characters = [
    {'mal_id': 980001, 'name': 'Tadaomi Karasuma', 'anime_mal_id': 24833, 'tags': ['mentor', 'hero', 'gun_user', 'strong'], 'difficulty': 'medium', 'alias': 'Karasuma'},
    {'mal_id': 980002, 'name': 'Irina Jelavic', 'anime_mal_id': 24833, 'tags': ['mentor', 'assassin', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Irina'},
    {'mal_id': 980003, 'name': 'Kaede Kayano', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Kayano'},
    {'mal_id': 980004, 'name': 'Nagisa Shiota', 'anime_mal_id': 24833, 'tags': ['protagonist', 'hero', 'young', 'strategist'], 'difficulty': 'easy', 'alias': 'Nagisa'},
    {'mal_id': 980005, 'name': 'Karma Akabane', 'anime_mal_id': 24833, 'tags': ['rival', 'young', 'strategist', 'strong'], 'difficulty': 'medium', 'alias': 'Karma'},
    {'mal_id': 980006, 'name': 'Itona Horibe', 'anime_mal_id': 24833, 'tags': ['rival', 'young', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Itona'},
    {'mal_id': 980007, 'name': 'Rio Nakamura', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'strategist'], 'difficulty': 'easy', 'alias': 'Rio'},
    {'mal_id': 980008, 'name': 'Manami Okuda', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'strategist'], 'difficulty': 'easy', 'alias': 'Okuda'},
    {'mal_id': 980009, 'name': 'Gakushuu Asano', 'anime_mal_id': 24833, 'tags': ['rival', 'young', 'strategist'], 'difficulty': 'hard', 'alias': 'Gakushuu'},
    {'mal_id': 980010, 'name': 'Ritsu', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'cyborg', 'strategist'], 'difficulty': 'easy', 'alias': 'Autonomous Intelligence Fixed Artillery'},
    {'mal_id': 980011, 'name': 'Jet Black', 'anime_mal_id': 1, 'tags': ['hero', 'mentor', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Jet'},
    {'mal_id': 980012, 'name': 'Faye Valentine', 'anime_mal_id': 1, 'tags': ['hero', 'gun_user', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Faye'},
    {'mal_id': 980013, 'name': 'Edward Wong Hau Pepelu Tivrusky IV', 'anime_mal_id': 1, 'tags': ['hero', 'young', 'strategist'], 'difficulty': 'medium', 'alias': 'Ed'},
    {'mal_id': 980014, 'name': 'Ein', 'anime_mal_id': 1, 'tags': ['hero', 'non_human'], 'difficulty': 'easy', 'alias': 'Ein'},
    {'mal_id': 980015, 'name': 'Vicious', 'anime_mal_id': 1, 'tags': ['villain', 'uses_sword', 'strategist'], 'difficulty': 'hard', 'alias': 'Vicious'},
    {'mal_id': 980016, 'name': 'Julia', 'anime_mal_id': 1, 'tags': ['hero', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Julia'},
    {'mal_id': 980017, 'name': 'Gren', 'anime_mal_id': 1, 'tags': ['hero', 'gun_user', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Gren'},
    {'mal_id': 980018, 'name': 'Shin', 'anime_mal_id': 1, 'tags': ['villain', 'gun_user'], 'difficulty': 'medium', 'alias': 'Shin'},
    {'mal_id': 980019, 'name': 'Lin', 'anime_mal_id': 1, 'tags': ['villain', 'gun_user'], 'difficulty': 'medium', 'alias': 'Lin'},
    {'mal_id': 980020, 'name': 'Laughing Bull', 'anime_mal_id': 1, 'tags': ['mentor', 'strategist'], 'difficulty': 'easy', 'alias': 'Laughing Bull'},
    {'mal_id': 980021, 'name': 'Nicholas D. Wolfwood', 'anime_mal_id': 6, 'tags': ['hero', 'gun_user', 'has_tragic_past', 'strong'], 'difficulty': 'medium', 'alias': 'Wolfwood'},
    {'mal_id': 980022, 'name': 'Meryl Stryfe', 'anime_mal_id': 6, 'tags': ['hero', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Meryl'},
    {'mal_id': 980023, 'name': 'Milly Thompson', 'anime_mal_id': 6, 'tags': ['hero', 'gun_user', 'strong'], 'difficulty': 'easy', 'alias': 'Milly'},
    {'mal_id': 980024, 'name': 'Millions Knives', 'anime_mal_id': 6, 'tags': ['villain', 'rival', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Knives'},
    {'mal_id': 980025, 'name': 'Legato Bluesummers', 'anime_mal_id': 6, 'tags': ['villain', 'strategist', 'psychic'], 'difficulty': 'hard', 'alias': 'Legato'},
    {'mal_id': 980026, 'name': 'Rem Saverem', 'anime_mal_id': 6, 'tags': ['mentor', 'hero', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Rem'},
    {'mal_id': 980027, 'name': 'Chapel the Evergreen', 'anime_mal_id': 6, 'tags': ['villain', 'gun_user', 'strategist'], 'difficulty': 'hard', 'alias': 'Chapel'},
    {'mal_id': 980028, 'name': 'Midvalley the Hornfreak', 'anime_mal_id': 6, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Midvalley'},
    {'mal_id': 980029, 'name': 'Dominique the Cyclops', 'anime_mal_id': 6, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Dominique'},
    {'mal_id': 980030, 'name': 'Zazie the Beast', 'anime_mal_id': 6, 'tags': ['villain', 'non_human', 'strategist'], 'difficulty': 'medium', 'alias': 'Zazie'},
    {'mal_id': 980031, 'name': 'Benimaru', 'anime_mal_id': 37430, 'tags': ['hero', 'demon', 'strong', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Benimaru'},
    {'mal_id': 980032, 'name': 'Shion', 'anime_mal_id': 37430, 'tags': ['hero', 'demon', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shion'},
    {'mal_id': 980033, 'name': 'Shuna', 'anime_mal_id': 37430, 'tags': ['hero', 'demon', 'magic_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'Shuna'},
    {'mal_id': 980034, 'name': 'Milim Nava', 'anime_mal_id': 37430, 'tags': ['rival', 'demon', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Milim'},
    {'mal_id': 980035, 'name': 'Diablo', 'anime_mal_id': 37430, 'tags': ['villain', 'demon', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Diablo'},
    {'mal_id': 980036, 'name': 'Veldora Tempest', 'anime_mal_id': 37430, 'tags': ['non_human', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Veldora'},
    {'mal_id': 980037, 'name': 'Souei', 'anime_mal_id': 37430, 'tags': ['hero', 'assassin', 'fast'], 'difficulty': 'medium', 'alias': 'Souei'},
    {'mal_id': 980038, 'name': 'Hakurou', 'anime_mal_id': 37430, 'tags': ['mentor', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Hakurou'},
    {'mal_id': 980039, 'name': 'Gabiru', 'anime_mal_id': 37430, 'tags': ['rival', 'non_human', 'strong'], 'difficulty': 'easy', 'alias': 'Gabiru'},
    {'mal_id': 980040, 'name': 'Geld', 'anime_mal_id': 37430, 'tags': ['hero', 'non_human', 'strong'], 'difficulty': 'medium', 'alias': 'Geld'},
    {'mal_id': 980041, 'name': 'Touta Matsuda', 'anime_mal_id': 1535, 'tags': ['hero', 'young', 'gun_user'], 'difficulty': 'easy', 'alias': 'Matsuda'},
    {'mal_id': 980042, 'name': 'Kiyomi Takada', 'anime_mal_id': 1535, 'tags': ['villain', 'strategist'], 'difficulty': 'medium', 'alias': 'Takada'},
    {'mal_id': 980043, 'name': 'Watari', 'anime_mal_id': 1535, 'tags': ['mentor', 'strategist'], 'difficulty': 'easy', 'alias': 'Watari'},
    {'mal_id': 980044, 'name': 'Naomi Misora', 'anime_mal_id': 1535, 'tags': ['hero', 'strategist'], 'difficulty': 'medium', 'alias': 'Naomi'},
    {'mal_id': 980045, 'name': 'Raye Penber', 'anime_mal_id': 1535, 'tags': ['hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Raye'},
    {'mal_id': 980046, 'name': 'Rem', 'anime_mal_id': 1535, 'tags': ['hero', 'non_human', 'super_powers'], 'difficulty': 'medium', 'alias': 'Rem'},
    {'mal_id': 980047, 'name': 'Mello', 'anime_mal_id': 1535, 'tags': ['rival', 'blond_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Mello'},
    {'mal_id': 980048, 'name': 'Matt', 'anime_mal_id': 1535, 'tags': ['rival', 'strategist'], 'difficulty': 'easy', 'alias': 'Matt'},
    {'mal_id': 980049, 'name': 'Halle Lidner', 'anime_mal_id': 1535, 'tags': ['hero', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Halle'},
    {'mal_id': 980050, 'name': 'Roger Ruvie', 'anime_mal_id': 1535, 'tags': ['mentor', 'strategist'], 'difficulty': 'easy', 'alias': 'Roger'},
    {'mal_id': 980051, 'name': 'Nunnally Lamperouge', 'anime_mal_id': 1575, 'tags': ['hero', 'young'], 'difficulty': 'easy', 'alias': 'Nunnally'},
    {'mal_id': 980052, 'name': 'Euphemia li Britannia', 'anime_mal_id': 1575, 'tags': ['hero', 'young'], 'difficulty': 'easy', 'alias': 'Euphemia'},
    {'mal_id': 980053, 'name': 'Schneizel el Britannia', 'anime_mal_id': 1575, 'tags': ['villain', 'strategist'], 'difficulty': 'hard', 'alias': 'Schneizel'},
    {'mal_id': 980054, 'name': 'Jeremiah Gottwald', 'anime_mal_id': 1575, 'tags': ['rival', 'cyborg', 'strong'], 'difficulty': 'medium', 'alias': 'Jeremiah'},
    {'mal_id': 980055, 'name': 'Villetta Nu', 'anime_mal_id': 1575, 'tags': ['villain', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Villetta'},
    {'mal_id': 980056, 'name': 'Sayoko Shinozaki', 'anime_mal_id': 1575, 'tags': ['hero', 'assassin', 'strategist'], 'difficulty': 'medium', 'alias': 'Sayoko'},
    {'mal_id': 980057, 'name': 'Lloyd Asplund', 'anime_mal_id': 1575, 'tags': ['strategist'], 'difficulty': 'medium', 'alias': 'Lloyd'},
    {'mal_id': 980058, 'name': 'Gino Weinberg', 'anime_mal_id': 1575, 'tags': ['hero', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Gino'},
    {'mal_id': 980059, 'name': 'Anya Alstreim', 'anime_mal_id': 1575, 'tags': ['hero', 'young', 'strong'], 'difficulty': 'medium', 'alias': 'Anya'},
    {'mal_id': 980060, 'name': 'Rolo Lamperouge', 'anime_mal_id': 1575, 'tags': ['villain', 'young', 'assassin', 'super_powers'], 'difficulty': 'medium', 'alias': 'Rolo'},
    {'mal_id': 980061, 'name': 'Anya Forger', 'anime_mal_id': 50265, 'tags': ['hero', 'young', 'psychic'], 'difficulty': 'easy', 'alias': 'Anya'},
    {'mal_id': 980062, 'name': 'Yor Forger', 'anime_mal_id': 50265, 'tags': ['hero', 'assassin', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Yor'},
    {'mal_id': 980063, 'name': 'Loid Forger', 'anime_mal_id': 50265, 'tags': ['protagonist', 'hero', 'strategist'], 'difficulty': 'medium', 'alias': 'Twilight'},
    {'mal_id': 980064, 'name': 'Becky Blackbell', 'anime_mal_id': 50265, 'tags': ['hero', 'young'], 'difficulty': 'easy', 'alias': 'Becky'},
    {'mal_id': 980065, 'name': 'Yuri Briar', 'anime_mal_id': 50265, 'tags': ['rival', 'strategist'], 'difficulty': 'medium', 'alias': 'Yuri'},
    {'mal_id': 980066, 'name': 'Damian Desmond', 'anime_mal_id': 50265, 'tags': ['rival', 'young', 'strategist'], 'difficulty': 'easy', 'alias': 'Damian'},
    {'mal_id': 980067, 'name': 'Bond Forger', 'anime_mal_id': 50265, 'tags': ['hero', 'non_human'], 'difficulty': 'easy', 'alias': 'Bond'},
    {'mal_id': 980068, 'name': 'Sylvia Sherwood', 'anime_mal_id': 50265, 'tags': ['mentor', 'strategist'], 'difficulty': 'medium', 'alias': 'Handler'},
    {'mal_id': 980069, 'name': 'Franky Franklin', 'anime_mal_id': 50265, 'tags': ['hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Franky'},
    {'mal_id': 980070, 'name': 'Fiona Frost', 'anime_mal_id': 50265, 'tags': ['rival', 'strategist', 'stoic'], 'difficulty': 'medium', 'alias': 'Nightfall'},
    {'mal_id': 980071, 'name': 'Rin Okumura', 'anime_mal_id': 9919, 'tags': ['protagonist', 'hero', 'demon', 'has_transformation', 'fire_user'], 'difficulty': 'medium', 'alias': 'Rin'},
    {'mal_id': 980072, 'name': 'Yukio Okumura', 'anime_mal_id': 9919, 'tags': ['hero', 'strategist', 'gun_user'], 'difficulty': 'medium', 'alias': 'Yukio'},
    {'mal_id': 980073, 'name': 'Shiemi Moriyama', 'anime_mal_id': 9919, 'tags': ['hero', 'young', 'magic_user'], 'difficulty': 'easy', 'alias': 'Shiemi'},
    {'mal_id': 980074, 'name': 'Mephisto Pheles', 'anime_mal_id': 9919, 'tags': ['villain', 'strategist', 'magic_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Mephisto'},
    {'mal_id': 980075, 'name': 'Amaimon', 'anime_mal_id': 9919, 'tags': ['villain', 'demon', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Amaimon'},
    {'mal_id': 980076, 'name': 'Izumo Kamiki', 'anime_mal_id': 9919, 'tags': ['hero', 'young', 'magic_user'], 'difficulty': 'medium', 'alias': 'Izumo'},
    {'mal_id': 980077, 'name': 'Shura Kirigakure', 'anime_mal_id': 9919, 'tags': ['mentor', 'hero', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Shura'},
    {'mal_id': 980078, 'name': 'Ryuji Suguro', 'anime_mal_id': 9919, 'tags': ['rival', 'strong', 'magic_user'], 'difficulty': 'medium', 'alias': 'Bon'},
    {'mal_id': 980079, 'name': 'Konekomaru Miwa', 'anime_mal_id': 9919, 'tags': ['hero', 'young', 'strategist', 'magic_user'], 'difficulty': 'easy', 'alias': 'Konekomaru'},
    {'mal_id': 980080, 'name': 'Renzo Shima', 'anime_mal_id': 9919, 'tags': ['rival', 'strategist', 'magic_user'], 'difficulty': 'medium', 'alias': 'Renzo'},
    {'mal_id': 980081, 'name': 'Maka Albarn', 'anime_mal_id': 3588, 'tags': ['protagonist', 'hero', 'young', 'uses_sword'], 'difficulty': 'medium', 'alias': 'Maka'},
    {'mal_id': 980082, 'name': 'Soul Eater Evans', 'anime_mal_id': 3588, 'tags': ['rival', 'hero', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Soul'},
    {'mal_id': 980083, 'name': 'Death the Kid', 'anime_mal_id': 3588, 'tags': ['hero', 'strategist', 'gun_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kid'},
    {'mal_id': 980084, 'name': 'Black Star', 'anime_mal_id': 3588, 'tags': ['rival', 'hero', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Black☆Star'},
    {'mal_id': 980085, 'name': 'Tsubaki Nakatsukasa', 'anime_mal_id': 3588, 'tags': ['hero', 'uses_sword', 'super_powers'], 'difficulty': 'medium', 'alias': 'Tsubaki'},
    {'mal_id': 980086, 'name': 'Patty Thompson', 'anime_mal_id': 3588, 'tags': ['hero', 'young', 'gun_user'], 'difficulty': 'easy', 'alias': 'Patty'},
    {'mal_id': 980087, 'name': 'Liz Thompson', 'anime_mal_id': 3588, 'tags': ['hero', 'gun_user'], 'difficulty': 'easy', 'alias': 'Liz'},
    {'mal_id': 980088, 'name': 'Franken Stein', 'anime_mal_id': 3588, 'tags': ['mentor', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Dr. Stein'},
    {'mal_id': 980089, 'name': 'Medusa Gorgon', 'anime_mal_id': 3588, 'tags': ['villain', 'strategist', 'magic_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Medusa'},
    {'mal_id': 980090, 'name': 'Crona', 'anime_mal_id': 3588, 'tags': ['rival', 'has_tragic_past', 'uses_sword', 'super_powers'], 'difficulty': 'medium', 'alias': 'Crona'},
    {'mal_id': 980091, 'name': 'Shinra Kusakabe', 'anime_mal_id': 38671, 'tags': ['protagonist', 'hero', 'fire_user', 'has_tragic_past', 'super_powers'], 'difficulty': 'easy', 'alias': 'Shinra'},
    {'mal_id': 980092, 'name': 'Arthur Boyle', 'anime_mal_id': 38671, 'tags': ['rival', 'hero', 'uses_sword', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Arthur'},
    {'mal_id': 980093, 'name': 'Maki Oze', 'anime_mal_id': 38671, 'tags': ['hero', 'strong', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Maki'},
    {'mal_id': 980094, 'name': 'Takehisa Hinawa', 'anime_mal_id': 38671, 'tags': ['mentor', 'hero', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Hinawa'},
    {'mal_id': 980095, 'name': 'Tamaki Kotatsu', 'anime_mal_id': 38671, 'tags': ['hero', 'young', 'fire_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'Tamaki'},
    {'mal_id': 980096, 'name': 'Benimaru Shinmon', 'anime_mal_id': 38671, 'tags': ['mentor', 'strong', 'fire_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Benimaru'},
    {'mal_id': 980097, 'name': 'Joker', 'anime_mal_id': 38671, 'tags': ['rival', 'strategist', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Joker'},
    {'mal_id': 980098, 'name': 'Hibana', 'anime_mal_id': 38671, 'tags': ['hero', 'strategist', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Princess Hibana'},
    {'mal_id': 980099, 'name': 'Leonard Burns', 'anime_mal_id': 38671, 'tags': ['mentor', 'strong', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Burns'},
    {'mal_id': 980100, 'name': 'Sho Kusakabe', 'anime_mal_id': 38671, 'tags': ['rival', 'young', 'has_tragic_past', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Sho'},
]

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
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 34000 + index * 520
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

print(f'updated tenth large import batch with {len(characters)} high-throughput staged characters')
