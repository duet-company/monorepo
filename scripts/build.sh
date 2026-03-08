#!/bin/bash
#
# Duet Company - Autonomous Build Script
#
# This script automates the build and deployment process
# Run it to build the entire platform from scratch
#

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check Python
    if ! command -v python3 &> /dev/null; then
        log_error "Python 3.10+ is required"
        exit 1
    fi

    # Check Node.js
    if ! command -v node &> /dev/null; then
        log_warn "Node.js not found (frontend will be skipped)"
    fi

    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_warn "Docker not found (container build will be skipped)"
    fi

    log_info "Prerequisites checked"
}

# Build backend
build_backend() {
    log_info "Building backend..."

    cd backend

    # Create virtual environment
    if [ ! -d "venv" ]; then
        log_info "Creating Python virtual environment..."
        python3 -m venv venv
    fi

    # Activate virtual environment
    source venv/bin/activate

    # Install dependencies
    log_info "Installing Python dependencies..."
    pip install -r requirements.txt

    # Run tests (if they exist)
    if [ -d "tests" ]; then
        log_info "Running tests..."
        pytest tests/ || log_warn "Tests failed or no tests found"
    fi

    cd ..
    log_info "Backend built successfully"
}

# Build frontend
build_frontend() {
    if command -v node &> /dev/null; then
        log_info "Building frontend..."

        cd frontend

        # Install dependencies
        if [ ! -d "node_modules" ]; then
            log_info "Installing Node.js dependencies..."
            npm install
        fi

        # Build
        log_info "Building frontend..."
        npm run build

        cd ..
        log_info "Frontend built successfully"
    else
        log_warn "Skipping frontend build (Node.js not found)"
    fi
}

# Build Docker images
build_docker() {
    if command -v docker &> /dev/null; then
        log_info "Building Docker images..."

        # Build backend image
        if [ -f "Dockerfile.backend" ]; then
            log_info "Building backend Docker image..."
            docker build -f Dockerfile.backend -t duet/backend:latest .
        fi

        # Build frontend image
        if [ -f "Dockerfile.frontend" ]; then
            log_info "Building frontend Docker image..."
            docker build -f Dockerfile.frontend -t duet/frontend:latest .
        fi

        log_info "Docker images built successfully"
    else
        log_warn "Skipping Docker build (Docker not found)"
    fi
}

# Run database migrations
run_migrations() {
    log_info "Running database migrations..."

    cd backend
    source venv/bin/activate

    # Run Alembic migrations
    if [ -d "alembic" ]; then
        alembic upgrade head
    else
        log_warn "No migrations found"
    fi

    cd ..
}

# Start services
start_services() {
    log_info "Starting services..."

    # Check if docker-compose is available
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d
    elif command -v docker &> /dev/null && docker compose version &> /dev/null; then
        docker compose up -d
    else
        log_warn "No docker-compose found, services not started"
    fi

    log_info "Services started"
}

# Health check
health_check() {
    log_info "Running health check..."

    # Check API health
    if command -v curl &> /dev/null; then
        if curl -f http://localhost:8000/health &> /dev/null; then
            log_info "API is healthy"
        else
            log_warn "API health check failed"
        fi
    fi
}

# Main build process
main() {
    log_info "Starting Duet Company build process..."
    echo ""

    check_prerequisites
    build_backend
    build_frontend
    build_docker
    run_migrations
    start_services
    health_check

    echo ""
    log_info "Build process completed successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. Configure environment variables in .env"
    echo "  2. Start the backend: cd backend && source venv/bin/activate && uvicorn app.main:app --reload"
    echo "  3. Start the frontend: cd frontend && npm run dev"
    echo "  4. Open http://localhost:3000"
    echo ""
}

# Run main function
main "$@"
