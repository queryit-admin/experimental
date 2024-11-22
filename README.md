# Test API

A simple FastAPI application with a test endpoint.

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Run the server:
```bash
uvicorn main:app --reload
```

## API Documentation

Once the server is running, you can access:
- API documentation at: http://localhost:8000/docs
- Alternative documentation at: http://localhost:8000/redoc

## Endpoints

- `GET /`: Root endpoint with API information
- `GET /test/`: Test endpoint that returns a greeting message with timestamp

## Project Structure

```
.
├── main.py              # Main FastAPI application
├── requirements.txt     # Project dependencies
├── routes/             # API routes
│   └── test/          # Test route module
│       ├── models.py  # Test route models
│       └── route.py   # Test route endpoints
└── README.md          # This file
```
