## Variables

HUBOT_HIPCHAT_JID
- this is the user the hubot adapter will use to login and act like

HUBOT_HIPCHAT_PASSWORD
- the password of the user the hubot will use for interaction

HUBOT_HIPCHAT_ROOMS
- a list of rooms the hubot will automatically join
- hubot will join new rooms if he is invite 

KEEP_ALIVE_HOST="http://sample-hubot.herokuapp.com"
- used to pink the heroku instance so it stays alive (especially if you use the FREE tier version)

INVITE_HOST
- the redirect url if a user opens https://sample-hubot.herokuapp.com/invites

INVITE_ROOM
- the room an invite will be posted to

INVITE_USERS
- a list of users who will be mentioned to invite the user

HUBOT_SEMAPHOREAPP_AUTH_TOKEN
- auth token which is used to access the semaphoreapp api

#===== Local Environment =====#
export HUBOT_HIPCHAT_JID="...@chat.hipchat.com"
export HUBOT_HIPCHAT_PASSWORD="..."
export HUBOT_HIPCHAT_ROOMS="...@conf.hipchat.com"
export KEEP_ALIVE_HOST="http://sample-hubot.herokuapp.com"
export INVITE_HOST="https://myintranet/invite"
export INVITE_ROOM="...@conf.hipchat.com"
export INVITE_USERS="@user1 @user2"
export HUBOT_SEMAPHOREAPP_AUTH_TOKEN="..."

#===== Heroku Environment =====#
heroku config:set ENVIRONMENT_VARIABLE_NAME=VALUE