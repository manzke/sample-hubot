# Description:
#   http service which invites new people

FNS = require "./fns-bridge"
host = process.env.INVITE_HOST
room = process.env.INVITE_ROOM
users = process.env.INVITE_USERS

module.exports = (robot) ->
    unless process.env.INVITE_HOST
      console.log 'Variable INVITE_HOST was not set'
      process.exit -1
    unless process.env.INVITE_ROOM
        console.log 'Variable INVITE_ROOM was not set'
        process.exit -1
    unless process.env.INVITE_USERS
        console.log 'Variable INVITE_USERS was not set'
        users = 'Admins'

    console.log "redirect for invites will be send to #{host}"
    robot.router.get '/invites', (req, res) ->
        res.writeHead 301, {'Content-Type': 'text/html', 'Location': "#{host}"}
        res.end '''<html><head><meta http-equiv="refresh" content="0;url=#{host}"></head><body>This page has moved to <a href="#{host}">#{host}</a></body></html>'''

    robot.router.post '/invites', (req, res) ->
        name = req.body.name
        surname = req.body.surname
        email = req.body.email
        department = req.body.department
        company = req.body.company #robot check
        html = "#{users} please invite user #{name} #{surname} in #{department} \ninvite with: \n@hubot fns invite #{name} #{surname} #{email}"

        #robot.messageRoom room, html
        user = { room: room }
        robot.send user, html

        res.writeHead 201, 'Content-Type': 'text/html'
        res.end '''
<html>
<head>
<title>Thank you!</title>
</head><body>Thanks!</body>
</html>'''
