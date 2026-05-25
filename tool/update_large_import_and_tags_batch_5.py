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
    url_slug = url_name(name)
    return {
        'mal_id': mal_id,
        'name': name,
        'name_kanji': None,
        'nicknames': [alias] if alias else [],
        'favorites': favorites,
        'about': build_about(name, tags),
        'main_picture': f'https://cdn.myanimelist.net/images/characters/sample/{slug}.jpg',
        'url': f'https://myanimelist.net/character/{mal_id}/{url_slug}',
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
    {'mal_id': 920001, 'name': 'Gaara', 'anime_mal_id': 20, 'tags': ['has_tragic_past', 'young', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gaara'},
    {'mal_id': 920002, 'name': 'Hinata Hyuga', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hinata'},
    {'mal_id': 920003, 'name': 'Neji Hyuga', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Neji'},
    {'mal_id': 920004, 'name': 'Orochimaru', 'anime_mal_id': 20, 'tags': ['villain', 'has_transformation', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Orochimaru'},
    {'mal_id': 920005, 'name': 'Tsunade', 'anime_mal_id': 20, 'tags': ['mentor', 'hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Tsunade'},
    {'mal_id': 920006, 'name': 'Pain', 'anime_mal_id': 20, 'tags': ['villain', 'has_tragic_past', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Pain'},
    {'mal_id': 920007, 'name': 'Might Guy', 'anime_mal_id': 20, 'tags': ['mentor', 'hero', 'strong', 'fast', 'martial_artist'], 'difficulty': 'medium', 'alias': 'Guy'},
    {'mal_id': 920008, 'name': 'Shikamaru Nara', 'anime_mal_id': 20, 'tags': ['hero', 'young', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shikamaru'},
    {'mal_id': 920009, 'name': 'Killer Bee', 'anime_mal_id': 20, 'tags': ['hero', 'strong', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Bee'},
    {'mal_id': 920010, 'name': 'Kabuto Yakushi', 'anime_mal_id': 20, 'tags': ['villain', 'strategist', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Kabuto'},
    {'mal_id': 920011, 'name': 'Sanji', 'anime_mal_id': 21, 'tags': ['hero', 'strong', 'fast'], 'difficulty': 'easy', 'alias': 'Black Leg'},
    {'mal_id': 920012, 'name': 'Nami', 'anime_mal_id': 21, 'tags': ['hero', 'strategist'], 'difficulty': 'medium', 'alias': 'Cat Burglar'},
    {'mal_id': 920013, 'name': 'Usopp', 'anime_mal_id': 21, 'tags': ['hero', 'strategist'], 'difficulty': 'medium', 'alias': 'God Usopp'},
    {'mal_id': 920014, 'name': 'Nico Robin', 'anime_mal_id': 21, 'tags': ['black_hair', 'hero', 'strategist', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Robin'},
    {'mal_id': 920015, 'name': 'Trafalgar Law', 'anime_mal_id': 21, 'tags': ['black_hair', 'uses_sword', 'strategist', 'has_tragic_past', 'super_powers'], 'difficulty': 'hard', 'alias': 'Law'},
    {'mal_id': 920016, 'name': 'Portgas D. Ace', 'anime_mal_id': 21, 'tags': ['hero', 'has_tragic_past', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ace'},
    {'mal_id': 920017, 'name': 'Shanks', 'anime_mal_id': 21, 'tags': ['mentor', 'hero', 'strong'], 'difficulty': 'medium', 'alias': 'Red-Haired Shanks'},
    {'mal_id': 920018, 'name': 'Boa Hancock', 'anime_mal_id': 21, 'tags': ['strong', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hancock'},
    {'mal_id': 920019, 'name': 'Donquixote Doflamingo', 'anime_mal_id': 21, 'tags': ['villain', 'strategist', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Doflamingo'},
    {'mal_id': 920020, 'name': 'Sabo', 'anime_mal_id': 21, 'tags': ['hero', 'has_tragic_past', 'fire_user', 'strong'], 'difficulty': 'medium', 'alias': 'Sabo'},
    {'mal_id': 920021, 'name': 'Renji Abarai', 'anime_mal_id': 269, 'tags': ['uses_sword', 'hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Renji'},
    {'mal_id': 920022, 'name': 'Uryuu Ishida', 'anime_mal_id': 269, 'tags': ['hero', 'strategist', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Uryuu'},
    {'mal_id': 920023, 'name': 'Orihime Inoue', 'anime_mal_id': 269, 'tags': ['hero', 'young', 'super_powers'], 'difficulty': 'easy', 'alias': 'Orihime'},
    {'mal_id': 920024, 'name': 'Toshiro Hitsugaya', 'anime_mal_id': 269, 'tags': ['white_hair', 'young', 'ice_user', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hitsugaya'},
    {'mal_id': 920025, 'name': 'Ulquiorra Cifer', 'anime_mal_id': 269, 'tags': ['villain', 'non_human', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Ulquiorra'},
    {'mal_id': 920026, 'name': 'Grimmjow Jaegerjaquez', 'anime_mal_id': 269, 'tags': ['villain', 'non_human', 'strong', 'fast', 'super_powers'], 'difficulty': 'hard', 'alias': 'Grimmjow'},
    {'mal_id': 920027, 'name': 'Kisuke Urahara', 'anime_mal_id': 269, 'tags': ['mentor', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Urahara'},
    {'mal_id': 920028, 'name': 'Yoruichi Shihouin', 'anime_mal_id': 269, 'tags': ['hero', 'fast', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yoruichi'},
    {'mal_id': 920029, 'name': 'Gin Ichimaru', 'anime_mal_id': 269, 'tags': ['villain', 'strategist', 'has_tragic_past', 'super_powers'], 'difficulty': 'hard', 'alias': 'Gin'},
    {'mal_id': 920030, 'name': 'Mayuri Kurotsuchi', 'anime_mal_id': 269, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Mayuri'},
    {'mal_id': 920031, 'name': 'Gohan', 'anime_mal_id': 223, 'tags': ['hero', 'young', 'has_transformation', 'strong', 'super_powers', 'super_saiyan'], 'difficulty': 'easy', 'alias': 'Son Gohan'},
    {'mal_id': 920032, 'name': 'Piccolo', 'anime_mal_id': 223, 'tags': ['mentor', 'non_human', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Piccolo'},
    {'mal_id': 920033, 'name': 'Future Trunks', 'anime_mal_id': 223, 'tags': ['uses_sword', 'hero', 'has_transformation', 'strong', 'fast', 'super_powers', 'super_saiyan'], 'difficulty': 'medium', 'alias': 'Trunks'},
    {'mal_id': 920034, 'name': 'Cell', 'anime_mal_id': 223, 'tags': ['villain', 'has_transformation', 'non_human', 'strong', 'fast', 'super_powers'], 'difficulty': 'hard', 'alias': 'Cell'},
    {'mal_id': 920035, 'name': 'Majin Buu', 'anime_mal_id': 223, 'tags': ['villain', 'has_transformation', 'non_human', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Buu'},
    {'mal_id': 920036, 'name': 'Broly', 'anime_mal_id': 223, 'tags': ['has_transformation', 'strong', 'super_powers', 'super_saiyan'], 'difficulty': 'medium', 'alias': 'Broly'},
    {'mal_id': 920037, 'name': 'Beerus', 'anime_mal_id': 223, 'tags': ['non_human', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Beerus'},
    {'mal_id': 920038, 'name': 'Android 18', 'anime_mal_id': 223, 'tags': ['blond_hair', 'cyborg', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': '18'},
    {'mal_id': 920039, 'name': 'Krillin', 'anime_mal_id': 223, 'tags': ['hero', 'martial_artist', 'strong', 'super_powers'], 'difficulty': 'easy', 'alias': 'Krillin'},
    {'mal_id': 920040, 'name': 'Master Roshi', 'anime_mal_id': 223, 'tags': ['mentor', 'martial_artist', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Roshi'},
    {'mal_id': 920041, 'name': 'Izuku Midoriya', 'anime_mal_id': 31964, 'tags': ['protagonist', 'hero', 'young', 'strong', 'super_powers'], 'difficulty': 'easy', 'alias': 'Deku'},
    {'mal_id': 920042, 'name': 'Katsuki Bakugo', 'anime_mal_id': 31964, 'tags': ['rival', 'hero', 'young', 'strong', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Bakugo'},
    {'mal_id': 920043, 'name': 'Ochaco Uraraka', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'super_powers'], 'difficulty': 'easy', 'alias': 'Ochaco'},
    {'mal_id': 920044, 'name': 'Tenya Iida', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'fast'], 'difficulty': 'easy', 'alias': 'Iida'},
    {'mal_id': 920045, 'name': 'Shouta Aizawa', 'anime_mal_id': 31964, 'tags': ['black_hair', 'mentor', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Eraser Head'},
    {'mal_id': 920046, 'name': 'Endeavor', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'fire_user', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Endeavor'},
    {'mal_id': 920047, 'name': 'Hawks', 'anime_mal_id': 31964, 'tags': ['hero', 'fast', 'strong'], 'difficulty': 'medium', 'alias': 'Hawks'},
    {'mal_id': 920048, 'name': 'Dabi', 'anime_mal_id': 31964, 'tags': ['villain', 'fire_user', 'has_tragic_past', 'super_powers'], 'difficulty': 'hard', 'alias': 'Dabi'},
    {'mal_id': 920049, 'name': 'Himiko Toga', 'anime_mal_id': 31964, 'tags': ['villain', 'has_transformation', 'fast'], 'difficulty': 'hard', 'alias': 'Toga'},
    {'mal_id': 920050, 'name': 'Fumikage Tokoyami', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'super_powers'], 'difficulty': 'medium', 'alias': 'Tokoyami'},
    {'mal_id': 920051, 'name': 'Yuji Itadori', 'anime_mal_id': 40748, 'tags': ['protagonist', 'hero', 'young', 'strong', 'fast', 'super_powers'], 'difficulty': 'easy', 'alias': 'Yuji'},
    {'mal_id': 920052, 'name': 'Megumi Fushiguro', 'anime_mal_id': 40748, 'tags': ['black_hair', 'hero', 'young', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Megumi'},
    {'mal_id': 920053, 'name': 'Nobara Kugisaki', 'anime_mal_id': 40748, 'tags': ['hero', 'young', 'super_powers'], 'difficulty': 'medium', 'alias': 'Nobara'},
    {'mal_id': 920054, 'name': 'Ryomen Sukuna', 'anime_mal_id': 40748, 'tags': ['villain', 'strong', 'fast', 'super_powers'], 'difficulty': 'hard', 'alias': 'Sukuna'},
    {'mal_id': 920055, 'name': 'Yuta Okkotsu', 'anime_mal_id': 40748, 'tags': ['hero', 'young', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yuta'},
    {'mal_id': 920056, 'name': 'Toji Fushiguro', 'anime_mal_id': 40748, 'tags': ['assassin', 'strong', 'fast'], 'difficulty': 'hard', 'alias': 'Toji'},
    {'mal_id': 920057, 'name': 'Maki Zenin', 'anime_mal_id': 40748, 'tags': ['uses_sword', 'hero', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Maki'},
    {'mal_id': 920058, 'name': 'Suguru Geto', 'anime_mal_id': 40748, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Geto'},
    {'mal_id': 920059, 'name': 'Yami Sukehiro', 'anime_mal_id': 34572, 'tags': ['black_hair', 'mentor', 'uses_sword', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yami'},
    {'mal_id': 920060, 'name': 'Mereoleona Vermillion', 'anime_mal_id': 34572, 'tags': ['hero', 'fire_user', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mereoleona'},
    {'mal_id': 920061, 'name': 'Luck Voltia', 'anime_mal_id': 34572, 'tags': ['hero', 'young', 'lightning_user', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Luck'},
    {'mal_id': 920062, 'name': 'Nacht Faust', 'anime_mal_id': 34572, 'tags': ['black_hair', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Nacht'},
    {'mal_id': 920063, 'name': 'Finral Roulacase', 'anime_mal_id': 34572, 'tags': ['hero', 'fast', 'super_powers'], 'difficulty': 'easy', 'alias': 'Finral'},
    {'mal_id': 920064, 'name': 'Charmy Pappitson', 'anime_mal_id': 34572, 'tags': ['hero', 'young', 'super_powers'], 'difficulty': 'easy', 'alias': 'Charmy'},
    {'mal_id': 920065, 'name': 'Vanessa Enoteca', 'anime_mal_id': 34572, 'tags': ['hero', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Vanessa'},
    {'mal_id': 920066, 'name': 'Julius Novachrono', 'anime_mal_id': 34572, 'tags': ['mentor', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Julius'},
    {'mal_id': 920067, 'name': 'Leorio Paradinight', 'anime_mal_id': 11061, 'tags': ['hero', 'young'], 'difficulty': 'easy', 'alias': 'Leorio'},
    {'mal_id': 920068, 'name': 'Biscuit Krueger', 'anime_mal_id': 11061, 'tags': ['mentor', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Bisky'},
    {'mal_id': 920069, 'name': 'Isaac Netero', 'anime_mal_id': 11061, 'tags': ['mentor', 'strong', 'fast', 'martial_artist'], 'difficulty': 'hard', 'alias': 'Netero'},
    {'mal_id': 920070, 'name': 'Feitan Portor', 'anime_mal_id': 11061, 'tags': ['assassin', 'villain', 'fast'], 'difficulty': 'hard', 'alias': 'Feitan'},
    {'mal_id': 920071, 'name': 'Illumi Zoldyck', 'anime_mal_id': 11061, 'tags': ['assassin', 'villain', 'strategist'], 'difficulty': 'hard', 'alias': 'Illumi'},
    {'mal_id': 920072, 'name': 'Kite', 'anime_mal_id': 11061, 'tags': ['mentor', 'hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kite'},
    {'mal_id': 920073, 'name': 'Knuckle Bine', 'anime_mal_id': 11061, 'tags': ['hero', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Knuckle'},
    {'mal_id': 920074, 'name': 'Shalnark', 'anime_mal_id': 11061, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Shalnark'},
    {'mal_id': 920075, 'name': 'Aki Hayakawa', 'anime_mal_id': 44511, 'tags': ['black_hair', 'hero', 'has_tragic_past', 'uses_sword', 'super_powers'], 'difficulty': 'medium', 'alias': 'Aki'},
    {'mal_id': 920076, 'name': 'Kobeni Higashiyama', 'anime_mal_id': 44511, 'tags': ['hero', 'young', 'fast'], 'difficulty': 'easy', 'alias': 'Kobeni'},
    {'mal_id': 920077, 'name': 'Kishibe', 'anime_mal_id': 44511, 'tags': ['mentor', 'strong'], 'difficulty': 'medium', 'alias': 'Kishibe'},
    {'mal_id': 920078, 'name': 'Himeno', 'anime_mal_id': 44511, 'tags': ['hero', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Himeno'},
    {'mal_id': 920079, 'name': 'Angel Devil', 'anime_mal_id': 44511, 'tags': ['non_human', 'super_powers'], 'difficulty': 'medium', 'alias': 'Angel'},
    {'mal_id': 920080, 'name': 'Quanxi', 'anime_mal_id': 44511, 'tags': ['assassin', 'strong', 'fast'], 'difficulty': 'hard', 'alias': 'Quanxi'},
    {'mal_id': 920081, 'name': 'Jean Kirstein', 'anime_mal_id': 16498, 'tags': ['hero', 'young'], 'difficulty': 'easy', 'alias': 'Jean'},
    {'mal_id': 920082, 'name': 'Erwin Smith', 'anime_mal_id': 16498, 'tags': ['mentor', 'hero', 'strategist'], 'difficulty': 'medium', 'alias': 'Erwin'},
    {'mal_id': 920083, 'name': 'Hange Zoe', 'anime_mal_id': 16498, 'tags': ['hero', 'strategist'], 'difficulty': 'medium', 'alias': 'Hange'},
    {'mal_id': 920084, 'name': 'Annie Leonhart', 'anime_mal_id': 16498, 'tags': ['villain', 'has_transformation', 'strong'], 'difficulty': 'medium', 'alias': 'Annie'},
    {'mal_id': 920085, 'name': 'Reiner Braun', 'anime_mal_id': 16498, 'tags': ['has_transformation', 'has_tragic_past', 'strong'], 'difficulty': 'medium', 'alias': 'Reiner'},
    {'mal_id': 920086, 'name': 'Bertolt Hoover', 'anime_mal_id': 16498, 'tags': ['villain', 'has_transformation', 'has_tragic_past'], 'difficulty': 'hard', 'alias': 'Bertolt'},
    {'mal_id': 920087, 'name': 'Alphonse Elric', 'anime_mal_id': 5114, 'tags': ['hero', 'young', 'non_human', 'super_powers'], 'difficulty': 'easy', 'alias': 'Al'},
    {'mal_id': 920088, 'name': 'Winry Rockbell', 'anime_mal_id': 5114, 'tags': ['hero', 'young', 'strategist'], 'difficulty': 'easy', 'alias': 'Winry'},
    {'mal_id': 920089, 'name': 'Scar', 'anime_mal_id': 5114, 'tags': ['has_tragic_past', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Scar'},
    {'mal_id': 920090, 'name': 'Ling Yao', 'anime_mal_id': 5114, 'tags': ['hero', 'young', 'strong'], 'difficulty': 'easy', 'alias': 'Ling'},
    {'mal_id': 920091, 'name': 'Riza Hawkeye', 'anime_mal_id': 5114, 'tags': ['hero', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Riza'},
    {'mal_id': 920092, 'name': 'L', 'anime_mal_id': 1535, 'tags': ['strategist'], 'difficulty': 'hard', 'alias': 'L'},
    {'mal_id': 920093, 'name': 'Ryuk', 'anime_mal_id': 1535, 'tags': ['non_human', 'villain'], 'difficulty': 'medium', 'alias': 'Ryuk'},
    {'mal_id': 920094, 'name': 'Misa Amane', 'anime_mal_id': 1535, 'tags': ['blond_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Misa'},
    {'mal_id': 920095, 'name': 'Near', 'anime_mal_id': 1535, 'tags': ['white_hair', 'young', 'strategist'], 'difficulty': 'hard', 'alias': 'Near'},
    {'mal_id': 920096, 'name': 'C.C.', 'anime_mal_id': 1575, 'tags': ['strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'C.C.'},
    {'mal_id': 920097, 'name': 'Suzaku Kururugi', 'anime_mal_id': 1575, 'tags': ['hero', 'rival', 'strong'], 'difficulty': 'medium', 'alias': 'Suzaku'},
    {'mal_id': 920098, 'name': 'Kallen Stadtfeld', 'anime_mal_id': 1575, 'tags': ['hero', 'strong'], 'difficulty': 'medium', 'alias': 'Kallen'},
    {'mal_id': 920099, 'name': 'Charles zi Britannia', 'anime_mal_id': 1575, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Charles'},
    {'mal_id': 920100, 'name': 'Cornelia li Britannia', 'anime_mal_id': 1575, 'tags': ['villain', 'strategist', 'strong'], 'difficulty': 'hard', 'alias': 'Cornelia'},
]

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 18000 + index * 470
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

print(f'updated fifth large import batch with {len(characters)} high-throughput staged characters')
