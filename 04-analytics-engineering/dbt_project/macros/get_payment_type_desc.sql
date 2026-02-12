{#
    This macro returns the description of the payment_type 
#}

{% macro get_payment_type_description(column_name) -%}
    CASE {{column_name}}
         WHEN 1 THEN 'Credit Card'
         WHEN 2 THEN 'Cash'
         WHEN 3 THEN 'No Charge'
         WHEN 4 THEN 'Dispute'
         WHEN 5 THEN 'Unknown'
         WHEN 0 THEN 'Flex Fare trip'
    ELSE 'Voided trip'
    END
{%- endmacro %}