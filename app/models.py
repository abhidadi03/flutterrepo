import enum
from datetime import datetime
from typing import List, Optional
from sqlmodel import Column, Field, Relationship, SQLModel

class User(SQLModel,table = True):
    __tablename__='user'
    id:int = Field(nullable=False, primary_key= True)
    name:str = Field(nullable=False)
    email:str = Field(nullable=False)
    firebase_uid:str = Field(nullable=True)
    phone_no:str = Field(nullable=True)

class PasswordReset(SQLModel,table = True):
    __tablename__ = "password_reset"
    id:int = Field(nullable=False, primary_key=True)
    user_id:int = Field(foreign_key="user.id",ondelete="CASCADE")
    otp:int
    expires_at:datetime = Field(nullable=False)
    created_at:datetime = Field(default_factory=datetime.utcnow)

