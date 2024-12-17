--konfig
world_list = { 'TAP','JAMMET','KINDABFG' }

local interval = math.random(20, 40) * 60


-- body

local last_execution = os.time()
local bot = getBot()
local rotation = bot.rotation

local function isPathFindable(x, y)
    return (getBot():isInTile(x, y) or #getBot():getPath(x, y) > 0)
end

local function warp(world, id)
    world = world:upper()
    id = id or ''
    local nuked = false
    local stuck = false

    if not bot:isInWorld(world) then
        while not bot:isInWorld(world) and not nuked do
            bot:warp(id == '' and world or world .. ('|' .. id))
            sleep(7000)
        end
    end

    if bot:isInWorld(world) and getTile(bot.x, bot.y).fg == 6 and id ~= '' then
        local count = 0
        while getTile(bot.x, bot.y).fg == 6 and not stuck do
            bot:warp(id == '' and world or world .. ('|' .. id))
            sleep(12000)
            count = count + 1
            if count % 5 == 0 then
                stuck = true
            end
        end
    end
end

local function reconnect(world, door, x, y)
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            sleep(2000)
        end
    end

    if world and not bot:isInWorld(world:upper()) then
        warp(world, door)
        if x and y then
            while not bot:isInTile(x, y) do
                bot:findPath(x, y)
                sleep(100)
            end
        end
    end
end

local function packet(x, y)
    local packet = 'action|dialog_return\ndialog_name|itemsucker\ntilex|' ..
    x .. '|\ntiley|' .. y .. '|\nbuttonClicked|getplantationdevice'
    bot:sendPacket(2, packet)
    sleep(2000)
end

local function getItemCount(id)
    return bot:getInventory():getItemCount(id)
end

local first_run = false

while true do
    local current_time = os.time()

    if first_run and bot.malady ~= 0 or (current_time - last_execution >= interval) and bot.malady ~= 0 then
        rotation.visit_random_worlds = not rotation.visit_random_worlds
        print('Taking magplant remote')
        local index = math.random(#world_list)
        local world = world_list[index]
        rotation.enabled = false

        warp(world, '')
        if bot:isInWorld(world:upper()) then
            for _, tile in pairs(getTilesSafe()) do
                if tile.fg == 5638 then
                    local tile_path = {
                        { x = tile.x + 1, y = tile.y },
                        { x = tile.x - 1, y = tile.y },
                        { x = tile.x,     y = tile.y + 1 },
                        { x = tile.x,     y = tile.y - 1 },
                        { x = tile.x - 1, y = tile.y - 1 },
                        { x = tile.x + 1, y = tile.y - 1 },
                        { x = tile.x + 2, y = tile.y },
                        { x = tile.x - 2, y = tile.y },
                        { x = tile.x,     y = tile.y + 2 },
                        { x = tile.x,     y = tile.y - 2 },
                    }

                    for _, p in pairs(tile_path) do
                        if isPathFindable(p.x, p.y) then
                            sigma = true
                            rizz = p
                            while not bot:isInTile(p.x, p.y) do
                                bot:findPath(p.x, p.y)
                                sleep(2000)
                            end
                            break
                        end
                    end

                    if sigma and rizz and bot:isInTile(rizz.x, rizz.y) then
                        while getItemCount(5640) ~= 1 and bot:isInTile(rizz.x, rizz.y) do
                            bot:wrench(tile.x, tile.y)
                            packet(tile.x, tile.y)
                            sleep(200)
                            reconnect(world)
                            sleep(3000)
                            bot:leaveWorld()
                            sleep(2000)
                        end
                    end
                end
            end
        end
        first_run = false
        last_execution = os.time()
    end

    rotation.enabled = true

    sleep(10000)
end


-- 