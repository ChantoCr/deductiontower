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


extra_tags_by_character_id = {
    'kiba_inuzuka': ['strong'],
    'kushina_uzumaki': ['super_powers'],
    'shisui_uchiha': ['leader', 'strategist'],
    'kimimaro': ['fast'],
    'karui': ['fast'],
    'ebisu': ['leader'],
    'hanzo': ['strategist'],
    'ao': ['mentor'],
    'basil_hawkins': ['strong'],
    'capone_bege': ['strong'],
    'cavendish': ['strong', 'has_transformation'],
    'boa_sandersonia': ['fast'],
    'monet': ['ice_user', 'fast'],
    'shirahoshi': ['super_powers'],
    'kyros': ['leader'],
    'baby_5': ['fast', 'strategist'],
    'queen': ['has_transformation', 'super_powers'],
    'rangiku_matsumoto': ['strong'],
    'nemu_kurotsuchi': ['strategist'],
    'kensei_muguruma': ['uses_sword'],
    'iba_tetsuzaemon': ['uses_sword'],
    'bambietta_basterbine': ['fast'],
    'bazz_b': ['super_powers', 'leader'],
    'as_nodt': ['strategist'],
    'candice_catnipp': ['strong'],
    'mask_de_masculine': ['leader'],
    'askin_nakk_le_vaar': ['leader'],
    'turles': ['leader'],
    'zarbon': ['fast'],
    'captain_ginyu': ['strong'],
    'recoome': ['leader'],
    'guldo': ['strategist'],
    'dabura': ['strong'],
    'king_cold': ['strategist'],
    'hanta_sero': ['fast'],
    'mezo_shoji': ['super_powers'],
    'rikido_sato': ['muscular', 'super_powers'],
    'yuga_aoyama': ['fast'],
    'camie_utsushimi': ['fast', 'strategist'],
    'inasa_yoarashi': ['strong'],
    'ryukyu': ['strong'],
    'sir_nighteye': ['leader'],
    'juzo_honenuki': ['strategist'],
    'kiyotaka_ijichi': ['mentor'],
    'akari_nitta': ['young'],
    'takuma_ino': ['strategist'],
    'atsuya_kusakabe': ['strong'],
    'ui_ui': ['strategist'],
    'larue': ['strong'],
    'uraume': ['strategist'],
    'junpei_yoshino': ['strategist'],
    'haruta_shigemo': ['strategist'],
    'riko_amanai': ['has_tragic_past'],
    'klaus_lunettes': ['strategist'],
    'sol_marron': ['strong'],
    'nebra_silva': ['strategist'],
    'kirsch_vermillion': ['strategist'],
    'fana': ['has_transformation'],
    'ladros': ['strong'],
    'mars': ['strong'],
    'zenon_zogratis': ['strategist', 'strong'],
    'dante_zogratis': ['strategist', 'muscular'],
    'satotz': ['leader'],
    'ponzu': ['strategist'],
    'pokkle': ['strategist'],
    'welfin': ['leader'],
    'ikalgo': ['fast'],
    'menthuthuyoupi': ['leader', 'muscular'],
    'kortopi': ['strategist'],
    'kalluto_zoldyck': ['strategist'],
    'tsezguerra': ['strong'],
    'theo_magath': ['gun_user'],
    'marcel_galliard': ['leader'],
    'rico_brzenska': ['strategist'],
    'yelena': ['leader'],
    'furlan_church': ['strategist'],
    'isabel_magnolia': ['strategist'],
    'mina_carolina': ['fast'],
    'dhalis_zachary': ['brown_hair'],
    'maria_ross': ['leader'],
    'maes_hughes': ['has_tragic_past'],
    'shou_tucker': ['super_powers'],
    'barry_the_chopper': ['uses_sword'],
    'buccaneer': ['leader'],
    'jerso': ['strong'],
    'zampano': ['strong'],
    'solf_j_kimblee': ['leader'],
}

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

print(f'added richer reviewed tags to {updated} remaining staged characters')
