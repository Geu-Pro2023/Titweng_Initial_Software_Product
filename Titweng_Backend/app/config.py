import os

# Paths
YOLO_MODEL_PATH = os.path.join("yolov8_model", "best.pt")
SIAMESE_MODEL_PATH = os.path.join("siamese_output", "siamese_model_final.pth")
EMBEDDINGS_PATH = os.path.join("siamese_output", "cow_embeddings.npz")
COW_LIST_PATH = os.path.join("siamese_output", "cow_list.json")
UPLOAD_FOLDER = os.path.join("uploads")

# Matching threshold for Siamese CNN
MATCH_THRESHOLD = 0.5

# Notifications placeholders
EMAIL_SENDER = "your_email@example.com"
SMS_SENDER = "your_sms_number"


