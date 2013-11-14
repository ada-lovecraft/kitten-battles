'use strict'

### Controllers ###

app = angular.module('app')

app.controller 'AppController', ($scope) ->
  $scope.app =
    title: "Kitten Battles"
  console.log 'app controller'

app.controller 'MainController', ($scope, $filter, BattleService, $log, $routeParams, $location, $route) ->
	
	lastRoute = $route.current
	if $routeParams.id
		routeWatcher = $scope.$on '$locationChangeSuccess', (event) ->
			if $route.current.$$route.controller == 'MainController'
				$route.current = lastRoute
				routeWatcher()

	$scope.battleList = []
	getSavedBattle = (id) ->
		BattleService.getSavedBattle(id).then (battle) ->
			$scope.battle = battle
	getNewBattle = ->
		BattleService.new().then (battle) ->
			$scope.battle = battle
			$log.debug 'battle:', battle

	$scope.getBattleId = (battle) ->
		return battle._id

	$scope.vote = (winner) ->
		$scope.battle.winner = winner
		BattleService.vote($scope.battle).then (response) ->
			if response.success
				if $scope.battle.a.id == winner
					$scope.battle.a.score++
				else
					$scope.battle.b.score++
				$scope.battle.a.battles++
				$scope.battle.b.battles++

				$scope.battle.a.winPercentage = ($scope.battle.a.score / $scope.battle.a.battles) * 100
				$scope.battle.b.winPercentage = ($scope.battle.b.score / $scope.battle.b.battles) * 100
				$scope.battleList.unshift $scope.battle
				
				if $routeParams.id
					
					$location.path('/')

				
				getNewBattle()

	if $routeParams.id
		getSavedBattle $routeParams.id

	else
		getNewBattle()

app.controller 'SandboxController', ($scope) ->
	console.log 'Sandbox Controller'
