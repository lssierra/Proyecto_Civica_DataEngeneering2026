{% macro profile_models_nulls(model_names) %}

{% set unions = [] %}

{% for model_name in model_names %}

    {% set relation = ref(model_name) %}
    {% set columns = adapter.get_columns_in_relation(relation) %}

    {% for column in columns %}

        {% set sql %}
        select
            '{{ model_name }}' as model_name,
            count(*) as total_rows,
            '{{ column.name }}' as column_name,
            count_if({{ adapter.quote(column.name) }} is null) as null_count
        from {{ relation }}
        {% endset %}

        {% do unions.append(sql) %}

    {% endfor %}

{% endfor %}

{{ unions | join(' union all ') }}

{% endmacro %}