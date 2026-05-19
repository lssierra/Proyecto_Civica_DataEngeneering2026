-- model name: int_departures_foreseen 

WITH all_ids AS (
    SELECT docking_id, docking_seq, docking_year FROM {{ ref('int_departures_today') }}
    UNION
    SELECT docking_id, docking_seq, docking_year FROM {{ ref('int_departures_ferrys_today') }}
),


unified AS (
SELECT
a.docking_id,
a.docking_seq,
a.docking_year,
COALESCE(dft.eta, d1t.eta) AS eta,
COALESCE(dft.etd, d1t.etd) AS etd,
COALESCE(dft.dockingstatus_id, d1t.dockingstatus_id) AS dockingstatus_id,
COALESCE(dft.imo, d1t.imo) AS imo,
COALESCE(dft.originport_id, d1t.originport_id) AS originport_id,
COALESCE(dft.destinationport_id, d1t.destinationport_id) AS destinationport_id,
COALESCE(dft.dock_id, d1t.dock_id) AS dock_id,
COALESCE(dft.consignee, d1t.consignee) AS consignee,
COALESCE(dft.dock_modules, d1t.dock_modules) AS dock_modules,
COALESCE(dft.ship_name, d1t.ship_name) AS ship_name,
COALESCE(dft.ship_length, d1t.ship_length) AS ship_length,
COALESCE(dft.ship_width, d1t.ship_width) AS ship_width,
COALESCE(dft.ship_draft, d1t.ship_draft) AS ship_draft,
COALESCE(dft.marinetraffic_url, d1t.marinetraffic_url) AS marinetraffic_url,
COALESCE(dft.shiptype_name, d1t.shiptype_name) AS shiptype_name,
COALESCE(dft.mmsi, d1t.mmsi) AS mmsi,
COALESCE(dft.callsign, d1t.callsign) AS callsign,
COALESCE(dft._ingested_at, d1t._ingested_at) AS _ingested_at
FROM all_ids AS a 
LEFT JOIN {{ ref('int_departures_today') }} AS d1t
    ON a.docking_year = d1t.docking_year AND a.docking_id = d1t.docking_id AND a.docking_seq = d1t.docking_seq
LEFT JOIN {{ ref('int_departures_ferrys_today') }} AS dft 
    ON a.docking_year = dft.docking_year AND a.docking_id = dft.docking_id AND a.docking_seq = dft.docking_seq
),

clean AS (
SELECT
--para snp_departures_foreseen
u.docking_id,
u.docking_year,
u.docking_seq,
u.eta,
u.etd,
u.dockingstatus_id,
u.imo,
u.originport_id,
u.destinationport_id,
u.dock_id,
u.consignee,
u.dock_modules,

--para snp_ship_departures_foreseen
u.ship_name,
u.ship_length,
u.ship_width,
u.ship_draft,
u.marinetraffic_url,
st.shiptype_id AS shiptype_id,
u.shiptype_name,
u.mmsi,
u.callsign,

--metadata
u._ingested_at

FROM unified AS u
LEFT JOIN {{ ref('int_ship_types') }} AS st 
    ON u.shiptype_name = st.shiptype_name


)


SELECT * FROM clean