from fastapi import FastAPI
import os

app = FastAPI()


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/")
def root():
    return {"message": "hello from llm-platform", "version": os.getenv("VERSION", "dev")}
