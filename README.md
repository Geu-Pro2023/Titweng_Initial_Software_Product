# Titweng Cattle Verification System (MVP)

## Description
The **Titweng Cattle Verification System** is a machine learning-powered solution designed to verify and register cattle using nose prints. It combines computer vision, a Siamese Convolutional Neural Network (CNN), and a mobile/web interface to provide real-time cattle verification for farmers, buyers, and sellers.

**Key Features:**
- **Cattle Registration**: Register a cow using nose print images.
- **Cattle Verification**: Verify a cow against the registered database.
- **Notifications**: Automatic email and SMS notifications sent to the owner upon verification.
- **Mobile/Web Interface**: Flutter app or web interface to interact with the system.
- **API Access**: Backend FastAPI endpoints for registration and verification.

## GitHub Repository
1. **Click:** [Project Repository:](https://github.com/Geu-Pro2023/Titweng_Initial_Software_Product)
2. **Click** [Figma Design:](https://www.figma.com/design/BDT9TX3z4jfmnWl0VU6ysn/Titweng-Mobile-UI?node-id=0-1&t=lyeLWb7C8fbTX7zO-1)

## **Video Demo**
**Demo:** https://youtu.be/aZAGvWUMY90 

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

<img width="836" height="430" alt="Screenshot 2025-10-07 at 1 06 05 am" src="https://github.com/user-attachments/assets/4406ab26-8312-4c0e-b886-cb9e36ebc7a2" />

- **ML Model Architecture:** Siamese CNN using ResNet18 backbone with a fully connected embedding layer.
- **Data Visualizations:** Histograms and correlation plots from the notebook (ML_Notebook.ipynb).

**Deployment Plan**
- **Backend (API):** FastAPI hosted locally or on a cloud server.
- **Mobile App:** Flutter app connecting to FastAPI endpoints.
- **Notifications:** Integrated using email (SMTP) and SMS (Twilio or similar).
- **Future Deployment:** Docker container for backend + cloud-hosted database for scalability.

## ML Model

- **Model Type:** Siamese CNN for image similarity.
- **Input:** Cropped cow nose print images (224x224 RGB).
- **Embedding Size:** 256-dimensional vector.
### **Performance Metrics:**
- Accuracy, Precision, Recall, F1-score (see notebook for details).
- Notebook Link: notebooks/ML_Notebook.ipynb

## How to Test the MVP

1. Run FastAPI server locally.
2. Use Swagger UI to register a cow with 3–5 nose images.
3. Use Swagger UI to verify a cow by uploading a new nose image.
4. Check email and SMS notifications.
5. Observe the similarity score returned by the API.

## YOLOv8 Cow Nose Print Detection
<img width="624" height="590" alt="Screenshot 2025-10-07 at 1 18 09 am" src="https://github.com/user-attachments/assets/c51b86e4-793c-42e5-af19-cd850870ad9d" />

## Siamese CNN Learning Curves

<img width="944" height="377" alt="Screenshot 2025-10-07 at 1 29 50 am" src="https://github.com/user-attachments/assets/b4e34c26-31c2-4125-a173-6f5b68862be9" />


