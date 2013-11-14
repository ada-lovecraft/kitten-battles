mongoose = require 'mongoose'
cats = require './sucked/cats/_cats.js'
ProgressBar = require 'progress'


mongoose.connect 'mongodb://localhost/kittens'

db = mongoose.connection

db.on 'error', console.error.bind(console, 'connection error:')

db.once 'open', ->
	bar = new ProgressBar ':bar :current/:total cats', { 
		total: cats.length
		width: 100

	}
	kittySchema = mongoose.Schema {
		name: String
		image: String
		score: Number
		battles: Number
		id: Number
	}

	Kitten = mongoose.model 'Kitten', kittySchema
	cats.forEach (cat,index) ->
		kitten = new Kitten {
			name: cat.title
			image: cat.link
			score: 0
			battles: 0
			id: index
		}

		kitten.save (err, kat) ->
			bar.tick()

