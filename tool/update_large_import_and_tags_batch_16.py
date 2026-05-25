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
        'importNotes': 'High-throughput approved batch staging with broader catalog expansion and curated tags.',
        'image': None,
    }


characters = [
    {'mal_id': 995001, 'name': 'Takuya Muramatsu', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'brown_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Muramatsu'},
    {'mal_id': 995002, 'name': 'Taiga Okajima', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Okajima'},
    {'mal_id': 995003, 'name': 'Hiroto Maehara', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'brown_hair', 'fast'], 'difficulty': 'easy', 'alias': 'Maehara'},
    {'mal_id': 995004, 'name': 'Sumire Hara', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'strategist'], 'difficulty': 'easy', 'alias': 'Hara'},
    {'mal_id': 995005, 'name': 'Sosuke Sugaya', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'brown_hair', 'fast'], 'difficulty': 'easy', 'alias': 'Sugaya'},
    {'mal_id': 995006, 'name': 'Yukiko Kanzaki', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'black_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Kanzaki'},
    {'mal_id': 995007, 'name': 'Megu Kataoka', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'strategist'], 'difficulty': 'easy', 'alias': 'Kataoka'},
    {'mal_id': 995008, 'name': 'Hinata Okano', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'fast'], 'difficulty': 'easy', 'alias': 'Okano'},
    {'mal_id': 995009, 'name': 'Rinka Hayami', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Hayami'},
    {'mal_id': 995010, 'name': 'Aguri Yukimura', 'anime_mal_id': 24833, 'tags': ['mentor', 'hero', 'black_hair', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Aguri'},
    {'mal_id': 995011, 'name': 'Diethard Ried', 'anime_mal_id': 1575, 'tags': ['villain', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Diethard'},
    {'mal_id': 995012, 'name': 'Kaguya Sumeragi', 'anime_mal_id': 1575, 'tags': ['hero', 'young', 'black_hair', 'leader', 'strategist'], 'difficulty': 'medium', 'alias': 'Kaguya'},
    {'mal_id': 995013, 'name': 'Rakshata Chawla', 'anime_mal_id': 1575, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Rakshata'},
    {'mal_id': 995014, 'name': 'Milly Ashford', 'anime_mal_id': 1575, 'tags': ['hero', 'young', 'blond_hair', 'leader'], 'difficulty': 'easy', 'alias': 'Milly'},
    {'mal_id': 995015, 'name': 'Mao', 'anime_mal_id': 1575, 'tags': ['villain', 'psychic', 'has_tragic_past', 'super_powers'], 'difficulty': 'hard', 'alias': 'Mao'},
    {'mal_id': 995016, 'name': 'Tamaki', 'anime_mal_id': 1575, 'tags': ['hero', 'brown_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Tamaki'},
    {'mal_id': 995017, 'name': 'Kyoshiro Tohdoh', 'anime_mal_id': 1575, 'tags': ['mentor', 'hero', 'uses_sword', 'leader'], 'difficulty': 'medium', 'alias': 'Tohdoh'},
    {'mal_id': 995018, 'name': 'Nagisa Chiba', 'anime_mal_id': 1575, 'tags': ['hero', 'brown_hair', 'uses_sword', 'strategist'], 'difficulty': 'medium', 'alias': 'Chiba'},
    {'mal_id': 995019, 'name': 'Monica Kruszewski', 'anime_mal_id': 1575, 'tags': ['villain', 'blond_hair', 'strong'], 'difficulty': 'medium', 'alias': 'Monica'},
    {'mal_id': 995020, 'name': 'Gilbert G.P. Guilford', 'anime_mal_id': 1575, 'tags': ['villain', 'blond_hair', 'leader', 'strategist'], 'difficulty': 'medium', 'alias': 'Guilford'},
    {'mal_id': 995021, 'name': 'Hitoshi Demegawa', 'anime_mal_id': 1535, 'tags': ['villain', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Demegawa'},
    {'mal_id': 995022, 'name': 'Kal Snyder', 'anime_mal_id': 1535, 'tags': ['villain', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Kal'},
    {'mal_id': 995023, 'name': 'Jack Neylon', 'anime_mal_id': 1535, 'tags': ['villain', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Jack'},
    {'mal_id': 995024, 'name': 'Kiichiro Osoreda', 'anime_mal_id': 1535, 'tags': ['villain', 'gun_user', 'strong'], 'difficulty': 'easy', 'alias': 'Osoreda'},
    {'mal_id': 995025, 'name': 'Masahiko Kida', 'anime_mal_id': 1535, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Kida'},
    {'mal_id': 995026, 'name': 'Hirokazu Ukita', 'anime_mal_id': 1535, 'tags': ['hero', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Ukita'},
    {'mal_id': 995027, 'name': 'Sidoh', 'anime_mal_id': 1535, 'tags': ['non_human', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Sidoh'},
    {'mal_id': 995028, 'name': 'Gelus', 'anime_mal_id': 1535, 'tags': ['non_human', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Gelus'},
    {'mal_id': 995029, 'name': 'Lind L. Tailor', 'anime_mal_id': 1535, 'tags': ['hero', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Lind'},
    {'mal_id': 995030, 'name': 'Anthony Rester', 'anime_mal_id': 1535, 'tags': ['hero', 'blond_hair', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Rester'},
    {'mal_id': 995031, 'name': 'Iaian', 'anime_mal_id': 30276, 'tags': ['hero', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Iaian'},
    {'mal_id': 995032, 'name': 'Okamaitachi', 'anime_mal_id': 30276, 'tags': ['hero', 'uses_sword', 'fast'], 'difficulty': 'medium', 'alias': 'Okamaitachi'},
    {'mal_id': 995033, 'name': 'Bushidrill', 'anime_mal_id': 30276, 'tags': ['hero', 'strong', 'strategist'], 'difficulty': 'medium', 'alias': 'Bushidrill'},
    {'mal_id': 995034, 'name': 'Amai Mask', 'anime_mal_id': 30276, 'tags': ['hero', 'blond_hair', 'has_transformation', 'strong'], 'difficulty': 'medium', 'alias': 'Amai Mask'},
    {'mal_id': 995035, 'name': 'Stinger', 'anime_mal_id': 30276, 'tags': ['hero', 'uses_sword', 'fast'], 'difficulty': 'medium', 'alias': 'Stinger'},
    {'mal_id': 995036, 'name': 'Lightning Max', 'anime_mal_id': 30276, 'tags': ['hero', 'blond_hair', 'fast'], 'difficulty': 'easy', 'alias': 'Lightning Max'},
    {'mal_id': 995037, 'name': 'Snek', 'anime_mal_id': 30276, 'tags': ['hero', 'strong'], 'difficulty': 'easy', 'alias': 'Snek'},
    {'mal_id': 995038, 'name': 'Golden Ball', 'anime_mal_id': 30276, 'tags': ['hero', 'strategist', 'strong'], 'difficulty': 'easy', 'alias': 'Golden Ball'},
    {'mal_id': 995039, 'name': 'Spring Mustachio', 'anime_mal_id': 30276, 'tags': ['hero', 'uses_sword', 'strategist'], 'difficulty': 'medium', 'alias': 'Mustachio'},
    {'mal_id': 995040, 'name': 'Charanko', 'anime_mal_id': 30276, 'tags': ['hero', 'young', 'martial_artist'], 'difficulty': 'easy', 'alias': 'Charanko'},
    {'mal_id': 995041, 'name': 'Rinku', 'anime_mal_id': 392, 'tags': ['villain', 'young', 'fast', 'super_powers'], 'difficulty': 'medium', 'alias': 'Rinku'},
    {'mal_id': 995042, 'name': 'Suzuki', 'anime_mal_id': 392, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Suzuki'},
    {'mal_id': 995043, 'name': 'Seaman', 'anime_mal_id': 392, 'tags': ['villain', 'psychic', 'super_powers'], 'difficulty': 'medium', 'alias': 'Seaman'},
    {'mal_id': 995044, 'name': 'Itsuki', 'anime_mal_id': 392, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Itsuki'},
    {'mal_id': 995045, 'name': 'Gamemaster', 'anime_mal_id': 392, 'tags': ['villain', 'young', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Gamemaster'},
    {'mal_id': 995046, 'name': 'Sniper', 'anime_mal_id': 392, 'tags': ['villain', 'gun_user', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Sniper'},
    {'mal_id': 995047, 'name': 'Koto', 'anime_mal_id': 392, 'tags': ['hero', 'pink_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Koto'},
    {'mal_id': 995048, 'name': 'Juri', 'anime_mal_id': 392, 'tags': ['hero', 'blue_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Juri'},
    {'mal_id': 995049, 'name': 'Zeru', 'anime_mal_id': 392, 'tags': ['villain', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Zeru'},
    {'mal_id': 995050, 'name': 'Doctor Kamiya', 'anime_mal_id': 392, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Kamiya'},
    {'mal_id': 995051, 'name': 'Robert E.O. Speedwagon', 'anime_mal_id': 14719, 'tags': ['mentor', 'hero', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Speedwagon'},
    {'mal_id': 995052, 'name': 'Erina Pendleton', 'anime_mal_id': 14719, 'tags': ['hero', 'blond_hair', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Erina'},
    {'mal_id': 995053, 'name': 'Lisa Lisa', 'anime_mal_id': 14719, 'tags': ['mentor', 'hero', 'blond_hair', 'martial_artist'], 'difficulty': 'medium', 'alias': 'Lisa Lisa'},
    {'mal_id': 995054, 'name': 'Kars', 'anime_mal_id': 14719, 'tags': ['villain', 'non_human', 'has_transformation', 'strong'], 'difficulty': 'hard', 'alias': 'Kars'},
    {'mal_id': 995055, 'name': 'Esidisi', 'anime_mal_id': 14719, 'tags': ['villain', 'non_human', 'fire_user', 'strong'], 'difficulty': 'hard', 'alias': 'Esidisi'},
    {'mal_id': 995056, 'name': 'Wamuu', 'anime_mal_id': 14719, 'tags': ['villain', 'non_human', 'fast', 'strong'], 'difficulty': 'hard', 'alias': 'Wamuu'},
    {'mal_id': 995057, 'name': 'Koichi Hirose', 'anime_mal_id': 14719, 'tags': ['hero', 'young', 'black_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Koichi'},
    {'mal_id': 995058, 'name': 'Yukako Yamagishi', 'anime_mal_id': 14719, 'tags': ['villain', 'black_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Yukako'},
    {'mal_id': 995059, 'name': 'Trish Una', 'anime_mal_id': 14719, 'tags': ['hero', 'pink_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Trish'},
    {'mal_id': 995060, 'name': 'Pannacotta Fugo', 'anime_mal_id': 14719, 'tags': ['rival', 'young', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Fugo'},
    {'mal_id': 995061, 'name': 'Totosai', 'anime_mal_id': 249, 'tags': ['mentor', 'hero', 'non_human', 'strategist'], 'difficulty': 'medium', 'alias': 'Totosai'},
    {'mal_id': 995062, 'name': 'Kaede', 'anime_mal_id': 249, 'tags': ['mentor', 'hero', 'white_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Kaede'},
    {'mal_id': 995063, 'name': 'Myoga', 'anime_mal_id': 249, 'tags': ['hero', 'non_human', 'fast'], 'difficulty': 'easy', 'alias': 'Myoga'},
    {'mal_id': 995064, 'name': 'Muso', 'anime_mal_id': 249, 'tags': ['villain', 'has_transformation', 'strong'], 'difficulty': 'medium', 'alias': 'Muso'},
    {'mal_id': 995065, 'name': 'Hakudoshi', 'anime_mal_id': 249, 'tags': ['villain', 'white_hair', 'super_powers'], 'difficulty': 'hard', 'alias': 'Hakudoshi'},
    {'mal_id': 995066, 'name': 'Kageromaru', 'anime_mal_id': 249, 'tags': ['villain', 'has_transformation', 'strong'], 'difficulty': 'medium', 'alias': 'Kageromaru'},
    {'mal_id': 995067, 'name': 'Juromaru', 'anime_mal_id': 249, 'tags': ['villain', 'has_transformation', 'strong'], 'difficulty': 'medium', 'alias': 'Juromaru'},
    {'mal_id': 995068, 'name': 'Tsubaki', 'anime_mal_id': 249, 'tags': ['villain', 'black_hair', 'magic_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Tsubaki'},
    {'mal_id': 995069, 'name': 'Kaijinbo', 'anime_mal_id': 249, 'tags': ['villain', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Kaijinbo'},
    {'mal_id': 995070, 'name': 'Mistress Centipede', 'anime_mal_id': 249, 'tags': ['villain', 'non_human', 'super_powers'], 'difficulty': 'medium', 'alias': 'Centipede'},
    {'mal_id': 995071, 'name': 'Lisanna Strauss', 'anime_mal_id': 6702, 'tags': ['hero', 'white_hair', 'has_transformation'], 'difficulty': 'medium', 'alias': 'Lisanna'},
    {'mal_id': 995072, 'name': 'Aquarius', 'anime_mal_id': 6702, 'tags': ['hero', 'blue_hair', 'non_human', 'water_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Aquarius'},
    {'mal_id': 995073, 'name': 'Freed Justine', 'anime_mal_id': 6702, 'tags': ['hero', 'green_hair', 'magic_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Freed'},
    {'mal_id': 995074, 'name': 'Bickslow', 'anime_mal_id': 6702, 'tags': ['hero', 'white_hair', 'magic_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Bickslow'},
    {'mal_id': 995075, 'name': 'Evergreen', 'anime_mal_id': 6702, 'tags': ['villain', 'green_hair', 'magic_user'], 'difficulty': 'medium', 'alias': 'Evergreen'},
    {'mal_id': 995076, 'name': 'Lyon Vastia', 'anime_mal_id': 6702, 'tags': ['hero', 'white_hair', 'ice_user', 'magic_user'], 'difficulty': 'medium', 'alias': 'Lyon'},
    {'mal_id': 995077, 'name': 'Bacchus Groh', 'anime_mal_id': 6702, 'tags': ['hero', 'blond_hair', 'martial_artist', 'strong'], 'difficulty': 'medium', 'alias': 'Bacchus'},
    {'mal_id': 995078, 'name': 'Cobra', 'anime_mal_id': 6702, 'tags': ['villain', 'green_hair', 'assassin', 'super_powers'], 'difficulty': 'medium', 'alias': 'Cobra'},
    {'mal_id': 995079, 'name': 'Minerva Orland', 'anime_mal_id': 6702, 'tags': ['villain', 'purple_hair', 'magic_user', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Minerva'},
    {'mal_id': 995080, 'name': 'Brandish', 'anime_mal_id': 6702, 'tags': ['villain', 'green_hair', 'magic_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Brandish'},
    {'mal_id': 995081, 'name': 'Pochita', 'anime_mal_id': 44511, 'tags': ['hero', 'non_human', 'has_transformation', 'super_powers'], 'difficulty': 'easy', 'alias': 'Pochita'},
    {'mal_id': 995082, 'name': 'Hirofumi Yoshida', 'anime_mal_id': 44511, 'tags': ['hero', 'black_hair', 'assassin', 'strategist'], 'difficulty': 'medium', 'alias': 'Yoshida'},
    {'mal_id': 995083, 'name': 'Hirokazu Arai', 'anime_mal_id': 44511, 'tags': ['hero', 'black_hair', 'gun_user', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Arai'},
    {'mal_id': 995084, 'name': 'Haruka Iseumi', 'anime_mal_id': 44511, 'tags': ['rival', 'young', 'black_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Haruka'},
    {'mal_id': 995085, 'name': 'Nobana Higashiyama', 'anime_mal_id': 44511, 'tags': ['hero', 'young', 'brown_hair', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Nobana'},
    {'mal_id': 995086, 'name': 'Seigi Akoku', 'anime_mal_id': 44511, 'tags': ['rival', 'young', 'strong'], 'difficulty': 'easy', 'alias': 'Seigi'},
    {'mal_id': 995087, 'name': 'Miri Sugo', 'anime_mal_id': 44511, 'tags': ['villain', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Miri'},
    {'mal_id': 995088, 'name': 'Barem Bridge', 'anime_mal_id': 44511, 'tags': ['villain', 'blond_hair', 'fire_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Barem'},
    {'mal_id': 995089, 'name': 'Fumiko Mifune', 'anime_mal_id': 44511, 'tags': ['hero', 'brown_hair', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Fumiko'},
    {'mal_id': 995090, 'name': 'Cosmo', 'anime_mal_id': 44511, 'tags': ['villain', 'pink_hair', 'psychic', 'super_powers'], 'difficulty': 'hard', 'alias': 'Cosmo'},
    {'mal_id': 995091, 'name': 'Akitaru Obi', 'anime_mal_id': 38671, 'tags': ['mentor', 'hero', 'leader', 'strong'], 'difficulty': 'medium', 'alias': 'Obi'},
    {'mal_id': 995092, 'name': 'Konro Sagamiya', 'anime_mal_id': 38671, 'tags': ['mentor', 'hero', 'fire_user', 'has_tragic_past', 'super_powers'], 'difficulty': 'medium', 'alias': 'Konro'},
    {'mal_id': 995093, 'name': 'Yona', 'anime_mal_id': 38671, 'tags': ['villain', 'has_transformation', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Yona'},
    {'mal_id': 995094, 'name': 'Scop', 'anime_mal_id': 38671, 'tags': ['villain', 'non_human', 'strategist'], 'difficulty': 'medium', 'alias': 'Scop'},
    {'mal_id': 995095, 'name': 'Orochi', 'anime_mal_id': 38671, 'tags': ['villain', 'black_hair', 'assassin', 'strong'], 'difficulty': 'medium', 'alias': 'Orochi'},
    {'mal_id': 995096, 'name': 'Pan Ko Paat', 'anime_mal_id': 38671, 'tags': ['mentor', 'hero', 'blond_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Pan Ko Paat'},
    {'mal_id': 995097, 'name': 'Asako Hague', 'anime_mal_id': 38671, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Asako'},
    {'mal_id': 995098, 'name': 'Tooru Kishiri', 'anime_mal_id': 38671, 'tags': ['villain', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Kishiri'},
    {'mal_id': 995099, 'name': 'Li Flail', 'anime_mal_id': 38671, 'tags': ['villain', 'muscular', 'strong'], 'difficulty': 'medium', 'alias': 'Flail'},
    {'mal_id': 995100, 'name': 'Takigi Oze', 'anime_mal_id': 38671, 'tags': ['hero', 'brown_hair', 'strong', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Takigi'},
]

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 44000 + index * 425
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
        'notes': 'Approved in high-throughput staging mode with broader catalog expansion and curated tags.',
    }
write_json(approval_path, list(approval_by_id.values()))

print(f'updated sixteenth large import batch with {len(characters)} high-throughput staged characters')
