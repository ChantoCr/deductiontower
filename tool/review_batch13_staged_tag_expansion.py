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
    'karin': ['leader'],
    'jugo': ['leader'],
    'tayuya': ['fast'],
    'kidomaru': ['strong'],
    'sakon_and_ukon': ['leader'],
    'chojuro': ['hero'],
    'kurotsuchi': ['hero'],
    'mifune': ['hero'],
    'torune_aburame': ['leader'],
    'fu_yamanaka': ['leader'],
    'caribou': ['leader'],
    'bellamy': ['leader'],
    'caesar_clown': ['leader'],
    'vergo': ['leader'],
    'diamante': ['strategist'],
    'charlotte_smoothie': ['villain'],
    'charlotte_pudding': ['has_tragic_past'],
    'charlotte_brulee': ['leader'],
    'hody_jones': ['leader'],
    'king_the_wildfire': ['leader'],
    'shinji_hirako': ['leader'],
    'sado_yasutora': ['hero'],
    'hachigen_ushoda': ['mentor'],
    'love_aikawa': ['hero'],
    'mashiro_kuna': ['fast'],
    'isane_kotetsu': ['young'],
    'giselle_gewelle': ['leader'],
    'meninas_mcallon': ['fast'],
    'liltotto_lamperd': ['strategist'],
    'quilge_opie': ['leader'],
    'android_16': ['leader'],
    'android_19': ['leader'],
    'dr_gero': ['super_powers'],
    'king_piccolo': ['strategist'],
    'puar': ['fast'],
    'oolong': ['strategist'],
    'mr_satan': ['martial_artist'],
    'pan': ['fast'],
    'frost': ['leader'],
    'champa': ['strategist'],
    'mei_hatsume': ['strategist'],
    'ectoplasm': ['strategist'],
    'cementoss': ['leader'],
    'hound_dog': ['leader'],
    'recovery_girl': ['leader'],
    'kamui_woods': ['leader'],
    'gang_orca': ['hero'],
    'snipe': ['leader'],
    'ms_joke': ['hero'],
    'mandalay': ['leader'],
    'jiro_awasaka': ['leader'],
    'eso': ['leader'],
    'kechizu': ['leader'],
    'iori_hazenoki': ['leader'],
    'charles_bernard': ['fast'],
    'amai_rin': ['strategist'],
    'daido_hagane': ['fast'],
    'miyo_rokujushi': ['fast'],
    'chizuru_hari': ['leader'],
    'ogami': ['leader'],
    'gueldre_poizot': ['leader'],
    'marx_francois': ['leader'],
    'damnatio_kira': ['villain'],
    'catherine': ['leader'],
    'heath_grice': ['strategist'],
    'digit_taliss': ['leader'],
    'mariella': ['hero'],
    'broccos': ['leader'],
    'droit': ['leader'],
    'morris_libardirt': ['leader'],
    'zepile': ['hero'],
    'goreinu': ['leader'],
    'squala': ['leader'],
    'neon_nostrade': ['strategist'],
    'dalzollene': ['leader'],
    'gotoh': ['leader'],
    'cheetu': ['strong'],
    'flutter': ['strategist'],
    'bloster': ['leader'],
    'rammot': ['leader'],
    'moblit_berner': ['leader'],
    'kitz_woermann': ['strategist'],
    'nile_dawk': ['hero'],
    'marlowe_freudenberg': ['leader'],
    'boris_feulner': ['leader'],
    'louise': ['has_tragic_past'],
    'tom_ksaver': ['leader'],
    'dina_fritz': ['leader'],
    'rod_reiss': ['villain'],
    'frieda_reiss': ['leader'],
    'sheska': ['young'],
    'tim_marcoh': ['leader'],
    'bido': ['leader'],
    'dolcetto': ['leader'],
    'martel': ['leader'],
    'roa': ['leader'],
    'rebecca_catalina': ['young'],
    'psiren': ['strategist'],
    'rosalie': ['young'],
    'madame_christmas': ['hero'],
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

print(f'added richer reviewed tags to {updated} staged batch-13 characters')
