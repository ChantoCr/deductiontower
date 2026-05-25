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
        'id': 'blue_hair',
        'label': 'Blue Hair',
        'type': 'appearance',
        'difficulty': 'easy',
    },
    {
        'id': 'green_hair',
        'label': 'Green Hair',
        'type': 'appearance',
        'difficulty': 'easy',
    },
]

extra_tags_by_character_id = {
    'tadaomi_karasuma': ['strategist'],
    'kaede_kayano': ['green_hair'],
    'nagisa_shiota': ['blue_hair'],
    'manami_okuda': ['blue_hair'],
    'ritsu': ['green_hair'],
    'jet_black': ['strong'],
    'ein': ['leader'],
    'julia': ['fast'],
    'laughing_bull': ['brown_hair'],
    'nicholas_d_wolfwood': ['strategist'],
    'milly_thompson': ['leader'],
    'zazie_the_beast': ['fast'],
    'shion': ['blue_hair'],
    'shuna': ['young'],
    'veldora_tempest': ['alien'],
    'hakurou': ['hero'],
    'touta_matsuda': ['strategist'],
    'kiyomi_takada': ['leader'],
    'matt': ['young'],
    'nunnally_lamperouge': ['leader'],
    'becky_blackbell': ['pink_hair'],
    'sylvia_sherwood': ['hero'],
    'franky_franklin': ['gun_user'],
    'shiemi_moriyama': ['green_hair'],
    'amaimon': ['leader'],
    'maka_albarn': ['strategist'],
    'liz_thompson': ['young'],
    'franken_stein': ['hero'],
    'arthur_boyle': ['fast'],
    'leonard_burns': ['strategist'],
    'kiba_inuzuka': ['hero'],
    'kushina_uzumaki': ['leader'],
    'chiyo': ['has_tragic_past'],
    'ao': ['strong'],
    'killer': ['strong'],
    'basil_hawkins': ['leader'],
    'shirahoshi': ['leader'],
    'rangiku_matsumoto': ['strong'],
    'nemu_kurotsuchi': ['strategist'],
    'bazz_b': ['leader'],
    'captain_ginyu': ['strong'],
    'king_cold': ['strategist'],
    'sir_nighteye': ['leader'],
    'kiyotaka_ijichi': ['leader'],
    'riko_amanai': ['has_tragic_past'],
    'kirsch_vermillion': ['strategist'],
    'fana': ['has_transformation'],
    'satotz': ['leader'],
    'melody': ['has_tragic_past'],
    'tsezguerra': ['strong'],
    'dot_pixis': ['hero'],
    'colt_grice': ['leader'],
    'yelena': ['leader'],
    'maes_hughes': ['has_tragic_past'],
    'miles': ['leader'],
    'solf_j_kimblee': ['leader'],
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

print(f'added richer reviewed tags to {updated} currently staged characters and ensured {len(tag_definitions)} extra tag definitions exist')
