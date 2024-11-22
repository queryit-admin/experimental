from fastapi import APIRouter, HTTPException, status
from .models import TestResponse

router = APIRouter(
    prefix="/test",
    tags=["test"],
    responses={
        status.HTTP_500_INTERNAL_SERVER_ERROR: {
            "description": "Internal server error",
            "content": {
                "application/json": {
                    "example": {"detail": "Internal server error occurred"}
                }
            }
        }
    }
)

@router.get(
    "/",
    response_model=TestResponse,
    status_code=status.HTTP_200_OK,
    summary="Test endpoint",
    description="A simple test endpoint that returns a greeting message with timestamp"
)
async def test_endpoint() -> TestResponse:
    """
    Get a test response.
    
    Returns:
        TestResponse: A response containing a greeting message and timestamp
        
    Raises:
        HTTPException: If there's an internal server error
    """
    try:
        return TestResponse(message="Hello from the test endpoint!")
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
