from fastapi import FastAPI

app = FastAPI(title="Test...")

@app.get("/")
def get_status():
    return {"status": "ok"}

