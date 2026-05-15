{% set cols_para_hash = get_column_names(
    ref('stg_port_operation__port_bcn_arrivals_7days_raw'),
    except=['_INGESTED_AT']
) %}



WITH unified AS (
SELECT
COALESCE(a7.docking_id, a7o.docking_id, a1t.docking_id, aft.docking_id, acft.docking_id) AS docking_id,
COALESCE(acft.docking_year, aft.docking_year, a1t.docking_year, a7.docking_year, a7o.docking_year) AS docking_year,
COALESCE(acft.eta, aft.eta, a1t.eta, a7.eta, a7o.eta) AS eta,
COALESCE(acft.etd, aft.etd, a1t.etd, a7.etd, a7o.etd) AS etd,
COALESCE(acft.dockingstatus_id, aft.dockingstatus_id, a1t.dockingstatus_id, a7.dockingstatus_id, a7o.dockingstatus_id) AS dockingstatus_id,
COALESCE(acft.imo, aft.imo, a1t.imo, a7.imo, a7o.imo) AS imo,
COALESCE(acft.originport_id, aft.originport_id, a1t.originport_id, a7.originport_id, a7o.originport_id) AS originport_id,
COALESCE(acft.destinationport_id, aft.destinationport_id, a1t.destinationport_id, a7.destinationport_id, a7o.destinationport_id) AS destinationport_id,
COALESCE(acft.dock_id, aft.dock_id, a1t.dock_id, a7.dock_id, a7o.dock_id) AS dock_id,
COALESCE(acft.consignee, aft.consignee, a1t.consignee, a7.consignee, a7o.consignee) AS consignee,
COALESCE(acft.dock_modules, aft.dock_modules, a1t.dock_modules, a7.dock_modules, a7o.dock_modules) AS dock_modules,
COALESCE(acft.ship_name, aft.ship_name, a1t.ship_name, a7.ship_name, a7o.ship_name) AS ship_name,
COALESCE(acft.ship_length, aft.ship_length, a1t.ship_length, a7.ship_length, a7o.ship_length) AS ship_length,
COALESCE(acft.ship_width, aft.ship_width, a1t.ship_width, a7.ship_width, a7o.ship_width) AS ship_width,
COALESCE(acft.ship_draft, aft.ship_draft, a1t.ship_draft, a7.ship_draft, a7o.ship_draft) AS ship_draft,
COALESCE(acft.marinetraffic_url, aft.marinetraffic_url, a1t.marinetraffic_url, a7.marinetraffic_url, a7o.marinetraffic_url) AS marinetraffic_url,
COALESCE(acft.shiptype_id, aft.shiptype_id, a1t.shiptype_id, a7.shiptype_id, a7o.shiptype_id) AS shiptype_id,
COALESCE(acft.shiptype_name, aft.shiptype_name, a1t.shiptype_name, a7.shiptype_name, a7o.shiptype_name) AS shiptype_name,
COALESCE(acft.mmsi, aft.mmsi, a1t.mmsi, a7.mmsi, a7o.mmsi) AS mmsi,
COALESCE(acft.callsign, aft.callsign, a1t.callsign, a7.callsign, a7o.callsign) AS callsign,
COALESCE(acft.shippingcompany_id, aft.shippingcompany_id, a1t.shippingcompany_id, a7.shippingcompany_id, a7o.shippingcompany_id) AS shippingcompany_id,
COALESCE(acft.shippingcompany_name, aft.shippingcompany_name, a1t.shippingcompany_name, a7.shippingcompany_name, a7o.shippingcompany_name) AS shippingcompany_name
a7._INGESTED_AT
FROM {{ ref('int_arrivals_7days') }} AS a7
FULL OUTER JOIN {{ ref('int_arrivals_7days_ops') }} AS a7o USING(docking_id)
FULL OUTER JOIN {{ ref('int_arrivals_today') }} AS a1t USING(docking_id)
FULL OUTER JOIN {{ ref('int_arrivals_ferrys_today') }} AS aft USING(docking_id)
FULL OUTER JOIN {{ ref('int_arrivals_cruises_and_ferrys_today') }} AS acft USING(docking_id)
),

with_hash as (
    select
        *,
        {{ dbt_utils.generate_surrogate_key(cols_para_hash) }} as row_hash
    from unified
)

SELECT * FROM with_hash