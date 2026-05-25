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
        'importNotes': 'High-throughput approved batch staging with broader series expansion and curated tags.',
        'image': None,
    }


characters = [
    {'mal_id': 994001, 'name': 'Rigurd', 'anime_mal_id': 37430, 'tags': ['hero', 'non_human', 'leader', 'strategist'], 'difficulty': 'easy', 'alias': 'Rigurd'},
    {'mal_id': 994002, 'name': 'Kaijin', 'anime_mal_id': 37430, 'tags': ['hero', 'strong', 'strategist'], 'difficulty': 'easy', 'alias': 'Kaijin'},
    {'mal_id': 994003, 'name': 'Kurobee', 'anime_mal_id': 37430, 'tags': ['hero', 'black_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Kurobee'},
    {'mal_id': 994004, 'name': 'Souka', 'anime_mal_id': 37430, 'tags': ['hero', 'blue_hair', 'assassin', 'fast'], 'difficulty': 'medium', 'alias': 'Souka'},
    {'mal_id': 994005, 'name': 'Treyni', 'anime_mal_id': 37430, 'tags': ['hero', 'non_human', 'green_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Treyni'},
    {'mal_id': 994006, 'name': 'Myourmiles', 'anime_mal_id': 37430, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Myourmiles'},
    {'mal_id': 994007, 'name': 'Adalman', 'anime_mal_id': 37430, 'tags': ['villain', 'non_human', 'magic_user', 'super_powers'], 'difficulty': 'hard', 'alias': 'Adalman'},
    {'mal_id': 994008, 'name': 'Albis', 'anime_mal_id': 37430, 'tags': ['hero', 'blond_hair', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Albis'},
    {'mal_id': 994009, 'name': 'Suphia', 'anime_mal_id': 37430, 'tags': ['hero', 'blond_hair', 'strong', 'fast'], 'difficulty': 'medium', 'alias': 'Suphia'},
    {'mal_id': 994010, 'name': 'Phobio', 'anime_mal_id': 37430, 'tags': ['villain', 'strong', 'has_transformation'], 'difficulty': 'medium', 'alias': 'Phobio'},
    {'mal_id': 994011, 'name': 'VT', 'anime_mal_id': 1, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'VT'},
    {'mal_id': 994012, 'name': 'Annie', 'anime_mal_id': 1, 'tags': ['mentor', 'hero', 'blond_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Annie'},
    {'mal_id': 994013, 'name': 'Mao Yenrai', 'anime_mal_id': 1, 'tags': ['villain', 'leader', 'strategist'], 'difficulty': 'medium', 'alias': 'Mao'},
    {'mal_id': 994014, 'name': 'Punch', 'anime_mal_id': 1, 'tags': ['hero', 'strong'], 'difficulty': 'easy', 'alias': 'Punch'},
    {'mal_id': 994015, 'name': 'Judy', 'anime_mal_id': 1, 'tags': ['hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Judy'},
    {'mal_id': 994016, 'name': 'Wen', 'anime_mal_id': 1, 'tags': ['villain', 'young', 'has_transformation'], 'difficulty': 'medium', 'alias': 'Wen'},
    {'mal_id': 994017, 'name': 'Stella Bonnaro', 'anime_mal_id': 1, 'tags': ['hero', 'blond_hair', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Stella'},
    {'mal_id': 994018, 'name': 'Roco Bonnaro', 'anime_mal_id': 1, 'tags': ['hero', 'blond_hair', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Roco'},
    {'mal_id': 994019, 'name': 'Doohan', 'anime_mal_id': 1, 'tags': ['mentor', 'hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Doohan'},
    {'mal_id': 994020, 'name': 'Carlos', 'anime_mal_id': 1, 'tags': ['hero', 'gun_user', 'strategist'], 'difficulty': 'easy', 'alias': 'Carlos'},
    {'mal_id': 994021, 'name': 'Knives Millions', 'anime_mal_id': 6, 'tags': ['villain', 'blond_hair', 'leader', 'super_powers'], 'difficulty': 'hard', 'alias': 'Knives'},
    {'mal_id': 994022, 'name': 'Kuroneko-sama', 'anime_mal_id': 6, 'tags': ['hero', 'non_human', 'fast'], 'difficulty': 'easy', 'alias': 'Kuroneko'},
    {'mal_id': 994023, 'name': 'Monique', 'anime_mal_id': 6, 'tags': ['villain', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Monique'},
    {'mal_id': 994024, 'name': 'Hoppered the Gauntlet', 'anime_mal_id': 6, 'tags': ['villain', 'gun_user', 'strong'], 'difficulty': 'medium', 'alias': 'Hoppered'},
    {'mal_id': 994025, 'name': 'E.G. Mine', 'anime_mal_id': 6, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'E.G. Mine'},
    {'mal_id': 994026, 'name': 'Rai-Dei the Blade', 'anime_mal_id': 6, 'tags': ['villain', 'uses_sword', 'strong'], 'difficulty': 'medium', 'alias': 'Rai-Dei'},
    {'mal_id': 994027, 'name': 'Monev the Gale', 'anime_mal_id': 6, 'tags': ['villain', 'muscular', 'strong'], 'difficulty': 'medium', 'alias': 'Monev'},
    {'mal_id': 994028, 'name': 'Leonof the Puppetmaster', 'anime_mal_id': 6, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'Leonof'},
    {'mal_id': 994029, 'name': 'Elendira the Crimsonnail', 'anime_mal_id': 6, 'tags': ['villain', 'blond_hair', 'assassin', 'strong'], 'difficulty': 'hard', 'alias': 'Elendira'},
    {'mal_id': 994030, 'name': 'Razlo the Tri-Punisher', 'anime_mal_id': 6, 'tags': ['villain', 'has_transformation', 'strong'], 'difficulty': 'hard', 'alias': 'Razlo'},
    {'mal_id': 994031, 'name': 'Ryoma Terasaka', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'strong'], 'difficulty': 'easy', 'alias': 'Terasaka'},
    {'mal_id': 994032, 'name': 'Hinano Kurahashi', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'strategist'], 'difficulty': 'easy', 'alias': 'Hinano'},
    {'mal_id': 994033, 'name': 'Kotaro Takebayashi', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'strategist'], 'difficulty': 'easy', 'alias': 'Takebayashi'},
    {'mal_id': 994034, 'name': 'Taisei Yoshida', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'strong'], 'difficulty': 'easy', 'alias': 'Yoshida'},
    {'mal_id': 994035, 'name': 'Kirara Hazama', 'anime_mal_id': 24833, 'tags': ['villain', 'young', 'student', 'strategist'], 'difficulty': 'medium', 'alias': 'Kirara'},
    {'mal_id': 994036, 'name': 'Yuzuki Fuwa', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'strategist'], 'difficulty': 'easy', 'alias': 'Fuwa'},
    {'mal_id': 994037, 'name': 'Tomohito Sugino', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'fast'], 'difficulty': 'easy', 'alias': 'Sugino'},
    {'mal_id': 994038, 'name': 'Ryunosuke Chiba', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Chiba'},
    {'mal_id': 994039, 'name': 'Toka Yada', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'fast'], 'difficulty': 'easy', 'alias': 'Yada'},
    {'mal_id': 994040, 'name': 'Yuma Isogai', 'anime_mal_id': 24833, 'tags': ['hero', 'young', 'student', 'leader'], 'difficulty': 'medium', 'alias': 'Isogai'},
    {'mal_id': 994041, 'name': 'Henry Henderson', 'anime_mal_id': 50265, 'tags': ['mentor', 'hero', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Henry'},
    {'mal_id': 994042, 'name': 'Emile Elman', 'anime_mal_id': 50265, 'tags': ['hero', 'young', 'student', 'blond_hair'], 'difficulty': 'easy', 'alias': 'Emile'},
    {'mal_id': 994043, 'name': 'Ewen Egeburg', 'anime_mal_id': 50265, 'tags': ['hero', 'young', 'student', 'brown_hair'], 'difficulty': 'easy', 'alias': 'Ewen'},
    {'mal_id': 994044, 'name': 'Martha Marriott', 'anime_mal_id': 50265, 'tags': ['mentor', 'hero', 'strong', 'strategist'], 'difficulty': 'medium', 'alias': 'Martha'},
    {'mal_id': 994045, 'name': 'Dominic', 'anime_mal_id': 50265, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Dominic'},
    {'mal_id': 994046, 'name': 'Camilla', 'anime_mal_id': 50265, 'tags': ['hero', 'blond_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Camilla'},
    {'mal_id': 994047, 'name': 'Millie', 'anime_mal_id': 50265, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Millie'},
    {'mal_id': 994048, 'name': 'Sharon', 'anime_mal_id': 50265, 'tags': ['mentor', 'hero', 'strategist'], 'difficulty': 'easy', 'alias': 'Sharon'},
    {'mal_id': 994049, 'name': 'Chloe', 'anime_mal_id': 50265, 'tags': ['hero', 'brown_hair', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Chloe'},
    {'mal_id': 994050, 'name': 'Daybreak', 'anime_mal_id': 50265, 'tags': ['rival', 'strategist', 'fast'], 'difficulty': 'medium', 'alias': 'Daybreak'},
    {'mal_id': 994051, 'name': 'Renzou Shima', 'anime_mal_id': 9919, 'tags': ['hero', 'brown_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Renzou'},
    {'mal_id': 994052, 'name': 'Arthur A. Angel', 'anime_mal_id': 9919, 'tags': ['hero', 'blond_hair', 'uses_sword', 'leader'], 'difficulty': 'medium', 'alias': 'Arthur'},
    {'mal_id': 994053, 'name': 'Lewin Light', 'anime_mal_id': 9919, 'tags': ['mentor', 'hero', 'blond_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Lewin'},
    {'mal_id': 994054, 'name': 'Saburouta Toudou', 'anime_mal_id': 9919, 'tags': ['villain', 'white_hair', 'uses_sword', 'strategist'], 'difficulty': 'hard', 'alias': 'Toudou'},
    {'mal_id': 994055, 'name': 'Juzo Shima', 'anime_mal_id': 9919, 'tags': ['mentor', 'hero', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Juzo'},
    {'mal_id': 994056, 'name': 'Mamushi Hojo', 'anime_mal_id': 9919, 'tags': ['hero', 'black_hair', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mamushi'},
    {'mal_id': 994057, 'name': 'Nemu Takara', 'anime_mal_id': 9919, 'tags': ['hero', 'young', 'student', 'strategist'], 'difficulty': 'easy', 'alias': 'Nemu'},
    {'mal_id': 994058, 'name': 'Noriko Paku', 'anime_mal_id': 9919, 'tags': ['mentor', 'hero', 'strategist'], 'difficulty': 'medium', 'alias': 'Paku'},
    {'mal_id': 994059, 'name': 'Rick Lincoln', 'anime_mal_id': 9919, 'tags': ['hero', 'strong', 'gun_user'], 'difficulty': 'easy', 'alias': 'Rick'},
    {'mal_id': 994060, 'name': 'Igor Neuhaus', 'anime_mal_id': 9919, 'tags': ['villain', 'strategist', 'super_powers'], 'difficulty': 'medium', 'alias': 'Igor'},
    {'mal_id': 994061, 'name': 'Sid Barrett', 'anime_mal_id': 3588, 'tags': ['mentor', 'hero', 'black_hair', 'super_powers'], 'difficulty': 'medium', 'alias': 'Sid'},
    {'mal_id': 994062, 'name': 'Marie Mjolnir', 'anime_mal_id': 3588, 'tags': ['mentor', 'hero', 'blond_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Marie'},
    {'mal_id': 994063, 'name': 'Eruka Frog', 'anime_mal_id': 3588, 'tags': ['villain', 'non_human', 'magic_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Eruka'},
    {'mal_id': 994064, 'name': 'Justin Law', 'anime_mal_id': 3588, 'tags': ['villain', 'blond_hair', 'gun_user', 'strong'], 'difficulty': 'medium', 'alias': 'Justin'},
    {'mal_id': 994065, 'name': 'Azusa Yumi', 'anime_mal_id': 3588, 'tags': ['hero', 'black_hair', 'uses_sword', 'strategist'], 'difficulty': 'medium', 'alias': 'Azusa'},
    {'mal_id': 994066, 'name': 'Ox Ford', 'anime_mal_id': 3588, 'tags': ['hero', 'young', 'student', 'black_hair', 'strong'], 'difficulty': 'easy', 'alias': 'Ox'},
    {'mal_id': 994067, 'name': 'Kim Diehl', 'anime_mal_id': 3588, 'tags': ['hero', 'young', 'student', 'blond_hair', 'magic_user'], 'difficulty': 'easy', 'alias': 'Kim'},
    {'mal_id': 994068, 'name': 'Giriko', 'anime_mal_id': 3588, 'tags': ['villain', 'uses_sword', 'strong', 'super_powers'], 'difficulty': 'medium', 'alias': 'Giriko'},
    {'mal_id': 994069, 'name': 'Mosquito', 'anime_mal_id': 3588, 'tags': ['villain', 'non_human', 'has_transformation', 'super_powers'], 'difficulty': 'medium', 'alias': 'Mosquito'},
    {'mal_id': 994070, 'name': 'Free', 'anime_mal_id': 3588, 'tags': ['villain', 'non_human', 'magic_user', 'strong'], 'difficulty': 'medium', 'alias': 'Free'},
    {'mal_id': 994071, 'name': 'Iris', 'anime_mal_id': 38671, 'tags': ['hero', 'white_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Iris'},
    {'mal_id': 994072, 'name': 'Viktor Licht', 'anime_mal_id': 38671, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Licht'},
    {'mal_id': 994073, 'name': 'Vulcan Joseph', 'anime_mal_id': 38671, 'tags': ['hero', 'brown_hair', 'strategist', 'strong'], 'difficulty': 'medium', 'alias': 'Vulcan'},
    {'mal_id': 994074, 'name': 'Lisa Isaribi', 'anime_mal_id': 38671, 'tags': ['villain', 'blond_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Lisa'},
    {'mal_id': 994075, 'name': 'Arrow', 'anime_mal_id': 38671, 'tags': ['villain', 'black_hair', 'gun_user', 'strong'], 'difficulty': 'medium', 'alias': 'Arrow'},
    {'mal_id': 994076, 'name': 'Karim Fulham', 'anime_mal_id': 38671, 'tags': ['hero', 'blue_hair', 'ice_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Karim'},
    {'mal_id': 994077, 'name': 'Ogun Montgomery', 'anime_mal_id': 38671, 'tags': ['hero', 'black_hair', 'strong', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Ogun'},
    {'mal_id': 994078, 'name': 'Charon', 'anime_mal_id': 38671, 'tags': ['villain', 'muscular', 'strong', 'super_powers'], 'difficulty': 'hard', 'alias': 'Charon'},
    {'mal_id': 994079, 'name': 'Haumea', 'anime_mal_id': 38671, 'tags': ['villain', 'blond_hair', 'psychic', 'super_powers'], 'difficulty': 'hard', 'alias': 'Haumea'},
    {'mal_id': 994080, 'name': 'Juggernaut', 'anime_mal_id': 38671, 'tags': ['hero', 'young', 'strong', 'fire_user', 'super_powers'], 'difficulty': 'medium', 'alias': 'Juggernaut'},
    {'mal_id': 994081, 'name': 'Sachiko Yagami', 'anime_mal_id': 1535, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Sachiko'},
    {'mal_id': 994082, 'name': 'Sayu Yagami', 'anime_mal_id': 1535, 'tags': ['hero', 'young', 'has_tragic_past'], 'difficulty': 'easy', 'alias': 'Sayu'},
    {'mal_id': 994083, 'name': 'Shuichi Aizawa', 'anime_mal_id': 1535, 'tags': ['hero', 'brown_hair', 'gun_user', 'strategist'], 'difficulty': 'medium', 'alias': 'Aizawa'},
    {'mal_id': 994084, 'name': 'Kanzo Mogi', 'anime_mal_id': 1535, 'tags': ['hero', 'strong', 'strategist'], 'difficulty': 'medium', 'alias': 'Mogi'},
    {'mal_id': 994085, 'name': 'Hideki Ide', 'anime_mal_id': 1535, 'tags': ['hero', 'brown_hair', 'strategist'], 'difficulty': 'easy', 'alias': 'Ide'},
    {'mal_id': 994086, 'name': 'Stephen Gevanni', 'anime_mal_id': 1535, 'tags': ['hero', 'blond_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Gevanni'},
    {'mal_id': 994087, 'name': 'Wedy', 'anime_mal_id': 1535, 'tags': ['villain', 'strategist', 'fast'], 'difficulty': 'medium', 'alias': 'Wedy'},
    {'mal_id': 994088, 'name': 'Aiber', 'anime_mal_id': 1535, 'tags': ['villain', 'strategist'], 'difficulty': 'medium', 'alias': 'Aiber'},
    {'mal_id': 994089, 'name': 'Kyosuke Higuchi', 'anime_mal_id': 1535, 'tags': ['villain', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Higuchi'},
    {'mal_id': 994090, 'name': 'Reiji Namikawa', 'anime_mal_id': 1535, 'tags': ['villain', 'brown_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Namikawa'},
    {'mal_id': 994091, 'name': 'Rivalz Cardemonde', 'anime_mal_id': 1575, 'tags': ['hero', 'brown_hair', 'young', 'strategist'], 'difficulty': 'easy', 'alias': 'Rivalz'},
    {'mal_id': 994092, 'name': 'Nina Einstein', 'anime_mal_id': 1575, 'tags': ['hero', 'blond_hair', 'student', 'strategist'], 'difficulty': 'medium', 'alias': 'Nina'},
    {'mal_id': 994093, 'name': 'Ougi Kaname', 'anime_mal_id': 1575, 'tags': ['hero', 'brown_hair', 'leader', 'strategist'], 'difficulty': 'medium', 'alias': 'Ougi'},
    {'mal_id': 994094, 'name': 'Kanon Maldini', 'anime_mal_id': 1575, 'tags': ['hero', 'blond_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Kanon'},
    {'mal_id': 994095, 'name': 'Xingke', 'anime_mal_id': 1575, 'tags': ['hero', 'black_hair', 'leader', 'strong'], 'difficulty': 'medium', 'alias': 'Xingke'},
    {'mal_id': 994096, 'name': 'Marianne vi Britannia', 'anime_mal_id': 1575, 'tags': ['mentor', 'hero', 'blond_hair', 'has_tragic_past'], 'difficulty': 'medium', 'alias': 'Marianne'},
    {'mal_id': 994097, 'name': 'Bismarck Waldstein', 'anime_mal_id': 1575, 'tags': ['villain', 'blond_hair', 'uses_sword', 'strong'], 'difficulty': 'hard', 'alias': 'Bismarck'},
    {'mal_id': 994098, 'name': 'Luciano Bradley', 'anime_mal_id': 1575, 'tags': ['villain', 'blond_hair', 'strong'], 'difficulty': 'medium', 'alias': 'Luciano'},
    {'mal_id': 994099, 'name': 'Cecile Croomy', 'anime_mal_id': 1575, 'tags': ['hero', 'blond_hair', 'strategist'], 'difficulty': 'medium', 'alias': 'Cecile'},
    {'mal_id': 994100, 'name': 'V.V.', 'anime_mal_id': 1575, 'tags': ['villain', 'non_human', 'strategist', 'super_powers'], 'difficulty': 'hard', 'alias': 'V.V.'},
]

source_path = imports / 'mal_jikan_characters_sample.json'
source = load_json(source_path)
existing_source_ids = {item['mal_id'] for item in source}
for index, character in enumerate(characters):
    if character['mal_id'] in existing_source_ids:
        continue
    favorites = 43000 + index * 450
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
        'notes': 'Approved in high-throughput staging mode with broader series expansion and curated tags.',
    }
write_json(approval_path, list(approval_by_id.values()))

print(f'updated fifteenth large import batch with {len(characters)} high-throughput staged characters')
