import requests
# from fastapi import APIRouter, HTTPException, Depends, Body
# from sqlalchemy.orm import Session
# from sqlalchemy import select

# router = APIRouter()

# FIREBASE_API_KEY = "YOUR_FIREBASE_API_KEY"

# @router.post("/login")
# def login(user: dict = Body(...), session: Session = Depends(get_session)):
#     """
#     Expects: {"email": "abc@gmail.com", "password": "secret123"}
#     """
#     email = user["email"]
#     password = user["password"]

#     # Step 1: Ask Firebase to authenticate
#     payload = {
#         "email": email,
#         "password": password,
#         "returnSecureToken": True
#     }

#     url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={FIREBASE_API_KEY}"
#     response = requests.post(url, json=payload)

#     if response.status_code != 200:
#         raise HTTPException(status_code=401, detail="Invalid email or password")

#     data = response.json()
#     id_token = data["idToken"]
#     uid = data["localId"]

#     # Step 2: Find user in local DB
#     db_user = session.execute(
#         select(User).where(User.firebase_uid == uid)
#     ).scalar_one_or_none()

#     if not db_user:
#         raise HTTPException(status_code=404, detail="User not found in local DB")

#     # Step 3: Return response
#     return {
#         "message": "Login successful",
#         "id_token": id_token,   # Firebase token, can be used for protected routes
#         "user": {
#             "id": db_user.id,
#             "name": db_user.name,
#             "email": db_user.email,
#             "firebase_uid": db_user.firebase_uid
#         }
#     }
















































@router.post("/forgot-password")
async def forgot_password(email: str, session: Session = Depends(get_session)):
    user = session.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Generate OTP
    otp = str(random.randint(100000, 999999))
    expiry = datetime.datetime.utcnow() + datetime.timedelta(minutes=10)

    # Save OTP in DB
    reset = PasswordResetOTP(user_id=user.id, otp=otp, expires_at=expiry)
    session.add(reset)
    session.commit()

    # Send OTP email
    await send_email(
        to=email,
        subject="Password Reset OTP",
        body=f"Your OTP is {otp}. It will expire in 10 minutes."
    )

    return {"message": "OTP sent to your email"}
























