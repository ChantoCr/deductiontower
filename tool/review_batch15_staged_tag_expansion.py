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
    'rigurd': ['strong'],
    'kaijin': ['leader'],
    'kurobee': ['strategist'],
    'souka': ['strong'],
    'treyni': ['strategist'],
    'myourmiles': ['leader'],
    'adalman': ['leader'],
    'albis': ['leader'],
    'suphia': ['muscular'],
    'vt': ['mentor'],
    'annie': ['has_tragic_past'],
    'punch': ['leader'],
    'judy': ['leader'],
    'wen': ['has_tragic_past'],
    'stella_bonnaro': ['young'],
    'roco_bonnaro': ['young'],
    'doohan': ['leader'],
    'carlos': ['strong'],
    'knives_millions': ['strategist'],
    'monique': ['fast'],
    'hoppered_the_gauntlet': ['leader'],
    'e_g_mine': ['leader'],
    'rai_dei_the_blade': ['fast'],
    'monev_the_gale': ['leader'],
    'leonof_the_puppetmaster': ['leader'],
    'elendira_the_crimsonnail': ['fast'],
    'razlo_the_tri_punisher': ['leader'],
    'ryoma_terasaka': ['fast'],
    'hinano_kurahashi': ['leader'],
    'taisei_yoshida': ['leader'],
    'kirara_hazama': ['fast'],
    'yuzuki_fuwa': ['leader'],
    'tomohito_sugino': ['strong'],
    'ryunosuke_chiba': ['strong'],
    'toka_yada': ['strong'],
    'yuma_isogai': ['strong'],
    'henry_henderson': ['leader'],
    'emile_elman': ['strategist'],
    'ewen_egeburg': ['strategist'],
    'martha_marriott': ['leader'],
    'dominic': ['leader'],
    'camilla': ['leader'],
    'millie': ['leader'],
    'sharon': ['leader'],
    'chloe': ['fast'],
    'daybreak': ['villain'],
    'renzou_shima': ['leader'],
    'arthur_a_angel': ['strong'],
    'lewin_light': ['leader'],
    'saburouta_toudou': ['strong'],
    'juzo_shima': ['leader'],
    'mamushi_hojo': ['fast'],
    'nemu_takara': ['fast'],
    'noriko_paku': ['leader'],
    'rick_lincoln': ['leader'],
    'igor_neuhaus': ['leader'],
    'sid_barrett': ['strategist'],
    'marie_mjolnir': ['leader'],
    'eruka_frog': ['fast'],
    'justin_law': ['leader'],
    'azusa_yumi': ['strong'],
    'ox_ford': ['strategist'],
    'kim_diehl': ['strategist'],
    'giriko': ['leader'],
    'mosquito': ['fast'],
    'free': ['leader'],
    'iris': ['has_tragic_past'],
    'viktor_licht': ['leader'],
    'vulcan_joseph': ['leader'],
    'lisa_isaribi': ['villain'],
    'arrow': ['fast'],
    'karim_fulham': ['leader'],
    'ogun_montgomery': ['fast'],
    'charon': ['leader'],
    'haumea': ['strategist'],
    'juggernaut': ['has_tragic_past'],
    'sachiko_yagami': ['has_tragic_past'],
    'sayu_yagami': ['strategist'],
    'shuichi_aizawa': ['leader'],
    'kanzo_mogi': ['leader'],
    'hideki_ide': ['leader'],
    'stephen_gevanni': ['leader'],
    'aiber': ['villain'],
    'kyosuke_higuchi': ['leader'],
    'reiji_namikawa': ['leader'],
    'rivalz_cardemonde': ['fast'],
    'nina_einstein': ['leader'],
    'ougi_kaname': ['strong'],
    'kanon_maldini': ['leader'],
    'xingke': ['strategist'],
    'marianne_vi_britannia': ['strategist'],
    'bismarck_waldstein': ['leader'],
    'luciano_bradley': ['leader'],
    'cecile_croomy': ['leader'],
    'v_v': ['leader'],
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

print(f'added richer reviewed tags to {updated} staged batch-15 characters')
