SOURCES = {
    "port_bcn_arrivals_today": {
        "url": "https://opendata.portdebarcelona.cat/es/dataset/342fe09b-017b-4019-a743-ee773f09befd/resource/72f0fc9e-b4b4-4a61-a0fb-e7b65b601b4d/download/arribadesavui.csv",
        "target_table": "PORT_BCN_ARRIVALS_TODAY_RAW",
        "stage_prefix": "port_bcn_arrivals_today",
        "encoding": "utf-8-sig",
        "separator": ",",
    },

    "port_bcn_departures_today": {
        "url": "https://opendata.portdebarcelona.cat/es/dataset/342fe09b-017b-4019-a743-ee773f09befd/resource/4bf1ccd0-5132-4d54-81d4-1ab72d5542e9/download/sortidesavui.csv",
        "target_table": "PORT_BCN_DEPARTURES_TODAY_RAW",
        "stage_prefix": "port_bcn_departures_today",
        "encoding": "utf-8-sig",
        "separator": ",",
    },

    "port_bcn_arrivals_ferrys_today": {
        "url": "https://opendata.portdebarcelona.cat/es/dataset/342fe09b-017b-4019-a743-ee773f09befd/resource/4db5d287-37fc-4c5b-9a56-abe738cb5856/download/arribadesavuiferry.csv", 
        "target_table": "PORT_BCN_ARRIVALS_FERRYS_TODAY_RAW",
        "stage_prefix": "port_bcn_arrivals_ferrys_today",
        "encoding": "utf-8-sig",
        "separator": ",",
    },

    "port_bcn_departures_ferrys_today": {
        "url": "https://opendata.portdebarcelona.cat/es/dataset/342fe09b-017b-4019-a743-ee773f09befd/resource/d509c2f2-0b54-4383-80d9-38f5523ead4a/download/sortidesavuiferry.csv", 
        "target_table": "PORT_BCN_DEPARTURES_FERRYS_TODAY_RAW",
        "stage_prefix": "port_bcn_departures_ferrys_today",
        "encoding": "utf-8-sig",
        "separator": ",",
    },

    "port_bcn_arrivals_7days": {
        "url": "https://opendata.portdebarcelona.cat/es/dataset/21315800-f5c7-40b1-9154-716272108775/resource/d7a6cc76-0795-48a3-90ea-b5fa8e6ee599/download/arribadessetdies.csv",
        "target_table": "PORT_BCN_ARRIVALS_7DAYS_RAW",
        "stage_prefix": "port_bcn_arrivals_7days",
        "encoding": "utf-8-sig",
        "separator": ",",
    },

    "port_bcn_arrivals_7days_OPS": {
        "url": "https://opendata.portdebarcelona.cat/es/dataset/6ab4fa4a-71c5-4b2f-9ffe-105c2e4d095e/resource/037f83fa-af02-401b-a434-a3d16e4c5718/download/ops_7dies.csv",
        "target_table": "PORT_BCN_ARRIVALS_7DAYS_OPS_RAW",
        "stage_prefix": "port_bcn_arrivals_7days_OPS",
        "encoding": "utf-8-sig",
        "separator": ",",
    },

    "port_bcn_arrivals_cruises_and_ferrys_today": {
        "url": "https://opendata.portdebarcelona.cat/dataset/0a5f703d-35e5-4262-84ac-b6930239f4aa/resource/9c803939-6ea4-4095-aa82-11127538154a/download/portbcncreuers.csv",
        "target_table": "PORT_BCN_ARRIVALS_CRUISES_AND_FERRYS_TODAY_RAW",
        "stage_prefix": "port_bcn_arrivals_cruises_and_ferrys_today",
        "encoding": "utf-8-sig",
        "separator": ",",
    },

    "port_bcn_ships_docked_today": {
        "url": "https://opendata.portdebarcelona.cat/es/dataset/c6f3045b-8aee-476e-9ea3-7a46c453e04a/resource/7e75a37e-bafc-43fc-8b0a-02c0e051d8e5/download/portbcnvaixellsavui.csv",
        "target_table": "PORT_BCN_SHIPS_DOCKED_TODAY_RAW",
        "stage_prefix": "port_bcn_ships_docked_today",
        "encoding": "utf-8-sig",
        "separator": ",",
    }
} 