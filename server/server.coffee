
###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
api = require './api'

app = module.exports = require('express.io')()

app.http().io()

assetsPath = path.join(__dirname, '..', '_public')
imagesPath = path.join(__dirname,'..','sucked','cats')

# all environments
app.set "port", process.env.PORT or 3000
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.static(assetsPath)
app.use app.router

# development only
app.use express.errorHandler()  if "development" is app.get("env")

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

module.exports.startServer = (port, path, cb) ->
	app.set 'port', port
	app.listen port, ->
	  console.log "Express.io server listening on port #{port}"

