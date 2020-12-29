MOUSE_ID=$1

STATE1=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
while true; do
	sleep 0.2
	STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
	comm -13 <(echo "$STATE1") <(echo "$STATE2")
	STATE1=$STATE2
done

