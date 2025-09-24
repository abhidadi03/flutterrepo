from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
from pydantic import EmailStr
from fastapi import APIRouter



conf = ConnectionConfig(
   MAIL_USERNAME="abhidadi101@gmail.com",
   MAIL_PASSWORD="owqqotswkazyllfv",
   MAIL_FROM="abhidadi101@gmail.com",
   MAIL_PORT=587,
   MAIL_SERVER="smtp.gmail.com",
   MAIL_STARTTLS=True,
   MAIL_SSL_TLS=False,
   USE_CREDENTIALS=True
)

async def send_email(to:str, subject:str, body:str):

    message = MessageSchema(
        subject=subject,
        recipients=[to],
        body=body,
        subtype="plain"
    )
    fm = FastMail(conf)
    await fm.send_message(message)

