using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "task8.sit")
function task8(robot)
    spiral!(()->ismarker(robot), robot)
end
task8(robot)