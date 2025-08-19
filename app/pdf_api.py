from fastapi import APIRouter, HTTPException, Response
from pydantic import BaseModel
import pdfkit
import tempfile

router = APIRouter()

class HTMLRequest(BaseModel):
    html: str

@router.post("/html-to-pdf")
def html_to_pdf(request: HTMLRequest):
    try:
        with tempfile.NamedTemporaryFile(suffix=".pdf", delete=False) as tmp_pdf:
            pdfkit.from_string(request.html, tmp_pdf.name)
            tmp_pdf.seek(0)
            pdf_bytes = tmp_pdf.read()
        return Response(content=pdf_bytes, media_type="application/pdf")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
