from fastapi import APIRouter, UploadFile, File
from app.utils.yolo_utils import detect_and_crop_nose
from app.utils.siamese_utils import get_embedding, find_best_match
from app.utils.notifications import send_email, send_sms
from app.config import UPLOAD_FOLDER
import os
import shutil

router = APIRouter()

@router.post("/")
async def verify_cow(nose_image: UploadFile = File(...)):
    """
    Buyer/Seller uploads nose image for verification
    """
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)

    # Save uploaded file temporarily
    temp_path = os.path.join(UPLOAD_FOLDER, nose_image.filename)
    with open(temp_path, "wb") as f:
        shutil.copyfileobj(nose_image.file, f)

    # Detect and crop nose
    cropped_path = detect_and_crop_nose(temp_path)
    os.remove(temp_path)  # Remove original upload

    if not cropped_path:
        return {"status": "failed", "message": "No nose detected"}

    embedding = get_embedding(cropped_path)
    best_cow_id, sim_score = find_best_match(embedding)

    if best_cow_id:
        # Retrieve owner info from your database or cow list
        owner_info = {"name": "Owner Name", "email": "owner@example.com", "phone": "+123456789"}

        # Send notification to owner
        send_email(owner_info["email"], "Cattle Verification Alert", f"Your cow {best_cow_id} was scanned!")
        send_sms(owner_info["phone"], f"Your cow {best_cow_id} was scanned!")

        return {
            "status": "success",
            "cow_id": best_cow_id,
            "owner": owner_info,
            "similarity": float(sim_score)
        }
    else:
        return {"status": "failed", "message": "No match found"}
