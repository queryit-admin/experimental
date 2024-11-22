from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes.test.route import router as test_router

app = FastAPI(
    title="Test API",
    description="A test API with FastAPI",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(test_router)

@app.get("/")
async def root():
    """Root endpoint returning API information"""
    return {
        "message": "Welcome to the Test API",
        "version": "1.0.0",
        "docs_url": "/docs"
    }
