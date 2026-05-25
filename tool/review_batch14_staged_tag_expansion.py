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
    'shizune': ['strong'],
    'genma_shiranui': ['fast'],
    'hamura_otsutsuki': ['hero'],
    'indra_otsutsuki': ['leader'],
    'chino': ['fast'],
    'menma_uzumaki': ['rival'],
    'charlotte_perospero': ['strong'],
    'charlotte_oven': ['muscular'],
    'charlotte_daifuku': ['villain'],
    'hina': ['leader'],
    'tashigi': ['strong'],
    'kaku': ['uses_sword'],
    'jabra': ['fast'],
    'blueno': ['strong'],
    'kumadori': ['villain'],
    'kalifa': ['fast'],
    'chojiro_sasakibe': ['strategist'],
    'omaeda_marechiyo': ['strategist'],
    'sentarou_kotsubaki': ['strategist'],
    'kiyone_kotetsu': ['young'],
    'robert_accutrone': ['leader'],
    'cang_du': ['villain'],
    'bg9': ['strong'],
    'pepe_waccabrada': ['villain'],
    'nanana_najahkoop': ['fast'],
    'jerome_guizbatt': ['fast'],
    'king_vegeta': ['strategist'],
    'paragus': ['leader'],
    'bojack': ['strategist'],
    'zangya': ['fast'],
    'tapion': ['strong'],
    'pikkon': ['fast'],
    'nail': ['leader'],
    'kami': ['hero'],
    'yakon': ['muscular'],
    'oceanus_shenron': ['strong'],
    'thirteen': ['strategist'],
    'selkie': ['leader'],
    'crust': ['muscular'],
    'wash': ['strategist'],
    'pony_tsunotori': ['strong'],
    'kinoko_komori': ['strategist'],
    'ibara_shiozaki': ['strategist'],
    'jurota_shishida': ['muscular'],
    'reiko_yanagi': ['strategist'],
    'dhruv_lakdawalla': ['leader'],
    'yorozu': ['strong'],
    'tsumiki_fushiguro': ['young'],
    'wasuke_itadori': ['hero'],
    'mimiko_hasaba': ['strategist'],
    'nanako_hasaba': ['strategist'],
    'toshihisa_negi': ['leader'],
    'sekke_bronzazza': ['young'],
    'sister_lily': ['strategist'],
    'alecdora_sandler': ['leader'],
    'shiren_tium': ['young'],
    'randall_luftair': ['leader'],
    'david_swallow': ['leader'],
    'nils_ragus': ['strategist'],
    'en_ringard': ['leader'],
    'kahono': ['strategist'],
    'amane': ['has_tragic_past'],
    'tsubone': ['strategist'],
    'belerainte': ['leader'],
    'cluck': ['strategist'],
    'kanzai': ['leader'],
    'botobai_gigante': ['strategist'],
    'saiyu': ['leader'],
    'gel': ['young'],
    'dimo_reeves': ['strategist'],
    'flegel_reeves': ['has_tragic_past'],
    'pastor_nick': ['leader'],
    'kenny_ackerman': ['strong'],
    'uri_reiss': ['strategist'],
    'kuchel_ackerman': ['young'],
    'marco_bott': ['young'],
    'thomas_wagner': ['has_tragic_past'],
    'daz': ['has_tragic_past'],
    'lobov': ['leader'],
    'kanao_tsuyuri': ['fast'],
    'aoi_kanzaki': ['young'],
    'tamayo': ['mentor'],
    'yushiro': ['strategist'],
    'sabito': ['young'],
    'makomo': ['young'],
    'kaigaku': ['uses_sword'],
    'nakime': ['leader'],
    'hantengu': ['villain'],
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

print(f'added richer reviewed tags to {updated} staged batch-14 characters')
