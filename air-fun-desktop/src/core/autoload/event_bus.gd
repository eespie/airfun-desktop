extends Node

# System
@warning_ignore("unused_signal") signal sigChangeScene(scene :String)
@warning_ignore("unused_signal") signal sigPause(is_paused : bool)

# Gameplay
@warning_ignore("unused_signal") signal sigNewGame(game_type :String)
@warning_ignore("unused_signal") signal sigGameOver()
@warning_ignore("unused_signal") signal sigAddScore(points :int)
@warning_ignore("unused_signal") signal sigNewHighScore(points :int)

# Planes
@warning_ignore("unused_signal") signal sigNewPlanePop()
@warning_ignore("unused_signal") signal sigPlaneCrashed(game :Node2D)
@warning_ignore("unused_signal") signal sigPlaneArrived(id :int)
@warning_ignore("unused_signal") signal sigPlaneSelect(selected :bool, id :int)
@warning_ignore("unused_signal") signal sigPlaneWarningStart(id :int)
@warning_ignore("unused_signal") signal sigPlaneWarningEnd(id :int)


# Mouse
@warning_ignore("unused_signal") signal sigMouseDrag(pos :Vector2)
@warning_ignore("unused_signal") signal sigMouseButtonClicked(pos :Vector2)
@warning_ignore("unused_signal") signal sigMouseButtonReleased(pos :Vector2)
