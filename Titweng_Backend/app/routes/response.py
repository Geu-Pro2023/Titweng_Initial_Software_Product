from fastapi import APIRouter
from app.models import OwnerResponseRequest

router = APIRouter()

@router.post("/")
async def owner_response(data: OwnerResponseRequest):
    """
    Owner clicks YES or NO
    """
    if data.response.lower() == "yes":
        # Mark as verified (placeholder)
        return {"status": "verified", "event_id": data.event_id}
    elif data.response.lower() == "no":
        # Trigger authority alert (placeholder)
        return {"status": "alert_sent", "event_id": data.event_id}
    else:
        return {"status": "error", "message": "Invalid response"}
