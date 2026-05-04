import requests
import pandas as pd
import io
import logging

logger = logging.getLogger(__name__)

def download_csv(url: str, encoding: str = "utf-8-sig", separator: str = ",") -> pd.DataFrame:
    """Descarga un CSV desde una URL pública y lo devuelve como DataFrame."""
    logger.info(f"Descargando: {url}")
    response = requests.get(url, timeout=30)
    response.raise_for_status()

    df = pd.read_csv(
        io.StringIO(response.content.decode(encoding)),
        dtype=str,              # Todo string — el tipado lo hace dbt
        keep_default_na=False,
        sep=separator,
    )
    df.columns = [c.strip().upper() for c in df.columns]
    logger.info(f"Descargadas {len(df)} filas, {len(df.columns)} columnas")
    return df