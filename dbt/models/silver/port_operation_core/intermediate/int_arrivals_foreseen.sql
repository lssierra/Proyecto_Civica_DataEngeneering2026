--model name: int_arrivals_foreseen
--description: 

WITH all_ids AS (
    SELECT docking_id, docking_seq, docking_year FROM {{ ref('int_arrivals_7days') }}
    UNION
    SELECT docking_id, docking_seq, docking_year FROM {{ ref('int_arrivals_7days_ops') }}
    UNION
    SELECT docking_id, docking_seq, docking_year FROM {{ ref('int_arrivals_today') }}
    UNION
    SELECT docking_id, docking_seq, docking_year FROM {{ ref('int_arrivals_ferrys_today') }}
),


unified AS (
SELECT
a.docking_id,
a.docking_seq,
a.docking_year,
COALESCE( aft.eta, a1t.eta, a7.eta, a7o.eta) AS eta,
COALESCE( aft.etd, a1t.etd, a7.etd, a7o.etd) AS etd,
COALESCE(aft.dockingstatus_id, a1t.dockingstatus_id, a7.dockingstatus_id, 'S') AS dockingstatus_id,
COALESCE(aft.dockingstatus_desc, a1t.dockingstatus_desc, a7.dockingstatus_desc, 'Solicitada') AS dockingstatus_desc,
COALESCE(aft.imo, a1t.imo, a7.imo, a7o.imo) AS imo,
COALESCE(aft.originport_id, a1t.originport_id, a7.originport_id) AS originport_id,
COALESCE(aft.destinationport_id, a1t.destinationport_id, a7.destinationport_id) AS destinationport_id,
COALESCE( aft.dock_id, a1t.dock_id, a7.dock_id, a7o.dock_id) AS dock_id,
COALESCE(aft.consignee, a1t.consignee, a7.consignee, a7o.consignee) AS consignee,
COALESCE(aft.dock_modules, a1t.dock_modules, a7.dock_modules, a7o.dock_modules) AS dock_modules,
COALESCE( aft.ship_name, a1t.ship_name, a7.ship_name, a7o.ship_name) AS ship_name,
COALESCE(aft.country_id, a1t.country_id, a7.country_id, a7o.country_id) AS country_id,
COALESCE(aft.ship_length, a1t.ship_length, a7.ship_length, a7o.ship_length) AS ship_length,
COALESCE(aft.ship_width, a1t.ship_width, a7.ship_width) AS ship_width,
COALESCE(aft.ship_draft, a1t.ship_draft, a7.ship_draft) AS ship_draft,
COALESCE(aft.marinetraffic_url, a1t.marinetraffic_url, a7.marinetraffic_url) AS marinetraffic_url,
a7o.shiptype_id AS shiptype_id,
COALESCE(aft.shiptype_name, a1t.shiptype_name, a7.shiptype_name, a7o.shiptype_name) AS shiptype_name,
COALESCE(aft.mmsi, a1t.mmsi, a7.mmsi) AS mmsi,
COALESCE(aft.callsign, a1t.callsign, a7.callsign) AS callsign,
COALESCE(a1t.shippingcompany_id, a7.shippingcompany_id, a7o.shippingcompany_id) AS shippingcompany_id,
COALESCE(a1t.shippingcompany_name, a7.shippingcompany_name, a7o.shippingcompany_name) AS shippingcompany_name,
COALESCE(aft._ingested_at, a1t._ingested_at, a7._INGESTED_AT, a7o._ingested_at) AS _ingested_at,
a7o.ops
FROM all_ids AS a
LEFT JOIN {{ ref('int_arrivals_7days') }} AS a7 
    ON a.docking_id = a7.docking_id AND a.docking_seq = a7.docking_seq AND a.docking_year = a7.docking_year
LEFT JOIN {{ ref('int_arrivals_7days_ops') }} AS a7o 
    ON a.docking_id = a7o.docking_id AND a.docking_seq = a7o.docking_seq AND a.docking_year = a7o.docking_year
LEFT JOIN {{ ref('int_arrivals_today') }} AS a1t 
    ON a.docking_id = a1t.docking_id AND a.docking_seq = a1t.docking_seq AND a.docking_year = a1t.docking_year
LEFT JOIN {{ ref('int_arrivals_ferrys_today') }} AS aft 
    ON a.docking_id = aft.docking_id AND a.docking_seq = aft.docking_seq AND a.docking_year = aft.docking_year
),

with_shiptype_id AS (
SELECT
-- para snp_arrivals_foreseen
u.docking_id,
u.docking_year,
u.docking_seq,
u.eta,
u.etd,
u.dockingstatus_id,
u.dockingstatus_desc,
u.imo,
u.originport_id,
u.destinationport_id,
u.dock_id,
u.consignee,
u.dock_modules,
u.ops,

--para snp_ships_arrivals_foreseem
u.ship_name,
u.ship_length,
u.ship_width,
u.ship_draft,
u.marinetraffic_url,
COALESCE(u.shiptype_id, st.shiptype_id) AS shiptype_id,
u.shiptype_name,
u.mmsi,
u.callsign,
u.shippingcompany_id,


--metadata
u._ingested_at


FROM unified AS u
LEFT JOIN {{ ref('int_ship_types') }} AS st 
    ON u.shiptype_name = st.shiptype_name
),

clean as (
SELECT
-- para snp_arrivals_foreseen
u.docking_id,
u.docking_year,
u.docking_seq,
u.eta,
u.etd,
u.dockingstatus_id,
u.dockingstatus_desc,
u.imo,
u.originport_id,
u.destinationport_id,
u.dock_id,
u.consignee,
u.dock_modules,
u.ops,

--para snp_ships_arrivals_foreseem
u.ship_name,
u.ship_length,
u.ship_width,
u.ship_draft,
u.marinetraffic_url,
u.shiptype_id,
st.shiptype_name,
u.mmsi,
u.callsign,
u.shippingcompany_id,


--metadata
u._ingested_at


FROM with_shiptype_id AS u
LEFT JOIN {{ ref('int_ship_types') }} AS st 
    ON u.shiptype_id = st.shiptype_id
)

SELECT * FROM clean