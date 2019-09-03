#!/bin/bash
publishdir='/volume1/web/www/nowplaying/test.html'
do_repeat () {
querykodi=$(curl -s --header 'Content-Type: application/json' --data-binary '{ "id": 1, "jsonrpc": "2.0", "method": "Player.GetItem", "params": { "properties": [ "title", "showtitle" ], "playerid": 1 }, "id": "VideoGetItem" }' 'http://192.168.1.123:8080/jsonrpc' | cut -d: -f6-9 | cut -d'"' -f8,12 | tr '"' ' ' | tr -d '\n'  | sed 's/[\._-]//g')
if [[ ${querykodi%%[[:space:]]##[[:space:]]} == 'type' ]];
then
	querykodi=$(echo "Nothings Playing")
	$(echo '<h1 id="nowplaying" style="font-size:3vw; font-family:lain;">'$querykodi'</h1>' > $publishdir)
else
	$(echo '<h1 id="nowplaying" style="font-size:3vw; font-family:lain;">'${querykodi%%[[:space:]]##[[:space:]]}'</h1>' > $publishdir)
fi
}
while true
do
do_repeat
sleep 2
done
