from fastapi import FastAPI
from .pdf_api import router as pdf_router

app = FastAPI()

app.include_router(pdf_router)

@app.get("/")
def read_root():
    return {"Hello": "World"}
