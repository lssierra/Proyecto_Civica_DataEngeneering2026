{% test no_conflicting_values(model, test_partition_by, test_columns) %}

{% set checks = [] %}
{% for col in test_columns %}
    {% do checks.append(
        "sum(case when " ~ col ~ " is not null then 1 else 0 end) > 1
         and count(distinct " ~ col ~ ") > 1 then '" ~ col ~ "'"
    ) %}
{% endfor %}

select
    {{ test_partition_by }},
    case
        {% for check in checks %}
        when {{ check }}
        {% endfor %}
    end as conflicting_column
from {{ model }}
where dbt_valid_to is null
  and dbt_is_deleted = 'False'
group by {{ test_partition_by }}
having conflicting_column is not null

{% endtest %}