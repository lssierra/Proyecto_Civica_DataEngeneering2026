{% macro get_column_names(relation, except=[]) %}
    {% set columns = adapter.get_columns_in_relation(relation) %}
    {% set col_names = [] %}
    {% for col in columns %}
        {% if col.name | lower not in except | map('lower') | list %}
            {% do col_names.append(col.name | lower) %}
        {% endif %}
    {% endfor %}
    {{ return(col_names) }}
{% endmacro %}