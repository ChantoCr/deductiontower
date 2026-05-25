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
    'anko_mitarashi': ['leader'],
    'konohamaru_sarutobi': ['protagonist'],
    'yugito_nii': ['leader'],
    'fuu': ['leader'],
    'utakata': ['strategist'],
    'samui': ['leader'],
    'mabui': ['leader'],
    'pakura': ['leader'],
    'guren': ['leader'],
    'jewelry_bonney': ['rival'],
    'urouge': ['leader'],
    'scratchmen_apoo': ['leader'],
    'vista': ['hero'],
    'pell': ['leader'],
    'rebecca': ['has_tragic_past'],
    'viola': ['has_tragic_past'],
    'pica': ['leader'],
    'senor_pink': ['leader'],
    'charlotte_cracker': ['leader'],
    'nanao_ise': ['mentor'],
    'hanatarou_yamada': ['student'],
    'apache': ['fast'],
    'mila_rose': ['fast'],
    'sun_sun': ['fast'],
    'gremmy_thoumeaux': ['leader'],
    'jugram_haschwalth': ['leader'],
    'gerard_valkyrie': ['muscular'],
    'pernida_parnkgjas': ['strategist'],
    'lille_barro': ['strategist'],
    'yajirobe': ['uses_sword'],
    'chi_chi': ['leader'],
    'launch': ['strategist'],
    'supreme_kai': ['mentor'],
    'kibito': ['leader'],
    'old_kai': ['leader'],
    'babidi': ['leader'],
    'garlic_jr': ['leader'],
    'cooler': ['leader'],
    'janemba': ['strong'],
    'mashirao_ojiro': ['fast'],
    'toru_hagakure': ['strategist'],
    'minoru_mineta': ['strategist'],
    'neito_monoma': ['rival'],
    'itsuka_kendo': ['leader'],
    'tetsutetsu_tetsutetsu': ['fast'],
    'midnight': ['leader'],
    'edgeshot': ['leader'],
    'mirko': ['hero'],
    'gran_torino': ['hero'],
    'yuki_tsukumo': ['leader'],
    'shiu_kong': ['leader'],
    'takako_uro': ['fast'],
    'ryu_ishigori': ['rival'],
    'hiromi_higuruma': ['leader'],
    'naoya_zenin': ['leader'],
    'reggie_star': ['leader'],
    'hana_kurusu': ['hero'],
    'miguel': ['leader'],
    'manami_suda': ['leader'],
    'grey': ['young'],
    'revchi_salik': ['leader'],
    'valtos': ['fast'],
    'fanzell_kruger': ['hero'],
    'dominante_code': ['leader'],
    'letoile_becquerel': ['hero'],
    'fragil_tormenta': ['hero'],
    'svenkin_gatard': ['leader'],
    'vanica_zogratis': ['leader'],
    'gadjah': ['leader'],
    'baise': ['young'],
    'shizuku_murasaki': ['strategist'],
    'binolt': ['fast'],
    'abengane': ['leader'],
    'cheadle_yorkshire': ['hero'],
    'pariston_hill': ['strong'],
    'zushi': ['hero'],
    'basho': ['leader'],
    'leol': ['strong'],
    'zazan': ['leader'],
    'nanaba': ['strategist'],
    'gelgar': ['leader'],
    'miche_zacharius': ['leader'],
    'oluo_bozado': ['strategist'],
    'eld_jinn': ['fast'],
    'gunther_schultz': ['strategist'],
    'nifa': ['young'],
    'hitch_dreyse': ['fast'],
    'carla_yeager': ['leader'],
    'hannes': ['leader'],
    'denny_brosh': ['strategist'],
    'paninya': ['strategist'],
    'yoki': ['leader'],
    'isaac_mcdougal': ['leader'],
    'gracia_hughes': ['leader'],
    'selim_bradley': ['strategist'],
    'kain_fuery': ['leader'],
    'vato_falman': ['leader'],
    'heymans_breda': ['leader'],
    'jean_havoc': ['leader'],
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

print(f'added richer reviewed tags to {updated} staged batch-12 characters')
