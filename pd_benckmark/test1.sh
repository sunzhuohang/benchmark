runtime=${1:-10m}
xclock&
#Sleep for the specified time.
sleep $runtime
echo "All done"
