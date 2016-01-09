Bridge = require "./abstract-bridge"
module.exports = class UMS extends Bridge
    @DEFAULT_NAME: 'ums'

    constructor: (jid, robot, options) ->
        protocol = 'https'
        host = 'filenshare.saperion.com'
        service = 'ums-service'
        api_version = 1
        if options?
            if options.protocol?
                protocol = options.protocol
            if options.host?
                host = options.host
            if options.service?
                service = options.service
            if options.api_version?
                api_version = options.api_version

        url = "#{protocol}://#{host}/#{service}/api/#{api_version}/"
        super(jid, robot, UMS.DEFAULT_NAME, url)
