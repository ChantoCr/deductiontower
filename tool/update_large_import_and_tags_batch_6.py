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
    {'mal_id': 930001, 'name': 'Temari', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Temari'},
    {'mal_id': 930002, 'name': 'Kankuro', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kankuro'},
    {'mal_id': 930003, 'name': 'Sai', 'anime_mal_id': 20, 'tags': ['black_hair', 'hero', 'young', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Sai'},
    {'mal_id': 930004, 'name': 'Konan', 'anime_mal_id': 20, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Konan'},
    {'mal_id': 930005, 'name': 'Deidara', 'anime_mal_id': 20, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Deidara'},
    {'mal_id': 930006, 'name': 'Kisame Hoshigaki', 'anime_mal_id': 20, 'tags': ['villain', 'non_human', 'water_user', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Kisame'},
    {'mal_id': 930007, 'name': 'Sasori', 'anime_mal_id': 20, 'tags': ['villain', 'strategist', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Sasori'},
    {'mal_id': 930008, 'name': 'Hidan', 'anime_mal_id': 20, 'tags': ['villain', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Hidan'},
    {'mal_id': 930009, 'name': 'Zabuza Momochi', 'anime_mal_id': 20, 'tags': ['uses_sword', 'villain', 'has_tragic_past', 'strong'], 'difficulty': 'medium', 'alias': 'Zabuza'},
    {'mal_id': 930010, 'name': 'Haku', 'anime_mal_id': 20, 'tags': ['young', 'has_tragic_past', 'ice_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Haku'},
    {'mal_id': 930011, 'name': 'Franky', 'anime_mal_id': 21, 'tags': ['hero', 'cyborg', 'strong'], 'difficulty': 'medium', 'alias': 'Franky'},
    {'mal_id': 930012, 'name': 'Brook', 'anime_mal_id': 21, 'tags': ['hero', 'non_human', 'uses_sword'], 'difficulty': 'medium', 'alias': 'Soul King'},
    {'mal_id': 930013, 'name': 'Jinbe', 'anime_mal_id': 21, 'tags': ['hero', 'non_human', 'strong', 'water_user'], 'difficulty': 'medium', 'alias': 'Jinbe'},
    {'mal_id': 930014, 'name': 'Yamato', 'anime_mal_id': 21, 'tags': ['hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yamato'},
    {'mal_id': 930015, 'name': 'Eustass Kid', 'anime_mal_id': 21, 'tags': ['rival', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kid'},
    {'mal_id': 930016, 'name': 'Rob Lucci', 'anime_mal_id': 21, 'tags': ['villain', 'assassin', 'strong', 'has_transformation'], 'difficulty': 'hard', 'alias': 'Lucci'},
    {'mal_id': 930017, 'name': 'Crocodile', 'anime_mal_id': 21, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Crocodile'},
    {'mal_id': 930018, 'name': 'Smoker', 'anime_mal_id': 21, 'tags': ['white_hair', 'hero', 'super_powers'], 'difficulty': 'medium', 'alias': 'Smoker'},
    {'mal_id': 930019, 'name': 'Enel', 'anime_mal_id': 21, 'tags': ['villain', 'lightning_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Enel'},
    {'mal_id': 930020, 'name': 'Charlotte Katakuri', 'anime_mal_id': 21, 'tags': ['villain', 'strong', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Katakuri'},
    {'mal_id': 930021, 'name': 'Sajin Komamura', 'anime_mal_id': 269, 'tags': ['uses_sword', 'non_human', 'hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Komamura'},
    {'mal_id': 930022, 'name': 'Retsu Unohana', 'anime_mal_id': 269, 'tags': ['uses_sword', 'mentor', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Unohana'},
    {'mal_id': 930023, 'name': 'Soi Fon', 'anime_mal_id': 269, 'tags': ['assassin', 'hero', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Soi Fon'},
    {'mal_id': 930024, 'name': 'Shuhei Hisagi', 'anime_mal_id': 269, 'tags': ['hero', 'uses_sword', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hisagi'},
    {'mal_id': 930025, 'name': 'Kaname Tosen', 'anime_mal_id': 269, 'tags': ['villain', 'uses_sword', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Tosen'},
    {'mal_id': 930026, 'name': 'Nelliel Tu Odelschwanck', 'anime_mal_id': 269, 'tags': ['hero', 'non_human', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Nel'},
    {'mal_id': 930027, 'name': 'Tier Harribel', 'anime_mal_id': 269, 'tags': ['villain', 'non_human', 'water_user', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Harribel'},
    {'mal_id': 930028, 'name': 'Coyote Starrk', 'anime_mal_id': 269, 'tags': ['villain', 'non_human', 'gun_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Starrk'},
    {'mal_id': 930029, 'name': 'Nnoitra Gilga', 'anime_mal_id': 269, 'tags': ['villain', 'non_human', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Nnoitra'},
    {'mal_id': 930030, 'name': 'Yhwach', 'anime_mal_id': 269, 'tags': ['villain', 'strategist', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Yhwach'},
    {'mal_id': 930031, 'name': 'Bulma', 'anime_mal_id': 223, 'tags': ['hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Bulma'},
    {'mal_id': 930032, 'name': 'Videl', 'anime_mal_id': 223, 'tags': ['hero', 'young', 'strong'], 'difficulty': 'easy', 'alias': 'Videl'},
    {'mal_id': 930033, 'name': 'Tien Shinhan', 'anime_mal_id': 223, 'tags': ['hero', 'martial_artist', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Tien'},
    {'mal_id': 930034, 'name': 'Yamcha', 'anime_mal_id': 223, 'tags': ['hero', 'martial_artist', 'strong'], 'difficulty': 'easy', 'alias': 'Yamcha'},
    {'mal_id': 930035, 'name': 'Android 17', 'anime_mal_id': 223, 'tags': ['cyborg', 'hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': '17'},
    {'mal_id': 930036, 'name': 'Whis', 'anime_mal_id': 223, 'tags': ['mentor', 'non_human', 'fast', 'super_powers'], 'difficulty': 'hard', 'alias': 'Whis'},
    {'mal_id': 930037, 'name': 'Jiren', 'anime_mal_id': 223, 'tags': ['strong', 'fast', 'super_powers'], 'difficulty': 'hard', 'alias': 'Jiren'},
    {'mal_id': 930038, 'name': 'Hit', 'anime_mal_id': 223, 'tags': ['assassin', 'fast', 'super_powers'], 'difficulty': 'hard', 'alias': 'Hit'},
    {'mal_id': 930039, 'name': 'Goten', 'anime_mal_id': 223, 'tags': ['young', 'hero', 'has_transformation', 'super_powers', 'super_saiyan'], 'difficulty': 'easy', 'alias': 'Goten'},
    {'mal_id': 930040, 'name': 'Cabba', 'anime_mal_id': 223, 'tags': ['young', 'hero', 'has_transformation', 'super_powers', 'super_saiyan'], 'difficulty': 'easy', 'alias': 'Cabba'},
    {'mal_id': 930041, 'name': 'Eijiro Kirishima', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'strong', 'has_transformation', 'super_powers'], 'difficulty': 'easy', 'alias': 'Kirishima'},
    {'mal_id': 930042, 'name': 'Momo Yaoyorozu', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Momo'},
    {'mal_id': 930043, 'name': 'Tsuyu Asui', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'super_powers'], 'difficulty': 'easy', 'alias': 'Tsuyu'},
    {'mal_id': 930044, 'name': 'Mirio Togata', 'anime_mal_id': 31964, 'tags': ['hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Lemillion'},
    {'mal_id': 930045, 'name': 'Tamaki Amajiki', 'anime_mal_id': 31964, 'tags': ['hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Suneater'},
    {'mal_id': 930046, 'name': 'Nejire Hado', 'anime_mal_id': 31964, 'tags': ['hero', 'super_powers'], 'difficulty': 'medium', 'alias': 'Nejire'},
    {'mal_id': 930047, 'name': 'Twice', 'anime_mal_id': 31964, 'tags': ['villain', 'has_tragic_past', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Twice'},
    {'mal_id': 930048, 'name': 'Spinner', 'anime_mal_id': 31964, 'tags': ['villain', 'non_human'], 'difficulty': 'medium', 'alias': 'Spinner'},
    {'mal_id': 930049, 'name': 'Stain', 'anime_mal_id': 31964, 'tags': ['villain', 'uses_sword', 'fast', 'super_powers'], 'difficulty': 'hard', 'alias': 'Stain'},
    {'mal_id': 930050, 'name': 'Gentle Criminal', 'anime_mal_id': 31964, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gentle'},
    {'mal_id': 930051, 'name': 'Kento Nanami', 'anime_mal_id': 40748, 'tags': ['mentor', 'hero', 'uses_sword', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Nanami'},
    {'mal_id': 930052, 'name': 'Toge Inumaki', 'anime_mal_id': 40748, 'tags': ['white_hair', 'hero', 'young', 'super_powers'], 'difficulty': 'medium', 'alias': 'Inumaki'},
    {'mal_id': 930053, 'name': 'Panda', 'anime_mal_id': 40748, 'tags': ['non_human', 'hero', 'strong'], 'difficulty': 'easy', 'alias': 'Panda'},
    {'mal_id': 930054, 'name': 'Mahito', 'anime_mal_id': 40748, 'tags': ['villain', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Mahito'},
    {'mal_id': 930055, 'name': 'Aoi Todo', 'anime_mal_id': 40748, 'tags': ['hero', 'strong', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Todo'},
    {'mal_id': 930056, 'name': 'Mei Mei', 'anime_mal_id': 40748, 'tags': ['hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mei Mei'},
    {'mal_id': 930057, 'name': 'Kasumi Miwa', 'anime_mal_id': 40748, 'tags': ['hero', 'young', 'uses_sword'], 'difficulty': 'easy', 'alias': 'Miwa'},
    {'mal_id': 930058, 'name': 'Momo Nishimiya', 'anime_mal_id': 40748, 'tags': ['hero', 'young', 'magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Momo Nishimiya'},
    {'mal_id': 930059, 'name': 'Noritoshi Kamo', 'anime_mal_id': 40748, 'tags': ['hero', 'young', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kamo'},
    {'mal_id': 930060, 'name': 'Jogo', 'anime_mal_id': 40748, 'tags': ['villain', 'fire_user', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Jogo'},
    {'mal_id': 930061, 'name': 'Magna Swing', 'anime_mal_id': 34572, 'tags': ['hero', 'fire_user', 'strong', 'super_powers'], 'difficulty': 'easy', 'alias': 'Magna'},
    {'mal_id': 930062, 'name': 'Nozel Silva', 'anime_mal_id': 34572, 'tags': ['hero', 'strategist', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Nozel'},
    {'mal_id': 930063, 'name': 'Fuegoleon Vermillion', 'anime_mal_id': 34572, 'tags': ['mentor', 'hero', 'fire_user', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Fuegoleon'},
    {'mal_id': 930064, 'name': 'Leopold Vermillion', 'anime_mal_id': 34572, 'tags': ['hero', 'young', 'fire_user', 'super_powers'], 'difficulty': 'easy', 'alias': 'Leopold'},
    {'mal_id': 930065, 'name': 'Secre Swallowtail', 'anime_mal_id': 34572, 'tags': ['hero', 'magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Secre'},
    {'mal_id': 930066, 'name': 'William Vangeance', 'anime_mal_id': 34572, 'tags': ['mentor', 'hero', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'William'},
    {'mal_id': 930067, 'name': 'Patolli', 'anime_mal_id': 34572, 'tags': ['villain', 'has_tragic_past', 'magic_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Patolli'},
    {'mal_id': 930068, 'name': 'Zora Ideale', 'anime_mal_id': 34572, 'tags': ['hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Zora'},
    {'mal_id': 930069, 'name': 'Gordon Agrippa', 'anime_mal_id': 34572, 'tags': ['hero', 'magic_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gordon'},
    {'mal_id': 930070, 'name': 'Rhya', 'anime_mal_id': 34572, 'tags': ['villain', 'magic_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Rhya'},
    {'mal_id': 930071, 'name': 'Phinks Magcub', 'anime_mal_id': 11061, 'tags': ['villain', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Phinks'},
    {'mal_id': 930072, 'name': 'Machi Komacine', 'anime_mal_id': 11061, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Machi'},
    {'mal_id': 930073, 'name': 'Nobunaga Hazama', 'anime_mal_id': 11061, 'tags': ['villain', 'uses_sword', 'strong'], 'difficulty': 'hard', 'alias': 'Nobunaga'},
    {'mal_id': 930074, 'name': 'Pakunoda', 'anime_mal_id': 11061, 'tags': ['villain', 'gun_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Pakunoda'},
    {'mal_id': 930075, 'name': 'Franklin Bordeau', 'anime_mal_id': 11061, 'tags': ['villain', 'gun_user', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Franklin'},
    {'mal_id': 930076, 'name': 'Bonolenov Ndongo', 'anime_mal_id': 11061, 'tags': ['villain', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Bonolenov'},
    {'mal_id': 930077, 'name': 'Uvogin', 'anime_mal_id': 11061, 'tags': ['villain', 'strong'], 'difficulty': 'hard', 'alias': 'Uvogin'},
    {'mal_id': 930078, 'name': 'Colt', 'anime_mal_id': 11061, 'tags': ['non_human', 'hero', 'strong'], 'difficulty': 'medium', 'alias': 'Colt'},
    {'mal_id': 930079, 'name': 'Neferpitou', 'anime_mal_id': 11061, 'tags': ['villain', 'non_human', 'fast', 'super_powers'], 'difficulty': 'hard', 'alias': 'Pitou'},
    {'mal_id': 930080, 'name': 'Shaiapouf', 'anime_mal_id': 11061, 'tags': ['villain', 'non_human', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Pouf'},
    {'mal_id': 930081, 'name': 'Asa Mitaka', 'anime_mal_id': 44511, 'tags': ['protagonist', 'young', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Asa'},
    {'mal_id': 930082, 'name': 'Fami', 'anime_mal_id': 44511, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Fami'},
    {'mal_id': 930083, 'name': 'Yoru', 'anime_mal_id': 44511, 'tags': ['villain', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Yoru'},
    {'mal_id': 930084, 'name': 'Beam', 'anime_mal_id': 44511, 'tags': ['non_human', 'hero', 'super_powers'], 'difficulty': 'medium', 'alias': 'Beam'},
    {'mal_id': 930085, 'name': 'Violence Fiend', 'anime_mal_id': 44511, 'tags': ['non_human', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Violence'},
    {'mal_id': 930086, 'name': 'Katana Man', 'anime_mal_id': 44511, 'tags': ['villain', 'uses_sword', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Katana Man'},
    {'mal_id': 930087, 'name': 'Reze', 'anime_mal_id': 44511, 'tags': ['villain', 'has_transformation', 'fast', 'super_powers'], 'difficulty': 'hard', 'alias': 'Reze'},
    {'mal_id': 930088, 'name': 'Akane Sawatari', 'anime_mal_id': 44511, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Akane'},
    {'mal_id': 930089, 'name': 'Santa Claus', 'anime_mal_id': 44511, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Santa Claus'},
    {'mal_id': 930090, 'name': 'Princi', 'anime_mal_id': 44511, 'tags': ['hero', 'strong'], 'difficulty': 'medium', 'alias': 'Princi'},
    {'mal_id': 930091, 'name': 'Sasha Blouse', 'anime_mal_id': 16498, 'tags': ['hero', 'young'], 'difficulty': 'easy', 'alias': 'Sasha'},
    {'mal_id': 930092, 'name': 'Historia Reiss', 'anime_mal_id': 16498, 'tags': ['hero', 'young', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Historia'},
    {'mal_id': 930093, 'name': 'Zeke Yeager', 'anime_mal_id': 16498, 'tags': ['villain', 'strategist', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Zeke'},
    {'mal_id': 930094, 'name': 'Olivier Mira Armstrong', 'anime_mal_id': 5114, 'tags': ['mentor', 'hero', 'strong', 'strategist'], 'difficulty': 'medium', 'alias': 'Olivier'},
    {'mal_id': 930095, 'name': 'Alex Louis Armstrong', 'anime_mal_id': 5114, 'tags': ['hero', 'strong', 'muscular'], 'difficulty': 'easy', 'alias': 'Armstrong'},
    {'mal_id': 930096, 'name': 'Envy', 'anime_mal_id': 5114, 'tags': ['villain', 'has_transformation', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Envy'},
    {'mal_id': 930097, 'name': 'Greed', 'anime_mal_id': 5114, 'tags': ['villain', 'has_transformation', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Greed'},
    {'mal_id': 930098, 'name': 'Soichiro Yagami', 'anime_mal_id': 1535, 'tags': ['hero', 'strategist'], 'difficulty': 'medium', 'alias': 'Soichiro'},
    {'mal_id': 930099, 'name': 'Teru Mikami', 'anime_mal_id': 1535, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Mikami'},
    {'mal_id': 930100, 'name': 'Shirley Fenette', 'anime_mal_id': 1575, 'tags': ['hero', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Shirley'},
]

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 22000 + index * 510
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

print(f'updated sixth large import batch with {len(characters)} high-throughput staged characters')
