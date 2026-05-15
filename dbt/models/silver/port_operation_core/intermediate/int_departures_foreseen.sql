-- model name: int_departures_foreseen 


{% set cols_para_hash = get_column_names(
    ref('stg_port_operation__port_bcn_arrivals_7days_raw'),
    except=['_INGESTED_AT']
) %}


WITH unified AS (
SELECT
COALESCE(d1t.docking_id, dft.docking_id, dcft.docking_id) AS docking_id,
COALESCE(dcft.docking_year, dft.docking_year, d1t.docking_year) AS docking_year,
COALESCE(dcft.eta, dft.eta, d1t.eta) AS eta,
COALESCE(dcft.etd, dft.etd, d1t.etd) AS etd,
COALESCE(dcft.dockingstatus_id, dft.dockingstatus_id, d1t.dockingstatus_id) AS dockingstatus_id,
COALESCE(dcft.imo, dft.imo, d1t.imo) AS imo,
COALESCE(dcft.originport_id, dft.originport_id, d1t.originport_id) AS originport_id,
COALESCE(dcft.destinationport_id, dft.destinationport_id, d1t.destinationport_id) AS destinationport_id,
COALESCE(dcft.dock_id, dft.dock_id, d1t.dock_id) AS dock_id,
COALESCE(dcft.consignee, dft.consignee, d1t.consignee) AS consignee,
COALESCE(dcft.dock_modules, dft.dock_modules, d1t.dock_modules) AS dock_modules,
COALESCE(dcft.ship_name, dft.ship_name, d1t.ship_name) AS ship_name,
COALESCE(dcft.ship_length, dft.ship_length, d1t.ship_length) AS ship_length,
COALESCE(dcft.ship_width, dft.ship_width, d1t.ship_width) AS ship_width,
COALESCE(dcft.ship_draft, dft.ship_draft, d1t.ship_draft) AS ship_draft,
COALESCE(dcft.marinetraffic_url, dft.marinetraffic_url, d1t.marinetraffic_url) AS marinetraffic_url,
COALESCE(dcft.shiptype_id, dft.shiptype_id, d1t.shiptype_id) AS shiptype_id,
COALESCE(dcft.shiptype_name, dft.shiptype_name, d1t.shiptype_name) AS shiptype_name,
COALESCE(dcft.mmsi, dft.mmsi, d1t.mmsi) AS mmsi,
COALESCE(dcft.callsign, dft.callsign, d1t.callsign) AS callsign,
COALESCE(dcft.shippingcompany_id, dft.shippingcompany_id, d1t.shippingcompany_id) AS shippingcompany_id,
COALESCE(dcft.shippingcompany_name, dft.shippingcompany_name, d1t.shippingcompany_name) AS shippingcompany_name,
d1t._INGESTED_AT
FROM {{ ref('int_departures_today') }} AS d1t
FULL OUTER JOIN {{ ref('int_departures_ferrys_today') }} AS dft USING(docking_id)
FULL OUTER JOIN {{ ref('int_arrivals_cruises_and_ferrys_today') }} AS dcft USING(docking_id)
),

with_hash as (
    select
        *,
        {{ dbt_utils.generate_surrogate_key(cols_para_hash) }} as row_hash
    from unified
)

SELECT * FROM with_hash