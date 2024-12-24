using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")#загружаем уровень из .sit файла
include("RecursiveFuncs.jl")
function symmetry(robot, side)
    steps = recMoveUntilWall(robot, side)
    recMoveUntilWall(robot, rotate(side, 2))
    recMoveSteps(robot, side, steps)
end
symmetry(robot, West)