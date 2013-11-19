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

angular.module('services')
.factory 'sessionService', ($rootScope, $window, $http, $timeout) ->
	session = {
		init: ->
			@resetSession()
		resetSession: ->
			@currentUser - null
			@isLoggedIn = false
		facebookLogin: ->
			url = '/auth/facebook'
			width = 1000
			height = 650
			top = (window.outerHeight - height) / 2
			left = (window.outerWidth - width) / 2
			$timeout ->
				$window.open url, 'facebook_login', 'width=' + width + ',height=' + height + ',scrollbars=0,top=' + top + ',left=' + left
			, 0
		logout: ->
			$http.delete('/auth').success =>
				scope.resetSession;
				$rootScope.$emit 'session-changed'
		authSuccess: (userData) ->
			@currentUser = userData
			@isLoggedIn = true
			$rootScope.$emit 'session-changed'
		authFailed: ->
			@resetSession()
			alert 'authentication failed'
	}

	session.init()
	return session
