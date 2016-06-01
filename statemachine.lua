function createStateMachine()
	local StateMachine = {}


	function StateMachine:new(entity, currentState, previousState, globalState)
		--only entity and currentState required
		local stateMachine = {}
		stateMachine.curState = currentState
		stateMachine.prevState = previousState
		stateMachine.globalState = globalState
		
		local states = {}

		states[currentState.name] = currentState
		states[globalState.name] = globalState
		if previousState then
			states[previousState.name] = previousState
		end
		function stateMachine:update()
			self.globalState.execute(entity)
			self.curState.execute(entity)
		end

		function stateMachine:addState(newState)
			states[newState.name] = newState
		end

		function stateMachine:changeState(newStateName)
			self.prevState = self.curState
			self.curState.exit(entity)
			self.curState = states[newStateName]
			self.curState.enter(entity)
		end

		function stateMachine:revertState()
			self:changeState(self.prevState.name)
		end

		function stateMachine:isInState(stateName)
			return stateName == self.curState.name
		end

		return stateMachine

	end

	return StateMachine
end