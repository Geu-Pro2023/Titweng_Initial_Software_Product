from pydantic import BaseModel
from typing import List, Optional

# Admin registration request
class CowRegistration(BaseModel):
    owner_name: str
    owner_email: str
    owner_phone: str
    state: str
    location: str
    witness: str
    cow_color: str
    cow_breed: str
    cow_age: int
    cow_id: str
    nose_images: List[str]         # Filenames after upload
    facial_image: Optional[str]    # Filename after upload

# Buyer/Seller verification
class CowVerificationRequest(BaseModel):
    nose_image: str   # Uploaded filename

# Owner response to verification
class OwnerResponseRequest(BaseModel):
    event_id: str
    response: str  # "yes" or "no"
