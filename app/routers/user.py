from fastapi import APIRouter, Depends, HTTPException, Body, Header
from sqlalchemy.orm import Session
from sqlmodel import select
from typing import List
import requests
from sqlalchemy import desc
from ..models import User, PasswordReset
# from ..main import User
# from app.main import User
from ..email_service import send_email
from ..database import get_session
from firebase_admin import auth
from ..schema import UserCreate, UserOut, EmailRequest, ExistEmail, loginedUser, PasswordEmailRequest, VerifyOtpRequest, ResetPassword, Phonerequest
# import app.schema as schema
import random, datetime
from random import randint
router = APIRouter(
    prefix="/users",
    tags=["users"]
)


@router.post("/")
def create_user(user: UserCreate, session: Session = Depends(get_session)):
    print('came to add user')
    print('input user',user)
    existingEmail = session.execute(select(User).where(User.email == user.email)).scalar_one_or_none()
    existingPhone = session.execute(select(User).where(User.phone_no == user.phone_no)).scalar_one_or_none()

    if existingPhone:
        raise HTTPException(status_code=400, detail="Phone already exists")
    print('existingUser',existingEmail)
    if existingEmail:
        raise HTTPException(status_code = 400 , detail = 'Email already exists')
    try:
        firebase_user = auth.create_user(
            email = user.email,
            password = user.password
        )
        new_user = User(
        name = user.name,
        email = user.email,
        firebase_uid = firebase_user.uid,
        phone_no = user.phone_no
        )
        session.add(new_user)
        session.commit()
        session.refresh(new_user)
        print('user:',new_user)
        return {"detail":"User Created Successfully"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"{str(e)}")


@router.get("/", response_model=List[User])
def get_users(session: Session = Depends(get_session)):
    print('came into this api')
    statement = select(User).order_by(desc(User.id))
    results = session.exec(statement).all()
    return results

@router.delete("/{id}")
def delete_user(id:int, session:Session = Depends(get_session)):
    user = session.execute(select(User).where(User.id == id)).scalar_one_or_none()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    try:
        if user.firebase_uid:
            auth.delete_user(user.firebase_uid)

        session.delete(user)
        session.commit()
    except Exception as e:
        raise HTTPException(status_code=404, detail=f"{str(e)}")

    # if user:
    #     session.delete(user)
    #     session.commit()
    #     return {'message':"user deleted successfully"}
    # else:
    #     raise HTTPException(status_code=404,  detail='User not found')
    

@router.put("/{id}")
def update_user(id:int ,user:User, session:Session = Depends(get_session)):
    exisitingUser = session.execute(select(User).where(User.id  == id)).scalar_one_or_none()
    if exisitingUser:
        if user.name:
            exisitingUser.name = user.name
        if user.email:
            exisitingUser.email = user.email
        session.add(exisitingUser)
        session.commit()
        session.refresh(exisitingUser)
        return exisitingUser
    else:
       raise HTTPException(status_code= 404, detail="User not found")
    

@router.post("/login", response_model=loginedUser)
def login_user(user: dict = Body(...), session:Session = Depends(get_session)):
    email = user["email"]
    password = user["password"]

    payload = {
        "email":email,
        "password":password,
        "returnSecureToken":True
    }
    
    url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAxRYp3FSnf2U6iw-3gcPJLWYO3aMCWEyA"
    response = requests.post(url,json=payload)

    if response.status_code != 200:
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
    data = response.json()
    id_token = data["idToken"]
    uid = data["localId"]
    if not uid:
        raise HTTPException(status_code=404,detail="uid not found")
    db_user = session.execute(select(User).where(User.firebase_uid == uid)).scalar_one_or_none()

    if not db_user:
         raise HTTPException(status_code=401, detail="User not found")
    
    return loginedUser(
        id=db_user.id,
        name=db_user.name,
        email=db_user.email,
        id_token=id_token,
        firebase_uid=db_user.firebase_uid

    )
    # return {
    #     "message":"Login suceessful",
    #     "id_token": id_token,
    #     "user":{
    #         "id":db_user.id,
    #         "name":db_user.name
    #     }
    # }


@router.get("/getUser",response_model=UserOut)
def get_user(authorization:str = Header(...),session:Session = Depends(get_session)):

    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401,detail="Inavlid authorization header")
    id_token = authorization.split(" ")[1]
    # print("id form the firebase:${id_token}")

    print(f"id form the firebase;{id_token}")
    try:
        decoded = auth.verify_id_token(id_token)
        uid  = decoded["uid"]
        if not uid:
            raise HTTPException(status_code=404,detail="uid not found")
    except Exception:
        raise HTTPException(status_code=401,detail="Inavalid or Expired token")
    user = session.execute(select(User).where(User.firebase_uid == uid)).scalar_one_or_none()

    if not user:
        raise HTTPException(status_code=404,detail="Inavlid token")
    print(f"user---{user.name}")
    # return{
    #         "id":user.id,
    #         "name":user.name,
    #         "email":user.email
    # }
    return user
@router.post("/validateUser", response_model=ExistEmail)
def validateEmail(req:EmailRequest,session:Session = Depends(get_session)):
    existingUser = session.execute(select(User).where(User.email == req.email)).scalar_one_or_none()
    print(f"exist:{existingUser}")
    if existingUser is None:
        return ExistEmail(
            detail= "user not available",
            value=False
        )
        # return ExistEmail()
    return ExistEmail(
        detail="user available",
        value=True
    )

@router.post("/validateUserPhone", response_model=ExistEmail)
def validateEmail(req:Phonerequest,session:Session = Depends(get_session)):
    print(f'came{req}')
    existingUser = session.execute(select(User).where(User.phone_no == req.phone_no)).scalar_one_or_none()
    print(f"exist:{existingUser}")
    if existingUser is None:
        return ExistEmail(
            detail= "user not available",
            value=False
        )
        # return ExistEmail()
    return ExistEmail(
        detail="user available",
        value=True
    )

@router.post("/send-otp")
async def forgot_password(req:PasswordEmailRequest, session:Session = Depends(get_session)):
    print("came")
    print(f"details{req}")
    user = session.execute(select(User).where(User.email == req.email)).scalar_one_or_none()
    print(f"user email:{user}")
    if user is None:
        raise HTTPException(status_code=404,detail="User not found")
    otp = int(random.randint(100000, 999999))
    expiry = datetime.datetime.utcnow() + datetime.timedelta(minutes=10)
    reset = PasswordReset(
        user_id=user.id,
        otp=otp,
        expires_at=expiry
    )
    session.add(reset)
    session.commit()

    await send_email(
        to=req.email,
        subject="Password Reset Otp",
        body = f"Your Otp is {otp}. It will expire in 10 minutes"
    )
    print("success")
    return {"detail":"Otp sent successfully"}

@router.post("/verify-otp")
def verify_otp(req:VerifyOtpRequest, session: Session = Depends(get_session)):
    print("came in verify")
    print(f"request{req}")
    user = session.execute(select(User).where(User.email == req.email)).scalar_one_or_none()
    if not user:
       raise HTTPException(status_code=404,detail="User not found")
    print(f"check1:{user.id}")
    print(f"check2:{req.otp}")
    record = session.execute(select(PasswordReset).where(
        (user.id == PasswordReset.user_id) &
        (req.otp == PasswordReset.otp)  
        )).scalar_one_or_none()
    print(f"request--{record}")
    if record is None:
           raise HTTPException(status_code=404,detail="Invalid OTP")
    if record.expires_at < datetime.datetime.utcnow():
        raise HTTPException(status_code=400,detail="OTP expired")
    return {"detail":"OTP verified successfully"}
    
    
@router.post("/reset-password")
def reset_password(req:ResetPassword, session:Session = Depends(get_session)):
    print(f"request --- {req}")
    user = None
    if req.email:
        user = session.execute(select(User).where(User.email == req.email)).scalar_one_or_none()
    elif req.phone:
        user = session.execute(select(User).where(User.phone_no == req.phone)).scalar_one_or_none()

    print(f"userrr --- {user}")
    if not user:
        raise HTTPException(status_code= 404, detail="User not found")
    
    if req.confirmPassword != req.newPassword:
        raise HTTPException(status_code=400, detail="Confirm password should match with the newPassword")
    
    try:
        auth.update_user(
            uid = user.firebase_uid,
            password = req.confirmPassword
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"firebase error{e}")
    print("sucessssss")
    return {"detail":"Password updated successfully"}

