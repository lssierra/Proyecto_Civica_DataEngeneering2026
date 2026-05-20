with tramos as (
    select
        docking_id,
        docking_year,
        docking_seq,
        dock_id,
        eta,
        etd,
        initial_module,
        final_module,
        dock_id in ('90A', '90B', '24X')        as is_espera,
        datediff('minute', eta, etd)             as tramo_duration_min
    from {{ ref('snp_dockings_active') }}
    where dbt_is_deleted = 'False'
    qualify row_number() over (
        partition by docking_id, docking_seq
        order by dbt_valid_from desc
    ) = 1
),

arrivals_primera as (
    select
        docking_id,
        eta                                      as eta_original,
        etd                                      as etd_original,
        dockingstatus_id                         as status_original,
        imo,
        originport_id,
        destinationport_id,
        dock_id                                  as dock_id_previsto
    from {{ ref('snp_arrivals_foreseen') }}
    where dbt_is_deleted = 'False'
    qualify row_number() over (
        partition by docking_id
        order by dbt_valid_from asc
    ) = 1
),

arrivals_ultima as (
    select
        docking_id,
        eta                                      as eta_actual,
        etd                                      as etd_actual,
        dockingstatus_id                         as status_actual,
        dock_modules
    from {{ ref('snp_arrivals_foreseen') }}
    where dbt_is_deleted = 'False'
    qualify row_number() over (
        partition by docking_id
        order by dbt_valid_from desc
    ) = 1
),

no_ferris as (
    select ap.*
    from arrivals_primera ap
    inner join {{ ref('dim_ships') }} d on ap.imo = d.imo
    where d.shiptype_id != 15
),

tramos_resumen as (
    select
        t.docking_id,
        t.docking_year,
        min(t.eta)                               as eta_entrada,
        max(t.etd)                               as etd_salida,
        datediff('minute', min(t.eta), max(t.etd)) as duracion_total_min,
        sum(case when t.is_espera
            then t.tramo_duration_min else 0
        end)                                     as tiempo_espera_min,
        sum(case when not t.is_espera
            then t.tramo_duration_min else 0
        end)                                     as tiempo_muelle_min,
        count(*)                                 as num_tramos,
        count(case when t.is_espera then 1 end)  as num_tramos_espera,
        min(case when not t.is_espera
            then t.eta end)                      as eta_primer_muelle
    from tramos t
    inner join no_ferris nf on t.docking_id = nf.docking_id
    group by t.docking_id, t.docking_year
),

tramo_principal as (
    select t.docking_id, t.dock_id, t.initial_module, t.final_module
    from tramos t
    inner join no_ferris nf on t.docking_id = nf.docking_id
    where not t.is_espera
    qualify row_number() over (
        partition by t.docking_id
        order by t.tramo_duration_min desc
    ) = 1
)

select
    -- keys
    tr.docking_id,
    tr.docking_year,
    ap.imo,
    tp.dock_id,
    ap.dock_id_previsto,
    ap.originport_id,
    ap.destinationport_id,
    ap.status_original                           as dockingstatus_id_original,
    au.status_actual                             as dockingstatus_id_actual,

    -- dates
    ap.eta_original,
    ap.etd_original,
    au.eta_actual,
    au.etd_actual,
    tr.eta_entrada,
    tr.etd_salida,
    tr.eta_primer_muelle,

    -- measures
    datediff('minute',
        ap.eta_original,
        ap.etd_original)                         as duracio_prevista_original_min,
    tr.duracion_total_min,
    tr.tiempo_espera_min,
    tr.tiempo_muelle_min,
    round(tr.tiempo_espera_min /
        nullif(tr.duracion_total_min, 0) * 100, 1) as pct_temps_espera,
    datediff('minute',
        ap.eta_original,
        au.eta_actual)                           as eta_drift_min,
    datediff('minute',
        ap.etd_original,
        au.etd_actual)                           as etd_drift_min,
    datediff('minute',
        tr.eta_entrada,
        tr.eta_primer_muelle)                    as temps_fins_primer_moll_min,
    tr.num_tramos,
    tr.num_tramos_espera,
    tp.initial_module,
    tp.final_module,
    au.dock_modules

from tramos_resumen tr
left join no_ferris ap        on tr.docking_id = ap.docking_id
left join arrivals_ultima au  on tr.docking_id = au.docking_id
left join tramo_principal tp  on tr.docking_id = tp.docking_id