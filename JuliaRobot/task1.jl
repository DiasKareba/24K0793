using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function cross(robot)
    for side in [Ost, Sud, West, Nord]
        steps = moveUntilWall(robot, side, true)
        moveSteps(robot, rotate(side, 2), steps)
    end
end
cross(robot)