import snowflake.connector
import pandas as pd
import tempfile
import os
import logging
from datetime import datetime, timezone

logger = logging.getLogger(__name__)

def get_connection(config: dict) -> snowflake.connector.SnowflakeConnection:
    return snowflake.connector.connect(
        account   = config["account"],
        user      = config["user"],
        password  = config["password"],
        database  = config["database"],
        schema    = config["schema"],
        warehouse = config["warehouse"],
        role      = config["role"],
    )

def load_dataframe(
    conn: snowflake.connector.SnowflakeConnection,
    df: pd.DataFrame,
    target_table: str,
    stage_name: str,
    stage_prefix: str,
    source_url: str,
) -> int:
    ingested_at = datetime.now(timezone.utc)
    df["_INGESTED_AT"] = ingested_at.isoformat()
    df["_SOURCE_URL"]  = source_url

    timestamp = ingested_at.strftime("%Y%m%d_%H%M%S")
    named_file = f"/tmp/{stage_prefix}_{timestamp}.csv"

    try:
        df.to_csv(named_file, index=False, encoding="utf-8")

        cur = conn.cursor()

        logger.info(f"PUT {named_file} → @{stage_name}/{stage_prefix}/")
        cur.execute(f"PUT file://{named_file} @{stage_name}/{stage_prefix}/ OVERWRITE=TRUE AUTO_COMPRESS=FALSE")

        stage_file = f"@{stage_name}/{stage_prefix}/{stage_prefix}_{timestamp}.csv"
        logger.info(f"COPY INTO {target_table} FROM {stage_file}")
        cur.execute(f"""
            COPY INTO {target_table}
            FROM {stage_file}
            FILE_FORMAT = (
                TYPE                         = 'CSV'
                FIELD_OPTIONALLY_ENCLOSED_BY = '"'
                PARSE_HEADER                 = TRUE
                NULL_IF                      = ('')
                EMPTY_FIELD_AS_NULL          = TRUE
            )
            MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
            PURGE    = TRUE
            ON_ERROR = 'CONTINUE'
        """)

        result = cur.fetchone()
        rows_loaded = result[0] if result else 0
        logger.info(f"Cargadas {rows_loaded} filas en {target_table}")
        return rows_loaded

    finally:
        if os.path.exists(named_file):
            os.unlink(named_file)
        cur.close()