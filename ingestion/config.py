SOURCES = {
    "port_bcn_arrivals": {
        "url": "https://opendata.portdebarcelona.cat/es/dataset/342fe09b-017b-4019-a743-ee773f09befd/resource/72f0fc9e-b4b4-4a61-a0fb-e7b65b601b4d/download/arribadesavui.csv",
        "target_table": "PORT_BCN_ARRIVALS_RAW",
        "stage_prefix": "port_bcn_arrivals",
        "encoding": "utf-8-sig",
        "separator": ",",
    }#,
    # "port_bcn_departures": { ... },
    # "otra_fuente": { ... },
}