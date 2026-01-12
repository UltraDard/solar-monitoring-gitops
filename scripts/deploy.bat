@echo off
echo Deploying Solar Monitoring Stack...

echo Applying Simulator...
kubectl apply -f ../k8s/apps/

echo Applying Monitoring...
kubectl apply -f ../k8s/monitoring/

echo Done!
pause
