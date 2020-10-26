module("luci.controller.admin.test", package.seeall)


-- get username from active session
function get_username_session()

	local ubus = require "ubus"
	local conn = ubus.connect()

	if not conn then
	    error("Connection error with ubusd")
	end

	-- ask ubus sessions list and filter them by cookie ID
	local status = conn:call("session", "list", {ubus_rpc_session = luci.http.getcookie("sysauth")})

	if status then
		return status.data.username
	end

end

-- search the node to delete starting from Title and return its name
function node_from_title(node, pattern)

	for node_name, el in pairs(node) do
		if el.title == pattern then
			return node_name
		end
	end

end

function remove_nodes(name)

	if not name then name = "user" end

	local uci = require "luci.model.uci"
	local d = require "luci.dispatcher"

	-- reading from /etc/config/users nodes and subnodes to remove
	local x = uci.cursor()
	local remove_subnodes = x:get("users", name, "subnode")
	local remove_nodes = x:get("users", name, "node")

	local main_node = d.node("admin").nodes

	-- delete 2 unused nodes (in standard installation)
	main_node.filebrowser = nil
	main_node.services = nil

	if remove_subnodes then

		-- ther is only 1 record it's a string instead of table
		if(type(remove_subnodes) == "table") then

			-- cycle subnodes to remove
			for _, sub in ipairs(remove_subnodes) do

				local tmp = {}
				-- split string in table
				for s in sub:gmatch("([^/]+)") do
				    table.insert(tmp, s:sub(0, -1))
				end

				-- if ther is a third parameter, concatenate it with / (eg. Backup / Flash Firmware)
				-- then delete found node
				main_node[tmp[1]].nodes[node_from_title(main_node[tmp[1]].nodes, tmp[2] .. (tmp[3] and '/' .. tmp[3] or ''))] = nil
			end

		else
			local tmp = {}
			for s in remove_subnodes:gmatch("([^/]+)") do
				table.insert(tmp, s:sub(0, -1))
			end
			main_node[tmp[1]].nodes[node_from_title(main_node[tmp[1]].nodes, tmp[2] .. (tmp[3] and '/' .. tmp[3] or ''))] = nil
		end

	end

	if remove_nodes then

		-- if it is a table there are more pages to remove
		if(type(remove_nodes) == "table") then

			-- delete "first level" nodes (system,status,network etc.)
			for _, n in ipairs(remove_nodes) do
				main_node[n] = nil
			end

		else
			main_node[remove_nodes] = nil
		end
	end
end

function index()
	local ctrl = require 'luci.controller.admin.test'
	entry({"admin", "system", "manageusers"}, cbi("myapp-mymodule/manageusers"), translate("Manage Users"), 20).dependent=false

	local username = ctrl.get_username_session()
	if username and username ~= "root" then
	 	ctrl.remove_nodes(username)
	end
end
