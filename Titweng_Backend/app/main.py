from fastapi import FastAPI
from app.routes import admin, verify, response

app = FastAPI(title="Titweng Cattle Ownership Verification API")

app.include_router(admin.router, prefix="/admin", tags=["Admin"])
app.include_router(verify.router, prefix="/verify", tags=["Verification"])
app.include_router(response.router, prefix="/response", tags=["Owner Response"])
