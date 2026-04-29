import os
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker, Session
from dotenv import load_dotenv

load_dotenv()

DATA_HOST = os.getenv("HOST")
DATA_PORT = os.getenv("PORT")
DATA_NAME = os.getenv("NAME")
DATA_USER = os.getenv("USER")
DATA_PASSWORD = os.getenv("PASSWORD")

DATABASE = f"postgresql+psycopg2://{DATA_USER}:{DATA_PASSWORD}@{DATA_HOST}:{DATA_PORT}/{DATA_NAME}"

engine = create_engine(DATABASE)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_session():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()