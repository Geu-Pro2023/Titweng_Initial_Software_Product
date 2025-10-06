# Titweng Cattle Verification System (MVP)

## Description
The **Titweng Cattle Verification System** is a machine learning-powered solution designed to verify and register cattle using nose prints. It combines computer vision, a Siamese Convolutional Neural Network (CNN), and a mobile/web interface to provide real-time cattle verification for farmers, buyers, and sellers.

**Key Features:**
- **Cattle Registration**: Register a cow using nose print images.
- **Cattle Verification**: Verify a cow against the registered database.
- **Notifications**: Automatic email and SMS notifications sent to the owner upon verification.
- **Mobile/Web Interface**: Flutter app or web interface to interact with the system.
- **API Access**: Backend FastAPI endpoints for registration and verification.

---

## GitHub Repository
1. [Project Repository:](https://github.com/Geu-Pro2023/Titweng_Initial_Software_Product)
2. [Figma Design:](https://github.com/Geu-Pro2023/Titweng_Initial_Software_Product)
---



## Environment Setup
1. **Clone the repository**
```bash
git clone YOUR_GITHUB_REPO_LINK
cd Titweng_FastAPI
Create and activate a virtual environment


python -m venv venv
source venv/bin/activate   # Linux/Mac
venv\Scripts\activate      # Windows
Install dependencies
```
pip install -r requirements.txt
Run the API server
```
uvicorn app.main:app --reload --host 127.0.0.1 --port 8002
Access the Swagger UI
Open http://127.0.0.1:8002/docs to interact with the endpoints.
```

## Project Structure
```
Titweng_FastAPI/
├── app/
│   ├── main.py             # FastAPI entry point
│   ├── routes/
│   │   ├── admin.py        # Cow registration endpoints
│   │   └── verify.py       # Cow verification endpoints
│   ├── utils/
│   │   ├── yolo_utils.py   # Nose detection functions
│   │   ├── siamese_utils.py# Embedding & matching functions
│   │   └── notifications.py# Email & SMS notifications
│   └── config.py           # Configuration constants
├── notebooks/
│   └── ML_Notebook.ipynb   # Model training and evaluation notebook
├── uploads/                # Temporary folder for uploaded images
├── requirements.txt        # Python dependencies
└── README.md
```

## Designs & Mockups


1. <img width="354" height="697" alt="Screenshot 2025-10-06 at 9 38 03 pm" src="https://github.com/user-attachments/assets/b858d75c-0913-4966-96ba-58f3cdaf152b" />

2. <img width="339" height="688" alt="Screenshot 2025-10-06 at 9 37 43 pm" src="https://github.com/user-attachments/assets/5cf5adfa-d7b0-4573-a4ab-76f0417a846c" />

3. <img width="343" height="690" alt="Screenshot 2025-10-06 at 9 36 58 pm" src="https://github.com/user-attachments/assets/5a2bf4ea-c3d6-4cac-9c9d-933e9538f5aa" />

4. <img width="344" height="705" alt="Screenshot 2025-10-06 at 9 37 15 pm" src="https://github.com/user-attachments/assets/146875ae-ddc9-476e-93aa-a456110e5ee1" />

5. <img width="343" height="695" alt="Screenshot 2025-10-06 at 9 36 17 pm" src="https://github.com/user-attachments/assets/f1f21afa-485b-41f1-bafe-a4e644cf8967" />



- ML Model Architecture: Siamese CNN using ResNet18 backbone with a fully connected embedding layer.
- Data Visualizations: Histograms and correlation plots from the notebook (ML_Notebook.ipynb).

**Deployment Plan**
- Backend (API): FastAPI hosted locally or on a cloud server.

- Mobile App: Flutter app connecting to FastAPI endpoints.

- Notifications: Integrated using email (SMTP) and SMS (Twilio or similar).

- Future Deployment: Docker container for backend + cloud-hosted database for scalability.

## ML Model

- Model Type: Siamese CNN for image similarity.
- Input: Cropped cow nose print images (224x224 RGB).
- Embedding Size: 256-dimensional vector.
- Performance Metrics:
- Accuracy, Precision, Recall, F1-score (see notebook for details).
- Notebook Link: notebooks/ML_Notebook.ipynb

## **Video Demo**
Demo: https://youtu.be/aZAGvWUMY90 

## How to Test the MVP
```
Run FastAPI server locally.
Use Swagger UI to register a cow with 3–5 nose images.
Use Swagger UI to verify a cow by uploading a new nose image.
Check email and SMS notifications.
Observe the similarity score returned by the API.
```

