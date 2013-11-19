api = require './../api/api'
path = require 'path'
module.exports = (app, passport) ->
    
    assetsPath = path.join(__dirname, '..','..', '_public')
    imagesPath = path.join(__dirname,'..','..','sucked','cats')

    app.get "/auth/facebook", passport.authenticate("facebook")
    app.get "/auth/facebook/callback", passport.authenticate "facebook",
        successRedirect: "/auth/success"
        failureRedirect: "/auth/failure"
    
    app.get "/auth/success", (req, res) ->
        res.render "after-auth",
            state: "success"
            user: (if req.user then req.user else null)


    app.get "/auth/failure", (req, res) ->
        res.render "after-auth",
            state: "failure"
            user: null


    app.delete "/auth", (req, res) ->
        req.logout()
        res.writeHead 200
        res.end()

    app.get "/api/secured/*", (req, res, next) ->
        return res.json(error: "This is a secret message, login to see it.")  unless req.user
        next()
    , (req, res) ->
        res.json message: "This message is only for authenticated users"

    app.get "/api/*", (req, res) ->
        res.json message: "This message is known by all"


    # JSON API
    # Kittens
    app.get '/kittens/list', api.listKittens
    app.get '/kittens/show/:id', api.showKitten

    #Battles
    app.get '/battle/new', api.newBattle
    app.get '/battle/show/:id', api.showBattle
    app.post '/battle/vote', api.voteBattle


    #serve index for all other routes
    app.get '/images/:id', (req,res) ->
        res.sendfile "#{imagesPath}/#{req.params.id}"

    app.get '*', (req,res) -> res.sendfile "#{assetsPath}/index.html"



