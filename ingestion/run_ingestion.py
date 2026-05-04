import os
import logging
from dotenv import load_dotenv
from config import SOURCES
from downloader import download_csv
from loader import get_connection, load_dataframe

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s — %(message)s"
)
logger = logging.getLogger(__name__)
load_dotenv()

SNOWFLAKE_CONFIG = {
    "account":   os.environ["SNOWFLAKE_ACCOUNT"],
    "user":      os.environ["SNOWFLAKE_USER"],
    "password":  os.environ["SNOWFLAKE_PASSWORD"],
    "database":  os.environ["SNOWFLAKE_DATABASE"],
    "schema":    os.environ["SNOWFLAKE_SCHEMA"],
    "warehouse": os.environ["SNOWFLAKE_WAREHOUSE"],
    "role":      os.environ["SNOWFLAKE_ROLE"],
}

STAGE_NAME = f"{os.environ['SNOWFLAKE_DATABASE']}.{os.environ['SNOWFLAKE_SCHEMA']}.STG_INGESTION"

def main():
    conn = get_connection(SNOWFLAKE_CONFIG)
    try:
        for source_name, source_cfg in SOURCES.items():
            logger.info(f"=== Iniciando ingesta: {source_name} ===")
            try:
                df = download_csv(
                    url       = source_cfg["url"],
                    encoding  = source_cfg.get("encoding", "utf-8-sig"),
                    separator = source_cfg.get("separator", ","),
                )
                rows = load_dataframe(
                    conn         = conn,
                    df           = df,
                    target_table = source_cfg["target_table"],
                    stage_name   = STAGE_NAME,
                    stage_prefix = source_cfg["stage_prefix"],
                    source_url   = source_cfg["url"],
                )
                logger.info(f"=== {source_name}: OK ({rows} filas) ===")
            except Exception as e:
                logger.error(f"=== {source_name}: ERROR — {e} ===")
    finally:
        conn.close()

if __name__ == "__main__":
    main()