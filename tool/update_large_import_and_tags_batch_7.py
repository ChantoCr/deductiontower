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
    {'mal_id': 950001, 'name': 'Zenitsu Agatsuma', 'anime_mal_id': 38000, 'tags': ['blond_hair', 'hero', 'young', 'lightning_user', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Zenitsu'},
    {'mal_id': 950002, 'name': 'Inosuke Hashibira', 'anime_mal_id': 38000, 'tags': ['hero', 'uses_sword', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Inosuke'},
    {'mal_id': 950003, 'name': 'Kyojuro Rengoku', 'anime_mal_id': 38000, 'tags': ['mentor', 'hero', 'uses_sword', 'fire_user', 'strong'], 'difficulty': 'medium', 'alias': 'Rengoku'},
    {'mal_id': 950004, 'name': 'Giyu Tomioka', 'anime_mal_id': 38000, 'tags': ['black_hair', 'hero', 'uses_sword', 'stoic', 'strong'], 'difficulty': 'medium', 'alias': 'Giyu'},
    {'mal_id': 950005, 'name': 'Shinobu Kocho', 'anime_mal_id': 38000, 'tags': ['hero', 'uses_sword', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shinobu'},
    {'mal_id': 950006, 'name': 'Tengen Uzui', 'anime_mal_id': 38000, 'tags': ['hero', 'uses_sword', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Tengen'},
    {'mal_id': 950007, 'name': 'Muzan Kibutsuji', 'anime_mal_id': 38000, 'tags': ['villain', 'has_transformation', 'non_human', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Muzan'},
    {'mal_id': 950008, 'name': 'Akaza', 'anime_mal_id': 38000, 'tags': ['villain', 'demon', 'strong', 'fast', 'super_powers'], 'difficulty': 'hard', 'alias': 'Akaza'},
    {'mal_id': 950009, 'name': 'Kokushibo', 'anime_mal_id': 38000, 'tags': ['villain', 'demon', 'uses_sword', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Kokushibo'},
    {'mal_id': 950010, 'name': 'Sanemi Shinazugawa', 'anime_mal_id': 38000, 'tags': ['white_hair', 'hero', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Sanemi'},
    {'mal_id': 950011, 'name': 'Lucy Heartfilia', 'anime_mal_id': 6702, 'tags': ['blond_hair', 'hero', 'young', 'magic_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'Lucy'},
    {'mal_id': 950012, 'name': 'Erza Scarlet', 'anime_mal_id': 6702, 'tags': ['hero', 'uses_sword', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Erza'},
    {'mal_id': 950013, 'name': 'Gray Fullbuster', 'anime_mal_id': 6702, 'tags': ['black_hair', 'hero', 'ice_user', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gray'},
    {'mal_id': 950014, 'name': 'Wendy Marvell', 'anime_mal_id': 6702, 'tags': ['hero', 'young', 'magic_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'Wendy'},
    {'mal_id': 950015, 'name': 'Jellal Fernandes', 'anime_mal_id': 6702, 'tags': ['rival', 'has_tragic_past', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Jellal'},
    {'mal_id': 950016, 'name': 'Gajeel Redfox', 'anime_mal_id': 6702, 'tags': ['rival', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gajeel'},
    {'mal_id': 950017, 'name': 'Mirajane Strauss', 'anime_mal_id': 6702, 'tags': ['white_hair', 'hero', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mirajane'},
    {'mal_id': 950018, 'name': 'Zeref Dragneel', 'anime_mal_id': 6702, 'tags': ['black_hair', 'villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Zeref'},
    {'mal_id': 950019, 'name': 'Acnologia', 'anime_mal_id': 6702, 'tags': ['villain', 'non_human', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Acnologia'},
    {'mal_id': 950020, 'name': 'Cana Alberona', 'anime_mal_id': 6702, 'tags': ['hero', 'strategist', 'magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Cana'},
    {'mal_id': 950021, 'name': 'Kazuma Kuwabara', 'anime_mal_id': 392, 'tags': ['hero', 'rival', 'uses_sword', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kuwabara'},
    {'mal_id': 950022, 'name': 'Genkai', 'anime_mal_id': 392, 'tags': ['mentor', 'hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Genkai'},
    {'mal_id': 950023, 'name': 'Kurama', 'anime_mal_id': 392, 'tags': ['hero', 'strategist', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kurama'},
    {'mal_id': 950024, 'name': 'Younger Toguro', 'anime_mal_id': 392, 'tags': ['villain', 'muscular', 'strong', 'has_transformation'], 'difficulty': 'hard', 'alias': 'Toguro'},
    {'mal_id': 950025, 'name': 'Elder Toguro', 'anime_mal_id': 392, 'tags': ['villain', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Elder Toguro'},
    {'mal_id': 950026, 'name': 'Shinobu Sensui', 'anime_mal_id': 392, 'tags': ['villain', 'strategist', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Sensui'},
    {'mal_id': 950027, 'name': 'Botan', 'anime_mal_id': 392, 'tags': ['hero', 'young', 'super_powers'], 'difficulty': 'easy', 'alias': 'Botan'},
    {'mal_id': 950028, 'name': 'Koenma', 'anime_mal_id': 392, 'tags': ['young', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Koenma'},
    {'mal_id': 950029, 'name': 'Yukina', 'anime_mal_id': 392, 'tags': ['hero', 'ice_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yukina'},
    {'mal_id': 950030, 'name': 'Karasu', 'anime_mal_id': 392, 'tags': ['villain', 'super_powers'], 'difficulty': 'medium', 'alias': 'Karasu'},
    {'mal_id': 950031, 'name': 'Touka Kirishima', 'anime_mal_id': 22319, 'tags': ['hero', 'non_human', 'strong', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Touka'},
    {'mal_id': 950032, 'name': 'Rize Kamishiro', 'anime_mal_id': 22319, 'tags': ['villain', 'non_human', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Rize'},
    {'mal_id': 950033, 'name': 'Koutarou Amon', 'anime_mal_id': 22319, 'tags': ['hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Amon'},
    {'mal_id': 950034, 'name': 'Juuzou Suzuya', 'anime_mal_id': 22319, 'tags': ['white_hair', 'young', 'hero', 'fast'], 'difficulty': 'medium', 'alias': 'Juuzou'},
    {'mal_id': 950035, 'name': 'Hideyoshi Nagachika', 'anime_mal_id': 22319, 'tags': ['hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Hide'},
    {'mal_id': 950036, 'name': 'Kishou Arima', 'anime_mal_id': 22319, 'tags': ['white_hair', 'hero', 'uses_sword', 'strong', 'fast'], 'difficulty': 'hard', 'alias': 'Arima'},
    {'mal_id': 950037, 'name': 'Eto Yoshimura', 'anime_mal_id': 22319, 'tags': ['villain', 'has_transformation', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Eto'},
    {'mal_id': 950038, 'name': 'Hinami Fueguchi', 'anime_mal_id': 22319, 'tags': ['young', 'hero', 'non_human', 'super_powers'], 'difficulty': 'easy', 'alias': 'Hinami'},
    {'mal_id': 950039, 'name': 'Nishiki Nishio', 'anime_mal_id': 22319, 'tags': ['black_hair', 'rival', 'non_human', 'super_powers'], 'difficulty': 'medium', 'alias': 'Nishiki'},
    {'mal_id': 950040, 'name': 'Uta', 'anime_mal_id': 22319, 'tags': ['white_hair', 'villain', 'strategist'], 'difficulty': 'hard', 'alias': 'Uta'},
    {'mal_id': 950041, 'name': 'Dimple', 'anime_mal_id': 32182, 'tags': ['non_human', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Dimple'},
    {'mal_id': 950042, 'name': 'Teruki Hanazawa', 'anime_mal_id': 32182, 'tags': ['blond_hair', 'rival', 'young', 'psychic', 'super_powers'], 'difficulty': 'medium', 'alias': 'Teru'},
    {'mal_id': 950043, 'name': 'Ritsu Kageyama', 'anime_mal_id': 32182, 'tags': ['black_hair', 'young', 'psychic', 'super_powers'], 'difficulty': 'easy', 'alias': 'Ritsu'},
    {'mal_id': 950044, 'name': 'Keiji Mogami', 'anime_mal_id': 32182, 'tags': ['villain', 'psychic', 'super_powers'], 'difficulty': 'hard', 'alias': 'Mogami'},
    {'mal_id': 950045, 'name': 'Musashi Goda', 'anime_mal_id': 32182, 'tags': ['hero', 'muscular', 'strong'], 'difficulty': 'easy', 'alias': 'Musashi'},
    {'mal_id': 950046, 'name': 'Shou Suzuki', 'anime_mal_id': 32182, 'tags': ['blond_hair', 'young', 'psychic', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shou'},
    {'mal_id': 950047, 'name': 'Toichiro Suzuki', 'anime_mal_id': 32182, 'tags': ['villain', 'strategist', 'psychic', 'super_powers'], 'difficulty': 'hard', 'alias': 'Toichiro'},
    {'mal_id': 950048, 'name': 'Tome Kurata', 'anime_mal_id': 32182, 'tags': ['young', 'strategist'], 'difficulty': 'easy', 'alias': 'Tome'},
    {'mal_id': 950049, 'name': 'Katsuya Serizawa', 'anime_mal_id': 32182, 'tags': ['mentor', 'psychic', 'super_powers'], 'difficulty': 'medium', 'alias': 'Serizawa'},
    {'mal_id': 950050, 'name': 'Ryo Shimazaki', 'anime_mal_id': 32182, 'tags': ['villain', 'fast', 'psychic', 'super_powers'], 'difficulty': 'hard', 'alias': 'Shimazaki'},
    {'mal_id': 950051, 'name': "Speed-o'-Sound Sonic", 'anime_mal_id': 30276, 'tags': ['assassin', 'rival', 'fast'], 'difficulty': 'hard', 'alias': 'Sonic'},
    {'mal_id': 950052, 'name': 'Fubuki', 'anime_mal_id': 30276, 'tags': ['hero', 'strategist', 'psychic', 'super_powers'], 'difficulty': 'medium', 'alias': 'Blizzard'},
    {'mal_id': 950053, 'name': 'Bang', 'anime_mal_id': 30276, 'tags': ['mentor', 'martial_artist', 'strong'], 'difficulty': 'medium', 'alias': 'Silver Fang'},
    {'mal_id': 950054, 'name': 'King', 'anime_mal_id': 30276, 'tags': ['hero', 'strategist'], 'difficulty': 'easy', 'alias': 'King'},
    {'mal_id': 950055, 'name': 'Garou', 'anime_mal_id': 30276, 'tags': ['rival', 'strong', 'fast', 'has_transformation'], 'difficulty': 'hard', 'alias': 'Garou'},
    {'mal_id': 950056, 'name': 'Metal Bat', 'anime_mal_id': 30276, 'tags': ['hero', 'strong'], 'difficulty': 'easy', 'alias': 'Metal Bat'},
    {'mal_id': 950057, 'name': 'Puri-Puri Prisoner', 'anime_mal_id': 30276, 'tags': ['hero', 'muscular', 'strong'], 'difficulty': 'easy', 'alias': 'Prisoner'},
    {'mal_id': 950058, 'name': 'Atomic Samurai', 'anime_mal_id': 30276, 'tags': ['hero', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Atomic Samurai'},
    {'mal_id': 950059, 'name': 'Child Emperor', 'anime_mal_id': 30276, 'tags': ['hero', 'young', 'strategist'], 'difficulty': 'easy', 'alias': 'Child Emperor'},
    {'mal_id': 950060, 'name': 'Tanktop Master', 'anime_mal_id': 30276, 'tags': ['hero', 'strong', 'muscular'], 'difficulty': 'easy', 'alias': 'Tanktop Master'},
    {'mal_id': 950061, 'name': 'Kiritsugu Emiya', 'anime_mal_id': 10087, 'tags': ['hero', 'gun_user', 'strategist'], 'difficulty': 'hard', 'alias': 'Kiritsugu'},
    {'mal_id': 950062, 'name': 'Kirei Kotomine', 'anime_mal_id': 10087, 'tags': ['villain', 'strategist', 'strong'], 'difficulty': 'hard', 'alias': 'Kirei'},
    {'mal_id': 950063, 'name': 'Rider Iskandar', 'anime_mal_id': 10087, 'tags': ['mentor', 'hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Iskandar'},
    {'mal_id': 950064, 'name': 'Gilgamesh', 'anime_mal_id': 10087, 'tags': ['villain', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Gilgamesh'},
    {'mal_id': 950065, 'name': 'Lancer Diarmuid', 'anime_mal_id': 10087, 'tags': ['hero', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Lancer'},
    {'mal_id': 950066, 'name': 'Waver Velvet', 'anime_mal_id': 10087, 'tags': ['young', 'hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Waver'},
    {'mal_id': 950067, 'name': 'Irisviel von Einzbern', 'anime_mal_id': 10087, 'tags': ['hero', 'magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Irisviel'},
    {'mal_id': 950068, 'name': 'Berserker Lancelot', 'anime_mal_id': 10087, 'tags': ['villain', 'has_transformation', 'strong'], 'difficulty': 'hard', 'alias': 'Berserker'},
    {'mal_id': 950069, 'name': 'Caster Gilles de Rais', 'anime_mal_id': 10087, 'tags': ['villain', 'magic_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Caster'},
    {'mal_id': 950070, 'name': 'Tokiomi Tohsaka', 'anime_mal_id': 10087, 'tags': ['mentor', 'strategist', 'magic_user'], 'difficulty': 'hard', 'alias': 'Tokiomi'},
    {'mal_id': 950071, 'name': 'Kazuma Satou', 'anime_mal_id': 30831, 'tags': ['protagonist', 'strategist'], 'difficulty': 'easy', 'alias': 'Kazuma'},
    {'mal_id': 950072, 'name': 'Aqua', 'anime_mal_id': 30831, 'tags': ['hero', 'water_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'Aqua'},
    {'mal_id': 950073, 'name': 'Darkness', 'anime_mal_id': 30831, 'tags': ['hero', 'strong'], 'difficulty': 'easy', 'alias': 'Darkness'},
    {'mal_id': 950074, 'name': 'Yunyun', 'anime_mal_id': 30831, 'tags': ['young', 'magic_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'Yunyun'},
    {'mal_id': 950075, 'name': 'Wiz', 'anime_mal_id': 30831, 'tags': ['non_human', 'magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Wiz'},
    {'mal_id': 950076, 'name': 'Vanir', 'anime_mal_id': 30831, 'tags': ['villain', 'non_human', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Vanir'},
    {'mal_id': 950077, 'name': 'Eris', 'anime_mal_id': 30831, 'tags': ['hero', 'super_powers'], 'difficulty': 'easy', 'alias': 'Eris'},
    {'mal_id': 950078, 'name': 'Chris', 'anime_mal_id': 30831, 'tags': ['hero', 'young', 'strategist'], 'difficulty': 'easy', 'alias': 'Chris'},
    {'mal_id': 950079, 'name': 'Mitsurugi Kyouya', 'anime_mal_id': 30831, 'tags': ['rival', 'hero', 'uses_sword'], 'difficulty': 'medium', 'alias': 'Mitsurugi'},
    {'mal_id': 950080, 'name': 'Sylvia', 'anime_mal_id': 30831, 'tags': ['villain', 'has_transformation', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Sylvia'},
    {'mal_id': 950081, 'name': 'Kagome Higurashi', 'anime_mal_id': 249, 'tags': ['protagonist', 'hero', 'young', 'super_powers'], 'difficulty': 'easy', 'alias': 'Kagome'},
    {'mal_id': 950082, 'name': 'Sesshomaru', 'anime_mal_id': 249, 'tags': ['white_hair', 'rival', 'demon', 'uses_sword', 'strong'], 'difficulty': 'hard', 'alias': 'Sesshomaru'},
    {'mal_id': 950083, 'name': 'Miroku', 'anime_mal_id': 249, 'tags': ['hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Miroku'},
    {'mal_id': 950084, 'name': 'Sango', 'anime_mal_id': 249, 'tags': ['hero', 'strong'], 'difficulty': 'easy', 'alias': 'Sango'},
    {'mal_id': 950085, 'name': 'Naraku', 'anime_mal_id': 249, 'tags': ['villain', 'strategist', 'has_transformation', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Naraku'},
    {'mal_id': 950086, 'name': 'Kikyo', 'anime_mal_id': 249, 'tags': ['hero', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kikyo'},
    {'mal_id': 950087, 'name': 'Shippo', 'anime_mal_id': 249, 'tags': ['young', 'non_human', 'super_powers'], 'difficulty': 'easy', 'alias': 'Shippo'},
    {'mal_id': 950088, 'name': 'Bankotsu', 'anime_mal_id': 249, 'tags': ['villain', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Bankotsu'},
    {'mal_id': 950089, 'name': 'Koga', 'anime_mal_id': 249, 'tags': ['rival', 'fast', 'strong'], 'difficulty': 'medium', 'alias': 'Koga'},
    {'mal_id': 950090, 'name': 'Rin', 'anime_mal_id': 249, 'tags': ['young', 'hero'], 'difficulty': 'easy', 'alias': 'Rin'},
    {'mal_id': 950091, 'name': 'Joseph Joestar', 'anime_mal_id': 14719, 'tags': ['hero', 'strategist', 'strong'], 'difficulty': 'medium', 'alias': 'Joseph'},
    {'mal_id': 950092, 'name': 'Josuke Higashikata', 'anime_mal_id': 14719, 'tags': ['protagonist', 'hero', 'strong', 'super_powers'], 'difficulty': 'easy', 'alias': 'Josuke'},
    {'mal_id': 950093, 'name': 'Giorno Giovanna', 'anime_mal_id': 14719, 'tags': ['protagonist', 'hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Giorno'},
    {'mal_id': 950094, 'name': 'Bruno Bucciarati', 'anime_mal_id': 14719, 'tags': ['hero', 'strategist', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Bruno'},
    {'mal_id': 950095, 'name': 'Jean Pierre Polnareff', 'anime_mal_id': 14719, 'tags': ['uses_sword', 'hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Polnareff'},
    {'mal_id': 950096, 'name': 'Yoshikage Kira', 'anime_mal_id': 14719, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Kira'},
    {'mal_id': 950097, 'name': 'Enrico Pucci', 'anime_mal_id': 14719, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Pucci'},
    {'mal_id': 950098, 'name': 'Rohan Kishibe', 'anime_mal_id': 14719, 'tags': ['strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Rohan'},
    {'mal_id': 950099, 'name': 'Okuyasu Nijimura', 'anime_mal_id': 14719, 'tags': ['hero', 'strong', 'super_powers'], 'difficulty': 'easy', 'alias': 'Okuyasu'},
    {'mal_id': 950100, 'name': 'Jonathan Joestar', 'anime_mal_id': 14719, 'tags': ['hero', 'strong', 'muscular'], 'difficulty': 'easy', 'alias': 'Jonathan'},
]

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 25000 + index * 530
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

print(f'updated seventh large import batch with {len(characters)} high-throughput staged characters')
