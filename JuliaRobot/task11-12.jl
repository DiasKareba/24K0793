using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "task12.sit")#загружаем уровень из .sit файла
function countInLine(robot, side, gap)
    wallCount = 0
    currentGap = 0
    isWall = false
    while !isborder(robot, side)
        if !isborder(robot, Nord)
            currentGap+=1
            if currentGap>gap && isWall
                wallCount += 1
                isWall = false
            end
        else
            isWall = true
            currentGap = 0
        end
        move!(robot, side)
    end
    if isWall
        wallCount += 1
    end
    #println(wallCount)
    return wallCount
end
function countHorizontalBorders(robot, gap = 0)
    count = 0
    moves = MoveToCorner(robot)
    move!(robot, Sud)
    side = Ost
    while true
        count += countInLine(robot, side, gap)
        if !isborder(robot, Sud)
            move!(robot, Sud)
            side = rotate(side, 2)
        else
            break
        end
    end
    return count
end

task11(robot) = countHorizontalBorders(robot, 0)
task12(robot) = countHorizontalBorders(robot, 1)
println(task11(robot))
task12(robot)