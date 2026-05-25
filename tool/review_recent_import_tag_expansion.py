import json
from pathlib import Path

root = Path('assets/data')
imports = root / 'imports'


def load_json(path: Path):
    return json.loads(path.read_text(encoding='utf-8'))


def write_json(path: Path, data):
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


def merge_tags(existing: list[str], additions: list[str]) -> list[str]:
    merged = list(existing)
    for tag in additions:
        if tag not in merged:
            merged.append(tag)
    return merged


tag_definitions = [
    {
        'id': 'brown_hair',
        'label': 'Brown Hair',
        'type': 'appearance',
        'difficulty': 'easy',
    },
    {
        'id': 'red_hair',
        'label': 'Red Hair',
        'type': 'appearance',
        'difficulty': 'easy',
    },
    {
        'id': 'leader',
        'label': 'Leader',
        'type': 'role',
        'difficulty': 'medium',
    },
    {
        'id': 'student',
        'label': 'Student',
        'type': 'status',
        'difficulty': 'easy',
    },
]

extra_tags_by_character_id = {
    'iruka_umino': ['black_hair', 'has_tragic_past', 'leader'],
    'asuma_sarutobi': ['black_hair', 'leader', 'has_tragic_past'],
    'kurenai_yuhi': ['black_hair', 'leader'],
    'choji_akimichi': ['brown_hair', 'student'],
    'ino_yamanaka': ['blond_hair', 'student'],
    'tenten': ['brown_hair', 'student'],
    'shino_aburame': ['brown_hair', 'student'],
    'yamato_tenzo': ['brown_hair', 'leader'],
    'danzo_shimura': ['brown_hair', 'leader'],
    'suigetsu_hozuki': ['white_hair', 'fast'],
    'tony_tony_chopper': ['brown_hair', 'super_powers'],
    'carrot': ['blond_hair', 'super_powers'],
    'bon_clay': ['brown_hair', 'fast'],
    'bartolomeo': ['black_hair', 'leader'],
    'marco': ['blond_hair', 'leader'],
    'kaido': ['leader', 'fast'],
    'big_mom': ['leader', 'pink_hair'],
    'dracule_mihawk': ['black_hair', 'leader'],
    'perona': ['strategist', 'fast'],
    'x_drake': ['brown_hair', 'rival'],
    'yachiru_kusajishi': ['fast', 'super_powers'],
    'ikkaku_madarame': ['martial_artist', 'leader'],
    'yumichika_ayasegawa': ['fast', 'stoic'],
    'izuru_kira': ['blond_hair', 'stoic'],
    'momo_hinamori': ['black_hair', 'student'],
    'shunsui_kyoraku': ['brown_hair', 'leader'],
    'jushiro_ukitake': ['leader', 'has_tragic_past'],
    'lisa_yadomaru': ['brown_hair', 'stoic'],
    'hiyori_sarugaki': ['blond_hair', 'fast'],
    'rose_otoribashi': ['blond_hair', 'leader'],
    'bardock': ['black_hair', 'leader', 'alien'],
    'raditz': ['black_hair', 'fast'],
    'nappa': ['martial_artist', 'strong'],
    'gotenks': ['black_hair', 'fast', 'martial_artist'],
    'kale': ['black_hair', 'young', 'alien'],
    'caulifla': ['black_hair', 'fast', 'alien'],
    'kefla': ['black_hair', 'fast', 'alien'],
    'vados': ['white_hair', 'strategist'],
    'toppo': ['leader', 'martial_artist'],
    'zamasu': ['white_hair', 'leader', 'non_human'],
    'denki_kaminari': ['blond_hair', 'student'],
    'mina_ashido': ['student', 'fast'],
    'kyoka_jiro': ['black_hair', 'student'],
    'hitoshi_shinso': ['black_hair', 'student'],
    'present_mic': ['blond_hair', 'leader'],
    'best_jeanist': ['blond_hair', 'leader'],
    'lady_nagant': ['has_tragic_past', 'strategist'],
    'overhaul': ['black_hair', 'leader'],
    'fat_gum': ['mentor', 'leader'],
    'mt_lady': ['blond_hair', 'leader'],
    'utahime_iori': ['brown_hair', 'leader'],
    'shoko_ieiri': ['brown_hair', 'strategist'],
    'kokichi_muta': ['young', 'brown_hair'],
    'hanami': ['strategist', 'super_powers'],
    'dagon': ['strategist', 'strong'],
    'choso': ['black_hair', 'strong'],
    'naobito_zenin': ['blond_hair', 'strategist'],
    'mai_zenin': ['brown_hair', 'student'],
    'kirara_hoshi': ['pink_hair', 'student'],
    'hajime_kashimo': ['martial_artist', 'fast'],
    'mimosa_vermillion': ['student', 'brown_hair'],
    'charlotte_roselei': ['blond_hair', 'leader'],
    'jack_the_ripper': ['black_hair', 'fast'],
    'rill_boismortier': ['student', 'strategist'],
    'dorothy_unsworth': ['pink_hair', 'strategist'],
    'gauche_adlai': ['brown_hair', 'has_tragic_past'],
    'henry_legolant': ['brown_hair', 'strong'],
    'langris_vaude': ['brown_hair', 'fast'],
    'sally': ['brown_hair', 'super_powers'],
    'vetto': ['demon', 'muscular'],
    'palm_siberia': ['black_hair', 'has_tragic_past'],
    'shoot_mcmahon': ['black_hair', 'strategist'],
    'morel_mackernasey': ['brown_hair', 'strategist'],
    'knov': ['black_hair', 'stoic'],
    'razor': ['leader', 'martial_artist'],
    'komugi': ['brown_hair', 'young'],
    'zeno_zoldyck': ['white_hair', 'leader'],
    'silva_zoldyck': ['white_hair', 'leader'],
    'canary': ['black_hair', 'student'],
    'alluka_zoldyck': ['black_hair', 'has_tragic_past'],
    'connie_springer': ['student', 'brown_hair'],
    'ymir': ['brown_hair', 'strong'],
    'pieck_finger': ['black_hair', 'fast'],
    'porco_galliard': ['blond_hair', 'has_tragic_past'],
    'falco_grice': ['blond_hair', 'student'],
    'gabi_braun': ['brown_hair', 'student', 'strategist'],
    'onyankopon': ['leader', 'fast'],
    'nicolo': ['blond_hair', 'strategist'],
    'floch_forster': ['brown_hair', 'leader'],
    'petra_ral': ['brown_hair', 'fast'],
    'father': ['leader', 'strong'],
    'pride': ['black_hair', 'strategist'],
    'lust': ['black_hair', 'fast'],
    'gluttony': ['strong', 'muscular'],
    'sloth': ['muscular', 'super_powers'],
    'king_bradley': ['black_hair', 'fast', 'leader'],
    'may_chang': ['black_hair', 'student'],
    'lan_fan': ['black_hair', 'uses_sword'],
    'izumi_curtis': ['brown_hair', 'martial_artist'],
    'basque_grand': ['leader', 'strong'],
    'tadaomi_karasuma': ['black_hair', 'leader'],
    'irina_jelavic': ['blond_hair', 'fast'],
    'kaede_kayano': ['student', 'brown_hair'],
    'nagisa_shiota': ['student', 'fast'],
    'karma_akabane': ['red_hair', 'student', 'fast'],
    'itona_horibe': ['white_hair', 'student'],
    'rio_nakamura': ['blond_hair', 'student'],
    'manami_okuda': ['brown_hair', 'student'],
    'gakushuu_asano': ['brown_hair', 'student', 'leader'],
    'ritsu': ['student', 'super_powers'],
    'jet_black': ['black_hair', 'leader'],
    'faye_valentine': ['brown_hair', 'fast'],
    'edward_wong_hau_pepelu_tivrusky_iv': ['brown_hair', 'fast'],
    'ein': ['strategist', 'fast'],
    'vicious': ['black_hair', 'leader'],
    'julia': ['blond_hair', 'strategist'],
    'gren': ['blond_hair', 'strategist'],
    'shin': ['black_hair', 'fast'],
    'lin': ['black_hair', 'fast'],
    'laughing_bull': ['leader', 'hero'],
    'nicholas_d_wolfwood': ['black_hair', 'rival'],
    'meryl_stryfe': ['brown_hair', 'fast'],
    'milly_thompson': ['brown_hair', 'fast'],
    'millions_knives': ['blond_hair', 'leader'],
    'legato_bluesummers': ['blond_hair', 'leader'],
    'rem_saverem': ['blond_hair', 'strategist'],
    'chapel_the_evergreen': ['brown_hair', 'leader'],
    'midvalley_the_hornfreak': ['blond_hair', 'fast'],
    'dominique_the_cyclops': ['brown_hair', 'fast'],
    'zazie_the_beast': ['young', 'strategist'],
    'benimaru': ['red_hair', 'leader'],
    'shion': ['leader', 'fast'],
    'shuna': ['pink_hair', 'strategist'],
    'milim_nava': ['pink_hair', 'fast'],
    'diablo': ['black_hair', 'stoic'],
    'veldora_tempest': ['black_hair', 'leader'],
    'souei': ['black_hair', 'stoic'],
    'hakurou': ['white_hair', 'leader'],
    'gabiru': ['blond_hair', 'leader'],
    'geld': ['leader', 'muscular'],
    'touta_matsuda': ['brown_hair', 'fast'],
    'kiyomi_takada': ['brown_hair', 'young'],
    'watari': ['white_hair', 'leader'],
    'naomi_misora': ['black_hair', 'gun_user'],
    'raye_penber': ['black_hair', 'gun_user'],
    'rem': ['strategist', 'super_powers'],
    'mello': ['red_hair', 'strategist'],
    'matt': ['red_hair', 'strategist'],
    'halle_lidner': ['blond_hair', 'leader'],
    'roger_ruvie': ['white_hair', 'leader'],
    'nunnally_lamperouge': ['brown_hair', 'student'],
    'euphemia_li_britannia': ['pink_hair', 'leader'],
    'schneizel_el_britannia': ['blond_hair', 'leader'],
    'jeremiah_gottwald': ['blond_hair', 'leader'],
    'villetta_nu': ['brown_hair', 'leader'],
    'sayoko_shinozaki': ['black_hair', 'fast'],
    'lloyd_asplund': ['blond_hair', 'leader'],
    'gino_weinberg': ['blond_hair', 'student'],
    'anya_alstreim': ['brown_hair', 'student'],
    'rolo_lamperouge': ['brown_hair', 'student'],
    'anya_forger': ['pink_hair', 'student'],
    'yor_forger': ['black_hair', 'strategist'],
    'loid_forger': ['blond_hair', 'leader'],
    'becky_blackbell': ['blond_hair', 'student'],
    'yuri_briar': ['brown_hair', 'gun_user'],
    'damian_desmond': ['brown_hair', 'student'],
    'bond_forger': ['strategist', 'fast'],
    'sylvia_sherwood': ['blond_hair', 'leader'],
    'franky_franklin': ['brown_hair', 'fast'],
    'fiona_frost': ['blond_hair', 'fast'],
    'rin_okumura': ['black_hair', 'student'],
    'yukio_okumura': ['black_hair', 'student'],
    'shiemi_moriyama': ['brown_hair', 'student'],
    'mephisto_pheles': ['leader', 'super_powers'],
    'amaimon': ['fast', 'super_powers'],
    'izumo_kamiki': ['black_hair', 'student'],
    'shura_kirigakure': ['red_hair', 'strategist'],
    'ryuji_suguro': ['brown_hair', 'student'],
    'konekomaru_miwa': ['brown_hair', 'student'],
    'renzo_shima': ['blond_hair', 'student'],
    'maka_albarn': ['blond_hair', 'student'],
    'soul_eater_evans': ['white_hair', 'student'],
    'death_the_kid': ['black_hair', 'student'],
    'black_star': ['black_hair', 'student'],
    'tsubaki_nakatsukasa': ['black_hair', 'student'],
    'patty_thompson': ['blond_hair', 'student'],
    'liz_thompson': ['blond_hair', 'student'],
    'franken_stein': ['white_hair', 'leader'],
    'medusa_gorgon': ['black_hair', 'leader'],
    'crona': ['pink_hair', 'young'],
    'shinra_kusakabe': ['black_hair', 'fast'],
    'arthur_boyle': ['blond_hair', 'rival'],
    'maki_oze': ['brown_hair', 'strategist'],
    'takehisa_hinawa': ['black_hair', 'leader'],
    'tamaki_kotatsu': ['blond_hair', 'fast'],
    'benimaru_shinmon': ['black_hair', 'leader'],
    'joker': ['black_hair', 'fast'],
    'hibana': ['pink_hair', 'leader'],
    'leonard_burns': ['black_hair', 'leader'],
    'sho_kusakabe': ['white_hair', 'fast'],
}


tags_path = root / 'tags.json'
tags = load_json(tags_path)
existing_tag_ids = {tag['id'] for tag in tags}
for tag_definition in tag_definitions:
    if tag_definition['id'] not in existing_tag_ids:
        tags.append(tag_definition)
write_json(tags_path, tags)

approval_entries = load_json(imports / 'characters_import_approval.json')
mal_id_by_character_id = {entry['transformedId']: entry['malId'] for entry in approval_entries}

enrichment_path = imports / 'mal_jikan_character_enrichment_preview.json'
enrichment = load_json(enrichment_path)
updated = 0
for character_id, extra_tags in extra_tags_by_character_id.items():
    mal_id = mal_id_by_character_id.get(character_id)
    if mal_id is None:
        raise KeyError(f'Missing approval entry for {character_id}')

    key = str(mal_id)
    if key not in enrichment:
        raise KeyError(f'Missing enrichment entry for {character_id} ({mal_id})')

    enrichment[key]['tags'] = merge_tags(enrichment[key].get('tags', []), extra_tags)
    updated += 1

ordered_enrichment = {
    key: enrichment[key]
    for key in sorted(enrichment, key=lambda value: int(value))
}
write_json(enrichment_path, ordered_enrichment)

print(f'added richer reviewed tags to {updated} recently staged characters and ensured {len(tag_definitions)} extended tag definitions exist')
