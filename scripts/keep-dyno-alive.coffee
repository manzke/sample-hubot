# no command - just pings itself
host = process.env.KEEP_ALIVE_HOST
interval = process.env.KEEP_ALIVE_INTERVAL

module.exports = (robot) ->
    unless process.env.KEEP_ALIVE_HOST
        console.log 'Variable KEEP_ALIVE_HOST was not set'
        process.exit -1

    unless process.env.KEEP_ALIVE_INTERVAL
        interval = 60 #seconds
    console.log "using interval: #{interval} to ping host: #{host}"

    keepAlive = () ->
        setInterval () ->
            robot.http(host)
                .get() (err, res, body)->
                    console.log 'ping '+host
                    return
        , interval * 1000 #every X seconds

    keepAlive()

    robot.router.get '/', (req, res) ->
        res.writeHead 200, 'Content-Type': 'text/html'
        res.end ''''''
