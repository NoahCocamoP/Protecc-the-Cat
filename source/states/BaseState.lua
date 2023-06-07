-- BaseState that all our actual Game States will inherit properties from.
-- This will just make sure that all of the commands that our Game Statemachine uses
-- will be internally defined, even if the contents of each definition have nothing
-- inside of them.

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end