#!/usr/bin/env bash

linux_acpi() {
    arg=$1
    BAT=$(ls -d /sys/class/power_supply/BAT* | head -1)
    if [ ! -x "$(which acpi 2> /dev/null)" ];then
        case "$arg" in
            status)
                cat $BAT/status
            ;;

            percent)
                cat $BAT/capacity
            ;;

            *)
            ;;
        esac
    else
        case "$arg" in
            status)
                acpi | cut -d: -f2- | cut -d, -f1 | tr -d ' '
            ;;
            percent)
                acpi | cut -d: -f2- | cut -d, -f2 | tr -d '% '
            ;;
            *)
            ;;
        esac
    fi
}

battery_percent()
{
	case $(uname -s) in
		Linux)
			percent=$(linux_acpi percent)
			[ -n "$percent" ] && echo " $percent"
		;;

		Darwin)
			echo $(pmset -g batt | grep -Eo '[0-9]?[0-9]?[0-9]%')
		;;

		*)
		;;
	esac
}

battery_status()
{
	case $(uname -s) in
		Linux)
            status=$(linux_acpi status)
		;;

		Darwin)
			status=$(pmset -g batt | sed -n 2p | cut -d ';' -f 2)
		;;

		*)
		;;
	esac

	if [ $status = 'discharging' ] || [ $status = 'Discharging' ]; then
		echo ''
	else
	 	echo 'AC'
	fi
}

main()
{
	bat_stat=$(battery_status)
	bat_perc=$(battery_percent)

	if [ -z "$bat_stat" ]; then 
		echo "$bat_perc"
	elif [ -z "$bat_perc" ]; then 
		echo "$bat_stat"
	else
		echo "$bat_stat $bat_perc"
	fi
}

main

