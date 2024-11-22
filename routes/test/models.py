from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class TestResponse(BaseModel):
    """Model for test response data"""
    message: str = Field(..., description="Test response message")
    timestamp: datetime = Field(default_factory=datetime.now, description="Timestamp of the response")
    version: str = Field(default="1.0", description="API version")
    
    class Config:
        json_schema_extra = {
            "example": {
                "message": "Hello from the test endpoint!",
                "timestamp": "2024-01-22T15:53:00",
                "version": "1.0"
            }
        }
