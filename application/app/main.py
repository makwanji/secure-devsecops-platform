import os
from fastapi import FastAPI

APP_NAME = "devsecops-demo"
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")

app = FastAPI(
    title="DevSecOps Demo Application",
    description="Application for Secure DevSecOps Platform",
    version=APP_VERSION
)


@app.get("/")
def root():
    return {
        "application": APP_NAME,
        "version": APP_VERSION,
        "message": "Secure DevSecOps Platform is running"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


@app.get("/ready")
def readiness():
    return {
        "status": "ready"
    }


@app.get("/version")
def version():
    return {
        "application": APP_NAME,
        "version": APP_VERSION
    }


@app.get("/api/orders")
def orders():
    return {
        "orders": [
            {"id": 1001, "status": "completed"},
            {"id": 1002, "status": "processing"}
        ]
    }
