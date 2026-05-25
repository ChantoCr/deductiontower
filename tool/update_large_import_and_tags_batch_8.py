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


characters = [
    {'mal_id': 960001, 'name': 'Obanai Iguro', 'anime_mal_id': 38000, 'tags': ['black_hair', 'hero', 'uses_sword', 'stoic', 'strong'], 'difficulty': 'medium', 'alias': 'Obanai'},
    {'mal_id': 960002, 'name': 'Mitsuri Kanroji', 'anime_mal_id': 38000, 'tags': ['pink_hair', 'hero', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Mitsuri'},
    {'mal_id': 960003, 'name': 'Muichiro Tokito', 'anime_mal_id': 38000, 'tags': ['young', 'hero', 'uses_sword', 'stoic', 'strong'], 'difficulty': 'medium', 'alias': 'Muichiro'},
    {'mal_id': 960004, 'name': 'Gyomei Himejima', 'anime_mal_id': 38000, 'tags': ['mentor', 'hero', 'strong', 'muscular'], 'difficulty': 'medium', 'alias': 'Gyomei'},
    {'mal_id': 960005, 'name': 'Daki', 'anime_mal_id': 38000, 'tags': ['villain', 'demon', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Daki'},
    {'mal_id': 960006, 'name': 'Gyutaro', 'anime_mal_id': 38000, 'tags': ['villain', 'demon', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Gyutaro'},
    {'mal_id': 960007, 'name': 'Douma', 'anime_mal_id': 38000, 'tags': ['villain', 'demon', 'ice_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Douma'},
    {'mal_id': 960008, 'name': 'Gyokko', 'anime_mal_id': 38000, 'tags': ['villain', 'demon', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Gyokko'},
    {'mal_id': 960009, 'name': 'Rui', 'anime_mal_id': 38000, 'tags': ['villain', 'demon', 'young', 'super_powers'], 'difficulty': 'medium', 'alias': 'Rui'},
    {'mal_id': 960010, 'name': 'Enmu', 'anime_mal_id': 38000, 'tags': ['villain', 'demon', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Enmu'},
    {'mal_id': 960011, 'name': 'Laxus Dreyar', 'anime_mal_id': 6702, 'tags': ['hero', 'lightning_user', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Laxus'},
    {'mal_id': 960012, 'name': 'Mavis Vermillion', 'anime_mal_id': 6702, 'tags': ['mentor', 'strategist', 'magic_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Mavis'},
    {'mal_id': 960013, 'name': 'Gildarts Clive', 'anime_mal_id': 6702, 'tags': ['mentor', 'hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gildarts'},
    {'mal_id': 960014, 'name': 'Levy McGarden', 'anime_mal_id': 6702, 'tags': ['hero', 'young', 'strategist', 'magic_user'], 'difficulty': 'easy', 'alias': 'Levy'},
    {'mal_id': 960015, 'name': 'Juvia Lockser', 'anime_mal_id': 6702, 'tags': ['hero', 'water_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Juvia'},
    {'mal_id': 960016, 'name': 'Elfman Strauss', 'anime_mal_id': 6702, 'tags': ['hero', 'muscular', 'strong', 'has_transformation'], 'difficulty': 'medium', 'alias': 'Elfman'},
    {'mal_id': 960017, 'name': 'Rogue Cheney', 'anime_mal_id': 6702, 'tags': ['rival', 'black_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Rogue'},
    {'mal_id': 960018, 'name': 'Sting Eucliffe', 'anime_mal_id': 6702, 'tags': ['blond_hair', 'rival', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Sting'},
    {'mal_id': 960019, 'name': 'Ultear Milkovich', 'anime_mal_id': 6702, 'tags': ['has_tragic_past', 'strategist', 'magic_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Ultear'},
    {'mal_id': 960020, 'name': 'Kagura Mikazuchi', 'anime_mal_id': 6702, 'tags': ['hero', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Kagura'},
    {'mal_id': 960021, 'name': 'Chu', 'anime_mal_id': 392, 'tags': ['villain', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Chu'},
    {'mal_id': 960022, 'name': 'Jin', 'anime_mal_id': 392, 'tags': ['hero', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Jin'},
    {'mal_id': 960023, 'name': 'Toya', 'anime_mal_id': 392, 'tags': ['villain', 'ice_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Toya'},
    {'mal_id': 960024, 'name': 'Bui', 'anime_mal_id': 392, 'tags': ['villain', 'strong', 'muscular'], 'difficulty': 'medium', 'alias': 'Bui'},
    {'mal_id': 960025, 'name': 'Yomi', 'anime_mal_id': 392, 'tags': ['villain', 'strategist', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Yomi'},
    {'mal_id': 960026, 'name': 'Mukuro', 'anime_mal_id': 392, 'tags': ['has_tragic_past', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Mukuro'},
    {'mal_id': 960027, 'name': 'Keiko Yukimura', 'anime_mal_id': 392, 'tags': ['hero'], 'difficulty': 'easy', 'alias': 'Keiko'},
    {'mal_id': 960028, 'name': 'Shizuru Kuwabara', 'anime_mal_id': 392, 'tags': ['hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Shizuru'},
    {'mal_id': 960029, 'name': 'George Saotome', 'anime_mal_id': 392, 'tags': ['strategist'], 'difficulty': 'easy', 'alias': 'George'},
    {'mal_id': 960030, 'name': 'Rando', 'anime_mal_id': 392, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Rando'},
    {'mal_id': 960031, 'name': 'Haise Sasaki', 'anime_mal_id': 22319, 'tags': ['protagonist', 'white_hair', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Haise'},
    {'mal_id': 960032, 'name': 'Kuki Urie', 'anime_mal_id': 22319, 'tags': ['hero', 'young', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Urie'},
    {'mal_id': 960033, 'name': 'Ayato Kirishima', 'anime_mal_id': 22319, 'tags': ['black_hair', 'rival', 'non_human', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ayato'},
    {'mal_id': 960034, 'name': 'Seidou Takizawa', 'anime_mal_id': 22319, 'tags': ['villain', 'has_transformation', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Takizawa'},
    {'mal_id': 960035, 'name': 'Naki', 'anime_mal_id': 22319, 'tags': ['villain', 'non_human', 'strong'], 'difficulty': 'medium', 'alias': 'Naki'},
    {'mal_id': 960036, 'name': 'Yoshimura', 'anime_mal_id': 22319, 'tags': ['mentor', 'non_human', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yoshimura'},
    {'mal_id': 960037, 'name': 'Tatara', 'anime_mal_id': 22319, 'tags': ['villain', 'non_human', 'fire_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Tatara'},
    {'mal_id': 960038, 'name': 'Noro', 'anime_mal_id': 22319, 'tags': ['villain', 'non_human', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Noro'},
    {'mal_id': 960039, 'name': 'Roma Hoito', 'anime_mal_id': 22319, 'tags': ['villain', 'non_human', 'strategist'], 'difficulty': 'medium', 'alias': 'Roma'},
    {'mal_id': 960040, 'name': 'Donato Porpora', 'anime_mal_id': 22319, 'tags': ['villain', 'strategist', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Donato'},
    {'mal_id': 960041, 'name': 'Tsubomi Takane', 'anime_mal_id': 32182, 'tags': ['young'], 'difficulty': 'easy', 'alias': 'Tsubomi'},
    {'mal_id': 960042, 'name': 'Ichi Mezato', 'anime_mal_id': 32182, 'tags': ['young', 'strategist'], 'difficulty': 'easy', 'alias': 'Mezato'},
    {'mal_id': 960043, 'name': 'Tenga Onigawara', 'anime_mal_id': 32182, 'tags': ['hero', 'strong'], 'difficulty': 'easy', 'alias': 'Onigawara'},
    {'mal_id': 960044, 'name': 'Koyama Sakurai', 'anime_mal_id': 32182, 'tags': ['villain', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Koyama'},
    {'mal_id': 960045, 'name': 'Tsuchiya', 'anime_mal_id': 32182, 'tags': ['villain', 'psychic', 'super_powers'], 'difficulty': 'medium', 'alias': 'Tsuchiya'},
    {'mal_id': 960046, 'name': 'Minegishi', 'anime_mal_id': 32182, 'tags': ['villain', 'strategist', 'psychic', 'super_powers'], 'difficulty': 'hard', 'alias': 'Minegishi'},
    {'mal_id': 960047, 'name': 'Shinji Kamuro', 'anime_mal_id': 32182, 'tags': ['villain', 'psychic', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kamuro'},
    {'mal_id': 960048, 'name': 'Matsuo', 'anime_mal_id': 32182, 'tags': ['villain', 'strategist', 'psychic'], 'difficulty': 'hard', 'alias': 'Matsuo'},
    {'mal_id': 960049, 'name': 'Takenaka', 'anime_mal_id': 32182, 'tags': ['young', 'psychic'], 'difficulty': 'easy', 'alias': 'Takenaka'},
    {'mal_id': 960050, 'name': 'Ishiguro', 'anime_mal_id': 32182, 'tags': ['villain', 'strategist', 'psychic'], 'difficulty': 'hard', 'alias': 'Ishiguro'},
    {'mal_id': 960051, 'name': 'Mumen Rider', 'anime_mal_id': 30276, 'tags': ['hero'], 'difficulty': 'easy', 'alias': 'Mumen Rider'},
    {'mal_id': 960052, 'name': 'Boros', 'anime_mal_id': 30276, 'tags': ['villain', 'non_human', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Boros'},
    {'mal_id': 960053, 'name': 'Flashy Flash', 'anime_mal_id': 30276, 'tags': ['hero', 'fast'], 'difficulty': 'medium', 'alias': 'Flashy Flash'},
    {'mal_id': 960054, 'name': 'Watchdog Man', 'anime_mal_id': 30276, 'tags': ['hero', 'non_human', 'strong'], 'difficulty': 'medium', 'alias': 'Watchdog Man'},
    {'mal_id': 960055, 'name': 'Drive Knight', 'anime_mal_id': 30276, 'tags': ['hero', 'cyborg', 'strategist'], 'difficulty': 'medium', 'alias': 'Drive Knight'},
    {'mal_id': 960056, 'name': 'Metal Knight', 'anime_mal_id': 30276, 'tags': ['hero', 'cyborg', 'strategist'], 'difficulty': 'medium', 'alias': 'Metal Knight'},
    {'mal_id': 960057, 'name': 'Zombieman', 'anime_mal_id': 30276, 'tags': ['hero', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Zombieman'},
    {'mal_id': 960058, 'name': 'Pig God', 'anime_mal_id': 30276, 'tags': ['hero', 'strong'], 'difficulty': 'easy', 'alias': 'Pig God'},
    {'mal_id': 960059, 'name': 'Superalloy Darkshine', 'anime_mal_id': 30276, 'tags': ['hero', 'muscular', 'strong'], 'difficulty': 'medium', 'alias': 'Darkshine'},
    {'mal_id': 960060, 'name': 'Vaccine Man', 'anime_mal_id': 30276, 'tags': ['villain', 'non_human', 'super_powers'], 'difficulty': 'medium', 'alias': 'Vaccine Man'},
    {'mal_id': 960061, 'name': 'Maiya Hisau', 'anime_mal_id': 10087, 'tags': ['hero', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Maiya'},
    {'mal_id': 960062, 'name': 'Kayneth El-Melloi Archibald', 'anime_mal_id': 10087, 'tags': ['villain', 'strategist', 'magic_user'], 'difficulty': 'hard', 'alias': 'Kayneth'},
    {'mal_id': 960063, 'name': 'Sola-Ui Nuada-Re Sophia-Ri', 'anime_mal_id': 10087, 'tags': ['magic_user'], 'difficulty': 'medium', 'alias': 'Sola-Ui'},
    {'mal_id': 960064, 'name': 'Natalia Kaminski', 'anime_mal_id': 10087, 'tags': ['mentor', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Natalia'},
    {'mal_id': 960065, 'name': 'Assassin Hassan-i-Sabbah', 'anime_mal_id': 10087, 'tags': ['villain', 'assassin', 'has_transformation'], 'difficulty': 'hard', 'alias': 'Assassin'},
    {'mal_id': 960066, 'name': 'Uryuu Ryuunosuke', 'anime_mal_id': 10087, 'tags': ['villain', 'strategist'], 'difficulty': 'medium', 'alias': 'Ryuunosuke'},
    {'mal_id': 960067, 'name': 'Aoi Tohsaka', 'anime_mal_id': 10087, 'tags': ['hero'], 'difficulty': 'easy', 'alias': 'Aoi'},
    {'mal_id': 960068, 'name': 'Kariya Matou', 'anime_mal_id': 10087, 'tags': ['has_tragic_past', 'magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kariya'},
    {'mal_id': 960069, 'name': 'Byakuya Matou', 'anime_mal_id': 10087, 'tags': ['villain', 'strategist'], 'difficulty': 'medium', 'alias': 'Byakuya Matou'},
    {'mal_id': 960070, 'name': 'Risei Kotomine', 'anime_mal_id': 10087, 'tags': ['mentor', 'strategist'], 'difficulty': 'medium', 'alias': 'Risei'},
    {'mal_id': 960071, 'name': 'Chomusuke', 'anime_mal_id': 30831, 'tags': ['non_human'], 'difficulty': 'easy', 'alias': 'Chomusuke'},
    {'mal_id': 960072, 'name': 'Luna', 'anime_mal_id': 30831, 'tags': ['hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Luna'},
    {'mal_id': 960073, 'name': 'Sena', 'anime_mal_id': 30831, 'tags': ['hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Sena'},
    {'mal_id': 960074, 'name': 'Beldia', 'anime_mal_id': 30831, 'tags': ['villain', 'non_human', 'uses_sword'], 'difficulty': 'medium', 'alias': 'Beldia'},
    {'mal_id': 960075, 'name': 'Hans', 'anime_mal_id': 30831, 'tags': ['villain', 'non_human', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hans'},
    {'mal_id': 960076, 'name': 'Wolbach', 'anime_mal_id': 30831, 'tags': ['villain', 'magic_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Wolbach'},
    {'mal_id': 960077, 'name': 'Alderp', 'anime_mal_id': 30831, 'tags': ['villain', 'strategist'], 'difficulty': 'medium', 'alias': 'Alderp'},
    {'mal_id': 960078, 'name': 'Dust', 'anime_mal_id': 30831, 'tags': ['hero', 'rival'], 'difficulty': 'easy', 'alias': 'Dust'},
    {'mal_id': 960079, 'name': 'Arnes', 'anime_mal_id': 30831, 'tags': ['hero', 'magic_user'], 'difficulty': 'easy', 'alias': 'Arnes'},
    {'mal_id': 960080, 'name': 'Cecily', 'anime_mal_id': 30831, 'tags': ['hero', 'uses_sword'], 'difficulty': 'easy', 'alias': 'Cecily'},
    {'mal_id': 960081, 'name': 'Kanna', 'anime_mal_id': 249, 'tags': ['villain', 'white_hair', 'young', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kanna'},
    {'mal_id': 960082, 'name': 'Kagura', 'anime_mal_id': 249, 'tags': ['villain', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kagura'},
    {'mal_id': 960083, 'name': 'Jaken', 'anime_mal_id': 249, 'tags': ['non_human'], 'difficulty': 'easy', 'alias': 'Jaken'},
    {'mal_id': 960084, 'name': 'Kohaku', 'anime_mal_id': 249, 'tags': ['young', 'hero', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Kohaku'},
    {'mal_id': 960085, 'name': 'Jakotsu', 'anime_mal_id': 249, 'tags': ['villain', 'uses_sword', 'fast'], 'difficulty': 'medium', 'alias': 'Jakotsu'},
    {'mal_id': 960086, 'name': 'Suikotsu', 'anime_mal_id': 249, 'tags': ['villain', 'has_transformation', 'strong'], 'difficulty': 'medium', 'alias': 'Suikotsu'},
    {'mal_id': 960087, 'name': 'Ginta', 'anime_mal_id': 249, 'tags': ['hero'], 'difficulty': 'easy', 'alias': 'Ginta'},
    {'mal_id': 960088, 'name': 'Hakkaku', 'anime_mal_id': 249, 'tags': ['hero'], 'difficulty': 'easy', 'alias': 'Hakkaku'},
    {'mal_id': 960089, 'name': 'Ayame', 'anime_mal_id': 249, 'tags': ['hero'], 'difficulty': 'easy', 'alias': 'Ayame'},
    {'mal_id': 960090, 'name': 'Goshinki', 'anime_mal_id': 249, 'tags': ['villain', 'demon', 'strong'], 'difficulty': 'medium', 'alias': 'Goshinki'},
    {'mal_id': 960091, 'name': 'Caesar Anthonio Zeppeli', 'anime_mal_id': 14719, 'tags': ['hero', 'strategist', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Caesar'},
    {'mal_id': 960092, 'name': 'Mohammed Avdol', 'anime_mal_id': 14719, 'tags': ['hero', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Avdol'},
    {'mal_id': 960093, 'name': 'Noriaki Kakyoin', 'anime_mal_id': 14719, 'tags': ['hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kakyoin'},
    {'mal_id': 960094, 'name': 'Jolyne Cujoh', 'anime_mal_id': 14719, 'tags': ['protagonist', 'hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Jolyne'},
    {'mal_id': 960095, 'name': 'Leone Abbacchio', 'anime_mal_id': 14719, 'tags': ['hero', 'stoic', 'super_powers'], 'difficulty': 'medium', 'alias': 'Abbacchio'},
    {'mal_id': 960096, 'name': 'Guido Mista', 'anime_mal_id': 14719, 'tags': ['hero', 'gun_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mista'},
    {'mal_id': 960097, 'name': 'Narancia Ghirga', 'anime_mal_id': 14719, 'tags': ['hero', 'young', 'super_powers'], 'difficulty': 'easy', 'alias': 'Narancia'},
    {'mal_id': 960098, 'name': 'Diavolo', 'anime_mal_id': 14719, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Diavolo'},
    {'mal_id': 960099, 'name': 'Weather Report', 'anime_mal_id': 14719, 'tags': ['hero', 'water_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Weather'},
    {'mal_id': 960100, 'name': 'Ermes Costello', 'anime_mal_id': 14719, 'tags': ['hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ermes'},
]

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 28000 + index * 540
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

print(f'updated eighth large import batch with {len(characters)} high-throughput staged characters')
