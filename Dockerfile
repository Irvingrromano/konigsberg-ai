# Build frontend
FROM node:18 AS build-frontend
WORKDIR /app/frontend
COPY frontend/ ./
RUN npm install && npm run build

# Build backend
FROM python:3.10-slim
WORKDIR /app
COPY backend/ ./backend
RUN pip install --no-cache-dir -r backend/requirements.txt

# Copy frontend build into backend's static folder
COPY --from=build-frontend /app/frontend/build ./backend/static

# Run app
WORKDIR /app/backend
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
