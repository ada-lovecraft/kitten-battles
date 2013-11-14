'use strict'

# Declare app level module which depends on filters, and services

App = angular.module 'app', [
	'ngRoute'
	'partials'
	'sling.ui'
	'ngAnimate'
], ($routeProvider, $locationProvider, $httpProvider, $rootScopeProvider) ->

	interceptor = ($rootScope, $q, $location) ->
		success = (response) ->
			returnValue = null
			if response.config.url.match /\.html$/
				return response
			else
				returnValue = response.data
			return returnValue

		error = (response) ->
			return $q.reject response

		return (promise) ->
			promise.then success, error

	$httpProvider.responseInterceptors.push interceptor
	$httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'


App.config([
	'$routeProvider'
	'$locationProvider'
	($routeProvider, $locationProvider, config) ->
		
		$routeProvider
			.when('/sandbox', { templateUrl: '/partials/sandbox.html' })
			.when('/:id?', {templateUrl: '/partials/main.html', controller: 'MainController'})
			.when('/triage/:id?', { templateUrl: '/partials/triage.html' })
			.otherwise({redirectTo: '/'})

		# Without server side support html5 must be disabled.
		$locationProvider.html5Mode(false)
])
