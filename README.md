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

## Usage Examples
### **1. Register Cattle**
```
import requests

url = "http://localhost:8000/api/register-cattle"
files = {
    'images': [('nose1.jpg', open('nose1.jpg', 'rb'), 'image/jpeg'),
               ('nose2.jpg', open('nose2.jpg', 'rb'), 'image/jpeg')]
}
data = {
    'owner_name': 'John Doe',
    'owner_email': 'john@example.com',
    'owner_phone': '+1234567890',
    'cattle_breed': 'Angus',
    'age': '2 years'
}

response = requests.post(url, files=files, data=data)
print(response.json())
```
### **2. Verify Cattle**

```
import requests

url = "http://localhost:8000/api/verify-cattle"
files = {'image': open('query_nose.jpg', 'rb')}

response = requests.post(url, files=files)
print(response.json())
```

## Machine Learning Model
### **Siamese CNN Architecture**
The system uses a Siamese Neural Network with the following structure:

- Feature Extraction: CNN backbone (MobileNetV2)
- Distance Metric: Contrastive loss with Euclidean distance
- Input Size: 224x224 RGB images
- Output: Similarity score (0-1 range)

### **Training Process**
1. Data augmentation on nose print images
2. Contrastive loss minimization
3. Threshold tuning for verification accuracy

### **Mobile Application**
The Flutter mobile app provides:
- Camera interface for capturing nose prints
- Registration and verification workflows
- History of previous verifications
- Push notifications for verification results


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

## **Deployment**
### **1. Local Development**

```
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### **2. Production Deployment**

```
# Using Docker
docker build -t titweng-cattle .
docker run -p 8000:8000 titweng-cattle

# Using Gunicorn (Linux/Mac)
gunicorn -w 4 -k uvicorn.workers.UvicornWorker app.main:app

```

## Testing
**Run the test suite:**

```
pytest tests/ -v
```

## **Contributing**

1. Fork the repository
2. Create a feature branch (git checkout -b feature/AmazingFeature)
3. Commit your changes (git commit -m 'Add some AmazingFeature')
4. Push to the branch (git push origin feature/AmazingFeature)
5. Open a Pull Request

## **License**
This project is licensed under the MIT License - see the LICENSE file for details.

## **Contributor**
1.Geu Aguto Garang Bior - g.bior@alustudent.com
