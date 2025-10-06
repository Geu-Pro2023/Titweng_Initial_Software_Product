import torch
import torch.nn as nn
import numpy as np
from torchvision import models, transforms
from PIL import Image

# ---------------------------
# 1. Define your Siamese model
# ---------------------------
class SiameseNetwork(nn.Module):
    def __init__(self):
        super(SiameseNetwork, self).__init__()
        # Use a ResNet18 backbone (adjust if original model used resnet50)
        resnet = models.resnet18(weights=None)
        self.backbone = nn.Sequential(*list(resnet.children())[:-1])  # remove final FC layer
        # Fully connected layers after backbone
        self.fc = nn.Sequential(
            nn.Linear(resnet.fc.in_features, 256),
            nn.ReLU(),
            nn.Linear(256, 256)
        )

    def forward(self, x):
        x = self.backbone(x)
        x = x.view(x.size(0), -1)
        x = self.fc(x)
        return x

# ---------------------------
# 2. Load model function
# ---------------------------
def load_siamese_model():
    model = SiameseNetwork()
    # Load your trained weights
    state_dict = torch.load("siamese_output/siamese_model_final.pth", map_location="cpu")

    # Load weights safely, ignoring mismatched keys
    model_dict = model.state_dict()
    pretrained_dict = {k: v for k, v in state_dict.items() if k in model_dict}
    model_dict.update(pretrained_dict)
    model.load_state_dict(model_dict)

    model.eval()
    return model

# ---------------------------
# 3. Load embeddings
# ---------------------------
cow_embeddings_data = np.load("siamese_output/cow_embeddings.npz", allow_pickle=True)
cow_embeddings = np.array([cow_embeddings_data[k] for k in cow_embeddings_data.files])
cow_ids = np.array(cow_embeddings_data.files)

# ---------------------------
# 4. Export model instance
# ---------------------------
siamese_model = load_siamese_model()

# ---------------------------
# 5. Function to get embedding from image path
# ---------------------------
def get_embedding(image_path):
    """
    Returns a tensor embedding for a given image path
    """
    # Load image
    img = Image.open(image_path).convert("RGB")

    # Preprocess: resize, to tensor, normalize
    preprocess = transforms.Compose([
        transforms.Resize((224, 224)),  # adjust to your model input
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                             std=[0.229, 0.224, 0.225])
    ])
    image_tensor = preprocess(img).unsqueeze(0)  # [1, 3, H, W]

    # Move to GPU if available
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    image_tensor = image_tensor.to(device)
    siamese_model.to(device)

    # Pass through model
    with torch.no_grad():
        embedding = siamese_model(image_tensor)

    return embedding.cpu()

# ---------------------------
# 6. Find best match
# ---------------------------
def find_best_match(query_embedding, embeddings=cow_embeddings, ids=cow_ids):
    """
    Find the closest embedding using Euclidean distance.
    """
    query_np = query_embedding.numpy().flatten()
    distances = np.linalg.norm(embeddings - query_np, axis=1)
    best_idx = np.argmin(distances)
    return ids[best_idx], distances[best_idx]
