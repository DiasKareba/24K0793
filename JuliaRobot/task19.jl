using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")#загружаем уровень из .sit файла
include("RecursiveFuncs.jl")
recMoveUntilWall(robot, Nord)