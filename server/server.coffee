fs = require('fs')
mongoose = require('mongoose')
passport = require('passport')
http = require('http')
mongodbURI = 'mongodb://localhost/kittens'
facebookAppId = '239433526117683'
facebookAppSecret = '9b31cf3ed2199c369b40a21d678be95e'

mongoose.createConnection(mongodbURI)

models_path = __dirname + '/models'

fs.readdirSync(models_path).forEach  (file) ->
    if file.substring(-7) == '.coffee'
        require(models_path + '/' + file)
    


require('./config/passport')(passport, facebookAppId, facebookAppSecret);

app = require('./config/express')(passport, mongodbURI);

require('./config/routes')(app, passport);

module.exports.startServer = (port, a,b) ->
	http.createServer(app).listen port, ->
	    console.log("Express server listening on port #{port}");


