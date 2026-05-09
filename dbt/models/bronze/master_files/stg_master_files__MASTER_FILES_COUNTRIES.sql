with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_COUNTRIES') }}

),

renamed as (

    select
        isopais,
        nompais,
        areeconomica,
        idareaforeland,
        nomareaforeland,
        idsubareaforeland,
        nomareasubforeland,
        _ingested_at,
        _source_url

    from source

)

select * from renamed