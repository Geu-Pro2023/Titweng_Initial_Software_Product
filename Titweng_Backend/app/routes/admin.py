from fastapi import APIRouter, UploadFile, File, Form
from app.utils.yolo_utils import detect_and_crop_nose
from app.utils.siamese_utils import get_embedding, cow_embeddings, cow_ids
from app.utils.helpers import generate_uuid
from app.utils.notifications import send_email, send_sms
from app.config import UPLOAD_FOLDER
import os
import shutil

router = APIRouter()

@router.post("/register")
async def register_cow(
    owner_name: str = Form(...),
    owner_email: str = Form(...),
    owner_phone: str = Form(...),
    cow_id: str = Form(...),
    nose_images: list[UploadFile] = File(...)
):
    """
    Admin registers new cow by uploading nose images
    """
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    cow_uuid = generate_uuid()
    embeddings_list = []

    for nose_img in nose_images:
        # Save uploaded file temporarily
        temp_path = os.path.join(UPLOAD_FOLDER, nose_img.filename)
        with open(temp_path, "wb") as f:
            shutil.copyfileobj(nose_img.file, f)

        # Detect and crop nose
        cropped_path = detect_and_crop_nose(temp_path)
        if cropped_path:
            emb = get_embedding(cropped_path)
            embeddings_list.append(emb)

        # Remove temp file
        os.remove(temp_path)

    # Save embeddings somewhere persistent if needed
    print(f"Embeddings generated for cow {cow_id} ({len(embeddings_list)} images)")

    # Send confirmation to owner
    send_email(owner_email, "Cow Registration Successful",
               f"Hello {owner_name}, your cow {cow_id} has been registered successfully.")
    send_sms(owner_phone, f"Your cow {cow_id} has been registered successfully.")

    return {"status": "success", "cow_id": cow_id, "owner": owner_name, "embeddings_count": len(embeddings_list)}
    
