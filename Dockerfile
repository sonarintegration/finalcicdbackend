#stage 1: Build
FROM golang:1.22 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go app with static linking
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Stage 2: Run
FROM scratch

LABEL maintainer="Shubham Chavan <shubhamchav@cybage.com>"
# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the executable from the build stage
COPY --from=builder /app/main .

# Expose port 8082
EXPOSE 8082

# Command to run the executable
CMD ["./main"]
