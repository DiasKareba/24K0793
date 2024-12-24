using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
include("SmartRobot.jl")
include("RecursiveFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "labyrinth.sit")#загружаем уровень из .sit файла
function ismarker(robot, side)
    move!(robot, side)
    e = ismarker(robot)
    move!(robot, rotate(side, 2))
    return e
end
upd2629(robot) = putmarker!(robot)
upd30(robot) = (robot.x+robot.y)%2==0 && putmarker!(robot)
upd31(robot) = abs(robot.x)==abs(robot.y) && putmarker!(robot)
function task26(robot)
    robot = SmartRobot(robot)
    SetUpdateFunc(robot, ()->upd31(robot))
    walkLabyrinth(LabBot(robot))
end
task26(robot)