with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_PORTS') }}

),

renamed as (

    select
        unlocode,
        nomlocalitat,
        isopais,
        nompais,
        aregeografica,
        nomareageografica,
        _ingested_at,
        _source_url

    from source

)

select * from renamed