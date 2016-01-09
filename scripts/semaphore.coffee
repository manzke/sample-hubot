# Description
#   Uses Semaphore's API to start deployments.
#
# Configuration:
#   HUBOT_SEMAPHOREAPP_AUTH_TOKEN
#     Your authentication token for Semaphore API
#
# Commands
#   hubot deploy project/branch to server - deploys project/branch to server
#   hubot deploy project to server - deploys project/master to server
#   hubot deploy project/branch - deploys project/branch to 'prod'
#   hubot deploy project - deploys project/master to 'prod'

module.exports = (robot) ->
    robot.respond /deploy (.*)/, (msg) =>
        unless process.env.HUBOT_SEMAPHOREAPP_AUTH_TOKEN
            return msg.reply "I need HUBOT_SEMAPHOREAPP_AUTH_TOKEN for this to work."

        command = msg.match[1]
        aSlashBToC = command.match /(.*)\/(.*)\s+to\s+(.*)/ # project/branch to server
        aToB = command.match /(.*)\s+to\s+(.*)/ # project to server
        aSlashB = command.match /(.*)\/(.*)/ # project/branch

        [project, branch, server] = switch
            when aSlashBToC? then aSlashBToC[1..3]
            when aToB? then [aToB[1], 'master', aToB[2]]
            when aSlashB? then [aSlashB[1], aSlashB[2], 'prod']
            else [command, 'master', 'prod']

        deploy msg, project, branch, server


deploy = (msg, project, branch, server) ->
    app = new SemaphoreApp(msg)
    app.getProjects (allProjects) ->
        [project_obj] = (p for p in allProjects when p.name == project)
        unless project_obj
            return msg.reply "Can't find project #{project}"
        [branch_obj] =  (b for b in project_obj.branches when b.branch_name == branch)
        unless branch_obj
            return msg.reply "Can't find branch #{project}/#{branch}"
        # unless branch_obj.result == 'passed'
        #     return msg.reply "#{project}/#{branch} – last build is #{branch_obj.result}. Aborting deploy."
        [server_obj] = (s for s in project_obj.servers when s.server_name == server)
        unless server_obj
            return msg.reply "Can't find server #{server} for project #{project}"

        app.getBranches project_obj.hash_id, (allBranches) ->
            app.getServers project_obj.hash_id, (allServers) ->
                [branch_id] = (b.id for b in allBranches when b.name == branch)
                [server_id] = (s.id for s in allServers when s.name == server)
                app.createDeploy project_obj.hash_id, branch_id, branch_obj.build_number, server_id, (json) ->
                    msg.send "Deploying #{project}/#{branch} to #{server} ( #{json.html_url} )"

class SemaphoreApp
    constructor: (@msg) ->

    requester: (endpoint) ->
        @msg.robot.http("https://semaphoreapp.com/api/v1/#{endpoint}")
            .query(auth_token: "#{process.env.HUBOT_SEMAPHOREAPP_AUTH_TOKEN}")

    get: (endpoint, callback) ->
        # console.log "GET #{endpoint}"
        @requester(endpoint).get() (err, res, body) =>
            try
                json = JSON.parse body
            catch error
                @msg.reply "Semaphore error: #{err}"
            # console.log json
            callback json

    post: (endpoint, callback) ->
        # console.log "POST #{endpoint}"
        data = JSON.stringify {}
        @requester(endpoint).post(data) (err, res, body) =>
            try
                json = JSON.parse body
            catch error
                @msg.reply "Semaphore error: #{error} / #{res} / #{body}"
            callback json

    getProjects: (callback) ->
        @get 'projects', callback

    getBranches: (project, callback) ->
        @get "projects/#{project}/branches", callback

    getServers: (project, callback) ->
        @get "projects/#{project}/servers", callback

    createDeploy: (project, branch, build, server, callback) ->
        @post "projects/#{project}/#{branch}/builds/#{build}/deploy/#{server}", callback