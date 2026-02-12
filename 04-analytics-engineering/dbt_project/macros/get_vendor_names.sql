{#
    This macro returns the description of the vendor id 
#}

{% macro get_vendor_name(vendorid) -%}
    CASE 
        WHEN {{vendorid}} = 1 THEN 'Creative Mobile Technolgies, LLC'
        WHEN {{vendorid}} = 2 THEN 'Curb Mobility, LLC '
        WHEN {{vendorid}} = 3 THEN 'VeriFone Inc'
        WHEN {{vendorid}} = 4 THEN 'Flywheel Software Inc'
        WHEN {{vendorid}} = 5 THEN 'LimeBike Inc'
        WHEN {{vendorid}} = 6 THEN 'Verifone Inc'
        ELSE 'Unknown Vendor'
       
    END
{%- endmacro %}
