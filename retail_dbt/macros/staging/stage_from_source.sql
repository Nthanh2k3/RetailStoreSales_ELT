{% macro stage_from_source(src_schema, src_name) %}
  {% set rel = source(src_schema, src_name) %}
  {% set cols = adapter.get_columns_in_relation(rel) %}

  {# typing hints per table come from vars: staging_types.<table_name> #}
  {% set all_types = var('staging_types', {}) %}
  {% set cfg = all_types.get(src_name, {}) %}
  {% set force_numeric   = cfg.get('force_numeric',   []) %}
  {% set force_date      = cfg.get('force_date',      []) %}
  {% set force_timestamp = cfg.get('force_timestamp', []) %}
  {% set force_boolean   = cfg.get('force_boolean',   []) %}
  {% set force_text      = cfg.get('force_text',      []) %}

  select
    {% for c in cols %}
      {% set chosen = decide_type(
          c,
          force_numeric=force_numeric,
          force_date=force_date,
          force_timestamp=force_timestamp,
          force_boolean=force_boolean,
          force_text=force_text
      ) %}
      {{ clean_expr_with_type(c, chosen) }}{% if not loop.last %}, {% endif %}
    {% endfor %}
  from {{ rel }}
{% endmacro %}
