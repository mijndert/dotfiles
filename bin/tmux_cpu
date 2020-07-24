#!/usr/bin/env zsh

get_percent()
{
	case $(uname -s) in
		Linux)
			percent=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
			echo $percent
		;;
		
		Darwin)
			percent=$(ps -A -o %cpu | awk '{s+=$1} END {print s "%"}')
			echo $percent
		;;
	esac
}

main()
{
	cpu_percent=$(get_percent)
	echo "CPU $cpu_percent"
	sleep 10
}

main