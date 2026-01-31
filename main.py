from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse

app = FastAPI()

# Serve static UI files
app.mount("/static", StaticFiles(directory="static"), name="static")

# Serve dashboard on root
@app.get("/")
def serve_dashboard():
    return FileResponse("static/index.html")