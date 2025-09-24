from fastapi import FastAPI, Depends, HTTPException, Body, Header,status
from .routers import user
from sqlmodel import SQLModel, Field, Session, select
from typing import Optional, List
from sqlalchemy import desc
from .database import init_database, get_session
from firebase_admin import auth
from app.schema import UserCreate, UserOut, EmailRequest, UserResponse
from firebase.firebase_config import cred
import requests
from .models import User
from datetime import datetime
# Create FastAPI app
app = FastAPI()

# class User(SQLModel, table=True):
#     id: Optional[int] = Field(default=None, primary_key=True)
#     name: str
#     email: str
#     firebase_uid:Optional[str] = Field(default=None,unique=True,index=True)
# class Task(SQLModel, table= True):
#     __tablename__ ='task'
#     id:int = Field(nullable= False , primary_key= True)
#     name:str = Field(nullable= False)
#     description:str = Field(nullable= False)



# --- Startup event to init DB ---





@app.on_event("startup")
def on_startup():
    init_database()


app.include_router(user.router)













# @app.post("/users", response_model=UserOut)
# def create_user(user: UserCreate, session: Session = Depends(get_session)):
#     print('came to add user')
#     print('input user',user)
#     # raise HTTPException(status_code= 400, detail='For testing')
#     existingEmail = session.execute(select(User).where(User.email == user.email)).scalar_one_or_none()
#     print('existingUser',existingEmail)
#     if existingEmail:
#         raise HTTPException(status_code = 400 , detail = 'Email already exists')
#     try:
#         firebase_user = auth.create_user(
#             email = user.email,
#             password = user.password
#         )
#         # user.firebase_uid = firebase_user.uid
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"firebase error:{str(e)}")
#     new_user = User(
#         name = user.name,
#         email = user.email,
#         firebase_uid = firebase_user.uid
#     )
#     session.add(new_user)
#     session.commit()
#     session.refresh(new_user)
#     print('user:',new_user)
#     return new_user
#     # raise HTTPException(status_code=400, detail="checking")
#     # return raiseHTT

# # @app.get("/users", response_model=List[User])
# # def get_users(session: Session = Depends(get_session)):
# #     print('came into this api')
# #     statement = select(User).order_by(desc(User.id))
# #     results = session.exec(statement).all()
# #     return results

# @app.delete("/users/{id}")
# def delete_user(id:int, session:Session = Depends(get_session)):
#     user = session.execute(select(User).where(User.id == id)).scalar_one_or_none()
#     if user:
#         session.delete(user)
#         session.commit()
#         # session.refresh(user)
#         return {'message':"user deleted successfully"}
#     else:
#         raise HTTPException(status_code=404,  detail='Id not found')
    

# @app.put("/users/{id}")
# def update_user(id:int ,user:User, session:Session = Depends(get_session)):
#     exisitingUser = session.execute(select(User).where(User.id  == id)).scalar_one_or_none()
#     if exisitingUser:
#         if user.name:
#             exisitingUser.name = user.name
#         if user.email:
#             exisitingUser.email = user.email
#         session.add(exisitingUser)
#         session.commit()
#         session.refresh(exisitingUser)
#         return exisitingUser
#     else:
#        raise HTTPException(status_code= 404, detail="User not found")
    

# @app.post("/login")
# def login_user(user: dict = Body(...), session:Session = Depends(get_session)):
#     email = user["email"]
#     password = user["password"]

#     payload = {
#         "email":email,
#         "password":password,
#         "returnSecureToken":True
#     }
    
#     url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAxRYp3FSnf2U6iw-3gcPJLWYO3aMCWEyA"
#     response = requests.post(url,json=payload)

#     if response.status_code != 200:
#         raise HTTPException(status_code=401, detail="Invalid email or password")
    
#     data = response.json()
#     id_token = data["idToken"]
#     uid = data["localId"]

#     db_user = session.execute(select(User).where(User.firebase_uid == uid)).scalar_one_or_none()

#     if not db_user:
#          raise HTTPException(status_code=401, detail="User not found")
    
#     return {
#         "message":"Login suceessful",
#         "id_token": id_token,
#         "user":{
#             "id":db_user.id,
#             "name":db_user.name
#         }
#     }

# @app.get("/getUser")
# def get_user(authorization:str = Header(...),session:Session = Depends(get_session)):

#     if not authorization.startswith("Bearer "):
#         raise HTTPException(status_code=401,detail="Inavlid authorization header")
#     id_token = authorization.split(" ")[1]
#     # print("id form the firebase:${id_token}")
#     print(f"id form the firebase;{id_token}")
#     try:
#         decoded = auth.verify_id_token(id_token)
#         uid  = decoded["uid"]
#     except Exception:
#         raise HTTPException(status_code=401,detail="Inavalid or Expired token")
#     user = session.execute(select(User).where(User.firebase_uid == uid)).scalar_one_or_none()

#     if not user:
#         raise HTTPException(status_code=404,detail="Inavlid token")
#     print(f"user---{user.name}")
#     return{
#             "id":user.id,
#             "name":user.name,
#             "email":user.email
#     }
# @app.post("/validateUser")
# def validateEmail(req:EmailRequest,session:Session = Depends(get_session)):
#     existingUser = session.execute(select(User).where(User.email == req.email)).scalar_one_or_none()
#     if existingUser is None:
#         # raise HTTPException(status_code=404,detail="user not found")
#         return {
#             "detail":"user not found",
#             "exist":False,
#         }
#     return {
#         "detail":"user Available",
#         "value":True
#         }
