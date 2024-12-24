using HorizonSideRobots

function rotate(side, steps)#поворот стороны на steps шагов против часовой(если отрицательное число, то по часовой)
    side = Int(side)+steps
    if side >= 0
        return HorizonSide(side%4)
    else
        return HorizonSide(4-side) 
    end
end
function GetBorders(robot)#возвращает список всех стен, которых касается
    borders = []
    for side in [Ost, Sud, West, Nord]
        if isborder(robot, side)
            push!(borders, side)
        end
    end
    return borders
end

function moveSteps(robot, side, steps = 1, lay = false; breakFunc = ()->false)#двигается steps шагов, если lay = true, то оставляет след из маркеров
    counter = 0
    for _ in 1:steps 
        if isborder(robot, side) || breakFunc()
            return counter#останавливается, если коснулся стены и возвращает кол-во шагов до нее
        end
        move!(robot, side)
        if lay
            putmarker!(robot)
        end
        counter += 1
    end
    return counter#возвращает кол-во пройденных шагов(здесь == steps)
end
function moveUntilWall(robot, side, lay = false)#двигается до стены, если lay = true, то оставляет след из маркеров
    counter = 0
    while !isborder(robot, side)
        counter += 1
        move!(robot, side)
        if lay
            putmarker!(robot)
        end
    end
    return counter
end
function moveUntil(stop_condition::Function, robot, side)#двигается до того, как stop_condition возвращает true
    n=0
    while !stop_condition()
        move!(robot, side)
        n+=1
    end
    return n
end

function MoveToCorner(robot, corner = (Nord, West))#передвигает робота в угол; возвращает список шагов чтобы вернуться домой
    moves = []
    while true
        for side in corner
            move = (side, moveUntilWall(robot, side))
            push!(moves, move)
            if issubset(corner, GetBorders(robot))
                return moves
            end
        end
    end
end
function ExecutePath(robot, path; reversePath = false)#выполняет список шагов; шаг = (сторона света; кол-во шагов)
    if !reversePath
        for cmd in path
            moveSteps(robot, cmd[1], cmd[2])
        end
    else
        for cmd in reverse(path)
            moveSteps(robot, rotate(cmd[1], 2), cmd[2])
        end
    end
end
function ReturnHome(robot, moves, corner = (Nord, West))#возвращается домой из любой клетки поля(moves- список шагов из дома в угол)
    MoveToCorner(robot, corner)
    ExecutePath(robot, moves, reversePath = true)
end

function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide})#двигается змейкой по заданным сторонам и останавливается, когда stop_condition возвращает true
    s=sides[1]
    while !stop_condition()
        moveUntil(()->stop_condition() || isborder(robot, s), robot,s)
        if stop_condition()
            break
        end
        s = rotate(s,2)
        move!(robot, sides[2])
    end
end
function spiral!(stop_condition::Function, robot)#идет по спирали пока stop_condition не вернет true
    steps = 1
    side = Nord
    while true
        side = rotate(side,1)
        moveSteps(robot, side, steps, breakFunc = stop_condition)
        if stop_condition()
            break
        end
        side = rotate(side,1)
        moveSteps(robot, side, steps, breakFunc = stop_condition)
        if stop_condition()
            break
        end
        steps += 1
    end
end

function shuttle!(stop_condition::Function, robot, side)#шатается влево-вправо, пока stop_condition не вернет true
    metWall = false
    steps = 0
    addStep = false
    while true
        walked = moveSteps(robot, side, steps)
        if stop_condition()
            return (side, steps)
        end
        if walked == steps
            moveSteps(robot, rotate(side, 2), steps)
        else
            moveSteps(robot, rotate(side, 2), walked)
            if metWall
                return ()
            end
            metWall = true
        end
        if addStep
            steps += 1
        end
        addStep = !addStep
        if !metWall
            side = rotate(side, 2)
        end
    end
end
function navAroundWall(robot, side)#идет вперед на 1 шаг, даже если перед ним стена(обходит стену при помощи shuttle!); возвращает путь, который был пройден
    if !isborder(robot, side)
        move!(robot, side)
        return (side, 1)
    end
    path = []
    pathAround = shuttle!(()->!isborder(robot, side), robot, rotate(side, 1))
    if pathAround == ()
        return []
    end
    push!(path, pathAround)
    move!(robot, side)
    pathThrough = (side, moveUntil(()->!isborder(robot, rotate(pathAround[1], 2)), robot, side)+1)
    push!(path, pathThrough)
    pathBack = (rotate(pathAround[1], 2), pathAround[2])
    moveSteps(robot, pathBack[1], pathBack[2])
    push!(path, pathBack)
    if pathThrough[2] > 1
        push!(path, (rotate(side, 2), moveSteps(robot, rotate(side, 2), pathThrough[2]-1)))
    end
    return path
end
function moveStepsWithPath(robot, side, steps = 1; moveType = ()->navAroundWall(robot, side), breakFunc = ()->false)#идет вперед на n шагов, даже если перед ним стена; возвращает (успешно ли обошел, пройденный путь)
    path = []
    curSteps = 0
    for _ in 1:steps
        if breakFunc()
            return (true, path)
        end
        if isborder(robot, side)
            push!(path, (side, curSteps))
            curSteps = 0
            pathAround = moveType()
            if pathAround == []
                return (false, path)
            end
            append!(path, pathAround)
        else
            move!(robot, side)
            curSteps += 1
        end
    end
    if curSteps != 0
        push!(path, (side, curSteps))
    end
    return (true, path)
end

function isOuterWall(robot, side)#проверяет внешняя ли это стена
    if !isborder(robot, side)
        #println("no border")
        return false
    end
    for otherSide in [rotate(side, 1), rotate(side, 3)]
        stepsBack = moveUntil(()->(!isborder(robot, side)||isborder(robot, otherSide)), robot, otherSide)
        Corner = isborder(robot, side) && isborder(robot, otherSide)
        moveSteps(robot, rotate(otherSide, 2), stepsBack)
        if !Corner
            #println("not corner")
            return false
        end
    end
    #println("outer wall")
    return true
end
function snakeWithNav(robot, sides)# проходит все поле, но может обходить внутренние стены
    side = sides[1]
    height = moveUntilWall(robot, side)
    side = rotate(side, 2)
    while true
        moveStepsWithPath(robot, side, height)
        if !isborder(robot, sides[2])
            move!(robot, sides[2])
        else
            break
        end
        side = rotate(side, 2)
    end
end
function spiralWithNav(stop_condition::Function, robot)#spiral! но с обходом стен
    steps = 1
    side = Nord
    while true
        side = rotate(side,1)
        moveStepsWithPath(robot, side, steps, breakFunc = stop_condition)
        if stop_condition()
            break
        end
        side = rotate(side,1)
        moveStepsWithPath(robot, side, steps, breakFunc = stop_condition)
        if stop_condition()
            break
        end
        steps += 1
    end
end
