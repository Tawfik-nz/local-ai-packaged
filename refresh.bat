
echo Stop all services
docker compose -p localai -f docker-compose.yml --profile gpu-nvidia down

echo Pull latest versions of all containers
docker compose -p localai -f docker-compose.yml --profile gpu-nvidia pull

echo Start services again with your desired profile
python start_services.py --profile gpu-nvidia