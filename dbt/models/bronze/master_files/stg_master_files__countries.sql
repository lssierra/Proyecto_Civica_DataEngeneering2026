with 

source as (

    select * from {{ source('master_files', 'MASTER_FILES_COUNTRIES') }}

),

renamed as (

    select
        ISOPAIS AS country_id,
        NOMPAIS AS country_name,
        AREECONOMICA AS econarea,
        IDAREAFORELAND AS forelandarea_id,
        NOMAREAFORELAND AS forelandarea_name,
        IDSUBAREAFORELAND AS subforelandarea_id,
        NOMAREASUBFORELAND AS subforelandarea_name,
        _INGESTED_AT,
        _SOURCE_URL

    from source

)

select * from renamed