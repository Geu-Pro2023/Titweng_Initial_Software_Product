from ultralytics import YOLO
import cv2
import os
from app.config import YOLO_MODEL_PATH, UPLOAD_FOLDER

# Load YOLOv8 model
yolo_model = YOLO(YOLO_MODEL_PATH)

def detect_and_crop_nose(image_path: str) -> str:
    """
    Detect cow nose in image, crop, and save to uploads folder.
    Returns path to cropped image.
    """
    results = yolo_model(image_path)
    boxes = results[0].boxes
    if len(boxes) == 0:
        return None
    
    # Get first detection
    box = boxes[0].xyxy[0]  # x1, y1, x2, y2
    x1, y1, x2, y2 = map(int, box.tolist())
    
    img = cv2.imread(image_path)
    crop = img[y1:y2, x1:x2]
    
    cropped_path = os.path.join(UPLOAD_FOLDER, f"cropped_{os.path.basename(image_path)}")
    cv2.imwrite(cropped_path, crop)
    return cropped_path
