using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "task7.sit")
function task7(robot)
    shuttle!(()->!isborder(robot, Nord), robot, Ost)
end
task7(robot)