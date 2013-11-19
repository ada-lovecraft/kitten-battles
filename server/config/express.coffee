express = require("express")
mongoStore = require("connect-mongo")(express)
path = require("path")
module.exports = (passport, mongodbURI) ->
  app = express()
  root = path.join(__dirname,"..",'..')
  app.set "showStackError", true
  app.set "port", process.env.PORT or 3000
  app.set "views", path.join(root, 'server', 'views')
  console.log 'view directory:', app.get 'views'
  app.set "view engine", "ejs"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session(
    secret: "my-session-store"
    store: new mongoStore(
      url: mongodbURI
      collection: "sessions"
    )
  )
  app.use passport.initialize()
  app.use passport.session()
  app.use express.static(path.join root, "_public")
  app.use app.router
  if "development" is app.get("env")
    app.use express.errorHandler()
    app.use (req, res, next) ->
      console.log req.url
      next()

  app
