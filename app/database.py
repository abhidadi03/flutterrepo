from sqlmodel import SQLModel, Session, create_engine
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

# Read DB URL from .env
DATABASE_URL = os.getenv("DATABASE_URL")

# Create engine
engine = create_engine(
    DATABASE_URL,
    echo=True  
)

# Initialize database tables
def init_database():
    SQLModel.metadata.create_all(engine)

# Dependency for FastAPI routes
def get_session():
    with Session(engine) as session:
        yield session

# Optional: Create session with custom URL
def create_database_session(url: str):
    engine = create_engine(url, echo=False)
    SQLModel.metadata.create_all(engine)
    return Session(engine)
