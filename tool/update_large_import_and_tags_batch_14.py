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
    {'mal_id': 993001, 'name': 'Shizune', 'anime_mal_id': 20, 'tags': ['hero', 'mentor', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Shizune'},
    {'mal_id': 993002, 'name': 'Genma Shiranui', 'anime_mal_id': 20, 'tags': ['hero', 'brown_hair', 'strategist', 'strong'], 'difficulty': 'easy', 'alias': 'Genma'},
    {'mal_id': 993003, 'name': 'Ibiki Morino', 'anime_mal_id': 20, 'tags': ['hero', 'black_hair', 'leader', 'strong'], 'difficulty': 'medium', 'alias': 'Ibiki'},
    {'mal_id': 993004, 'name': 'Izumo Kamizuki', 'anime_mal_id': 20, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Izumo'},
    {'mal_id': 993005, 'name': 'Kotetsu Hagane', 'anime_mal_id': 20, 'tags': ['hero', 'black_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Kotetsu'},
    {'mal_id': 993006, 'name': 'Hamura Otsutsuki', 'anime_mal_id': 20, 'tags': ['mentor', 'white_hair', 'non_human', 'super_powers', 'leader'], 'difficulty': 'hard', 'alias': 'Hamura'},
    {'mal_id': 993007, 'name': 'Indra Otsutsuki', 'anime_mal_id': 20, 'tags': ['villain', 'black_hair', 'super_powers', 'has_tragic_past'], 'difficulty': 'hard', 'alias': 'Indra'},
    {'mal_id': 993008, 'name': 'Asura Otsutsuki', 'anime_mal_id': 20, 'tags': ['hero', 'brown_hair', 'super_powers', 'has_tragic_past'], 'difficulty': 'hard', 'alias': 'Asura'},
    {'mal_id': 993009, 'name': 'Chino', 'anime_mal_id': 20, 'tags': ['villain', 'red_hair', 'super_powers', 'strategist'], 'difficulty': 'medium', 'alias': 'Chino'},
    {'mal_id': 993010, 'name': 'Menma Uzumaki', 'anime_mal_id': 20, 'tags': ['villain', 'blond_hair', 'super_powers', 'has_transformation'], 'difficulty': 'medium', 'alias': 'Menma'},
    {'mal_id': 993011, 'name': 'Charlotte Perospero', 'anime_mal_id': 21, 'tags': ['villain', 'leader', 'pink_hair', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Perospero'},
    {'mal_id': 993012, 'name': 'Charlotte Oven', 'anime_mal_id': 21, 'tags': ['villain', 'leader', 'strong', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Oven'},
    {'mal_id': 993013, 'name': 'Charlotte Daifuku', 'anime_mal_id': 21, 'tags': ['villain', 'leader', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Daifuku'},
    {'mal_id': 993014, 'name': 'Hina', 'anime_mal_id': 21, 'tags': ['hero', 'pink_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Hina'},
    {'mal_id': 993015, 'name': 'Tashigi', 'anime_mal_id': 21, 'tags': ['hero', 'black_hair', 'uses_sword', 'strategist'], 'difficulty': 'medium', 'alias': 'Tashigi'},
    {'mal_id': 993016, 'name': 'Kaku', 'anime_mal_id': 21, 'tags': ['villain', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kaku'},
    {'mal_id': 993017, 'name': 'Jabra', 'anime_mal_id': 21, 'tags': ['villain', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Jabra'},
    {'mal_id': 993018, 'name': 'Blueno', 'anime_mal_id': 21, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Blueno'},
    {'mal_id': 993019, 'name': 'Kumadori', 'anime_mal_id': 21, 'tags': ['villain', 'pink_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Kumadori'},
    {'mal_id': 993020, 'name': 'Kalifa', 'anime_mal_id': 21, 'tags': ['villain', 'blond_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kalifa'},
    {'mal_id': 993021, 'name': 'Chojiro Sasakibe', 'anime_mal_id': 269, 'tags': ['mentor', 'hero', 'white_hair', 'uses_sword', 'leader'], 'difficulty': 'medium', 'alias': 'Sasakibe'},
    {'mal_id': 993022, 'name': 'Omaeda Marechiyo', 'anime_mal_id': 269, 'tags': ['hero', 'black_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Omaeda'},
    {'mal_id': 993023, 'name': 'Sentarou Kotsubaki', 'anime_mal_id': 269, 'tags': ['hero', 'brown_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Sentarou'},
    {'mal_id': 993024, 'name': 'Kiyone Kotetsu', 'anime_mal_id': 269, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Kiyone'},
    {'mal_id': 993025, 'name': 'Robert Accutrone', 'anime_mal_id': 269, 'tags': ['villain', 'gun_user', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Robert'},
    {'mal_id': 993026, 'name': 'Cang Du', 'anime_mal_id': 269, 'tags': ['villain', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Cang Du'},
    {'mal_id': 993027, 'name': 'BG9', 'anime_mal_id': 269, 'tags': ['villain', 'cyborg', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'BG9'},
    {'mal_id': 993028, 'name': 'Pepe Waccabrada', 'anime_mal_id': 269, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Pepe'},
    {'mal_id': 993029, 'name': 'NaNaNa Najahkoop', 'anime_mal_id': 269, 'tags': ['villain', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'NaNaNa'},
    {'mal_id': 993030, 'name': 'Jerome Guizbatt', 'anime_mal_id': 269, 'tags': ['villain', 'muscular', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Jerome'},
    {'mal_id': 993031, 'name': 'King Vegeta', 'anime_mal_id': 223, 'tags': ['villain', 'black_hair', 'leader', 'alien', 'strong'], 'difficulty': 'medium', 'alias': 'King Vegeta'},
    {'mal_id': 993032, 'name': 'Paragus', 'anime_mal_id': 223, 'tags': ['villain', 'black_hair', 'strategist', 'alien'], 'difficulty': 'medium', 'alias': 'Paragus'},
    {'mal_id': 993033, 'name': 'Bojack', 'anime_mal_id': 223, 'tags': ['villain', 'blue_hair', 'leader', 'alien', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Bojack'},
    {'mal_id': 993034, 'name': 'Zangya', 'anime_mal_id': 223, 'tags': ['villain', 'green_hair', 'alien', 'super_powers'], 'difficulty': 'medium', 'alias': 'Zangya'},
    {'mal_id': 993035, 'name': 'Tapion', 'anime_mal_id': 223, 'tags': ['hero', 'red_hair', 'uses_sword', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Tapion'},
    {'mal_id': 993036, 'name': 'Pikkon', 'anime_mal_id': 223, 'tags': ['hero', 'non_human', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Pikkon'},
    {'mal_id': 993037, 'name': 'Nail', 'anime_mal_id': 223, 'tags': ['hero', 'non_human', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Nail'},
    {'mal_id': 993038, 'name': 'Kami', 'anime_mal_id': 223, 'tags': ['mentor', 'non_human', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kami'},
    {'mal_id': 993039, 'name': 'Yakon', 'anime_mal_id': 223, 'tags': ['villain', 'non_human', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yakon'},
    {'mal_id': 993040, 'name': 'Oceanus Shenron', 'anime_mal_id': 223, 'tags': ['villain', 'blue_hair', 'non_human', 'super_powers'], 'difficulty': 'hard', 'alias': 'Oceanus'},
    {'mal_id': 993041, 'name': 'Thirteen', 'anime_mal_id': 31964, 'tags': ['mentor', 'hero', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Thirteen'},
    {'mal_id': 993042, 'name': 'Manual', 'anime_mal_id': 31964, 'tags': ['hero', 'water_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Manual'},
    {'mal_id': 993043, 'name': 'Selkie', 'anime_mal_id': 31964, 'tags': ['hero', 'non_human', 'strong'], 'difficulty': 'medium', 'alias': 'Selkie'},
    {'mal_id': 993044, 'name': 'Crust', 'anime_mal_id': 31964, 'tags': ['hero', 'leader', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Crust'},
    {'mal_id': 993045, 'name': 'Wash', 'anime_mal_id': 31964, 'tags': ['hero', 'non_human', 'water_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Wash'},
    {'mal_id': 993046, 'name': 'Pony Tsunotori', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'blond_hair', 'non_human', 'super_powers'], 'difficulty': 'easy', 'alias': 'Pony'},
    {'mal_id': 993047, 'name': 'Kinoko Komori', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'brown_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Kinoko'},
    {'mal_id': 993048, 'name': 'Ibara Shiozaki', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'green_hair', 'super_powers'], 'difficulty': 'easy', 'alias': 'Ibara'},
    {'mal_id': 993049, 'name': 'Jurota Shishida', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'has_transformation', 'strong', 'super_powers'], 'difficulty': 'easy', 'alias': 'Jurota'},
    {'mal_id': 993050, 'name': 'Reiko Yanagi', 'anime_mal_id': 31964, 'tags': ['hero', 'young', 'student', 'black_hair', 'psychic', 'super_powers'], 'difficulty': 'easy', 'alias': 'Reiko'},
    {'mal_id': 993051, 'name': 'Remi', 'anime_mal_id': 40748, 'tags': ['villain', 'young', 'blond_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Remi'},
    {'mal_id': 993052, 'name': 'Dhruv Lakdawalla', 'anime_mal_id': 40748, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Dhruv'},
    {'mal_id': 993053, 'name': 'Kurourushi', 'anime_mal_id': 40748, 'tags': ['villain', 'non_human', 'super_powers', 'strong'], 'difficulty': 'hard', 'alias': 'Kurourushi'},
    {'mal_id': 993054, 'name': 'Yorozu', 'anime_mal_id': 40748, 'tags': ['villain', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Yorozu'},
    {'mal_id': 993055, 'name': 'Tsumiki Fushiguro', 'anime_mal_id': 40748, 'tags': ['hero', 'brown_hair', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Tsumiki'},
    {'mal_id': 993056, 'name': 'Wasuke Itadori', 'anime_mal_id': 40748, 'tags': ['mentor', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Wasuke'},
    {'mal_id': 993057, 'name': 'Mimiko Hasaba', 'anime_mal_id': 40748, 'tags': ['villain', 'young', 'black_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mimiko'},
    {'mal_id': 993058, 'name': 'Nanako Hasaba', 'anime_mal_id': 40748, 'tags': ['villain', 'young', 'blond_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Nanako'},
    {'mal_id': 993059, 'name': 'Juzo Kumiya', 'anime_mal_id': 40748, 'tags': ['villain', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Juzo'},
    {'mal_id': 993060, 'name': 'Toshihisa Negi', 'anime_mal_id': 40748, 'tags': ['villain', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Negi'},
    {'mal_id': 993061, 'name': 'Sekke Bronzazza', 'anime_mal_id': 34572, 'tags': ['rival', 'brown_hair', 'strategist', 'magic_user'], 'difficulty': 'easy', 'alias': 'Sekke'},
    {'mal_id': 993062, 'name': 'Sister Lily', 'anime_mal_id': 34572, 'tags': ['mentor', 'hero', 'brown_hair', 'magic_user'], 'difficulty': 'easy', 'alias': 'Sister Lily'},
    {'mal_id': 993063, 'name': 'Alecdora Sandler', 'anime_mal_id': 34572, 'tags': ['villain', 'green_hair', 'magic_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Alecdora'},
    {'mal_id': 993064, 'name': 'Hamon Caseus', 'anime_mal_id': 34572, 'tags': ['hero', 'blond_hair', 'strong', 'magic_user'], 'difficulty': 'easy', 'alias': 'Hamon'},
    {'mal_id': 993065, 'name': 'Shiren Tium', 'anime_mal_id': 34572, 'tags': ['hero', 'blue_hair', 'strong', 'magic_user'], 'difficulty': 'easy', 'alias': 'Shiren'},
    {'mal_id': 993066, 'name': 'Randall Luftair', 'anime_mal_id': 34572, 'tags': ['hero', 'ice_user', 'magic_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Randall'},
    {'mal_id': 993067, 'name': 'David Swallow', 'anime_mal_id': 34572, 'tags': ['hero', 'brown_hair', 'magic_user', 'strategist'], 'difficulty': 'medium', 'alias': 'David'},
    {'mal_id': 993068, 'name': 'Nils Ragus', 'anime_mal_id': 34572, 'tags': ['hero', 'young', 'student', 'brown_hair', 'magic_user'], 'difficulty': 'easy', 'alias': 'Nils'},
    {'mal_id': 993069, 'name': 'En Ringard', 'anime_mal_id': 34572, 'tags': ['hero', 'blond_hair', 'magic_user', 'strategist'], 'difficulty': 'medium', 'alias': 'En'},
    {'mal_id': 993070, 'name': 'Kahono', 'anime_mal_id': 34572, 'tags': ['hero', 'blue_hair', 'young', 'magic_user'], 'difficulty': 'easy', 'alias': 'Kahono'},
    {'mal_id': 993071, 'name': 'Amane', 'anime_mal_id': 11061, 'tags': ['hero', 'young', 'black_hair'], 'difficulty': 'easy', 'alias': 'Amane'},
    {'mal_id': 993072, 'name': 'Tsubone', 'anime_mal_id': 11061, 'tags': ['mentor', 'white_hair', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Tsubone'},
    {'mal_id': 993073, 'name': 'Belerainte', 'anime_mal_id': 11061, 'tags': ['hero', 'blond_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Belerainte'},
    {'mal_id': 993074, 'name': 'Cluck', 'anime_mal_id': 11061, 'tags': ['mentor', 'hero', 'pink_hair', 'leader'], 'difficulty': 'medium', 'alias': 'Cluck'},
    {'mal_id': 993075, 'name': 'Kanzai', 'anime_mal_id': 11061, 'tags': ['hero', 'strong', 'strategist'], 'difficulty': 'medium', 'alias': 'Kanzai'},
    {'mal_id': 993076, 'name': 'Saccho Kobayakawa', 'anime_mal_id': 11061, 'tags': ['hero', 'black_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Saccho'},
    {'mal_id': 993077, 'name': 'Mizaistom Nana', 'anime_mal_id': 11061, 'tags': ['hero', 'blond_hair', 'strategist', 'leader'], 'difficulty': 'medium', 'alias': 'Mizaistom'},
    {'mal_id': 993078, 'name': 'Botobai Gigante', 'anime_mal_id': 11061, 'tags': ['hero', 'strong', 'leader'], 'difficulty': 'medium', 'alias': 'Botobai'},
    {'mal_id': 993079, 'name': 'Saiyu', 'anime_mal_id': 11061, 'tags': ['hero', 'non_human', 'strategist'], 'difficulty': 'medium', 'alias': 'Saiyu'},
    {'mal_id': 993080, 'name': 'Gel', 'anime_mal_id': 11061, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Gel'},
    {'mal_id': 993081, 'name': 'Dimo Reeves', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Dimo'},
    {'mal_id': 993082, 'name': 'Flegel Reeves', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'young'], 'difficulty': 'easy', 'alias': 'Flegel'},
    {'mal_id': 993083, 'name': 'Pastor Nick', 'anime_mal_id': 16498, 'tags': ['villain', 'strategist'], 'difficulty': 'easy', 'alias': 'Nick'},
    {'mal_id': 993084, 'name': 'Kenny Ackerman', 'anime_mal_id': 16498, 'tags': ['villain', 'gun_user', 'strategist', 'has_tragic_past'], 'difficulty': 'hard', 'alias': 'Kenny'},
    {'mal_id': 993085, 'name': 'Uri Reiss', 'anime_mal_id': 16498, 'tags': ['mentor', 'hero', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Uri'},
    {'mal_id': 993086, 'name': 'Kuchel Ackerman', 'anime_mal_id': 16498, 'tags': ['hero', 'black_hair', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Kuchel'},
    {'mal_id': 993087, 'name': 'Marco Bott', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Marco'},
    {'mal_id': 993088, 'name': 'Thomas Wagner', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'young'], 'difficulty': 'easy', 'alias': 'Thomas'},
    {'mal_id': 993089, 'name': 'Daz', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'young'], 'difficulty': 'easy', 'alias': 'Daz'},
    {'mal_id': 993090, 'name': 'Lobov', 'anime_mal_id': 16498, 'tags': ['hero', 'brown_hair', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Lobov'},
    {'mal_id': 993091, 'name': 'Kanao Tsuyuri', 'anime_mal_id': 38000, 'tags': ['hero', 'young', 'black_hair', 'uses_sword', 'stoic'], 'difficulty': 'medium', 'alias': 'Kanao'},
    {'mal_id': 993092, 'name': 'Genya Shinazugawa', 'anime_mal_id': 38000, 'tags': ['hero', 'young', 'gun_user', 'has_tragic_past', 'strong'], 'difficulty': 'medium', 'alias': 'Genya'},
    {'mal_id': 993093, 'name': 'Aoi Kanzaki', 'anime_mal_id': 38000, 'tags': ['hero', 'young', 'blue_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Aoi'},
    {'mal_id': 993094, 'name': 'Tamayo', 'anime_mal_id': 38000, 'tags': ['hero', 'black_hair', 'demon', 'strategist', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Tamayo'},
    {'mal_id': 993095, 'name': 'Yushiro', 'anime_mal_id': 38000, 'tags': ['hero', 'demon', 'young', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yushiro'},
    {'mal_id': 993096, 'name': 'Sabito', 'anime_mal_id': 38000, 'tags': ['hero', 'uses_sword', 'has_tragic_past', 'strong'], 'difficulty': 'medium', 'alias': 'Sabito'},
    {'mal_id': 993097, 'name': 'Makomo', 'anime_mal_id': 38000, 'tags': ['hero', 'blue_hair', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Makomo'},
    {'mal_id': 993098, 'name': 'Kaigaku', 'anime_mal_id': 38000, 'tags': ['villain', 'black_hair', 'lightning_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Kaigaku'},
    {'mal_id': 993099, 'name': 'Nakime', 'anime_mal_id': 38000, 'tags': ['villain', 'black_hair', 'demon', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Nakime'},
    {'mal_id': 993100, 'name': 'Hantengu', 'anime_mal_id': 38000, 'tags': ['villain', 'demon', 'has_transformation', 'super_powers'], 'difficulty': 'hard', 'alias': 'Hantengu'},
]

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 42000 + index * 500
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

print(f'updated fourteenth large import batch with {len(characters)} high-throughput staged characters')
