extends Node

# System
@warning_ignore("unused_signal") signal sigChangeScene(scene :String)
@warning_ignore("unused_signal") signal sigPause(is_paused : bool)

# State machine
@warning_ignore("unused_signal") signal sigEnterState(name : String)
@warning_ignore("unused_signal") signal sigExitState(name : String)

# Gameplay
@warning_ignore("unused_signal") signal sigNewGame(game_type :String)
@warning_ignore("unused_signal") signal sigGameOver()
@warning_ignore("unused_signal") signal sigAddScore(points :int)
@warning_ignore("unused_signal") signal sigNewHighScore(points :int)
@warning_ignore("unused_signal") signal sigMessageDisplay(message :String, color: Color)

# Planes
@warning_ignore("unused_signal") signal sigNewPlaneTimer()
@warning_ignore("unused_signal") signal sigPlaneCrashed(game :Node2D)
@warning_ignore("unused_signal") signal sigPlaneArrived(id :int)
@warning_ignore("unused_signal") signal sigPlaneReleased(id :int)
@warning_ignore("unused_signal") signal sigPlaneTakeoff(id :int)

@warning_ignore("unused_signal") signal sigPlaneSelect(selected :bool, id :int)
@warning_ignore("unused_signal") signal sigPlaneSelectLongStart(id :int)
@warning_ignore("unused_signal") signal sigPlaneSelectLongStop(id :int)
@warning_ignore("unused_signal") signal sigPlaneSelectedLong(id :int)
@warning_ignore("unused_signal") signal sigPlaneUnselectAll()
@warning_ignore("unused_signal") signal sigPlaneWarningStart(id :int)
@warning_ignore("unused_signal") signal sigPlaneWarningEnd(id :int)

@warning_ignore("unused_signal") signal sigTargetSelect(selected :bool, id :int)

# Mouse
@warning_ignore("unused_signal") signal sigMouseDrag(pos :Vector2)
@warning_ignore("unused_signal") signal sigMouseButtonClicked(pos :Vector2)
@warning_ignore("unused_signal") signal sigMouseButtonReleased(pos :Vector2)

# Console
@warning_ignore("unused_signal") signal sigConsoleAddCommand(id: int, color: Color, description: String, command: String, post_desc: String, sig: Signal)
@warning_ignore("unused_signal") signal sigConsoleRemoveCommand(id :int)

# Command
@warning_ignore("unused_signal") signal sigCommandTaxi(id: int)
@warning_ignore("unused_signal") signal sigCommandTakeoff(id: int)
@warning_ignore("unused_signal") signal sigCommandFlightPlan(id: int)
@warning_ignore("unused_signal") signal sigCommandCrossRunway(id: int)
