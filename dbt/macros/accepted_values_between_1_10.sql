{% test accepted_values_between_1_10(model, column_name) %}

    select {{ column_name }}
    from {{ model }}
    where {{ column_name }} not between 1 and 10

{% endtest %}