# Define container name
CONTAINER_NAME="mmt-automated-deployment-and-rollback-pipeline"

# Check if the container exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping and removing existing container: $CONTAINER_NAME"
    
    # Stop the container if it's running
    docker stop $CONTAINER_NAME || true
    
    # Remove the container
    docker rm $CONTAINER_NAME || true
fi

# Build the Docker imag
docker build -t $CONTAINER_NAME .

# Run the new container
docker run -d --name $CONTAINER_NAME -p 8000:8000 $CONTAINER_NAME
