using HorizonSideRobots
include("MainFuncs.jl")
include("SmartRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "task6.sit")
function task6a(robot)
    moves = MoveToCorner(robot)
    [moveUntilWall(robot, side, true) for side = [Ost, Sud, West, Nord]]
    ReturnHome(robot, moves)
end
function isHomeAlign(robot)
    if (robot.x == 0) || (robot.y == 0)
        putmarker!(robot)
    end
end
function task6b(robot)
    robot = SmartRobot(robot)
    moves = MoveToCorner(robot)
    robot.update = ()->isHomeAlign(robot)
    for side in [Ost, Sud, West, Nord]
        moveUntilWall(robot, side)
    end
    robot.allowPaint = false
    ReturnHome(robot, moves)
end
task6b(robot)