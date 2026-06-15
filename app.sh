#!/bin/bash


# requirements:
  # Total CPU usage
  # Total memory usage (Free vs Used including percentage)
  # Total disk usage (Free vs Used including percentage)
  # Top 5 processes by CPU usage
  # Top 5 processes by memory usage

 
# CPU usage
returned_idle_cpu=$(
  top -bn1 |\
  grep "Cpu(s):" |\
  awk '{gsub(/ni,/, ""); print $7}'
)
cpu_usage=$(echo "100.0-$returned_idle_cpu" | bc)
cpu_usage=$(printf "%.1f" $cpu_usage)


# memory usage
total_memory=$(
  free |\
  grep "Mem:" |\
  awk '{print $2}'
)
used_memory=$(
  free |\
  grep "Mem:" |\
  awk '{print $3}'
)
memory_usage=$(echo $used_memory/$total_memory*100 | bc)
memory_usage=$(printf "%.1f" $memory_usage)


# disk usage
disk_usage=$(
  df --total |\
  tail -1 |\
  awk '{print $5}'
)


# top 5 processes by cpu usage
# "-" displays results in descending order
# "%cpu" is just column's name, just like "%mem"
# "%" is literally jsut a prefix of columns' names
cpu_consuming_processes=$(
  ps -aux --sort=-%cpu |\
  tail -n +2 |\
  head -5 |\
  awk '{print $11}'
)


# top 5 processes by memory usage
# "tail -n +2" - that removes the first two lines at the top as they r "Command/Memory/CPU,etc and sth else (no clue what other line is there but sth is there)"
memory_consuming_processes=$(
  ps -aux --sort=-%mem |\
  tail -n +2 |\
  head -5 |\
  awk '{print $11}'
)


# displaying variables
echo "CPU usage rn:" $cpu_usage% >> ./cpu_usage.txt
echo "Memory usage rn:" $memory_usage% >> ./cpu_usage.txt
echo "Disk space usage rn:" $disk_usage >> ./cpu_usage.txt
echo "The most CPU-consuming processes:" >> ./cpu_usage.txt
for i in $cpu_consuming_processes:
do
  echo "   "$i\n >> ./cpu_usage.txt
done
echo "The most memory-consuming processes:" >> ./cpu_usage.txt
for i in $memory_consuming_processes:
do
  echo "   "$i\n >> ./cpu_usage.txt
done
