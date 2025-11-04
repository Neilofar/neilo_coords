-- Register commands using ox_lib
lib.addCommand('toggleball', {
    help = locale('commands.toggleball.help'),
    restricted = false
}, function(source, args, raw)
    TriggerClientEvent('neilo_coords:toggleBall', source)
end)

lib.addCommand('copycoords', {
    help = locale('commands.copycoords.help'),
    restricted = false
}, function(source, args, raw)
    TriggerClientEvent('neilo_coords:copyCoords', source)
end)

