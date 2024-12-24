using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "task7.sit")#загружаем уровень из .sit файла
include("RecursiveFuncs.jl")
recWallNav(robot, Nord)