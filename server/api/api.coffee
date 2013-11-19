mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/kittens'
db = mongoose.connection

@apiReady = false
@kittySchema = null
@Kitten = null
@Battle = null
@recentBattles

db.on 'error', console.error.bind(console, 'connection error:')

db.once 'open', =>
	console.log 'db opened'
	@apiReady = true
	@kittySchema = mongoose.Schema {
		name: String
		image: String
		score: Number
		battles: Number
		id: Number
	}
	@battleSchema = mongoose.Schema {
		a: Object
		b: Object
		winner: Number
		parent: String
	}

	@Kitten = mongoose.model 'Kitten', @kittySchema
	@Battle = mongoose.model 'Battle', @battleSchema

# Serve JSON to our AngularJS client
exports.name = (req, res) ->
	res.json 
		name: "Jeremy Dowell"
		twitter: "codevinsky"

exports.listKittens = (req, res) =>
	if @apiReady
		@Kitten.find (err, kittens) ->
			if err
				throw err

			res.json kittens
	else
		throw new Error()

exports.showKitten = (req, res) =>
	console.log 'voting:', req.params.id

	@Kitten.findOne({id: req.params.id}, (err, kitten) ->
		throw err if err
		console.log 'kittens:', kitten
		res.json kitten
	)



exports.newBattle = (req, res) =>
	console.log 'generating battle'
	battle = new @Battle()
	@Kitten.count (err, count) =>
		a = null
		b = null 
		while a == b
			a = Math.floor(Math.random() * count)
			b = Math.floor(Math.random() * count)
		@Kitten.findOne {id: a}, (err, ka) =>
			@Kitten.findOne {id: b}, (err, kb) ->
				battle.a = ka
				battle.b = kb
				battle.save()
				res.json battle.toJSON()

exports.showBattle = (req, res) =>
	@Battle.findById req.params.id, (err, battle) =>
		console.log 'battle to copy:', battle
		@Battle.create {a: battle.a, b: battle.b , parent: battle.parent || battle._id }, (err, newBattle) ->
			console.log 'copied battle:', newBattle
			res.json newBattle

exports.voteBattle = (req, res) =>
	battle = req.body
	@Battle.findById battle._id, (err, doc) =>
		if err
			console.error err
			res.json {success: false, status: 'db_err'}
		else if doc
			if !doc.winner || doc.winner == null
				@Battle.findByIdAndUpdate(battle._id, { winner: battle.winner }).exec()
				@Kitten.findByIdAndUpdate(battle.a._id , { $inc: { battles: 1 } }).exec()
				@Kitten.findByIdAndUpdate(battle.b._id , { $inc: { battles: 1 } }).exec()
				@Kitten.update({  id: battle.winner }, { $inc: { score: 1 } }).exec()
				res.json {success: 'true'}
			else
				res.json {success: false, status: 'multiple_votes', id: battle._id}
		else
			res.json { success: false, status: 'unknown_battle'}

	###

