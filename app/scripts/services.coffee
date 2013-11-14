app = angular.module 'app'

app.factory 'KittenService', ($q, $http) ->
	return  {
		getData: -> 
			deferred = $q.defer()
			$http.get('/api/people').then (response) ->
				deferred.resolve response.data
			deferred.promise
		}
app.factory 'BattleService', ($q, $http) ->
	return  {
		new: -> 
			$http.get '/battle/new'
		getSavedBattle: (battleId) ->
			$http.get "/battle/show/#{battleId}"
		vote: (battle) ->
			$http.post '/battle/vote', battle
	}