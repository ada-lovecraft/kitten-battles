mongoose = require("mongoose")
User = require("../models/user")
FacebookStrategy = require("passport-facebook").Strategy
module.exports = (passport, facebookAppId, facebookAppSecret) ->
  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    User.findOne
      _id: id
    , (err, user) ->
      done err, user


  passport.use new FacebookStrategy(
    clientID: facebookAppId
    clientSecret: facebookAppSecret
    callbackURL: "/auth/facebook/callback"
  , (accessToken, refreshToken, profile, done) ->
    User.findOne
      "facebook.id": profile.id
    , (err, user) ->
      return done(err)  if err
      unless user
        console.log "profile:", profile
        user = new User(
          name: profile.displayName
          username: profile.username
          provider_id: profile.id
          provider: "facebook"
          facebook: profile._json
        )
        user.save (err) ->
          console.log err  if err
          done err, user

      else
        done err, user

  )
