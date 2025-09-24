from pydantic import BaseModel, EmailStr
from typing import Optional

class PasswordEmailRequest(BaseModel):
    email:str

class VerifyOtpRequest(BaseModel):
    email:str
    otp:int

class UserCreate(BaseModel):
    name:str
    email:str
    password:str
    phone_no:str

class UserOut(BaseModel):
    id:int
    name:str
    email:str
    firebase_uid:str

class EmailRequest(BaseModel):
    email: str

class Phonerequest(BaseModel):
     phone_no:str

class UserResponse(BaseModel):
    email:str
    value:bool
    message:str


class ExistEmail(BaseModel):
    detail:str
    value:bool


class loginedUser(BaseModel):
    id:int
    name:str
    email:str
    id_token:str
    firebase_uid:str

class EmailSchema(BaseModel):
    email:list[EmailStr]

class ResetPassword(BaseModel):
    email:Optional[str] = None
    phone:Optional[str] = None
    newPassword:str
    confirmPassword:str